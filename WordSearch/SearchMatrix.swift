import Foundation

struct SearchMatrixEntry: Hashable {
    static let emptyValue: Character = "-"
    
    var value: Character
    var isFound: Bool
    
    var isEmpty: Bool {
        value == SearchMatrixEntry.emptyValue
    }

    init(_ value: Character = emptyValue) {
        self.value = value
        self.isFound = false
    }
}

class SearchMatrix {
    struct Size {
        let width, height: Int
    }
    
    struct WordPosition {
        enum Axis {
            case horizontal, vertical
        }
        
        struct Origin {
            let row, col: Int
        }
        
        let origin: Origin
        let axis: Axis
    }

    let size: Size
    var data: [[SearchMatrixEntry]]

    init(size: Size) {
        self.size = size
        data = [[SearchMatrixEntry]](
            repeating: [SearchMatrixEntry](
                repeating: SearchMatrixEntry(),
                count: size.width
            ),
            count: size.height
        )
    }

    init(size: Size, data: [[SearchMatrixEntry]]) {
        self.size = size
        self.data = data
    }
    
    func row(_ index: Int) -> [SearchMatrixEntry] {
        guard index >= 0, index < size.height else {
            return []
        }
        return data[index]
    }
    
    func include(words: String...) {
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
        for i in 0..<size.height {
            for j in 0..<size.width {
                if data[i][j].isEmpty {
                    data[i][j] = SearchMatrixEntry(randomCharacter)
                }
            }
        }
    }
        
    private func randomPosition(word: String) -> WordPosition? {
        let wordLength = word.count
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
    
    private func randomIndex(lessThan limitValue: Int) -> Int {
        Int(arc4random_uniform(UInt32(limitValue)))
    }
    
    private func isInsertionPossible(_ word: String, position: WordPosition) -> Bool {
        for i in 0..<word.count {
            let row = position.axis == .horizontal ? position.origin.row : position.origin.row + i
            let col = position.axis == .horizontal ? position.origin.col + i : position.origin.row
            if !data[row][col].isEmpty {
                return false
            }
        }
        return true
    }
    
    private func insertWord(_ word: String, position: WordPosition) {
        for i in 0..<word.count {
            let row = position.axis == .horizontal ? position.origin.row : position.origin.row + i
            let col = position.axis == .horizontal ? position.origin.col + i : position.origin.row
            data[row][col] = SearchMatrixEntry(word[word.index(word.startIndex, offsetBy: i)])
        }
    }
}
