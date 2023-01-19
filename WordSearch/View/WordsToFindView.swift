//
//  WordsToFindView.swift
//  WordSearch
//
//  Created by Eduardo Motta de Oliveira on 1/17/23.
//

import SwiftUI

struct WordsToFindView: View {
    var words: [String] = ["LOVE", "LIFE", "HEART", "FRIENDSHIP"]
    
    var body: some View {
        VStack {
            Text("Feelings")
                .font(.largeTitle)
            ForEach(words, id: \.self) { word in
                Text(word)
                    .background(Capsule().stroke()
                        .padding(.init(top: 0, leading: -4, bottom: 0, trailing: -4))
                    )
            }
        }
    }
}

struct WordsToFindView_Previews: PreviewProvider {
    static var previews: some View {
        WordsToFindView()
    }
}
