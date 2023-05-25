import SwiftUI

struct SearchedWordView: View {
    let word: SearchedWord
    
    var body: some View {
        Text(word.value)
            .foregroundColor(.black)
            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            .background(
                Capsule()
                    .fill(.white)
                    
            )
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            SearchedWordView(word: SearchedWord("LOVE"))
        }
        .padding()
        .background(.gray)
    }
}
