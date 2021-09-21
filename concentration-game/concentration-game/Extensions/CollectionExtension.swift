//
//  CollectionExtension.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 21/09/21.
//

import Foundation

extension Collection {
    
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
