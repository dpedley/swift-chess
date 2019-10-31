import SwiftUI

final class ChessSquareView: View, Chess_UISquareVisualizer {
    var position: Chess.Position?
    var selectionType: Chess.UI.Selection = .none
    var pieceSet = Chess.UI.loadPieces(themeName: "")
    
    func setSelected(_ selectionType: Chess.UI.Selection) {
        self.selectionType = selectionType
    }
    
    func setOccupant(_ pieceType: Chess.UI.Piece) {
        self.piece = pieceSet[pieceType]
    }
    
    func clear(if outdatedSelectionType: Chess.UI.Selection) {
        if outdatedSelectionType == selectionType {
            setSelected(.none)
        }
    }
    
    var piece: Image?
    var body: some View {
        return piece
    }
}

final class ChessBoardView : View, Chess_UIGameVisualizer {
    var squares: [Chess_UISquareVisualizer] = [
        ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(),
    ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(),
ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(),
ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(),
ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(),
ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(),
ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(),
ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView(), ChessSquareView()
]
    func square(_ index: Int) -> ChessSquareView {
        guard let square = squares[index] as? ChessSquareView else {
            fatalError("squares must be ChessSquareView")
        }
        return square
    }
    
    func blackCaptured(_ piece: Chess.UI.Piece) {
        //
    }
    
    func whiteCaptured(_ piece: Chess.UI.Piece) {
        //
    }
    
    func addMoveToLedger(_ move: Chess.Move) {
        //
    }
    
    func sideChanged(_ playingSide: Chess.Side) {
        //
    }
    
    func clearAllSelections() {
        for square in squares {
            guard let square = square as? ChessSquareView else {
                return
            }
            square.setSelected(.none)
        }
    }
    
    var body: some View {
        Image("brown")
    }
    var body2: some View {
        VStack {
            Text("Chess")
                .font(.largeTitle)
            Spacer()
            Image("brown")
                .resizable()
//                .aspectRatio(1, contentMode: .fit)
//                .overlay(
////                VStack {
//                    // Loop by Rank [1-8]
////                    ForEach(0..<8) { rankIndex in
//                        HStack {
//                            // Loop by Files [A-F]
//                            ForEach(0..<8) { squareIndex in
//                                self.square(squareIndex)
//                            }
//                        }
////                    }
////                }
//            )
        }
    }
    init() {
        // Black's major pieces
        squares[0].setOccupant(.blackRook)
        squares[1].setOccupant(.blackKnight)
        squares[2].setOccupant(.blackBishop)
        squares[3].setOccupant(.blackQueen)
        squares[4].setOccupant(.blackKing)
        squares[5].setOccupant(.blackBishop)
        squares[6].setOccupant(.blackKnight)
        squares[7].setOccupant(.blackRook)
        
        // Black's pawns
        squares[8].setOccupant(.blackPawn)
        squares[9].setOccupant(.blackPawn)
        squares[10].setOccupant(.blackPawn)
        squares[11].setOccupant(.blackPawn)
        squares[12].setOccupant(.blackPawn)
        squares[13].setOccupant(.blackPawn)
        squares[14].setOccupant(.blackPawn)
        squares[15].setOccupant(.blackPawn)
        
        // White's pawns
        squares[48].setOccupant(.whiteRook)
        squares[49].setOccupant(.whiteKnight)
        squares[50].setOccupant(.whiteBishop)
        squares[51].setOccupant(.whiteQueen)
        squares[52].setOccupant(.whiteKing)
        squares[53].setOccupant(.whiteBishop)
        squares[54].setOccupant(.whiteKnight)
        squares[55].setOccupant(.whiteRook)
        
        // White's major pieces
        squares[56].setOccupant(.whitePawn)
        squares[57].setOccupant(.whitePawn)
        squares[58].setOccupant(.whitePawn)
        squares[59].setOccupant(.whitePawn)
        squares[60].setOccupant(.whitePawn)
        squares[61].setOccupant(.whitePawn)
        squares[62].setOccupant(.whitePawn)
        squares[63].setOccupant(.whitePawn)
    }
}

#if DEBUG
struct ChessBoardView_Previews : PreviewProvider {
    static var previews: some View {
        VStack {
            ChessBoardView()
        }
    }
}
#endif

