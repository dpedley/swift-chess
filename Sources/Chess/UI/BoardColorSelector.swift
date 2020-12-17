//
//  ChessBoardColorMenuView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//
import SwiftUI

public struct BoardColorSelector: View {
    @EnvironmentObject public var store: ChessStore
    let color: Chess.UI.BoardColor
    public var body: some View {
        HStack {
            Button(action: {
                store.environmentChange(.boardColor(newColor: color))
            }, label: {
                HStack {
                    BoardIconView(color)
                    Text(color.name)
                }
            })
            Spacer()
            checkmarkView(themeColor: store.environment.theme.color)
        }
    }
    func checkmarkView(themeColor: Chess.UI.BoardColor) -> some View {
        if color == themeColor {
            let image = Image(systemName: "checkmark.circle.fill")
                .scaleEffect(1.5)
                .foregroundColor(.green)
            return AnyView(image)
        }
        return AnyView(EmptyView())
    }
    public init(_ color: Chess.UI.BoardColor) {
        self.color = color
    }
}

struct BoardColorSelectorPreviews: PreviewProvider {
    static var previews: some View {
        Form {
            Section(header: Text("Colors")) {
                BoardColorSelector(.brown).environmentObject(previewChessStore)
                BoardColorSelector(.blue).environmentObject(previewChessStore)
                BoardColorSelector(.green).environmentObject(previewChessStore)
                BoardColorSelector(.purple).environmentObject(previewChessStore)
            }
        }
    }
}
