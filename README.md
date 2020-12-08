# Chess

This package provides UI components and game logic for standard chess play.

The code presents a unified pattern for the game interactions using 
[Combine](https://developer.apple.com/documentation/combine) and [SwiftUI](https://developer.apple.com/documentation/swiftui). A chess game, the board, players etc are all housed in a [ChessStore](./Sources/Chess/Store/ChessStore.swift)

Here's an example of creating a ChessStore that would allow two people to play.

```
let white = Chess.HumanPlayer(side: .white)
let black = Chess.HumanPlayer(side: . black)
let game = Chess.Game(white, against: black)
let store = ChessStore(game: game)
```

You might then use the store as the environment variable for a BoardView. 

You will find previews in the code where it is helpful to get a visual guide. Here's XCode showing the preview in BoardView.swift


![](Screenshots/boardview.png)

TODO: This readme should have a better ending.
