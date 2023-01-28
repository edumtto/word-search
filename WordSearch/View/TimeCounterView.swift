import SwiftUI

struct TimeCounterView: View {
    var timeCounter: Int
    
    var body: some View {
        HStack {
            Image(systemName: "timer")
            Text("\(timeCounter)")
        }
    }
}

struct TimeCounterView_Previews: PreviewProvider {
    static var previews: some View {
        TimeCounterView(timeCounter: 3)
    }
}
