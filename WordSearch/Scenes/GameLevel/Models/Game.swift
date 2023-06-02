import Foundation
import Combine

final class Game: ObservableObject {
    let levelTitle: String
    let levelCategory: String
    
    // MARK: State
    @Published private(set) var searchMatrix: SearchMatrix
    @Published private(set) var notFoundWords: [SearchedWord]
    @Published private(set) var timeCounter: UInt
    private(set) var score: GameScore
    
    private var selection: [SearchMatrix.Entry] = []
    private var selectionAxis: SelectionAxis?
    private var timer: Timer?
    private var navigationState: NavigationState
    
    init(_ level: AppConfiguration.Level, navigationState: NavigationState) {
        levelTitle = level.title
        levelCategory = level.category
        
        self.navigationState = navigationState
        
        let matrixSize: SearchMatrix.Size = .init(
            width: level.matrixSize.width,
            height: level.matrixSize.height
        )
        searchMatrix = SearchMatrix(size: matrixSize)
        
        notFoundWords = level.words.map { SearchedWord($0) }
        
        timeCounter = level.timeLimit
        
        score = GameScore(
            time: .init(total: level.timeLimit, spent: 0),
            words: .init(total: UInt(level.words.count), found: 0)
        )
        
        notFoundWords.forEach {
            searchMatrix.include(word: $0.value)
        }
        
        runTimer()
        debugPrint("> Game init")
    }
    
    deinit {
        timer?.invalidate()
        debugPrint("> Game deinit")
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

// MARK: Private methods
private extension Game {
    enum SelectionAxis {
        case horizontal, vertical
    }
    
    func setGameOver() {
        let totalTime = score.time.total
        let timeSpent = totalTime - timeCounter
        let totalWords = score.words.total
        let foundWords = totalWords - UInt(notFoundWords.count)
        navigationState.path.append(
            GameScore(
                time: .init(total: totalTime, spent: timeSpent),
                words: .init(total: totalWords, found: foundWords)
            )
        )
    }
    
    func runTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
         )
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTimer() {
        timeCounter -= 1
        print("---> \(timeCounter)")
        if timeCounter <= 0 {
            stopTimer()
            setGameOver()
        }
    }
    
    func isAdjacentSelection(entry: SearchMatrix.Entry) -> Bool {
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
    
    func clearSelection() {
        selection.forEach { entry in
            entry.isSelected = false
        }
        
        selection = []
        selectionAxis = nil
    }
    
    func checkIfWordFound(on selection: [SearchMatrix.Entry]) -> SearchedWord? {
        let selectedWord: String = selection
            .map { String($0.value) }
            .joined(separator: "")
        
        let reversedSelectedWord = String(selectedWord.reversed())
        let wordsFound = notFoundWords.filter { word in
            word.value == selectedWord || word.value == reversedSelectedWord
        }
        return wordsFound.first
    }
    
    func setWordFound(_ word: SearchedWord) {
        if let index = notFoundWords.firstIndex(of: word) {
            notFoundWords.remove(at: index)
        }
        
        selection.forEach {
            $0.isFound = true
            $0.isSelected = false
        }
    }
    
    func isWordSetFound() -> Bool {
        notFoundWords.isEmpty
    }
}
