import Foundation

struct AppConfiguration: Decodable, Hashable {
    struct MatrixSize: Decodable, Hashable {
        let width, height: UInt
    }
    
    struct Level: Decodable, Hashable {
        let title, category: String
        let words: [String]
        let timeLimit: UInt
        let matrixSize: MatrixSize
    }
    
    let levels: [Level]
}
