//
//  CharacterCell.swift
//  WordSearch
//
//  Created by Eduardo Motta de Oliveira on 1/10/23.
//

import SwiftUI

struct CharacterCell: View {
    var character: Character
    
    var body: some View {
        Text(String(character))
            .font(.headline)
    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell(character: "A")
    }
}
