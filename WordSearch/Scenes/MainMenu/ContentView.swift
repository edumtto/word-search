import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            GameLevelView()
                .navigationTitle("Level 1")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
