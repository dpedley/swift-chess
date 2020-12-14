//
//  ChessBoardColorMenuView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//
import SwiftUI

public struct ChessBoardColorMenuView: View {
    @EnvironmentObject public var store: ChessStore
    public var body: some View {
        Menu {
            Button {
                store.environmentChange(.boardColor(newColor: .brown))
            } label: {
                BoardIconView(.brown)
            }
            Button {
                store.environmentChange(.boardColor(newColor: .blue))
            } label: {
                BoardIconView(.blue)
            }
            Button {
                store.environmentChange(.boardColor(newColor: .green))
            } label: {
                BoardIconView(.green)
            }
            Button {
                store.environmentChange(.boardColor(newColor: .purple))
            } label: {
                BoardIconView(.purple)
            }
        } label: {
            Image(systemName: "paintbrush")
            Text("Board Color")
        }
    }
    public init() {}
}

struct ChessBoardColorMenuPreviews: PreviewProvider {
    static var previews: some View {
        ChessBoardColorMenuView().environmentObject(previewChessStore)
    }
}
