import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var navigationState: NavigationState
    private let configuration: AppConfiguration
    
    var body: some View {
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
                NavigationLink("Start game", value: configuration.levels[1])
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                    .foregroundColor(.black)
                    .controlSize(.large)
                    .fontWeight(.bold)
                    .padding(24)
            }
        }
    }
    
    init(configuration: AppConfiguration) {
        self.configuration = configuration
        debugPrint("> MainMenuView init")
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(configuration: AppConfiguration(levels: [
            AppConfiguration.Level(title: "", category: "", words: [], timeLimit: 10, matrixSize: .init(width: 3, height: 4))
        ]))
    }
}
