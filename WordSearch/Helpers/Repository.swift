import Foundation

struct Repository {
    let configuration: AppConfiguration = {
        JSONLoader.load(
            fileName: "configuration",
            keyDecodingStrategy: .convertFromSnakeCase
        )
    }()
    
    var level: AppConfiguration.Level {
        configuration.levels[0]
    }
}
