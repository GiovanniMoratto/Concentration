//
//  ViewController.swift
//  Concentration
//
//  Created by Giovanni Vicentin Moratto on 14/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    var emoji = [Int:String]()
    var emojiChoices = [
            "faces" : ["😀","😍","😴","😱","🤣","😂","😉","🙄","😬", "🤨"],
            "halloween" :["👻","🎃","🧛🏼‍♂️","🦇","🍬","🍭","🍫","😈","🧟‍♂️", "🍎"],
            "animals" : ["🐶","🐱","🐼","🦊","🦁","🐯","🐨","🐮","🐷", "🐵"],
            "summer" : ["🏄🏼‍♂️","🏊🏼‍♀️","☀️","🌈","🌼","🏖","⛱","🏝","🎣", "🍦"],
            "winter" : ["⛄️","☃️","🌨","❄️","🎿","🏂","⛷","🏒","⛸", "🛷"],
            "jobs" : ["👩🏼‍💻","👨🏼‍🏫","👩🏼‍🔬","👨🏼‍🍳","👩🏼‍🌾","👩🏼‍🚀","👩🏼‍✈️","👨🏼‍⚖️","👩🏼‍🔧", "👨🏼‍🏭"]
    ]
    lazy var themeEmoji = [String](setThemeEmoji())
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        guard let cardNumber = cardButtons.firstIndex(of: sender) else {
            print("chosen card was not in cardButtons")
            return
        }
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(getEmoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
    }
    
    func getEmoji(for card: Card) -> String {
        //Add the emoji choice to the emoji dictionary
        if emoji[card.identifier] == nil, themeEmoji.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(themeEmoji.count)))
            emoji[card.identifier] = themeEmoji.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func setThemeEmoji() -> [String] {
        let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
        let themes = Array(emojiChoices.keys)
        let theme = themes[randomIndex]
        themeLabel.text = "\(theme)"
        return emojiChoices[theme] ?? ["?"]
    }
}

