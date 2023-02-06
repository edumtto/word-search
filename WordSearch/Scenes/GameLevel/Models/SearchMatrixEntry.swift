import Foundation

extension SearchMatrix {
    final class Entry: Hashable, ObservableObject {
        struct Position: Equatable, Hashable {
            let row, col: UInt
        }
        
        static let emptyValue: Character = "-"
        
        @Published var isSelected: Bool
        @Published var isFound: Bool
        var value: Character
        var position: Position
        var isPartOfAWord: Bool
        
        init(
            value: Character = Entry.emptyValue,
            position: Position,
            isSelected: Bool = false,
            isFound: Bool = false,
            isPartOfAWord: Bool = false
        ) {
            self.value = value
            self.position = position
            self.isSelected = isSelected
            self.isFound = isFound
            self.isPartOfAWord = isPartOfAWord
        }
        
        static func == (lhs: SearchMatrix.Entry, rhs: SearchMatrix.Entry) -> Bool {
            lhs.position == rhs.position
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(position)
        }
    }
}
