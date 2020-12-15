//
//  ChessBoardColorMenuView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//
import SwiftUI

public struct ChessBoardColorMenu: View {
    @EnvironmentObject public var store: ChessStore
    @State var colorChooser: Bool = false
    public var body: some View {
        Button {
            self.colorChooser = true
        } label: {
            Image(systemName: "paintbrush")
            BoardIconView(store.environment.theme.color)
                .frame(width: 16, height: 16, alignment: .center)
        }
        .popover(isPresented: $colorChooser) {
            Button {
                store.environmentChange(.boardColor(newColor: .brown))
                colorChooser = false
            } label: {
                BoardIconView(.brown)
            }
            Button {
                store.environmentChange(.boardColor(newColor: .blue))
                colorChooser = false
            } label: {
                BoardIconView(.blue)
            }
            Button {
                store.environmentChange(.boardColor(newColor: .green))
                colorChooser = false
            } label: {
                BoardIconView(.green)
            }
            Button {
                store.environmentChange(.boardColor(newColor: .purple))
                colorChooser = false
            } label: {
                BoardIconView(.purple)
            }
        }
    }
    public init() {}
}

struct ChessBoardColorMenuPreviews: PreviewProvider {
    static var previews: some View {
        ChessBoardColorMenu().environmentObject(previewChessStore)
    }
}
