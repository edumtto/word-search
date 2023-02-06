import Foundation
import Combine

//protocol GameLevelViewModeling: ObservableObject {
//    var matrix: SearchMatrix { get }
//    var words: [SearchWord] { get }
//    var gameScore: GameScore { get }
//    var timeCounter: UInt { get }
//    func selectEntry(row: UInt, col: UInt)
//}

final class GameLevelViewModel: ObservableObject {
    enum SelectionAxis {
        case horizontal, vertical
    }
    
    private var selection: [SearchMatrix.Entry] = []
    private var selectionAxis: SelectionAxis?
    private var timer: Timer?
    private var pathState: PathState
    
    @Published private(set) var searchMatrix: SearchMatrix
    @Published private(set) var notFoundWords: [SearchedWord] {
        didSet {
            print("words to find: \(notFoundWords.count)")
        }
    }
    @Published private(set) var timeCounter: UInt
    private(set) var gameScore: GameScore
    
    let title: String
    
    init(_ level: AppConfiguration.Level, pathState: PathState) {
        title = level.title
        self.pathState = pathState
        
        let matrixSize: SearchMatrix.Size = .init(
            width: level.matrixSize.width,
            height: level.matrixSize.height
        )
        searchMatrix = SearchMatrix(size: matrixSize)
        
        notFoundWords = level.words.map { SearchedWord($0) }
        
        timeCounter = level.timeLimit
        
        gameScore = GameScore(
            time: .init(total: level.timeLimit, spent: 0),
            words: .init(total: UInt(level.words.count), found: 0)
        )
        
        notFoundWords.forEach {
            searchMatrix.include(word: $0.value)
        }
        
        print(">>> GameLevelViewModel init")
        runTimer()
    }
    
    deinit {
        timer?.invalidate()
        print(">>> GameLevelViewModel deinit")
    }
    
    func selectEntry(row: UInt, col: UInt) {
        let entry = searchMatrix[row, col]
        
        if entry.isFound {
            return
        }
        
        if selection.isEmpty {
            entry.isSelected = !entry.isSelected
            selection.append(entry)
            return
        }
        
        if isAdjacentSelection(entry: entry) {
            entry.isSelected = !entry.isSelected
            selection.append(entry)
            if let foundWord = checkIfWordFound(on: selection) {
                setWordFound(foundWord)
                if isWordSetFound() {
                    stopTimer()
                    setGameOver()
                }
            }
            return
        }
        
        clearSelection()
    }
}

// Private methods
extension GameLevelViewModel {
    private func setGameOver() {
        let totalTime = gameScore.time.total
        let timeSpent = totalTime - timeCounter
        let totalWords = gameScore.words.total
        let foundWords = totalWords - UInt(notFoundWords.count)
        pathState.path.append(
            GameScore(
                time: .init(total: totalTime, spent: timeSpent),
                words: .init(total: totalWords, found: foundWords)
            )
        )
    }
    
    private func runTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
         )
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer() {
        timeCounter -= 1
        if timeCounter <= 0 {
            stopTimer()
            setGameOver()
        }
    }
    
    private func isAdjacentSelection(entry: SearchMatrix.Entry) -> Bool {
        guard let lastSelection = selection.last else {
            return false
        }
        
        let rowPositionDiference = abs(Int32(entry.position.row) - Int32(lastSelection.position.row))
        let colPositionDiference = abs(Int32(entry.position.col) - Int32(lastSelection.position.col))
        
        // if vertical adjacent selection
        if rowPositionDiference == 1 && colPositionDiference == 0 {
            if selectionAxis == .horizontal {
                return false
            }
            selectionAxis = .vertical
            return true
        }
        
        // if horizontal adjacent selection
        if colPositionDiference == 1 && rowPositionDiference == 0 {
            if selectionAxis == .vertical {
                return false
            }
            selectionAxis = .horizontal
            return true
        }
        
        return false
    }
    
    private func clearSelection() {
        selection.forEach { entry in
            entry.isSelected = false
        }
        
        selection = []
        selectionAxis = nil
    }
    
    private func checkIfWordFound(on selection: [SearchMatrix.Entry]) -> SearchedWord? {
        let selectedWord: String = selection
            .map { String($0.value) }
            .joined(separator: "")
        
        let reversedSelectedWord = String(selectedWord.reversed())
        let wordsFound = notFoundWords.filter { word in
            word.value == selectedWord || word.value == reversedSelectedWord
        }
        return wordsFound.first
    }
    
    private func setWordFound(_ word: SearchedWord) {
        if let index = notFoundWords.firstIndex(of: word) {
            notFoundWords.remove(at: index)
        }
        
        selection.forEach {
            $0.isFound = true
            $0.isSelected = false
        }
    }
    
    private func isWordSetFound() -> Bool {
        notFoundWords.isEmpty
    }
}
