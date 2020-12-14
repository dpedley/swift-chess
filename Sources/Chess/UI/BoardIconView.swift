//
//  BoardIconView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//

import SwiftUI
import Combine

public struct BoardIconView: View {
    let color: Chess.UI.BoardColor
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .fill(color.dark)
                    Rectangle()
                        .fill(color.light)
                }
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .fill(color.light)
                    Rectangle()
                        .fill(color.dark)
                }
            }
            .frame(width: geometry.size.minimumLength,
                   height: geometry.size.minimumLength,
                   alignment: .center)
        }
    }
    public init(_ color: Chess.UI.BoardColor) {
        self.color = color
    }
}

struct BoardIconViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            BoardIconView(.blue)
            Spacer()
            BoardIconView(.green)
            Spacer()
            BoardIconView(.brown)
            Spacer()
            BoardIconView(.purple)
        }
    }
}
