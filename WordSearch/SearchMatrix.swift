import Foundation

class SearchMatrix {
    struct Size {
        let width, height: Int
    }

    struct Element: Hashable {
        static let defaultValue: Character = "."
        
        var value: Character
        var isFound: Bool

        init(_ value: Character = defaultValue) {
            self.value = value
            self.isFound = false
        }
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
    var data: [[Element]]

    init(size: Size) {
        self.size = size
        data = [[Element]](
            repeating: [Element](
                repeating: Element(),
                count: size.width
            ),
            count: size.height
        )
    }

    init(size: Size, data: [[Element]]) {
        self.size = size
        self.data = data
    }
    
    func row(_ index: Int) -> [Element] {
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
            if data[row][col].value != Element.defaultValue {
                return false
            }
        }
        return true
    }
    
    private func insertWord(_ word: String, position: WordPosition) {
        for i in 0..<word.count {
            let row = position.axis == .horizontal ? position.origin.row : position.origin.row + i
            let col = position.axis == .horizontal ? position.origin.col + i : position.origin.row
            data[row][col] = Element(word[word.index(word.startIndex, offsetBy: i)])
        }
    }
}
