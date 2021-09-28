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
    
    var numberOfPairsOfCards: Int { return (cardButtons.count + 1) / 2 }
    
    private var emoji: Dictionary<Card,String> = [Card:String]()
    
    private var themeBackgroundColor: UIColor?
    
    private var themeCardColor: UIColor?
    
    private var themeCardTitles: [String]?
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    // Variável com o objeto Concentration, passando o numberOfPairsOfCards na sua inicialização.
    
    /*
     Lazy é uma propertie cujo valor inicial não é calculado até a primeira vez que é usada. Graças a isso é possivel usar a variável "numberOfPairsOfCards" apenas quando ela for requisitada através de uma inicialização
     */
    
    private let halloweenTheme  = Theme.init(backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), cardTitles: ["🎃", "👻", "🦇", "🧛‍♂️", "🤡", "💀", "👹", "👽", "🧙🏻‍♀️", "🧟‍♀️", "🍭", "🍬"])
    private let foodTheme       = Theme.init(backgroundColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), cardColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), cardTitles: ["🍕", "🥙", "🍔", "🍟", "🍫", "🌭", "🍖", "🌯", "🍗", "🍝", "🍱", "🍜"])
    private let animalsTheme    = Theme.init(backgroundColor: #colorLiteral(red: 0.0703080667, green: 0.4238856008, blue: 0.02163499179, alpha: 1), cardColor: #colorLiteral(red: 0.4453506704, green: 0.1640041592, blue: 0.002700540119, alpha: 1), cardTitles: ["🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🦒", "🦘", "🦫", "🐿", "🦩"])

    // MARK: - IBOutlet
    
    @IBOutlet private(set) var cardButtons: [UIButton]!

    @IBOutlet private weak var matchLabel: UILabel!

    @IBOutlet private weak var scoreLabel: UILabel!

    @IBOutlet private weak var timeBonusLabel: UILabel!

    @IBOutlet private weak var restartButton: UIButton!
    
    @IBOutlet private weak var topContainer: UIView!
    
    @IBOutlet private weak var matchContainer: UIView!
    
    @IBOutlet private weak var cardsContainer: UIView!
    
    @IBOutlet private weak var bottomContainer: UIView!
    
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
        
        if game.matches == numberOfPairsOfCards {
            restartButton.isHidden = false
        }
    }
    
    @IBAction private func restartButtonPressed(_ sender: UIButton) {
        restartButton.isHidden = false
        game.resetCards()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emoji.removeAll()
        settingTheme()
        updateCardsView()
        updateLabelsView()
        scoreLabel.text = "Score: \(game.score)"
        matchLabel.text = "Matches: \(game.matches)"
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : themeCardColor
                
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
                button.backgroundColor = self.themeCardColor
            })}
    }
    
    /// Método para retornar um emoji ao card fornecido
    /// - Parameter card: Card que receberá um emoji e será associado.
    private func insertEmoji(for card: Card) -> String {
        
        assert(game.cards.contains(card), "ConcentrationViewController.emoji(at: \(card)): card was not in cards")
        
        if emoji[card] == nil && themeCardTitles != nil {
            emoji[card] = themeCardTitles!.remove(at: themeCardTitles!.count.arc4random)
        }
        
        return emoji[card] ?? "?"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTheme()
        updateCardsView()
        updateLabelsView()
        restartButton.isHidden = false
    }
    
    private func settingTheme() {
        let themes = [halloweenTheme, foodTheme, animalsTheme]
        let randomTheme = themes.count.arc4random
        themeBackgroundColor = themes[randomTheme].backgroundColor
        themeCardColor = themes[randomTheme].cardColor
        themeCardTitles = themes[randomTheme].cardTitles
        view.backgroundColor = themeBackgroundColor
        topContainer.backgroundColor = themeBackgroundColor
        matchContainer.backgroundColor = themeBackgroundColor
        cardsContainer.backgroundColor = themeBackgroundColor
        bottomContainer.backgroundColor = themeBackgroundColor
        scoreLabel.textColor = themeCardColor
        matchLabel.textColor = themeCardColor
        restartButton.tintColor = themeCardColor
        timeBonusLabel.textColor = themeCardColor
    }
    
}
