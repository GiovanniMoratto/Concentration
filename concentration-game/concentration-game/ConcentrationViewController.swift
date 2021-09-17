//
//  ViewController.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 16/09/21.
//

import UIKit

///
/// View-controller do Concentration Game
///
class ConcentrationViewController: UIViewController {
    
    /// Variável com o valor de clicks
    var flipCount = 0 {
        /// Verifica se o valor sofreu alteração e executa lógica
        didSet {
            /// Altera o texto da label atualizando contagem
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    /// Variável com conteúdo para os cards
    var emojiChoices = ["🎃", "👻", "🎃", "👻"]
    
    /// Variável com array de cards conectados ao UI
    @IBOutlet var cardButtons: [UIButton]!
    
    /// Variável com texto da Label que mostra quantos clicks foram feitos
    @IBOutlet weak var flipCountLabel: UILabel!
    
    /// Método para capturar ação de toque no card
    @IBAction func touchCard(_ sender: UIButton) {
        /// Acrescenta click no total de contagem
        flipCount += 1
        /// Cria uma variavel e associa a um optional com o valor do index do array de cards correspondente ao clique
        /// Extrai do Optional com o guard let e o retorna o valor
        guard let cardNumber = cardButtons.firstIndex(of: sender) else {
            /// Caso o card não esteja conectado à variável cardButtons, imprimi uma mensagem no console e retorna
            print("Chosen card was not in the cardButtons Array.")
            return
        }
        /// Vira o card e inseri emoji correspondente ao index
        flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
    }
    
    /// Função para gerar efeito visual de virada  no card
    func flipCard(withEmoji emoji: String, on button: UIButton){
        /// Verifica se o titulo atual do botão é igual ao emoji
        if button.currentTitle == emoji {
            /// Apaga emoji
            button.setTitle("", for: UIControl.State.normal)
            /// Defini a cor traseira do card
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        } else {
            /// Inseri emoji
            button.setTitle(emoji, for: UIControl.State.normal)
            /// Defini a cor frontal do card
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

