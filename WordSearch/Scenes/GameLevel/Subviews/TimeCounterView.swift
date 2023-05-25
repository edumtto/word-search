import SwiftUI

struct TimeCounterView: View {
    private let size: CGFloat = 40
    private let timeTotal: UInt
    private var timeCounter: UInt
    
    private var progress: CGFloat {
        CGFloat(timeCounter)/CGFloat(timeTotal)
    }
    
    var body: some View {
        HStack {
            Text("\(timeCounter)")
                .foregroundColor(.white)
                .overlay(progressCircle)
        }
        .frame(width: size, height: size)
    }
    
    private var progressCircle: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundColor(.white)
            )
    }
    
    init(timeTotal: UInt, timeCounter: UInt) {
        self.timeTotal = timeTotal
        self.timeCounter = timeCounter
    }
}

struct TimeCounterView_Previews: PreviewProvider {
    static var previews: some View {
        TimeCounterView(timeTotal: 600, timeCounter: 400)
            .padding()
            .background(.gray)
    }
}
