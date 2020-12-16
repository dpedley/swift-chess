//
//  PlayerTitleView.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//
import Foundation
import SwiftUI

public struct PlayerTitleView: View {
    let player: Chess.Player
    public var body: some View {
        HStack {
            Image(systemName: player.iconName())
            Text("\(player.menuName())")
        }
    }
}
