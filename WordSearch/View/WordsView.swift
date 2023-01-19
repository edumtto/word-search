import SwiftUI

struct WordsView: View {
    var words: [String]
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Feelings")
                .font(.largeTitle)
            ForEach(words, id: \.self) { word in
                Text(word)
                    .background(Capsule().stroke()
                        .padding(.init(top: 1, leading: -4, bottom: 0, trailing: -4))
                    )
            }
        }
    }
}

struct WordsToFindView_Previews: PreviewProvider {
    static var previews: some View {
        WordsView(words: ["LOVE", "LIFE", "HEART", "FRIENDSHIP"])
    }
}
