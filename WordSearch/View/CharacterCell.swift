import SwiftUI

struct CharacterCell: View {
    @EnvironmentObject var entry: SearchMatrix.Entry
    
    var body: some View {
        Text(String(entry.value))
            .font(.headline)
            .background(entry.isSelected ? Color.yellow : Color.clear)
    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell()
            .environmentObject(
                SearchMatrix.Entry(
                    value: "A",
                    position: .init(row: 0, col: 0),
                    isSelected: true
                )
            )
    }
}
