import SwiftUI

struct SnakeBodyView: View {
    let positions: [Position]
    let cellSize: CGFloat

    var body: some View {
        ForEach(positions, id: \.self) { pos in
            Rectangle()
                .fill(Color.green)
                .frame(width: cellSize, height: cellSize)
                .position(
                    x: CGFloat(pos.x) * cellSize + cellSize / 2,
                    y: CGFloat(pos.y) * cellSize + cellSize / 2
                )
        }
    }
}
