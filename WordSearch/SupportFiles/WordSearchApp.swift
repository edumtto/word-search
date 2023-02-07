import SwiftUI

@main
struct WordSearchApp: App {
    private var configuration: AppConfiguration {
        JSONLoader.load(
            fileName: "configuration",
            keyDecodingStrategy: .convertFromSnakeCase
        )
    }
    
    @StateObject private var navigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationState.path) {
                MainMenuView(configuration: configuration)
                    .navigationDestination(for: AppConfiguration.Level.self) { level in
                        GameLevelView(game: Game(level, navigationState: navigationState))
                    }
                    .navigationDestination(for: GameScore.self) { score in
                        FinalScoreView(score: score)
                    }
            }
            .environmentObject(navigationState)
        }
    }
}


