import Foundation

@MainActor class SearchMatrixViewModel: ObservableObject {
    enum SelectionAxis {
        case horizontal, vertical
    }
    static let staticWords: [String] = ["LOVE", "LIFE", "HEART", "FRIENDSHIP"]
    private var selection: [SearchMatrix.Entry] = []
    private var selectionAxis: SelectionAxis?
    
    @Published var matrix: SearchMatrix = {
        var model = SearchMatrix(size: .init(width: 9, height: 12))
        model.include(words: staticWords)
        //model.fillEmptyEntriesRandomly()
        return model
    }()
    
    @Published var words: [String] = staticWords
    
    func selectEntry(row: UInt, col: UInt) {
        let entry = matrix[row, col]
        
        if entry.isSelected {
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
            checkIfWordFound()
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
    
    private func checkIfWordFound() {
        let selectedWord: String = selection
            .map { String($0.value) }
            .joined(separator: "")
        
        let reversedSelectedWord = String(selectedWord.reversed())
        SearchMatrixViewModel.staticWords.forEach { word in
            if word == selectedWord || word == reversedSelectedWord {
                setWordFound(word)
            }
        }
    }
    
    private func setWordFound(_ word: String) {
        selection.forEach {
            $0.isFound = true
            $0.isSelected = false
        }
        
        print("Yay! \(word) found!")
    }
}
