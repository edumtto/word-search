import Foundation

struct GameScore: Hashable {
    struct Time: Hashable {
        let total, spent: Int
    }
    
    struct Words: Hashable {
        let total, found: Int
    }

    let time: Time
    let words: Words
}
