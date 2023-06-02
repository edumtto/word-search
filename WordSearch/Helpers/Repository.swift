import Foundation

struct Repository {
    let configuration: AppConfiguration = {
        JSONLoader.load(
            fileName: "configuration",
            keyDecodingStrategy: .convertFromSnakeCase
        )
    }()
    
    var level: AppConfiguration.Level {
        let availableLevels = configuration.levels.count
        let levelIndex = Int.random(in: 0..<availableLevels)
        return configuration.levels[levelIndex]
    }
}
