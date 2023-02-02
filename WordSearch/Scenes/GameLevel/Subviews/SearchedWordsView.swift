import SwiftUI

struct SearchedWordsView: View {
    var words: [SearchWord]
    
    var body: some View {
        VStack(spacing: 4) {
            ScrollView(.horizontal) {
                HStack(spacing: 14) {
                    ForEach(words, id: \.self) { word in
                        WordView()
                            .environmentObject(word)
                    }
                }.padding(16)
            }
        }
    }
}

struct SearchWordsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedWordsView(words: [SearchWord("LOVE"), SearchWord("LIFE", isFound: true), SearchWord("HEART"), SearchWord("FRIENDSHIP"), SearchWord("PEACE"), SearchWord("HAPPY"), SearchWord("ROMANCE"), SearchWord("THANKS"), SearchWord("SMILE")])
    }
}
