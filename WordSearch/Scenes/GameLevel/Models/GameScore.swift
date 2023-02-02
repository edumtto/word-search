import Foundation

struct GameScore: Hashable {
    struct Time: Hashable {
        let total, spent: UInt
    }
    
    struct Words: Hashable {
        let total, found: UInt
    }

    let time: Time
    let words: Words
}
