import SwiftUI

struct SearchWordsView: View {
    var words: [SearchWord]
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Feelings")
                .font(.largeTitle)
            GeometryReader { geometry in
                wordStack(geometry: geometry)
            }
        }
    }
    
    private func wordStack(geometry: GeometryProxy) -> some View {
        let availableSpace = geometry.size
        var usedSpace = CGSize.zero
        
        return ZStack(alignment: .center) {
            ForEach(words, id: \.self) { word in
                WordView()
                    .environmentObject(word)
                    .padding(.all, 8)
                    .alignmentGuide(VerticalAlignment.center) { dimension in
                        -usedSpace.height
                    }
                    .alignmentGuide(HorizontalAlignment.center) { dimension in
                        if word == words.first {
                            usedSpace.width = dimension.width
                            return 0
                        }
                        
                        // if needs to move to next row
                        if dimension.width > (availableSpace.width - usedSpace.width) {
                            usedSpace.width = dimension.width
                            usedSpace.height += dimension.height
                            return 0
                        }
                        
                        let horizontalPosition = -usedSpace.width
                        usedSpace.width += dimension.width
                        return horizontalPosition
                    }
                
            }
        }
    }
}

struct SearchWordsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchWordsView(words: [SearchWord("LOVE"), SearchWord("LIFE", isFound: true), SearchWord("HEART"), SearchWord("FRIENDSHIP"), SearchWord("PEACE"), SearchWord("HAPPY"), SearchWord("ROMANCE"), SearchWord("THANKS"), SearchWord("SMILE")])
    }
}
