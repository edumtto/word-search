import Foundation
import Combine

@MainActor
final class GameLevelViewModel: ObservableObject {
    enum SelectionAxis {
        case horizontal, vertical
    }
    
    private var selection: [SearchMatrix.Entry] = []
    private var selectionAxis: SelectionAxis?
    private var timer: Timer?
    private var pathState: PathState
    
    @Published private(set) var matrix: SearchMatrix
    @Published private(set) var words: [SearchWord]
    @Published private(set) var gameScore: GameScore
    @Published private(set) var timeCounter: UInt
    
    let title: String
    
    init(_ level: AppConfiguration.Level, pathState: PathState) {
        title = level.title
        self.pathState = pathState
        let matrixSize: SearchMatrix.Size = .init(
            width: level.matrixSize.width,
            height: level.matrixSize.height
        )
        matrix = SearchMatrix(size: matrixSize)
        words = level.words.map { SearchWord($0.uppercased()) }
        timeCounter = level.timeLimit
        gameScore = GameScore(
            time: .init(total: level.timeLimit, spent: 0),
            words: .init(total: UInt(level.words.count), found: 0)
        )
        
        words.forEach {
            matrix.include(word: $0.value)
        }
        print(">>> GameLevelViewModel init")
        runTimer()
    }
    
    func selectEntry(row: UInt, col: UInt) {
        let entry = matrix[row, col]
        
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
    
    private func setGameOver() {
        let totalTime = gameScore.time.total
        let timeSpent = totalTime - timeCounter
        pathState.path.append(
            GameScore(
                time: .init(total: totalTime, spent: timeSpent),
                words: .init(total: gameScore.words.total, found: UInt(words.filter(\.isFound).count))
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
    
    private func checkIfWordFound(on selection: [SearchMatrix.Entry]) -> SearchWord? {
        let selectedWord: String = selection
            .map { String($0.value) }
            .joined(separator: "")
        
        let reversedSelectedWord = String(selectedWord.reversed())
        let wordsFound = words.filter { word in
            !word.isFound && word.value == selectedWord || word.value == reversedSelectedWord
        }
        return wordsFound.first
    }
    
    private func setWordFound(_ word: SearchWord) {
        word.isFound = true
        
        selection.forEach {
            $0.isFound = true
            $0.isSelected = false
        }
    }
    
    private func isWordSetFound() -> Bool {
        words.filter({ $0.isFound == false }).isEmpty
    }
}
