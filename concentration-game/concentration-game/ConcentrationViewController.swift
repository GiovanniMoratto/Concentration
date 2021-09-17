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
    
    /// Variável com array de cards
    @IBOutlet var cardButtons: [UIButton]!
    
    /// Variável com o texto da Label
    @IBOutlet weak var flipCountLabel: UILabel!
    
    /// Método para capturar ação de toque no card
    @IBAction func touchCard(_ sender: UIButton) {
        /// Acrescenta click no total de contagem
        flipCount += 1
        /// Cria uma variavel e associa a um optional do valor do index de array de cards
        let cardNumber = cardButtons.firstIndex(of: sender)
        print("cardNumber = \(cardNumber)")
        
        /// Vira o card
        flipCard(withEmoji: "👻", on: sender)
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

