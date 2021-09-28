//
//  ViewController.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 16/09/21.
//

import UIKit


class ConcentrationViewController: UIViewController {
    // Representa o controller do game
    
    // MARK: - Attributes
    
//    var emojiChoices: Array = ["🎃", "👻", "🦇", "😱", "🤡", "💀", "👹", "👽", "🧙🏻‍♀️", "🧟‍♀️", "🍭", "🍬"]

    
    var emojiChoices: String = "🎃👻🦇😱🤡💀👹👽🧙🏻‍♀️🧟‍♀️🍭🍬"

    
    private var emoji: Dictionary<Card,String> = [Card:String]()
    // Variável que armazena um dicionário de card e emoji no game.
    
    /*
     Essa variável utiliza a função de chave e valor do dicionário para associar os emojis aos cards no game.
     */
    
    var numberOfPairsOfCards: Int { return (cardButtons.count + 1) / 2 }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    // Variável com o objeto Concentration, passando o numberOfPairsOfCards na sua inicialização.
    
    /*
     Lazy é uma propertie cujo valor inicial não é calculado até a primeira vez que é usada. Graças a isso é possivel usar a variável "numberOfPairsOfCards" apenas quando ela for requisitada através de uma inicialização
     */
    
    let cardColorFaceDown: UIColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    // Constante com valor da cor para o card faceUp = false

    // MARK: - IBOutlet
    
    @IBOutlet private(set) var cardButtons: [UIButton]!

    @IBOutlet private weak var matchLabel: UILabel!

    @IBOutlet private weak var scoreLabel: UILabel!

    @IBOutlet private weak var timeBonusLabel: UILabel!

    @IBOutlet private weak var restartButton: UIButton!
    
    // MARK: - IBAction
    
    /// Método para capturar ação de toque no card
    @IBAction private func touchCard(_ sender: UIButton) {

        guard let cardNumber: Int = cardButtons.firstIndex(of: sender) else {
            // guard let - unwraps optionals
            
            /*
             Preciso identificar o cardButton tocado para executar a lógica, para isso vou percorrer o array de cardButtons utilizando o método firstIndex, enviando como parâmetro o sender que representa o UIButton.
             Como o firstIndex me retorna um Optional, usei o guard let para abstrair seu valor.
             
             Com o guard let, instancio uma constante e associo à um valor. Caso seja nil, o card não está conectado conectado à variável cardButtons. Depois irá imprimir uma mensagem no console e retornar.
             */
            
            print("Chosen card was not in the cardButtons Array.")
            return
        }
        
        game.chooseCard(at: cardNumber)
        // Diz a model qual cartão foi escolhido e executa lógica de combinação e virada das cartas
        
        updateCardsView()
        // Atualiza a view dos cards para gerar efeitos visuais.
        
        updateLabelsView()
        // Atualiza a view das labels para gerar efeitos visuais.
        
    }
    
    // MARK: - Methods
    
    /// Mantém a visualização atualizada com base no estado dos cards
    private func updateCardsView() {
        
        for index in cardButtons.indices {
            
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                
                button.setTitle(insertEmoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                if card.twoCardsFaceUp, !card.isMatched {
                    
                    turnDownEffect(button: button)
                    
                }
                
                else if card.twoCardsFaceUp, card.isMatched {
                    
                    removeEffect(element: button)
                    
                }
                
            } else {
                // Se o card estiver virado para baixo (isFaceUp = false)
                
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : cardColorFaceDown
                
            }
        }
    }
    
    /// Mantém a visualização atualizada com base no estado das labels
    private func updateLabelsView() {
        
        timeBonusLabel.text = game.bonus
        removeEffect(element: timeBonusLabel)
        game.resetTimeBonus()
        matchLabel.text = "Matches: \(game.matches)"
        scoreLabel.text = "SCORE: \(game.score)"

    }

    /// Método para gerar efeito visual de remoção
    /// - Parameter element: UIView que receberá o efeito
    /// - Parameter time: Tempo que será atribuido ao efeito
    private func removeEffect(element: UIView) {
        element.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            element.alpha = 0
        })
    }
    
    /// Método para gerar efeito visual de virar para baixo
    /// - Parameter button: UIButton que receberá o efeito
    private func turnDownEffect(button: UIButton) {
        Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 + 0.5) {
            UIView.animate(withDuration: 1.0, animations: {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = self.cardColorFaceDown
            })}
    }
    
    /// Método para retornar um emoji ao card fornecido
    /// - Parameter card: Card que receberá um emoji e será associado.
    private func insertEmoji(for card: Card) -> String {
        
        assert(game.cards.contains(card), "ConcentrationViewController.emoji(at: \(card)): card was not in cards")
        
        if emoji[card] == nil, emojiChoices.count > 0 {
            
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))

        }
        
        return emoji[card] ?? "?"

    }
    
}
