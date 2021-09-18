//
//  ViewController.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 16/09/21.
//

import UIKit

class ConcentrationViewController: UIViewController {
    // representa o controller do game
    
    // MARK: - Variables
    
    var emojiChoices: Array = ["🎃", "👻", "🎃", "👻"]  // variável com conteúdo para os cards
    
    var flipCount: Int = 0 {    // variável com o valor de clicks
        didSet {    // verifica se o valor sofreu alteração e executa lógica
            flipCountLabel.text = "Flips: \(flipCount)" // altera o texto da label atualizando contagem
        }
    }
    
    lazy var game = ConcentrationModel(numberOfPairsOfCards: (cardButtons.count + 1) / 2) // Lazy permite usar a variável de instância "cardButtons" quando ele for requisitada através de uma inicialização
    
    // MARK: - IBOutlet
    
    @IBOutlet var cardButtons: [UIButton]! // variável com array de cards conectados ao UI
    
    @IBOutlet weak var flipCountLabel: UILabel! // variável com texto da label que mostra quantos clicks foram feitos
    
    // MARK: - IBAction
    
    @IBAction func touchCard(_ sender: UIButton) {
        /// método para capturar ação de toque no card
        
        flipCount += 1  // acrescenta click no total de contagem
        
        guard let cardNumber: Int = cardButtons.firstIndex(of: sender) else {
            // cria uma variavel e associa a um optional com o valor do index do array de cards correspondente ao clique
            // extrai do Optional com o guard let e o retorna o valor
            // caso o card não esteja conectado à variável cardButtons, imprimi uma mensagem no console e retorna
            print("Chosen card was not in the cardButtons Array.")
            return
        }
        
        flipCard(withEmoji: emojiChoices[cardNumber], on: sender) // vira o card e inseri emoji correspondente ao index
    }
    
    // MARK: - Functions
    
    func flipCard(withEmoji emoji: String, on button: UIButton){
        /// método para gerar efeito visual de virada  no card
        
        if button.currentTitle == emoji {   // verifica se o titulo atual do botão é igual ao emoji
            button.setTitle("", for: UIControl.State.normal)    // apaga emoji
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)  // defini a cor traseira do card
        } else {
            button.setTitle(emoji, for: UIControl.State.normal) // inseri emoji
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // defini a cor frontal do card
        }
    }
    
}

