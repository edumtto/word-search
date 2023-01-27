import SwiftUI

struct SearchMatrixView: View {
    @ObservedObject private var viewModel = SearchMatrixViewModel()
    
    var body: some View {
        VStack {
            WordsView(words: viewModel.words)
            Divider()
                .padding(.top)
                .padding(.bottom)
            ForEach(0..<viewModel.matrix.size.height, id: \.self) { row in
                HStack {
                    ForEach(0..<viewModel.matrix.size.width, id: \.self) { column in
                        let entry = viewModel.matrix[row, column]
                        CharacterCell()
                            .environmentObject(entry)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                viewModel.selectEntry(row: row, col: column)
                            }
                    }
                }
            }
        }
    }
}

struct SearchMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMatrixView()
    }
}
