import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var navigationState: NavigationState
    private let repository = Repository()
    
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
                NavigationLink("Start game", value: repository.level)
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                    .foregroundColor(.black)
                    .controlSize(.large)
                    .fontWeight(.bold)
                    .padding(24)
            }
        }
    }
    
    init() {
        debugPrint("> MainMenuView init")
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
