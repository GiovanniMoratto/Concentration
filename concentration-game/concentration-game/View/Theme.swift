//
//  Theme.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 27/09/21.
//

import UIKit

struct Theme {
    /*
     Represents the game's theme.
     
     For instance, a "halloween" theme might contain a dark (black) board with orange
     cards and a set of "scary" emojis.
     */
    
    var name: String
    // The name of the theme (i.e. to show it on screen or something)
    
    var boardColor: UIColor
    // The color of the board
    
    var cardColor: UIColor
    // The color of the card's back
    
    var emojis: [String]
    // Array of available emojis fot the theme
    
}
