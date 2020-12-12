//
//  SquareView.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/23/20.
//

import Foundation
import SwiftUI

struct SquareView: View, Identifiable {
    let id = UUID()
    @EnvironmentObject var store: ChessStore
    let position: Int
    var body: some View {
        Rectangle()
            .fill(color)
        store.game.board.squares[position].piece?.UI.asView()
    }
    var color: Color {
        let themeColor = store.theme.boardTheme.color
        return (file + row) % 2 == 0 ? themeColor.dark : themeColor.light
    }
    var file: Int { return position / 8 }
    var row: Int { return position % 8 }
}

struct SquareView_Preview: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .center, content: {
            SquareView(position: 3)
                .environmentObject(previewChessStore)
        // See ChessStore+Preview.swift for ^^ this
        })
        .background(Color.gray)
        .frame(width: 300,
               height: 300,
               alignment: .center)
    }
}

