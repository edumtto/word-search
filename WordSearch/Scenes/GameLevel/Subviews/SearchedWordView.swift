import SwiftUI

struct SearchedWordView: View {
    let word: SearchedWord
    
    var body: some View {
        Text(word.value)
            .background(
                Capsule()
                    .stroke()
                    .padding(.init(top: 1, leading: -4, bottom: 0, trailing: -4))
            )
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedWordView(word: SearchedWord("LOVE"))
    }
}
