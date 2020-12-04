//
//  BoardView.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/24/20.
//

import SwiftUI
import Combine

struct BoardView: View {
    let id = UUID()
    @EnvironmentObject var store: ChessStore
    var squares: [SquareView] {
        var squares: [SquareView] = []
        for i in 0..<64 {
            let squareView = SquareView(position: i)
            _ = squareView.environmentObject(store)
            squares.append(squareView)
        }
        return squares
    }
    static let oneEighth = CGAffineTransform(scaleX: 0.125, y: 0.125)
    func move(_ position: Int, in geometry: GeometryProxy) -> CGAffineTransform {
        return Self.oneEighth
            .translatedBy(x: CGFloat(position % 8) * geometry.size.width,
                          y: CGFloat(position / 8) * geometry.size.height)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Spacer()
                ZStack() {
                    GeometryReader { boardGeometry in
                        ForEach(squares) { square in
                            square.transformEffect(move(square.position, in: boardGeometry))
                                
                        }
                    }
                }
                Spacer()
            }
            .frame(width: geometry.size.minimumLength,
                    height: geometry.size.minimumLength,
                    alignment: .center)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView().environmentObject(previewChessStore)
        // See ChessStore+Preview.swift for ^^ this
    }
}
