import SwiftUI

@main
struct WordSearchApp: App {
    @StateObject private var navigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationState.path) {
                MainMenuView()
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


