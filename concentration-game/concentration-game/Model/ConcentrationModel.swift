//
//  ConcentrationModel.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 17/09/21.
//

import Foundation

class ConcentrationModel {
    // criação de classe (reference type) para o game
    
    // MARK: - Variables
    
    var cards: Array<Card> = [Card]() // variável com os cards do game
    
    // MARK: - Functions
    
    func chooseCard(at index: Int){
        /// métofo para desencadear lógica de operações após a escolha do card
        
        if cards[index].isFaceUp {
            cards[index].isFaceUp = false
        } else {
            cards[index].isFaceUp = true
        }
    }
    
    // MARK: - Initializers (Constructors)
    
    init(numberOfPairsOfCards: Int) {
        /// constroi o game com base no número de pares informado
        
        for _ in 1...numberOfPairsOfCards { // cria todos os cards do game
            let card = Card() // instância um card
            cards += [card, card] // adiciona um card ao array de cards junto com uma cópia, por ter utilizado uma struct ao invés de uma classe com um endereço de memória.
        }
        
        // TODO shuffle the cards
    }
    
}
