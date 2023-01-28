import SwiftUI

struct FinalScore: View {
    var score: GameScore
    
    var isGameWon: Bool {
        score.words.found == score.words.total
    }
    
    var body: some View {
        VStack {
            Image(systemName: isGameWon ? "trophy" : "timer.circle")
                .symbolVariant(.circle)
                .foregroundColor(isGameWon ? .yellow : .gray)
                .scaleEffect(5)
                .padding(.bottom, 54)
                
            Text(isGameWon ? "Congratulations!" : "Time is over!")
                .font(.title)
                .padding(16)
            Text("You found \(score.words.found) words from \(score.words.total)\nin \(score.time.spent) seconds!")
                .font(.title2)
                .multilineTextAlignment(.center)
        }
        .padding(16)
    }
}

struct FinalScore_Previews: PreviewProvider {
    static var previews: some View {
        FinalScore(score: GameScore(time: .init(total: 60, spent: 32), words: .init(total: 10, found: 9)))
    }
}
