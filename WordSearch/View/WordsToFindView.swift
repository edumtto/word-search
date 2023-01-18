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
            ForEach(words, id: \.self) { word in
                Text(word)
            }
        }
    }
}

struct WordsToFindView_Previews: PreviewProvider {
    static var previews: some View {
        WordsToFindView()
    }
}
