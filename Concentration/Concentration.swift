//
//  Concentration.swift
//  Concentration
//
//  Created by Giovanni Vicentin Moratto on 15/09/21.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    func chooseCard(at index: Int){
        
    }
    
    init(numberOfPairsOfCards: Int) {
        
        for identifier in 1...numberOfPairsOfCards {
            let card = Card(identifier: identifier)
            cards.append(card)
        }
    }
}
