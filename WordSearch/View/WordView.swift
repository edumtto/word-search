import SwiftUI

struct WordView: View {
    @EnvironmentObject var word: SearchWord
    
    var body: some View {
        Text(word.value)
            .background(Capsule().stroke()
                .padding(.init(top: 1, leading: -4, bottom: 0, trailing: -4))
            )
            .strikethrough(word.isFound)
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView().environmentObject(SearchWord("LOVE", isFound: true))
    }
}
