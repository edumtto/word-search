import SwiftUI

struct MainMenuView: View {
    @ObservedObject private var pathState = PathState()
    private let configuration: AppConfiguration
    
    var body: some View {
        NavigationStack(path: $pathState.path) {
            ZStack {
                Image("background").resizable(resizingMode: .tile).opacity(0.5)
                    .ignoresSafeArea()
                VStack {
                    Text("Word Search")
                        .font(
                            .custom("AmericanTypewriter", fixedSize: 40)
                            .weight(.black)
                        )
                        .padding(24)
                    NavigationLink("Start game", value: configuration.levels[0])
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                    .foregroundColor(.black)
                    .controlSize(.large)
                    .fontWeight(.bold)
                    .padding(24)
                }
                .navigationDestination(for: AppConfiguration.Level.self) { level in
                    GameLevelView(viewModel: GameLevelViewModel(level, pathState: pathState))
                }
            }
        }
        .environmentObject(pathState)
    }
    
    init(configuration: AppConfiguration) {
        self.configuration = configuration
        print(">>> MainMenuView init")
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(configuration: AppConfiguration(levels: [
            AppConfiguration.Level(title: "", category: "", words: [], timeLimit: 10, matrixSize: .init(width: 3, height: 4))
        ]))
    }
}

final class PathState: ObservableObject {
    @Published var path: NavigationPath {
        didSet {
            print(">>> path count: \(path.count)")
        }
    }
    
    init(path: NavigationPath = NavigationPath()) {
        self.path = path
    }
}
