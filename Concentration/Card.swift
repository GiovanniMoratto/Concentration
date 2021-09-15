//
//  Card.swift
//  Concentration
//
//  Created by Giovanni Vicentin Moratto on 15/09/21.
//

import Foundation

struct Card {
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    init(identifier: Int) {
        self.identifier = identifier
    }
}
