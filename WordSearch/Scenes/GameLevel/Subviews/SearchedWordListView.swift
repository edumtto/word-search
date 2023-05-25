import SwiftUI

struct SearchedWordListView: View {
    var words: [SearchedWord]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 14) {
                ForEach(words) { word in
                    SearchedWordView(word: word)
                }
            }
            .preferredColorScheme(.dark)
            .padding()
        }
    }
}

struct SearchWordsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedWordListView(words: [SearchedWord("LOVE"), SearchedWord("LIFE"), SearchedWord("HEART"), SearchedWord("FRIENDSHIP"), SearchedWord("PEACE"), SearchedWord("HAPPY"), SearchedWord("ROMANCE"), SearchedWord("THANKS"), SearchedWord("SMILE")])
            .padding(.init(top: 16, leading: 0, bottom: 16, trailing: 0))
            .background(.gray)
    }
}
