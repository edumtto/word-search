import SwiftUI

struct MainMenuBackground: View {
    let proxy: GeometryProxy
    @State var animating = false
    
    var body: some View {
        Image("background")
            .resizable(resizingMode: .tile)
            .ignoresSafeArea()
            .frame(width: proxy.size.width, height: proxy.size.height , alignment: .center)
            .scaleEffect(animating ? 1 : 10, anchor: .center)
            .blur(radius: animating ? 0 : 16)
            .opacity(0.4)
            .animation(.easeIn(duration: 0.6), value: animating)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animating = true
                }
            }
    }
    
    init(proxy: GeometryProxy) {
        self.proxy = proxy
    }
}

struct MainMenuView: View {
    @EnvironmentObject var navigationState: NavigationState
    private let repository = Repository()
    @State var displayContent = false
    @State var zoomButton = false
    
    var body: some View {
        ZStack {
            CustomColor.secondary
                .ignoresSafeArea()
            GeometryReader { proxy in
                MainMenuBackground(proxy: proxy)
            }
            VStack(spacing: 32) {
                titleText
                startGameButton
            }
            .opacity(displayContent ? 1 : 0)
            .animation(
                .easeIn(duration: 0.4),
                value: displayContent
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                displayContent = true
                zoomButton = true
            }
        }
    }
    
    var titleText: some View {
        VStack(alignment: .trailing, spacing: -4) {
            Text("Word Search")
                .font(
                    .custom("AmericanTypewriter", fixedSize: 40)
                    .weight(.black)
                )
            Text("by @edumtto")
                .font(.caption)
                .foregroundColor(.black)
        }
        .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        .border(.black)
        .background(.white)
    }
    
    var startGameButton: some View {
        NavigationLink("Start game", value: repository.level)
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
            .foregroundColor(.black)
            .controlSize(.large)
            .fontWeight(.bold)
            .padding(24)
            .scaleEffect(zoomButton ? 1.1 : 1)
            .animation(
                .easeInOut.repeatForever(autoreverses: true).delay(1),
                value: zoomButton
            )
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
