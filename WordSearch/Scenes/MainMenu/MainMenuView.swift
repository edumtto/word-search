import SwiftUI

struct MainMenuView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
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
                    NavigationLink("Start game") {
                        GameLevelView(level: 1)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                    .foregroundColor(.black)
                    .controlSize(.large)
                    .fontWeight(.bold)
                    .padding(24)
                }

            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
