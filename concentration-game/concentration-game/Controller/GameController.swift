//
//  ViewController.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 16/09/21.
//

import UIKit

class GameController: UIViewController {
    // Representa o controller do game
    
    // MARK: - Attributes
    
    var numberOfPairsOfCards: Int { return (cardButtons.count + 1) / 2 }
    
    private var emoji: Dictionary<Card,String> = [Card:String]()
    
//    private var themeBackgroundColor: UIColor?
//
//    private var themeCardColor: UIColor?
//
//    private var themeCardTitles: [String]?
    
    private lazy var game: Game = Game(numberOfPairsOfCards: numberOfPairsOfCards)
    // Variável com o objeto Concentration, passando o numberOfPairsOfCards na sua inicialização.
    
    /*
     Lazy é uma propertie cujo valor inicial não é calculado até a primeira vez que é usada. Graças a isso é possivel usar a variável "numberOfPairsOfCards" apenas quando ela for requisitada através de uma inicialização
     */
    
    private let secondsToRemove: Double = 0.5
    
    private let secondsToTurnDown: Double = 1.0
    
    private let removeColor: UIColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0)
    
    
    // Programming assignment 1 (Task #4 & extra-credit #1)
    //
    // "Give your game the concept of a 'theme'. A theme determines the set of emoji from
    // which cards are chosen"
    //
    // +Extra credit:
    // "Change the background and the 'card back color' to match the theme"
    
    ///
    /// The theme determines the game's look and feel.
    ///
    lazy var theme: Theme = defaultTheme
    
    ///
    /// The default theme to use
    ///
    private var defaultTheme = Theme(name: "Default", boardColor: #colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1), cardColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                                    emojis: ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇",
                                             "🍓", "🍈", "🍒", "🍑", "🍍", "🥝", "🥑", "🍅",])

    // MARK: - IBOutlet
    
    @IBOutlet private(set) var cardButtons: [UIButton]!

    @IBOutlet private weak var matchLabel: UILabel!

    @IBOutlet private weak var scoreLabel: UILabel!

    @IBOutlet private weak var timeBonusLabel: UILabel!
    
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
        
        updateUIFromModel()
        // Atualiza a view dos cards para gerar efeitos visuais.
        
        updateLabelsView()
        // Atualiza a view das labels para gerar efeitos visuais.
        
        
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        initialSetup()
    }
    
    // MARK: - Methods
    
    /*
    /// Mantém a visualização atualizada com base no estado dos cards
    private func updateCardsView() {
        
        for index in cardButtons.indices {
            
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(insertEmoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                if card.twoCardsFaceUp, !card.isMatched {
                    cardEffect(button: button, time: secondsToTurnDown, color: themeCardColor!)
                }
                else if card.twoCardsFaceUp, card.isMatched {
                    cardEffect(button: button, time: secondsToRemove, color: removeColor)
                }
                
            } else {
                // Se o card estiver virado para baixo (isFaceUp = false)
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? removeColor : themeCardColor
            }
        }
    }
     */
    
    /// Mantém a visualização atualizada com base no estado das labels
    private func updateLabelsView() {
        
        timeBonusLabel.text = game.bonus
        //removeEffect(element: timeBonusLabel)
        removeTimeBonusEffect(label: timeBonusLabel)
        game.resetTimeBonus()
        matchLabel.text = "Matches: \(game.matches)"
        scoreLabel.text = "SCORE: \(game.score)"

    }
    
    /// Método para gerar efeito visual no bônus
    /// - Parameter element: UILabel que receberá o efeito
    /// - Parameter time: Tempo que será atribuido ao efeito
    private func removeEffect(element: UIView) {
        element.alpha = 1
        UIView.animate(withDuration: 1, animations: {
            element.alpha = 0
        })
    }
    
    /// Método para gerar efeito visual no bônus
    /// - Parameter label: UILabel que receberá o efeito
    /// - Parameter time: Tempo que será atribuido ao efeito
    private func removeTimeBonusEffect(label: UILabel) {
        label.alpha = 1
        UIView.animate(withDuration: 5, animations: {
            label.alpha = 0
        })
    }
    
    /// Método para gerar efeito visual nos cards
    /// - Parameter button: UIButton que receberá o efeito
    /// - Parameter time: Tempo que será atribuido ao efeito
    /// - Parameter color: Cor que será atribuida ao card
    private func cardEffect(button: UIButton, time: Double, color: UIColor) {
        Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + time + 0.5) {
            UIView.animate(withDuration: time, animations: {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = color
            })}
    }
    
    /*
    /// Método para retornar um emoji ao card fornecido
    /// - Parameter card: Card que receberá um emoji e será associado.
    private func insertEmoji(for card: Card) -> String {
        assert(game.cards.contains(card), "ConcentrationViewController.emoji(at: \(card)): card was not in cards")

        var emojis: Array<String> = theme.emojis.shuffled()
        
        if emoji[card] == nil, emojis.count > 0 {
            
            let randomIndex = emojis.index(emojis.startIndex, offsetBy: emojis.count.arc4random)
            emoji[card] = String(emojis.remove(at: randomIndex))
        }
        
        return emoji[card] ?? "?"

    }
     */
    
//    /// Método para definir o tema do game
//    private func settingTheme() {
//        let themes = [halloweenTheme, foodTheme, animalsTheme]
//        let randomTheme = themes.count.arc4random
//        themeBackgroundColor = themes[randomTheme].backgroundColor
//        themeCardColor = themes[randomTheme].cardColor
//        themeCardTitles = themes[randomTheme].cardTitles
//        view.backgroundColor = themeBackgroundColor
//        scoreLabel.textColor = themeCardColor
//        matchLabel.textColor = themeCardColor
//        restartButton.tintColor = themeCardColor
//        timeBonusLabel.textColor = themeCardColor
//    }
    
    ///
    /// Get an emoji for the given card
    ///
    private func insertEmoji(for card: Card) -> String {
        // Return the emoji, or "?" if none available
        return emoji[card] ?? "?"
    }

    ///
    /// Assign an emoji for each card identifier
    ///
    private func mapCardsToEmojis() {

        // List of emojis available for the current theme
        var emojis = theme.emojis

        // Suffle them (to have slighlty different emojis with each new game)
        emojis.shuffle()

        for card in game.cards {
            // Make sure emojis has item(s) and the card is not set yet
            if !emojis.isEmpty, emoji[card] != nil {
                // Assign emoji
                emoji[card] = emojis.removeFirst()
            }
            else {
                emoji[card] = "?"
            }
        }
    }
    
    ///
    /// Keeps the UI updated based on the model's state
    ///
    private func updateUIFromModel() {
        
        for index in cardButtons.indices {
            
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(insertEmoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                if card.twoCardsFaceUp, !card.isMatched {
                    cardEffect(button: button, time: secondsToTurnDown, color: theme.cardColor)
                }
                else if card.twoCardsFaceUp, card.isMatched {
                    cardEffect(button: button, time: secondsToRemove, color: removeColor)
                }
                
            } else {
                // Se o card estiver virado para baixo (isFaceUp = false)
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? removeColor : theme.cardColor
            }
        }
    }
    
    ///
    /// Setups a new game
    ///
    private func initialSetup() {
        // Create new Concentration game
        game = Game(numberOfPairsOfCards: numberOfPairsOfCards)
        
        // Match board color (view's background) with the current theme color
        self.view.backgroundColor = theme.boardColor
        
        // Get emojis for each card
        mapCardsToEmojis()
        
        // Update cards view
        updateUIFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do initialSetup
        initialSetup()
    }
    
}
