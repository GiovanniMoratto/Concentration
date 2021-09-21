//
//  MutableCollectionExtension.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 21/09/21.
//

import Foundation

extension MutableCollection {
    
    /// Mistura os elementos de `self` no local.
    mutating func shuffle() {
        
        // logic from:
        // https://stackoverflow.com/questions/37843647/shuffle-array-swift-3/37843901
        
        // coleções vazias e de elemento único não serão embaralhadas
        if count < 2 { return }
        
        // embaralhar
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            swapAt(i, j)
        }
    }
}
