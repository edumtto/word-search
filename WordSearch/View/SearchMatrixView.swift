import SwiftUI

struct SearchMatrixView: View {
    var searchMatrix = SearchMatrixViewModel()
        
                                
    var body: some View {
        VStack {
            ForEach(0..<searchMatrix.model.size.height, id: \.self) { rowIndex in
                HStack {
                    ForEach(searchMatrix.model.row(rowIndex), id: \.self) { elem in
                        CharacterCell(character: elem.value)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            Divider()
            WordsToFindView()
                .padding(.top)
        }
        .padding()

    }
}

struct SearchMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMatrixView()
    }
}
