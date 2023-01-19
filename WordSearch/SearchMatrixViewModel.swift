import Foundation

@MainActor class SearchMatrixViewModel: ObservableObject {
    static let staticWords: [String] = ["LOVE", "LIFE", "HEART", "FRIENDSHIP"]
    
    @Published var matrix: SearchMatrix = {
        var model = SearchMatrix(size: .init(width: 9, height: 12))
        model.include(words: staticWords)
        model.fillEmptyEntriesRandomly()
        return model
    }()
    
    @Published var words: [String] = staticWords
}
