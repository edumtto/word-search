import SwiftUI

struct SearchMatrixView: View {
    @StateObject private var viewModel = SearchMatrixViewModel()
    //    @State private var offset = CGSize.zero
    
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
                                entry.isSelected = true
                                print("selected \(entry.value): \(entry.isSelected)")
                            }
                    }
                }
            }
            //            .gesture(
            //                DragGesture()
            //                    .onChanged { gesture in
            //                        offset = gesture.translation
            //                    }
            //                    .onEnded { _ in
            ////                        if abs(offset.width) > 100 {
            ////                            // remove the card
            ////                        } else {
            ////                            offset = .zero
            ////                        }
            //                    }
            //            )
        }
        //        .padding()
        
    }
}

struct SearchMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMatrixView()
    }
}
