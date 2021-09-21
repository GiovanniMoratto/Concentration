//
//  Card.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 17/09/21.
//

import Foundation

// representa o card usado no game (Struct = value type)
struct Card {
    
    // MARK: - Variables
    
    // variável com informação de que se o card atual está ou não virado para cima. Inicializada como falsa. Sua alteração gera efeito visual de virada no card.
    public var isFaceUp: Bool = false
    
    // variável com informação de que o se card atual já combinou com outro card. Inicializada como falsa
    public var isMatched: Bool = false
    
    // variável com um identificador exclusivo para o cartão. (o par de cards correspondentes tem o mesmo identificador)
    public var identifier: Int
    
    // MARK: - Static Variables
    
    // identificador estático que é aumentado toda vez que um novo é solicitado por getUniqueIdentifier(). Inicializada como zero
    private static var identifierFactory: Int = 0
    
    // MARK: - Static Functions
    
    /// método para retornar um id único usado como um identificador de cartão
    private static func getUniqueIdentifier() -> Int {
        
        identifierFactory += 1
        return identifierFactory
    }
    
    // MARK: - Initializers (Constructors)
    
    /// cria um cartão com o identificador fornecido. Ao instânciar o objeto passa a ser obrigatório declarar um valor ao(s) parâmetro(s) citados nos parênteses acima
    public init() {
        
        // self == this no java
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
