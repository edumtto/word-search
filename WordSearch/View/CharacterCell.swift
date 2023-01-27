import SwiftUI

struct CharacterCell: View {
    @EnvironmentObject var entry: SearchMatrix.Entry
    
    var body: some View {
        Text(String(entry.value))
            .font(.headline)
            .frame(width: 32, height: 32)
            .background(entry.isSelected ? Color.yellow : Color.clear)
            .foregroundColor(entry.isFound ? .gray : .black)
    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell()
            .environmentObject(
                SearchMatrix.Entry(
                    value: "A",
                    position: .init(row: 0, col: 0),
                    isSelected: true,
                    isFound: true
                )
            )
    }
}
