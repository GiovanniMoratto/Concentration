//
//  ViewController.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 16/09/21.
//

import UIKit

class GameController: UIViewController {
    
    // MARK: - Attributes
    
    var theme: ThemeModel!
    
    var numberOfPairsOfCards: Int { return (cardButtons.count + 1) / 2 }
    
    private var game: GameModel!
    
    private var emoji: Dictionary<CardModel,String> = [CardModel:String]()
    
    private let secondsToRemoveTheCard: Double = 0.7
    
    private let secondsToRemoveTheBonus: Double = 1.5
    
    private let secondsToTurnDown: Double = 1.0
    
    // MARK: - IBOutlet
    
    @IBOutlet private(set) var cardButtons: [UIButton]!
    
    @IBOutlet private weak var matchLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var timeBonusLabel: UILabel!
    
    @IBOutlet private weak var restartButton: UIButton!
    
    // MARK: - IBAction
    
    /// Método para capturar ação de toque no card
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let cardNumber: Int = cardButtons.firstIndex(of: sender) else { return }
        game.chooseCard(at: cardNumber)
        updateUIFromModel()
    }
    
    /// Método para reiniciar o game
    @IBAction func restartGame() {
        for cardButton in cardButtons {
            if cardButton.alpha == 0 {
                cardButton.alpha = 1
            }
        }
        game.resetCards()
        emoji.removeAll()
        initialSetup()
    }
    
    // MARK: - Methods
    
    /// Mantém visualização de todo o game atualizada
    private func updateUIFromModel() {
        matchLabel.text = "Matches: \(game.matches)"
        scoreLabel.text = "SCORE: \(game.score)"
        updateCardsView()
        timeBonusLabel.text = game.bonus
        removeEffect(element: timeBonusLabel, time: secondsToRemoveTheBonus)
        game.resetTimeBonus()
    }
    
    /// Mantém a visualização atualizada com base no estado dos cards
    private func updateCardsView() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(insertEmoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.borderColor = theme.cardBorderColorFront
                if card.twoCardsFaceUp, !card.isMatched {
                    turnEffect(button: button, time: secondsToTurnDown, cardColor: theme.cardColor, borderColor: theme.cardBorderColorBack)
                }
                else if card.twoCardsFaceUp, card.isMatched {
                    removeEffect(element: button, time: secondsToRemoveTheCard)
                }
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.borderColor = theme.cardBorderColorBack
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : theme.cardColor
            }
        }
    }
    
    /// Método para gerar efeito visual no bônus
    /// - Parameter element: UILabel que receberá o efeito
    /// - Parameter time: Tempo que será atribuido ao efeito
    private func removeEffect(element: UIView, time: Double) {
        element.alpha = 1
        UIView.animate(withDuration: time, animations: {
            element.alpha = 0
        })
    }
    
    /// Método para gerar efeito visual nos cards
    /// - Parameter button: UIButton que receberá o efeito
    /// - Parameter time: Tempo que será atribuido ao efeito
    /// - Parameter color: Cor que será atribuida ao card
    private func turnEffect(button: UIButton, time: Double, cardColor: UIColor, borderColor: UIColor) {
        Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + time + 0.5) {
            UIView.animate(withDuration: time, animations: {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = cardColor
                button.borderColor = borderColor
            })}
    }
    
    /// Método para Associar os Emojis a um Card
    private func mapCardsToEmojis() {
        var emojis = theme.emojis
        emojis.shuffle()
        
        for card in game.cards {
            if !emojis.isEmpty, emoji[card] != nil {
                emoji[card] = emojis.removeFirst()
            } else {
                emoji[card] = "?"
            }
        }
    }
    
    /// Método para retornar um emoji ao card fornecido
    /// - Parameter card: Card que receberá um emoji e será associado.
    private func insertEmoji(for card: CardModel) -> String {
        assert(game.cards.contains(card), "GameController.insertEmoji(at: \(card)): card was not in cards")
        return emoji[card] ?? "?"
    }
    
    /// Método para iniciar o jogo
    private func initialSetup() {
        game = GameModel(numberOfPairsOfCards: numberOfPairsOfCards)
        self.view.backgroundColor = theme.boardColor
        self.matchLabel.textColor = theme.textColor
        self.scoreLabel.textColor = theme.textColor
        self.timeBonusLabel.textColor = theme.textColor
        //self.restartButton.tintColor = theme.textColor
        self.matchLabel.shadowColor = theme.shadowTextColor
        self.scoreLabel.shadowColor = theme.shadowTextColor
        self.timeBonusLabel.shadowColor = theme.shadowTextColor
        //self.navigationItem.backButtonDisplayMode = .minimal
        mapCardsToEmojis()
        updateUIFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
}
