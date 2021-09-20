//
//  ConcentrationModel.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 17/09/21.
//

import Foundation

// criação de classe (reference type) para o game
class ConcentrationModel {
    
    
    // MARK: - Variables
    
    // variável com os cards do game
    var cards: Array<Card> = [Card]()
    
    // variável com informação se há ou não apenas 1 card virado para cima
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    // MARK: - Functions
    
    /// métofo para desencadear lógica de operações após a escolha do card
    func chooseCard(at index: Int){
        
        // se o card for incompativel
        if !cards[index].isMatched {
            
            // se já existe um card virado para cima, verifique se corresponde ao escolhido
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                
                // Se eles corresponderem, marque-os como matched
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                // Vire a carta escolhida para cima - face-up
                cards[index].isFaceUp = true
                
                // Como já havia um card virado para cima (e foi selecionado um novo),
                // não há mais apenas 1 card virado para cima
                indexOfOneAndOnlyFaceUpCard = nil
            }
            // ou nenhuma carta ou duas cartas estão viradas para cima
            else {
                // vira todos os cards para baixo
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                
                // vira o selecionado para cima
                cards[index].isFaceUp = true
                
                // apenas 1 card virado para cima
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    // MARK: - Initializers (Constructors)
    
    /// constroi o game com base no número de pares informado
    init(numberOfPairsOfCards: Int) {
        
        // cria todos os cards do game
        for _ in 1...numberOfPairsOfCards {
            // instância um card
            let card = Card()
            // adiciona um card ao array de cards junto com uma cópia, por ter utilizado uma struct ao invés de uma classe com um endereço de memória.
            cards += [card, card]
        }
        
        // TODO shuffle the cards
    }
    
}
