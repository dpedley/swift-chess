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
    let height: Int
    let width: Int
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                ForEach(0..<height) { yIdx in
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(0..<width) { xIdx in
                            Rectangle()
                                .fill( (yIdx + xIdx) % 2 == 0 ? color.dark : color.light )
                        }
                    }
                }
            }
            .frame(width: geometry.size.minimumLength,
                   height: geometry.size.minimumLength,
                   alignment: .center)
        }
    }
    public init(_ color: Chess.UI.BoardColor, width: Int = 2, height: Int = 2) {
        self.color = color
        self.height = height
        self.width = width
    }
}

struct BoardIconViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            BoardIconView(.blue)
            Spacer()
            BoardIconView(.green, width: 3, height: 3)
            Spacer()
            BoardIconView(.brown, width: 4, height: 4)
            Spacer()
            BoardIconView(.purple, width: 8, height: 8)
        }
    }
}
