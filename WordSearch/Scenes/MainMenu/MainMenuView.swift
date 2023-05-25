import SwiftUI

struct MainMenuBackground: View {
    let proxy: GeometryProxy
    let offset: CGSize
    @State var move = false
    
    var body: some View {
        Image("background").resizable(resizingMode: .tile).opacity(0.5)
            .frame(width: proxy.size.width, height: proxy.size.height , alignment: .center)
            .ignoresSafeArea()
            .offset(move ? offset : .init(width: 0, height: -proxy.size.height / 8))
            .scaleEffect(move ? 2.4 : 1.6, anchor: .center)
            .rotation3DEffect(.degrees(30), axis: (x: 1, y: 0, z: 0))
            .animation(
                Animation.easeInOut(duration: 14).repeatForever(autoreverses: true),
                value: move
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    move.toggle()
                }
            }
    }
    
    init(proxy: GeometryProxy) {
        self.proxy = proxy
        self.offset = .init(width: 0, height: -proxy.size.height / 8 - 40)
    }
}

struct MainMenuView: View {
    @EnvironmentObject var navigationState: NavigationState
    private let repository = Repository()
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                MainMenuBackground(proxy: proxy)
            }
            VStack {
                Text("Word Search")
                    .font(
                        .custom("AmericanTypewriter", fixedSize: 40)
                        .weight(.black)
                    )
                    .padding(24)
                NavigationLink("Start game", value: repository.level)
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
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
