import SwiftUI

@main
struct WordSearchApp: App {
    private var configuration: AppConfiguration {
        JSONLoader.load(
            fileName: "configuration",
            keyDecodingStrategy: .convertFromSnakeCase
        )
    }
    
    var body: some Scene {
        WindowGroup {
            MainMenuView(configuration: configuration)
        }
    }
}
