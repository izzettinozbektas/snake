import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: SnakeGameViewModel

    init() {
        _viewModel = StateObject(wrappedValue: SnakeGameViewModel(numRows: 20, numCols: 20))
    }

    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let availableHeight = geometry.size.height - 100
            let gridSize = min(availableWidth, availableHeight)
            let cellSize = floor(gridSize / CGFloat(viewModel.numCols))

            VStack(spacing: 0) {
                Text("Skor: \(viewModel.score)")
                    .font(.title2)
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))

                ZStack(alignment: .topLeading) {
                    // Izgara
                    ForEach(0..<viewModel.numRows, id: \.self) { row in
                        ForEach(0..<viewModel.numCols, id: \.self) { col in
                            Rectangle()
                                .stroke(Color.gray.opacity(0.2))
                                .frame(width: cellSize, height: cellSize)
                                .position(
                                    x: CGFloat(col) * cellSize + cellSize / 2,
                                    y: CGFloat(row) * cellSize + cellSize / 2
                                )
                        }
                    }

                    // Snake
                    ForEach(viewModel.snakePositions, id: \.self) { pos in
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: cellSize, height: cellSize)
                            .position(
                                x: CGFloat(pos.x) * cellSize + cellSize / 2,
                                y: CGFloat(pos.y) * cellSize + cellSize / 2
                            )
                    }

                    // Food
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: cellSize, height: cellSize)
                        .position(
                            x: CGFloat(viewModel.foodPosition.x) * cellSize + cellSize / 2,
                            y: CGFloat(viewModel.foodPosition.y) * cellSize + cellSize / 2
                        )

               
                    if let bonus = viewModel.bonusFoodPosition {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: cellSize, height: cellSize)
                            .position(
                                x: CGFloat(bonus.x) * cellSize + cellSize / 2,
                                y: CGFloat(bonus.y) * cellSize + cellSize / 2
                            )
                    }
                }
                .frame(width: CGFloat(viewModel.numCols) * cellSize,
                       height: CGFloat(viewModel.numRows) * cellSize)
                .background(Color.black.opacity(0.03))
                .cornerRadius(8)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            KeyboardListenerView(
                onKeyPressed: { direction in
                    viewModel.changeDirection(to: direction)
                    viewModel.setTurboMode(on: true) //  Hızlan
                },
                onKeyReleased: {
                    viewModel.setTurboMode(on: false) //  Normale dön
                }
            )
            .frame(width: 0, height: 0)

        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $viewModel.isGameOver) {
            Alert(
                title: Text("Game Over"),
                message: Text("Duvara çarptın ya da kendine çarptın."),
                dismissButton: .default(Text("Yeniden Başlat")) {
                    viewModel.restartGame()
                }
            )
        }
    }
}
