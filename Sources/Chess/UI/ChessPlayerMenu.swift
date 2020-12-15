//
//  ChessPlayerMenuView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//

import Foundation
import SwiftUI

public struct ChessPlayerMenu: View {
    @EnvironmentObject public var store: ChessStore
    @State var blackChooser: Bool = false
    @State var whiteChooser: Bool = false
    public var body: some View {
        HStack {
            Button {
                self.whiteChooser = true
            } label: {
                Image(systemName: store.game.white.iconName())
                Text("\(store.game.white.menuName())")
            }
            .sheet(isPresented: $whiteChooser) {
                ChessPlayerChooser(self.$whiteChooser, side: .white)
                    .environmentObject(store)
            }
            Button {
                guard store.game.userPaused else { return }
                let black = store.game.black
                black.side = .white
                let white = store.game.white
                white.side = .black
                store.game.black = white
                store.game.white = black
            } label: {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
            }
            Button {
                self.blackChooser = true
            } label: {
                Image(systemName: store.game.black.iconName())
                Text("\(store.game.black.menuName())")
            }
            .sheet(isPresented: $blackChooser) {
                ChessPlayerChooser(self.$blackChooser, side: .black)
                    .environmentObject(store)
            }
        }
    }
    public init() {}
}

struct ChessPlayerMenuViewPreviews: PreviewProvider {
    static var previews: some View {
        ChessPlayerMenu().environmentObject(previewChessStore)
    }
}
