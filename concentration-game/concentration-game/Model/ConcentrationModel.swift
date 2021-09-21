//
//  ConcentrationModel.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 17/09/21.
//

import Foundation

// representa a model do game como value type
struct ConcentrationModel {
    
    // MARK: - Variables
    
    // variável com os cards do game
    private(set) var cards: Array<Card> = [Card]()
    
    // variável com informação se há ou não apenas 1 card virado para cima
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            // verifica todos os cards através dos indices
            for index in cards.indices {
                // encontra o card virado para cima
                if cards[index].isFaceUp {
                    // se foundIndex for nulo
                    // se ainda não encontrou um card, este é o primeiro então defini como nulo
                    if foundIndex == nil {
                        // atribui um indice para o primeiro card
                        foundIndex = index
                    }
                    else {
                        // pelo menos duas cartas estão viradas para cima
                        // retorna nulo
                        return nil
                    }
                }
            }
            // começa nulo e se nunca for encontrado continua nulo, do contrario retorna um index. se esta nulo não há cards virados para cima
            return foundIndex
        }
        set(newValue) {
            // vira todos para baixo, exceto o que acabou de ser definido e terá um novo valor
            for index in cards.indices {
                // encontra o card virado para cima
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    // MARK: - Functions
    
    /// métofo para desencadear lógica de operações após a escolha do card
    // como a model foi alterada de class para struct a funcão precisa ser declarada como mutavel para evitar conflito com a propriedade self
    mutating func chooseCard(at index: Int) {
        // input validation
        assert(cards.indices.contains(index), "ConcentrationModel.chooseCard(at: \(index)): chosen index not in the cards")
        // se o card for incompativel
        if !cards[index].isMatched {
            // se já existe um card virado para cima, verifique se corresponde ao escolhido
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // Se eles corresponderem, marque-os como matched
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                // Vire a carta escolhida para cima - face-up
                cards[index].isFaceUp = true
                // atribui informação de que existem dois cards virados para cima
                cards[matchIndex].twoCardsFaceUp = true
                cards[index].twoCardsFaceUp = true
            }
            // ou nenhuma carta ou duas cartas estão viradas para cima
            else {
                // apenas 1 card virado para cima
                indexOfOneAndOnlyFaceUpCard = index
                // atribui informação de que não existem dois cards virados para cima
                cards[index].twoCardsFaceUp = false
            }
        }
    }
    
    // MARK: - Initializers (Constructors)
    
    /// constroi o game com base no número de pares informado
    init(numberOfPairsOfCards: Int) {
        // input validation
        assert(numberOfPairsOfCards > 0, "ConcentrationModel.init(at: \(numberOfPairsOfCards)): must have at least one pair of cards")
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
