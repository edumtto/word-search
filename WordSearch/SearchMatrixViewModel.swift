import Foundation
import Combine

@MainActor class SearchMatrixViewModel: ObservableObject {
    enum SelectionAxis {
        case horizontal, vertical
    }
    
    private var selection: [SearchMatrix.Entry] = []
    private var selectionAxis: SelectionAxis?
    private lazy var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .sink {
            print("timer fired: \($0)")
        }
    
    @Published private(set) var matrix: SearchMatrix
    @Published private(set) var words: [SearchWord]
    @Published private(set) var gameScore = GameScore(wordsFound: 0, timeSpent: "0 seconds")
    @Published private(set) var timeCounter: Int = 0
    @Published var presentScore: Bool = false
    
    init(matrixSize: SearchMatrix.Size, words: [SearchWord]) {
        self.matrix = SearchMatrix(size: matrixSize)
        self.words = words
        words.forEach {
            matrix.include(word: $0.value)
        }
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
                    presentScore = true
                    gameScore = GameScore(
                        wordsFound: words.count,
                        timeSpent: "\(timeCounter)"
                    )
                }
            }
            print("selected \(entry.value): \(entry.isSelected)")
            return
        }
        
        clearSelection()
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
