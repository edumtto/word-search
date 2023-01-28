import SwiftUI

struct GameLevelView: View {
    @ObservedObject private var viewModel = GameLevelViewModel(
        matrixSize: .init(width: 9, height: 12),
        words: [SearchWord("LOVE"), SearchWord("LIFE"), SearchWord("HEART"), SearchWord("FRIENDSHIP"), SearchWord("PEACE"), SearchWord("HAPPY"), SearchWord("ROMANCE"), SearchWord("THANKS"), SearchWord("SMILE")]
    )
    
    var body: some View {
            wordsView
            .navigationDestination(isPresented: $viewModel.presentScore) {
                FinalScore(score: viewModel.gameScore)
            }
    }
    
    private var wordsView: some View {
        VStack {
            SearchedWordsView(words: viewModel.words)
                .padding(.leading, 16)
                .padding(.trailing, 16)
            TimeCounterView(timeTotal: viewModel.gameScore.time.total, timeCounter: viewModel.timeCounter)
            Divider()
                .padding(.top)
                .padding(.bottom)
            ForEach(0..<viewModel.matrix.size.height, id: \.self) { row in
                HStack {
                    ForEach(0..<viewModel.matrix.size.width, id: \.self) { column in
                        let entry = viewModel.matrix[row, column]
                        MatrixItemView()
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
        GameLevelView()
    }
}
