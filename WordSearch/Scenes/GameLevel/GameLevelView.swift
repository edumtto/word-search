import SwiftUI

struct GameLevelView: View {
    @StateObject var game: Game
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [CustomColor.primary, CustomColor.secondary]),
                startPoint: .top,
                endPoint: .bottom
            )
                .ignoresSafeArea()
            VStack {
                headerView
                wordsView
                matrixView
            }
        }
        .navigationTitle(game.levelTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Text(game.levelCategory)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Spacer()
            TimeCounterView(timeTotal: game.score.time.total, timeCounter: game.timeCounter)
        }
        .frame(height: 40)
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
    
    private var wordsView: some View {
        SearchedWordListView(words: game.notFoundWords)
    }
    
    private var matrixView: some View {
        VStack {
            ForEach(0..<game.searchMatrix.size.height, id: \.self) { row in
                HStack {
                    ForEach(0..<game.searchMatrix.size.width, id: \.self) { column in
                        let entry = game.searchMatrix[row, column]
                        SearchMatrixEntryView()
                            .environmentObject(entry)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                game.selectEntry(row: row, col: column)
                            }
                    }
                }
            }
        }
        .padding(4)
        .background(.white)
        .cornerRadius(8)
    }
}

struct SearchMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameLevelView(
                game: Game(
                    AppConfiguration.Level(
                        title: "Level 3",
                        category: "Fruits",
                        words: ["apple", "grape", "orange", "banana", "guava", "melon"],
                        timeLimit: 20,
                        matrixSize: .init(width: 9, height: 12)
                    ),
                    navigationState: NavigationState()
                )
            )
        }
    }
}
