import SwiftUI

struct GameLevelView: View {
    @EnvironmentObject var pathState: PathState
    
    @ObservedObject var viewModel: GameLevelViewModel
    
    var body: some View {
        VStack {
            headerView
            wordsView
            Divider()
            matrixView
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: GameScore.self) { score in
            FinalScore(score: score)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Feelings")
                .font(.largeTitle)
            Spacer()
            TimeCounterView(timeTotal: viewModel.gameScore.time.total, timeCounter: viewModel.timeCounter)
        }
        .frame(height: 40)
        
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
    
    private var wordsView: some View {
            SearchedWordsView(words: viewModel.words)
    }
    
    private var matrixView: some View {
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

struct SearchMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameLevelView(
                viewModel: GameLevelViewModel(
                    AppConfiguration.Level(
                        title: "Level 3",
                        category: "Fruits",
                        words: ["apple", "grape", "orange"],
                        timeLimit: 20,
                        matrixSize: .init(width: 9, height: 12)
                    ),
                    pathState: PathState()
                )//.previewDevice(.init(rawValue: "iPhone 14"))
            )
        }
    }
}
