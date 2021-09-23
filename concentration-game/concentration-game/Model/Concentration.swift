//
//  ConcentrationModel.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 17/09/21.
//

import UIKit

struct Concentration {
    // Representa a model do game.
    
    // MARK: - Attributes
    
    private(set) var cards: Array<Card> = [Card]()
    // Variável que armazena um array com todos os cards do game.
     
    /*
     O controle de acesso (private(set)) indica que a variavel pode ser lida mas não pode ser modificado externamente.
     */
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        // Variável com informação se há ou não apenas 1 card virado para cima.
        
        /*
         Essa variável deriva da struct Card e deve estar sincronizada com o estado atual de cada card, com a lógica de virado ou não virado.
         O uso de chaves {} na variavél indica que é uma Computed Properties. Neste cenário farei uso do Property Wrapper
         */
        
        get {
            // read/retrieved accessor.
            
            /*
             Através do get posso incorporar um código que será executado quando a variável for chamada.
             Caso fosse uma properties read-only utilizaria apenas o get ou somente seu retorno, sem a declaração do get.
             */

            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
            /*
             A ideia aqui é varrer o array de cards buscando uma condição de isFaceUp = true e retorna-la.
             Para fazer isso foi utilazado o método filter que nada mais é que uma função de varretura de arrays por condição e intervalo de busca que retorna um array com elementos dentro da condição descrita.
             Neste exemplo busquei e retornei apenas o index do 1 e único card virado para cima no game.
             oneAndOnly
             */
        }
        set {
            // set/changed accessor.
            
            /*
             Através do set posso aterar o valor de outras propriedades no mesmo escopo, o que será util para virar os demais cards para baixo.
             O compilador aloca um nome padrão (newValue) caso não haja nenhum no valor atribuido na definção do configurador.
             Ex com nome: set(algumNome) {}
             */

            for index in cards.indices {
                // loop varrendo todos os cards pelos indices.
                
                cards[index].isFaceUp = (index == newValue)
                
                /*
                 Essa expressão captura o card pelo indice atual do loop e atribui um valor boolean para a variavel isFaceUp deste card.
                 Caso o indice seja igual ao newValue será true, do contrário será false.
                 Assim todos os demais cards serão virados para baixo, exceto o que acabou de ser definido e terá um novo valor.
                 */
            }
        }
    }
    
    // MARK: - Methods
    
    /// Método para desencadear lógica de operações após a escolha do card.
    /// Este método através do index enviado, irá verificar se houve combinações e virar os cards do game.
    /// - Parameter index: Um valor inteiro que representa o indice no arrays de cards, utilizado para identificar um determinado card no game.
    mutating func chooseCard(at index: Int) {
        
        /*
         Como a model foi alterada de class para struct, a funcão precisa ser declarada como mutavel para evitar conflito com a propriedade self.
         */
        
        assert(cards.indices.contains(index), "ConcentrationModel.chooseCard(at: \(index)): chosen index not in the cards")
        
        /*
         Validação de dados de entrada no método, apenas valores de existentes no array de cards serão aceitados.
         */
        
        if !cards[index].isMatched {
            
            /*
             Encontra o card através do indice enviado no método e verifica se o atributo isMatched do card possui o valor false.
             */
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // if let - unwraps optionals using happy path
                
                /*
                 Para fazer a lógica de comparação entre dois cards, irei utilizar o indice enviado nesta função com o indice armazedo na variável indexOfOneAndOnlyFaceUpCard.
                 Esse indice por sua vez retorna nil ou int? - nil quando há duas cartas viradas para cima ou nenhuma carta e int? quando há apenas uma.
                 
                 Instancio uma constante chamada matchIndex e como condição, digo que seu valor deverá ser igual ao valor de indexOfOneAndOnlyFaceUpCard e diferente do indice informado, pois seria a mesma carta. Caso obeça irá executar a lógica, do contrário irá para o else.
                 */
                
                /* Aqui podem existir dois cenários envolvendo 1 card virado atualmente para cima:
                 1. Combinar
                 2. Não Combinar
                 */
                
                if cards[matchIndex] == cards[index] {
                    
                    /*
                     Crio uma condicional para verificar se eles combinam.
                     Essa comparação irá aboradar o atributo identifier de ambos os cards
                     Caso combinem, altero o valor do atributo isMatched para true, do contrario ele permanece como false.
                     */
                    
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                cards[index].isFaceUp = true
                
                /*
                 Altera o valor do atributo isFaceUp para true.
                 Nesse momento tenho duas cartas viradas para cima: 1.cards[matchIndex] e 2.cards[index].
                 */

                cards[matchIndex].twoCardsFaceUp = true
                cards[index].twoCardsFaceUp = true
                // Altero o valor dos atributos twoCardsFaceUp para true.

            }
            
            else {
                
                /* Aqui também podem existir dois cenários:
                 1. Nenhum card virado para cima
                 2. Dois cards virados para cima
                 */
                
                indexOfOneAndOnlyFaceUpCard = index
                /*
                 Passo o valor enviado no método para o atributo indexOfOneAndOnlyFaceUpCard, que será responsável em abaixar todos os demais cards com exceção deste index.
                 No caso de nenhum card virado para cima, não é necessário incluir nenhuma lógica para tratativa.
                 */
                
                cards[index].twoCardsFaceUp = false
                // atribui informação de que não existem dois cards virados para cima.
            }
        }
    }
    
    // MARK: - Initializers (Constructors)
    
    init(numberOfPairsOfCards: Int) {
        
        /*
         Atribui a obrigatóriedade de recebimento ao atributo numberOfPairsOfCards ao instanciar o objeto. Com isso, constrói o game com base no número de pares informado.
         */

        assert(numberOfPairsOfCards > 0 && numberOfPairsOfCards % 2 == 0, "ConcentrationModel.init(at: \(numberOfPairsOfCards)): must have at least one pair of cards")
        
        /*
         Validação de dados de entrada no construtor, apenas valores pares e maiores que 0 serão aceitados.
         */
        
        for _ in 1...numberOfPairsOfCards {
            // Laço de repetições seguindo o numero de pares recebido
            
            let card = Card()
            // Intância uma constante recebendo o objeto Card
            
            cards += [card, card]
            // Adiciona ao array de cards inicializado a constante criada com uma cópia da mesma
        }
        
        cards.shuffle()
        // Mistura os cards no array
    }
    
}
