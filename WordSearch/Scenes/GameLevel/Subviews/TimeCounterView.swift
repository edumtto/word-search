import SwiftUI

struct TimeCounterView: View {
    let timeTotal: Int
    var timeCounter: Int
    
    private var progress: CGFloat {
        CGFloat(timeCounter)/CGFloat(timeTotal)
    }
    
    var body: some View {
        HStack {
            Text("\(timeCounter)")
                .overlay(progressCircle)
        }
    }
    
    private var progressCircle: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 40, height: 40)
            .overlay(
                Circle()
                    .trim(from:0, to: progress)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round,
                            lineJoin:.round
                        )
                    )
                    .foregroundColor(.gray)
            )
    }
}

struct TimeCounterView_Previews: PreviewProvider {
    static var previews: some View {
        TimeCounterView(timeTotal: 600, timeCounter: 400)
    }
}
