//
//  BoardGameView+Layout.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/16/20.
//

import SwiftUI

extension View {
    func playerFrame(_ geometry: GeometryProxy) -> some View {
        return frame(width: geometry.size.width,
                     height: 32)
    }
    func boardFrame(_ geometry: GeometryProxy) -> some View {
        return frame(width: geometry.size.width,
                      height: geometry.size.width)
    }
    func cornerFrame(_ geometry: GeometryProxy, alignment: Alignment) -> some View {
        return frame(width: geometry.size.width - 32, alignment: alignment)
    }
}
