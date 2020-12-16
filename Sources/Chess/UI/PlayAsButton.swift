//
//  PlayAsButton.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//

import Foundation
import SwiftUI

public struct PlayAsButton: View {
    public enum Choice: String {
        case white = "White"
        case black = "Black"
        case watch = "Watch"
    }
    let selection: Choice
    @Binding var playingAs: PlayAsButton.Choice
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill( playingAs == selection ? Color.blue : Color.gray )
            Text(selection.rawValue)
                .bold()
                .foregroundColor(.white)
        }
    }
    public init(_ selection: Choice, _ playingAs: Binding<Choice>) {
        self.selection = selection
        self._playingAs = playingAs
    }
}
