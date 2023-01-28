import Foundation
import Combine

@MainActor class SearchMatrixViewModel: ObservableObject {
    enum SelectionAxis {
        case horizontal, vertical
    }
    
    private var selection: [SearchMatrix.Entry] = []
    private var selectionAxis: SelectionAxis?
    private var timer = Timer()
    
    @Published private(set) var matrix: SearchMatrix
    @Published private(set) var words: [SearchWord]
    @Published private(set) var gameScore: GameScore
    @Published private(set) var timeCounter: Int
    @Published var presentScore: Bool = false
    
    init(matrixSize: SearchMatrix.Size, words: [SearchWord], timeLimit: Int = 10) {
        self.matrix = SearchMatrix(size: matrixSize)
        self.words = words
        self.timeCounter = timeLimit
        self.gameScore = GameScore(
            time: .init(total: timeLimit, spent: 0),
            words: .init(total: words.count, found: 0)
        )
        
        words.forEach {
            matrix.include(word: $0.value)
        }
        
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
            print("selected \(entry.value): \(entry.isSelected)")
            return
        }
        
        clearSelection()
    }
    
    private func setGameOver() {
        let totalTime = gameScore.time.total
        let timeSpent = totalTime - timeCounter
        gameScore = GameScore(
            time: .init(total: totalTime, spent: timeSpent),
            words: .init(total: gameScore.words.total, found: words.filter(\.isFound).count)
        )
        presentScore = true
    }
    
    private func runTimer() {
         timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
         )
    }
    
    private func stopTimer() {
        timer.invalidate()
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
        
        print("Yay! \(word.value) found!")
    }
    
    private func isWordSetFound() -> Bool {
        words.filter({ $0.isFound == false }).isEmpty
    }
}
