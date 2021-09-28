//
//  ThemeController.swift
//  concentration-game
//
//  Created by Giovanni Vicentin Moratto on 28/09/21.
//

import UIKit

class ThemeController: UIViewController, UISplitViewControllerDelegate {
    
    // Called after interface-builder setup
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    // Make sure splitViewController shows master during startup
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let concentrationVC = secondaryViewController as? GameController {
            if concentrationVC.theme.name == "Default" { // small hack to keep logic similar to lecture
                return true // do not show the detail-view
            }
        }
        return false // show the detail
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "Choose Theme":
            // Destinaton VC must be a ConcentrationViewController
            if let concentrationVC = segue.destination as? GameController {
                // (Bad design): We are getting the theme from the button's title
                if let themeName = (sender as? UIButton)?.currentTitle {
                    // We should have a theme for the sender's themeName
                    if let theme = themes[themeName] {
                        concentrationVC.theme = theme
                    } // else, the concentrationVC will use a "default" theme
                }
            }
        default:
            break
        }
    }
    
    ///
    /// Change theme based on the option (button) selected
    ///
    @IBAction func changeTheme(_ sender: Any) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    
    ///
    /// Available themes the app supports.
    ///
    /// Add more themes as you please.
    ///
    private var themes: [String : Theme] = [
        "Halloween":
            Theme(
                name: "Halloween",
                boardColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                cardColor:  #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1),
                emojis: ["🎃", "👻", "🦇", "🧛‍♂️", "🤡", "💀", "👹", "👽", "🧙🏻‍♀️", "🧟‍♀️", "🍭", "🍬"]
            ),
        "Food":
            Theme(
                name: "Food",
                boardColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
                cardColor:  #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
                emojis: ["🍕", "🥙", "🍔", "🍟", "🍫", "🌭", "🍖", "🌯", "🍗", "🍝", "🍱", "🍜"]
            ),
        "Animals":
            Theme(
                name: "Animals",
                boardColor: #colorLiteral(red: 0.0703080667, green: 0.4238856008, blue: 0.02163499179, alpha: 1),
                cardColor:  #colorLiteral(red: 0.4453506704, green: 0.1640041592, blue: 0.002700540119, alpha: 1),
                emojis: ["🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🦒", "🦘", "🦫", "🐿", "🦩"]
            )
        ]
}
