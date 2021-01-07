//
//  DungeonView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/19/20.
//
import SwiftUI
import Chess

struct DungeonView: View {
    @EnvironmentObject var store: ChessStore
    let side: Chess.Side
    static let uniqueSize: CGFloat = 32
    static let commonSize: CGFloat = 20
    let uniqueColumns: [GridItem] = {
        let column = GridItem(.fixed(uniqueSize), spacing: 2, alignment: .top)
        return Array(repeating: column, count: 5)
    }()
    let commonColumns: [GridItem] = {
        let column = GridItem(.fixed(commonSize), spacing: 1, alignment: .top)
        return Array(repeating: column, count: 8)
    }()
    func dungeonBackground(_ game: Chess.Game) -> Color {
        guard game.blackDungeon.count > 0 || game.whiteDungeon.count > 0 else {
            return Color.clear
        }
        return Color(UIColor.secondarySystemBackground)
    }
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                LazyVGrid(columns: uniqueColumns,
                          alignment: .leading, spacing: 0) {
                    ForEach(uniquePieces(store.game)) { piece in
                        PieceView(piece: piece,
                                  addDetails: false)
                            .frame(width: Self.uniqueSize, height: Self.uniqueSize)
                    }
                }
                LazyVGrid(columns: commonColumns,
                          alignment: .leading, spacing: 0) {
                    ForEach(piecesInCommon(store.game)) { piece in
                        PieceView(piece: piece,
                                  addDetails: false)
                            .frame(width: Self.commonSize, height: Self.commonSize)
                    }
                }
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
            .background(dungeonBackground(store.game))
        }
    }
}
struct DungeonViewPreview: PreviewProvider {
    static let fakeDungeons: ChessStore = {
        let white = Chess.HumanPlayer(side: .white)
        let black = Chess.HumanPlayer(side: .black)
        var game = Chess.Game(white, against: black)
        let store = ChessStore(game: game)
        let whitePieces = [
            Chess.Piece(side: .white, pieceType: .pawn),
            Chess.Piece(side: .white, pieceType: .pawn),
            Chess.Piece(side: .white, pieceType: .pawn),
            Chess.Piece(side: .white, pieceType: .bishop),
            Chess.Piece(side: .white, pieceType: .knight),
            Chess.Piece(side: .white, pieceType: .rook),
            Chess.Piece(side: .white, pieceType: .queen)]
        let blackPieces = [
            Chess.Piece(side: .black, pieceType: .pawn),
            Chess.Piece(side: .black, pieceType: .pawn),
            Chess.Piece(side: .black, pieceType: .bishop),
            Chess.Piece(side: .black, pieceType: .bishop),
            Chess.Piece(side: .black, pieceType: .rook),
            Chess.Piece(side: .black, pieceType: .rook)]
        store.game.blackDungeon.append(contentsOf: whitePieces)
        store.game.whiteDungeon.append(contentsOf: blackPieces)
        return store
    }()
    static var previews: some View {
        let content = ContentView()
        content.welcomeMessage = false
        return content.environmentObject(fakeDungeons)
    }
}
