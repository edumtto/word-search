import SwiftUI

struct SearchMatrixEntryView: View {
    @EnvironmentObject var entry: SearchMatrix.Entry
    
    var body: some View {
        Text(String(entry.value))
            .font(.headline)
            .frame(width: 32, height: 32)
            .background(
                Capsule()
                    .foregroundColor(entry.isSelected ? Color.yellow : Color.clear)
            )
            .foregroundColor(entry.isFound ? .red : .black)
            .animation(.linear(duration: 0.2), value: entry.isSelected)
            .animation(.linear, value: entry.isFound)
    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchMatrixEntryView()
            .environmentObject(
                SearchMatrix.Entry(
                    value: "A",
                    position: .init(row: 0, col: 0),
                    isSelected: true,
                    isFound: false
                )
            )
    }
}
