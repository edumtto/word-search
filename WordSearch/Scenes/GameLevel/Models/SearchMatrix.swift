import Foundation

final class SearchMatrix {
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
    var wordInsertionRetries: Int = 10

    init(size: Size) {
        self.size = size
        grid = [[Entry]]()
        
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
    
    @discardableResult func include(word: String) -> Bool {
        for _ in 0...wordInsertionRetries {
            guard let randomPosition = randomPosition(word: word) else {
                return false
            }
            
            if isInsertionPossible(word, position: randomPosition) {
                insertWord(word, position: randomPosition)
                 // debugPrint("\"\(word)\" inserted with \(retryCount) retries")
                return true
            }
        }
                
        return false
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
                if !self[row, col].isPartOfAWord {
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
            if self[row, col].isPartOfAWord {
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
                position: .init(row: row, col: col),
                isPartOfAWord: true
            )
        }
    }
}
