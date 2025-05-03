import Foundation
import Combine


class SnakeGameViewModel: ObservableObject {
    @Published var snakePositions: [Position]
    @Published var foodPosition: Position
    @Published var direction: Direction
    @Published var isGameOver: Bool
    @Published var score: Int
    @Published var bonusFoodPosition: Position? = nil

    private var bonusTimer: AnyCancellable?
    private var moveCount: Int = 0
    private var moveInterval: Double = 0.2



    let numRows: Int
    let numCols: Int

    private var timer: AnyCancellable?

    init(numRows: Int, numCols: Int) {
        self.numRows = numRows
        self.numCols = numCols
        self.snakePositions = [Position(x: numCols / 2, y: numRows / 2)]
        self.foodPosition = Position(x: Int.random(in: 0..<numCols), y: Int.random(in: 0..<numRows))
        self.direction = .right
        self.isGameOver = false
        self.score = 0
        startGame()
    }

    func startGame() {
        timer = Timer.publish(every: moveInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.moveSnake() }
    }
    // tubo mod tusa basılı tutunca ekler
    func setTurboMode(on: Bool) {
        stopGame()
        moveInterval = on ? 0.05 : 0.2
        startGame()
    }


    func stopGame() {
        timer?.cancel()
    }

    func restartGame() {
        bonusFoodPosition = nil
        bonusTimer?.cancel()
        moveCount = 0

        snakePositions = [Position(x: numCols / 2, y: numRows / 2)]
        foodPosition = Position(x: Int.random(in: 0..<numCols), y: Int.random(in: 0..<numRows))
        direction = .right
        isGameOver = false
        score = 0
        startGame()
    }

    func changeDirection(to newDirection: Direction) {
        if (direction == .up && newDirection != .down) ||
            (direction == .down && newDirection != .up) ||
            (direction == .left && newDirection != .right) ||
            (direction == .right && newDirection != .left) {
            direction = newDirection
        }
    }

    private func moveSnake() {
        moveCount += 1

        if moveCount % 10 == 0 {
            spawnBonusFood()
        }
        guard !isGameOver else { return }

        var newHead = snakePositions[0]

        switch direction {
        case .up: newHead.y -= 1
        case .down: newHead.y += 1
        case .left: newHead.x -= 1
        case .right: newHead.x += 1
        }

        if newHead.x < 0 || newHead.y < 0 || newHead.x >= numCols || newHead.y >= numRows || snakePositions.contains(newHead) {
            isGameOver = true
            stopGame()
            return
        }

        snakePositions.insert(newHead, at: 0)

        var ateFood = false

        if newHead == foodPosition {
            score += 1
            generateNewFood()
            ateFood = true
        }

        if let bonus = bonusFoodPosition, newHead == bonus {
            score += 3
            bonusFoodPosition = nil
            bonusTimer?.cancel()
            ateFood = true
        }

        if !ateFood {
            snakePositions.removeLast()
        }


    }

    private func generateNewFood() {
        var newPos: Position
        repeat {
            newPos = Position(
                x: Int.random(in: 0..<numCols),
                y: Int.random(in: 0..<numRows)
            )
        } while snakePositions.contains(newPos)
        foodPosition = newPos
    }
    private func spawnBonusFood() {
        guard !isGameOver else { return }

        var newPos: Position
        repeat {
            newPos = Position(
                x: Int.random(in: 0..<numCols),
                y: Int.random(in: 0..<numRows)
            )
        } while snakePositions.contains(newPos) || newPos == foodPosition

        bonusFoodPosition = newPos

        bonusTimer?.cancel()
        bonusTimer = Timer.publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, !self.isGameOver else { return }
                self.bonusFoodPosition = nil
                self.bonusTimer?.cancel()
            }
    }


}
