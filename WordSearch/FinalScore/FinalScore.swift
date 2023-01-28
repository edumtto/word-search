import SwiftUI

struct FinalScore: View {
    var score: GameScore
    
    var body: some View {
        Text("Congratulations!\nYou found \(score.wordsFound) words in \(score.timeSpent) seconds!")
    }
}

struct FinalScore_Previews: PreviewProvider {
    static var previews: some View {
        FinalScore(score: GameScore(wordsFound: 5, timeSpent: "0 seconds"))
    }
}
