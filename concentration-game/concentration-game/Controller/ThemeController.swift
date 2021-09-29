//
//  ThemeController.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 28/09/21.
//

import UIKit

class ThemeController: UIViewController {
    
    // MARK: - Attributes
    
    private var themes: [String : ThemeModel] = [
        "Halloween":
            ThemeModel(
                name: "Halloween",
                boardColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                cardColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1),
                textColor: #colorLiteral(red: 0.9480113387, green: 0.440803051, blue: 0.02514018305, alpha: 1),
                shadowTextColor: #colorLiteral(red: 0.9479655623, green: 0.818603456, blue: 0.7748424411, alpha: 1),
                emojis: ["🎃", "👻", "🦇", "🧛‍♂️", "🤡", "💀", "👹", "👽", "🧙🏻‍♀️", "🧟‍♀️", "🍭", "🍬"]
            ),
        "Food":
            ThemeModel(
                name: "Food",
                boardColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
                cardColor:  #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
                textColor: #colorLiteral(red: 0.8954734206, green: 0.09536682814, blue: 0.05411744863, alpha: 1),
                shadowTextColor: #colorLiteral(red: 0.9479655623, green: 0.818603456, blue: 0.7748424411, alpha: 1),
                emojis: ["🍕", "🥙", "🍔", "🍟", "🍫", "🌭", "🍖", "🌯", "🍗", "🍝", "🍱", "🍜"]
            ),
        "Animals":
            ThemeModel(
                name: "Animals",
                boardColor: #colorLiteral(red: 0.0703080667, green: 0.4238856008, blue: 0.02163499179, alpha: 1),
                cardColor:  #colorLiteral(red: 0.4453506704, green: 0.1640041592, blue: 0.002700540119, alpha: 1),
                textColor: #colorLiteral(red: 0.1010349467, green: 0.0891784206, blue: 0.6488422751, alpha: 1),
                shadowTextColor: #colorLiteral(red: 0.9479655623, green: 0.818603456, blue: 0.7748424411, alpha: 1),
                emojis: ["🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🦒", "🦘", "🦫", "🐿", "🦩"]
            )
    ]
    
    // MARK: - IBAction
    
    @IBAction func chooseTheme(_ sender: UIButton) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    
    // MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "Choose Theme":
            if let concentrationVC = segue.destination as? GameController {
                if let themeName = (sender as? UIButton)?.currentTitle {
                    if let theme = themes[themeName] {
                        concentrationVC.theme = theme
                    }
                }
            }
        default:
            break
        }
    }
}
