import SwiftUI

struct FinalScore: View {
    var score: GameScore
    
    var body: some View {
        VStack {
            Image(systemName: "trophy")
                .symbolVariant(.circle)
                .foregroundColor(.yellow)
                .background(
                    Circle().stroke()
                        .foregroundColor(.yellow)
                )
                .scaleEffect(5)
                .padding(.bottom, 54)
                
            Text("Congratulations!")
                .font(.title)
                .padding(16)
            Text("You found \(score.wordsFound) words in \(score.timeSpent) seconds!")
                .font(.title2)
        }
        .padding(16)
    }
}

struct FinalScore_Previews: PreviewProvider {
    static var previews: some View {
        FinalScore(score: GameScore(wordsFound: 5, timeSpent: "0"))
    }
}
