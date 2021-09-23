//
//  IntExtension.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 22/09/21.
//

import Foundation

extension Int {
    // índice aleatório entre 0 e número de opções de emoji -1
    // arc4random_uniform recebe um tipo UInt32
    // precisa ser um Int
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
