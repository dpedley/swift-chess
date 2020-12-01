//
//  ChessPiece.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/19/20.
//

import Foundation
import SwiftUI

/// PieceView
///
/// This is the view used for the chess pieces.
/// The artwork controls which piece you see
/// The style has the colors.
struct PieceView: View {
    @StateObject var artwork: PieceArtwork
    @StateObject var style: PieceStyle
    var body: some View {
        // Paint the piece
        PieceShape(artwork: artwork)
            .foregroundColor(style.fill)
        // Then outline it
        PieceShape(artwork: artwork)
            .stroke(style.outline)
        // Render the details in the highlight color
        PieceShape.Details(artwork: artwork)
            .stroke(style.highlight)
    }
    init(_ artwork: PieceArtwork, style: PieceStyle) {
        _style = StateObject(wrappedValue: style)
        _artwork = StateObject(wrappedValue: artwork)
    }
    
    init(_ pieceType: Chess.PieceType, side: Chess.Side) {
        let style: PieceStyle
        let artwork: PieceArtwork
        switch pieceType {
        case .pawn:
            artwork = .pawn
        case .knight:
            artwork = .knight
        case .bishop:
            artwork = .bishop
        case .rook:
            artwork = .rook
        case .queen:
            artwork = .queen
        case .king:
            artwork = .king
        }
        switch side {
        case .black:
            style = .black
        case .white:
            style = .white
        }
        self.init(artwork, style: style)
    }
    init?(_ piece: Chess.UI.Piece) {
        let style: PieceStyle
        let artwork: PieceArtwork
        switch piece {
        case .blackKing:
            style = .black
            artwork = .king
        case .blackQueen:
            style = .black
            artwork = .queen
        case .blackRook:
            style = .black
            artwork = .rook
        case .blackBishop:
            style = .black
            artwork = .bishop
        case .blackKnight:
            style = .black
            artwork = .knight
        case .blackPawn:
            style = .black
            artwork = .pawn
        case .whiteKing:
            style = .white
            artwork = .king
        case .whiteQueen:
            style = .white
            artwork = .queen
        case .whiteRook:
            style = .white
            artwork = .rook
        case .whiteBishop:
            style = .white
            artwork = .bishop
        case .whiteKnight:
            style = .white
            artwork = .knight
        case .whitePawn:
            style = .white
            artwork = .pawn
        case .none:
            return nil
        }
        self.init(artwork, style: style)
    }
}

struct PieceView_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            PieceView(.queen, style: .black)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: -50, y: -50)
            PieceView(.bishop, style: .white)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: 50, y: -50)
            PieceView(.king, style: .white)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: -50, y: 50)
            PieceView(.knight, style: .black)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: 50, y: 50)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}

