//
//  ViewController.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 16/09/21.
//

import UIKit

// representa o controller do game
class ConcentrationViewController: UIViewController {
    
    // MARK: - Variables
    
    // variável com conteúdo para os cards
    var emojiChoices: Array = ["🎃", "👻", "🦇", "😱", "🤡", "💀", "👹", "👽", "🧙🏻‍♀️", "🧟‍♀️", "🍭", "🍬"]
    
    // variavel com emoji correspondente para cada card/botão
    var emoji: Dictionary<Int,String> = [Int:String]()
    
    // variável com o valor de clicks
    var flipCount: Int = 0 {
        // verifica se o valor sofreu alteração e executa lógica
        didSet {
            // altera o texto da label atualizando contagem
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    // Lazy permite usar a variável de instância "cardButtons" quando ele for requisitada através de uma inicialização
    lazy var game = ConcentrationModel(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    // MARK: - IBOutlet
    
    // variável com array de cards conectados ao UI
    @IBOutlet var cardButtons: [UIButton]!
    
    // variável com texto da label que mostra quantos clicks foram feitos
    @IBOutlet weak var flipCountLabel: UILabel!
    
    // MARK: - IBAction
    
    /// método para capturar ação de toque no card
    @IBAction func touchCard(_ sender: UIButton) {
        
        // acrescenta click no total de contagem
        flipCount += 1
        
        // cria uma variavel e associa a um optional com o valor do index do array de cards correspondente ao clique
        guard let cardNumber: Int = cardButtons.firstIndex(of: sender) else {
            // extrai do Optional com o guard let e o retorna o valor
            // caso o card não esteja conectado à variável cardButtons, imprimi uma mensagem no console e retorna
            print("Chosen card was not in the cardButtons Array.")
            return
        }
        // diz a model qual cartão foi escolhido
        game.chooseCard(at: cardNumber)
        // atualiza a view
        updateViewFromModel()
    }
    
    // MARK: - Functions
    
    /// Mantém a visualização atualizada com base no estado do modelo
    func updateViewFromModel() {
        
        // loop percorrendo todos os card pelos indices
        for index in cardButtons.indices {
            
            // variável com o cardButton do indice atual
            let button = cardButtons[index]
            // variável com o card (model) do indice atual
            let card = game.cards[index]
            
            // Se o card estiver virado para cima (isFaceUp = true)
            if card.isFaceUp {
                // inseri emoji
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                // defini a cor frontal do card
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                // apaga emoji
                button.setTitle("", for: UIControl.State.normal)
                // defini a cor traseira do card
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
    }
    
    /// retorna um emoji para o card fornecido
    func emoji(for card: Card) -> String {
        
        // se o cartão não tiver um emoji definido, adicione um aleatório
        // a condicional precisa do "emojiChoices.count > 0" por conta do intervalo do arc4random_uniform
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            
            // índice aleatório entre 0 e número de opções de emoji -1
            // arc4random_uniform recebe um tipo UInt32
            // randomIndex precisa ser um Int
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            
            // adicione o emoji aleatório a este cartão
            emoji[card.identifier] = emojiChoices[randomIndex]
            
            // remove o emoji do emojiChoices para que não seja selecionado novamente
            emojiChoices.remove(at: randomIndex)
        }
        
        // retorna o emoji ou "?" se nenhum disponível
        return emoji[card.identifier] ?? "?"
    }
    
}
