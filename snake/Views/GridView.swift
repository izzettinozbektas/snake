import SwiftUI

struct GridView: View {
    let numRows: Int
    let numCols: Int
    let cellSize: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<numRows, id: \.self) { _ in
                HStack(spacing: 0) {
                    ForEach(0..<numCols, id: \.self) { _ in
                        Rectangle()
                            .stroke(Color.gray.opacity(0.2))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
}
