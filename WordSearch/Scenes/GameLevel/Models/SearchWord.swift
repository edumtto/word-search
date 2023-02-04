import Foundation

final class SearchWord: ObservableObject, Hashable, Identifiable {
    let value: String
    @Published var isFound: Bool
    
    init(_ value: String, isFound: Bool = false) {
        self.value = value
        self.isFound = isFound
    }
    
    static func == (lhs: SearchWord, rhs: SearchWord) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
