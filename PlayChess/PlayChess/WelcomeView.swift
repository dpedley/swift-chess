//
//  WelcomeView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/20/20.
//
import SwiftUI
import Chess

struct PlayChessTitleView: View {
    let pawnSize: CGFloat = 50
    func queen(_ side: Chess.Side) -> some View {
        let piece = Chess.PieceType.queen
        return PieceView(piece: Chess.Piece(side: side,
                                            pieceType: piece))
            .frame(width: pawnSize, height: pawnSize)
    }
    func king(_ side: Chess.Side) -> some View {
        let piece = Chess.PieceType.king
        return PieceView(piece: Chess.Piece(side: side,
                                            pieceType: piece))
            .frame(width: pawnSize, height: pawnSize)
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                queen(.black)
                    .rotationEffect(.degrees(-15))
                    .offset(x: -geometry.size.width / 2 + 20,
                            y: -10)
                king(.white)
                    .offset(x: -geometry.size.width / 2 + 40,
                            y: 3)
                Text("PlayChess!")
                    .font(.system(size: 50))
                    .offset(x: 24, y: 0)
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
        }
    }
}

struct WelcomeView: View {
    @AppStorage("welcomeMessage")
        var welcomeMessage: Bool = true
    let welcome = """
    Thank you for trying out PlayChess.
    """
    let instructions = """
    The game will start when you make the first move with the white
     pieces. To play as black, or change other settings use the gear icon.
    """.replacingOccurrences(of: "\n", with: "")
    let haveFun = """
    You'll start against RandomBot. This chess bot will pick a move without a plan.
     A great opponent for new players. It will shuffle pieces
     around while you figure out the game. When you click one of your
     pieces it will highlight where it might be allowed to move.
     Practice your moves, then try GreedyBot, a chess bot which will fight
     back, but make greedy mistakes.
    """.replacingOccurrences(of: "\n", with: "")
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    PlayChessTitleView()
                        .frame(height: 68)
                    Text(welcome)
                    Text(instructions)
                    Text(haveFun)
                    HStack {
                        Spacer()
                        Button("Tap here to start") {
                            self.welcomeMessage = false
                        }
                        .padding()
                        Spacer()
                    }
                }
                .padding(32)
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20.0)
                        .inset(by: 8)
                        .fill(Color.primary)
                    RoundedRectangle(cornerRadius: 20.0)
                        .inset(by: 10)
                        .fill(Color(UIColor.systemBackground))
                })
            Spacer()
        }
        .background(Color.primary.opacity(0.5))
    }
}

struct WelcomeViewPreview: PreviewProvider {
    static let store: ChessStore = {
        let white = Chess.HumanPlayer(side: .white)
        let black = Chess.HumanPlayer(side: .black)
        var game = Chess.Game(white, against: black)
        let store = ChessStore(game: game)
        store.game.userPaused = false
        return store
    }()
    static var previews: some View {
        GeometryReader { geometry in
            WelcomeView()
                .frame(width: geometry.size.width,
                       height: geometry.size.height,
                       alignment: .center)
        }
    }
}
