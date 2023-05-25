import SwiftUI

struct FinalScoreView: View {
    let score: GameScore
    @EnvironmentObject var navigationState: NavigationState
    @State var displayContent = false
    private let springAnimation = Animation.interpolatingSpring(stiffness: 100, damping: 20)
    
    var isGameWon: Bool {
        score.words.found == score.words.total
    }
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [CustomColor.secondary, CustomColor.tertiary], center: .center, startRadius: 20, endRadius: 500)
                .ignoresSafeArea()
            VStack(spacing: 32) {
                headerImageAndText
                scoreText
                backButton
                .navigationTitle("Score")
                .navigationBarBackButtonHidden(true)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                displayContent.toggle()
            }
        }
    }
    
    var headerImageAndText: some View {
        VStack {
            Text(isGameWon ? "🏆" : "😥")
                .font(Font.system(size: 100))
            Text(isGameWon ? "Congratulations!" : "Time is over!")
                .font(.title)
                .bold()
                .padding(.bottom, 16)
                .foregroundColor(.white)
        }
    }
    
    var scoreText: some View {
        VStack(spacing: 16) {
            VStack {
                Text("Words found:")
                Text("\(score.words.found)/\(score.words.total)")
                    .font(.title2)
                    .fontWeight(.black)
                    .opacity(displayContent ? 1 : 0)
                    .animation(springAnimation.delay(0.3), value: displayContent)
            }
            VStack {
                Text("Time:")
                Text("\(score.time.spent) seconds")
                    .font(.title2)
                    .fontWeight(.black)
                    .opacity(displayContent ? 1 : 0)
                    .animation(springAnimation.delay(0.6), value: displayContent)
            }
        }
        .foregroundColor(.white)
        .onAppear()
    }
    
    var backButton: some View {
        Button("Back to main menu") {
            navigationState.cleanPath()
        }
        .buttonStyle(.borderedProminent)
        .tint(.accentColor)
        .foregroundColor(.black)
        .controlSize(.large)
        .fontWeight(.bold)
        .padding(16)
        .opacity(displayContent ? 1 : 0)
        .scaleEffect(displayContent ? 1 : 0.01)
        .animation(springAnimation.delay(1), value: displayContent)
    }
}

struct FinalScoreView_Previews: PreviewProvider {
    static var previews: some View {
        FinalScoreView(score: GameScore(time: .init(total: 60, spent: 32), words: .init(total: 10, found: 10)))
    }
}
