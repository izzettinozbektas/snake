import SwiftUI

struct FoodView: View {
    let position: Position
    let cellSize: CGFloat

    var body: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: cellSize, height: cellSize)
            .position(
                x: CGFloat(position.x) * cellSize + cellSize / 2,
                y: CGFloat(position.y) * cellSize + cellSize / 2
            )
    }
}
