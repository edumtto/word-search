import Foundation

//protocol SearchMatrixProtocol {
//    func isEmpty()
//}

import Foundation

class SearchMatrixViewModel {
    var model: SearchMatrix = {
        var model = SearchMatrix(size: .init(width: 8, height: 8))
        model.include(words: "____", "###", "****", "!!!!!!")
        return model
    }()
    
//    private var randomCharacter: Character {
//        let allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
//        let randomNum = Int(arc4random_uniform(UInt32(allowedChars.count)))
//        let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
//        return allowedChars[randomIndex]
//    }
    

    
    // row value starts in 0, 1, 2 ...
//    func row(_ id: Int) -> [Character] {
//        let initialIndex = id * size.width
//        let finalIndex = initialIndex + size.width - 1
//        let row = elements[initialIndex...finalIndex]
//        return [Character](row)
//    }
    
//    func randomized() -> Self {
//        let length = size.height * size.width
//        var newElements = [Character]()
//        for _ in 0..<length {
//            newElements.append(randomCharacter)
//        }
//        elements = newElements
//        return self
//    }
}
