import Foundation

final class SearchedWord: ObservableObject, Hashable, Identifiable {
    let value: String
    
    init(_ value: String) {
        self.value = value.uppercased()
    }
    
    static func == (lhs: SearchedWord, rhs: SearchedWord) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
