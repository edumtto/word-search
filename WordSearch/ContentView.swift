import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            SearchMatrixView()
//                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
