//
//  Card.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 17/09/21.
//

import Foundation


struct Card {
    // representa o card usado no game (Struct = value type)
    
    // MARK: - Variables
    
    var isFaceUp: Bool = false  // variável com informação de que se o card atual está ou não virado para cima. Inicializada como falsa. Sua alteração gera efeito visual de virada no card.
    
    var isMatched: Bool = false // variável com informação de que o se card atual já combinou com outro card. Inicializada como falsa
    
    var identifier: Int // variável com um identificador exclusivo para o cartão. (o par de cards correspondentes tem o mesmo identificador)
    
    // MARK: - Static Variables
    
    static var identifierFactory: Int = 0   // identificador estático que é aumentado toda vez que um novo é solicitado por getUniqueIdentifier(). Inicializada como zero
    
    // MARK: - Static Functions
    
    static func getUniqueIdentifier() -> Int {
        /// método para retornar um id único usado como um identificador de cartão
        
        identifierFactory += 1
        return identifierFactory
    }
    
    // MARK: - Initializers (Constructors)
    
    init() {
        /// cria um cartão com o identificador fornecido. Ao instânciar o objeto passa a ser obrigatório declarar um valor ao(s) parâmetro(s) citados nos parênteses acima
        
        self.identifier = Card.getUniqueIdentifier()
        // self == this no java
    }
    
}
