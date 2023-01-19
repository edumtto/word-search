import Foundation

extension SearchMatrix {
    final class Entry: Hashable, ObservableObject {
        struct Position: Equatable, Hashable {
            let row, col: UInt
        }
        static let emptyValue: Character = "-"
        
        var value: Character
        var isSelected: Bool
        var isFound: Bool
        var position: Position
        
        var isEmpty: Bool {
            value == Entry.emptyValue
        }
        
        init(value: Character = Entry.emptyValue, position: Position, isSelected: Bool = false, isFound: Bool = false) {
            self.value = value
            self.position = position
            self.isSelected = isSelected
            self.isFound = isFound
        }
        
        static func == (lhs: SearchMatrix.Entry, rhs: SearchMatrix.Entry) -> Bool {
            lhs.position == rhs.position
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(position)
        }
    }
}

class SearchMatrix {
    struct Size {
        let width, height: UInt
    }
    
    struct WordPosition {
        enum Axis {
            case horizontal, vertical
        }
        
        let origin: Entry.Position
        let axis: Axis
    }

    let size: Size
    @Published var grid: [[Entry]]

    init(size: Size) {
        self.size = size
        grid = [[Entry]]()
//            repeating: [Entry(position: .init(row: <#T##UInt#>, col: <#T##UInt#>))](
//                repeating: SearchMatrixEntry(),
//                count: size.width
//            ),
//            count: size.height
//        )
        for row in 0..<size.height {
            var entryRow: [Entry] = []
            for col in 0..<size.width {
                let entry = Entry(value: randomCharacter, position: .init(row: row, col: col))
                entryRow.append(entry)
            }
            grid.append(entryRow)
        }
    }

    init(size: Size, grid: [[Entry]]) {
        self.size = size
        self.grid = grid
    }
    
    func row(_ index: Int) -> [Entry] {
        guard index >= 0, index < size.height else {
            return []
        }
        return grid[index]
    }
    
    subscript(row: UInt, col: UInt) -> Entry {
        get {
          return grid[Int(row)][Int(col)]
        }
        set(entry) {
            grid[Int(row)][Int(col)] = entry
        }
    }
    
    func include(words: [String]) {
        words.forEach(include)
    }
    
    func include(word: String) {
        var retries = 0
        
        repeat {
            guard let randomPosition = randomPosition(word: word) else { return } // Throws exception
            if isInsertionPossible(word, position: randomPosition) {
                insertWord(word, position: randomPosition)
                debugPrint("\"\(word)\" inserted (retries: \(retries))")
                return
            }
            retries += 1
        }
        while retries < 10
    }
    
    private var randomCharacter: Character {
        let allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomNum = Int(arc4random_uniform(UInt32(allowedChars.count)))
        let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
        return allowedChars[randomIndex]
    }
    
    func fillEmptyEntriesRandomly() {
        for row in 0..<size.height {
            for col in 0..<size.width {
                if self[row, col].isEmpty {
                    self[row, col] = Entry(value: randomCharacter, position: .init(row: row, col: col))
                }
            }
        }
    }
        
    private func randomPosition(word: String) -> WordPosition? {
        let wordLength = UInt(word.count)
        
        let isHorizontal = (arc4random_uniform(2) == 0)
        if isHorizontal, wordLength <= size.width {
            return WordPosition(
                origin: .init(
                    row: randomIndex(lessThan: size.height),
                    col: randomIndex(lessThan: size.width - wordLength)
                ),
                axis: .horizontal
            )
        } else if wordLength <= size.height {
            return WordPosition(
                origin: .init(
                    row: randomIndex(lessThan: size.height - wordLength),
                    col: randomIndex(lessThan: size.width)
                ),
                axis: .vertical
            )
        }
        return nil
    }
    
    private func randomIndex(lessThan limitValue: UInt) -> UInt {
        UInt(arc4random_uniform(UInt32(limitValue)))
    }
    
    private func isInsertionPossible(_ word: String, position: WordPosition) -> Bool {
        let wordLength = UInt(word.count)
        for i in 0..<wordLength {
            let row = position.axis == .horizontal ? position.origin.row : position.origin.row + i
            let col = position.axis == .horizontal ? position.origin.col + i : position.origin.row
            if !self[row, col].isEmpty {
                return false
            }
        }
        return true
    }
    
    private func insertWord(_ word: String, position: WordPosition) {
        let wordLength = UInt(word.count)
        for i in 0..<wordLength {
            let row = position.axis == .horizontal ? position.origin.row : position.origin.row + i
            let col = position.axis == .horizontal ? position.origin.col + i : position.origin.row
            self[row, col] = Entry(
                value: word[word.index(word.startIndex, offsetBy: Int(i))],
                position: .init(row: row, col: col)
            )
        }
    }
}
