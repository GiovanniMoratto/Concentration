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
//    var emojiChoices: Array = ["🎃", "👻", "🦇", "😱", "🤡", "💀", "👹", "👽", "🧙🏻‍♀️", "🧟‍♀️", "🍭", "🍬"]
    var emojiChoices: String = "🎃👻🦇😱🤡💀👹👽🧙🏻‍♀️🧟‍♀️🍭🍬"
    
    // variavel com emoji correspondente para cada card/botão
    private var emoji: Dictionary<Card,String> = [Card:String]()
    
    // variável com o valor de clicks
    private(set) var flipCount: Int = 0 {
        // verifica se o valor sofreu alteração e executa lógica
        didSet {
            updateFlipCountLabel()
        }
    }
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    // Lazy permite usar a variável de instância "cardButtons" quando ele for requisitada através de uma inicialização
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // variável com informação do tempo para remover os cards combinados
    let secondsToKickOff = 0.5
    
    // variável com informação do tempo para remover os cards não combinados
    let secondsToFaceDown = 1.5
    
    // MARK: - IBOutlet
    
    // variável com array de cards conectados ao UI
    @IBOutlet private var cardButtons: [UIButton]!
    
    // variável com texto da label que mostra quantos clicks foram feitos
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    // MARK: - IBAction
    
    /// método para capturar ação de toque no card
    @IBAction private func touchCard(_ sender: UIButton) {
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
    private func updateViewFromModel() {
        
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
                if card.twoCardsFaceUp, !card.isMatched {
                    timer(button: button, color: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), time: secondsToFaceDown)
                }
                else if card.twoCardsFaceUp, card.isMatched {
                    timer(button: button, color: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0), time: secondsToKickOff)
                }
            } else {
                // apaga emoji
                button.setTitle("", for: UIControl.State.normal)
                // defini a cor traseira do card
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
    }
    
    /// temporizador de tela
    private func timer(button: UIButton, color: UIColor, time: Double) {
        Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = color
        }
    }
    
    /// retorna um emoji para o card fornecido
    private func emoji(for card: Card) -> String {
        // input validation
        assert(game.cards.contains(card), "ConcentrationViewController.emoji(at: \(card)): card was not in cards")
        
        // se o cartão não tiver um emoji definido, adicione um aleatório
        // a condicional precisa do "emojiChoices.count > 0" por conta do intervalo do arc4random_uniform
        if emoji[card] == nil, emojiChoices.count > 0 {
            // remove o emoji do emojiChoices para que não seja selecionado novamente
            //emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        // retorna o emoji ou "?" se nenhum disponível
        return emoji[card] ?? "?"
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributesString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        // altera o texto da label atualizando contagem
        flipCountLabel.attributedText = attributesString
    }
    
}
