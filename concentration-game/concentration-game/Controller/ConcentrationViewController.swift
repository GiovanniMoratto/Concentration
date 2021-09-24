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
    // Variável que armazena um array com todos os tipos de emoji no game.
    
    var emojiChoices: String = "🎃👻🦇😱🤡💀👹👽🧙🏻‍♀️🧟‍♀️🍭🍬"
    // Variável que armazena uma string com todos os tipos de emoji no game.
    
    private var emoji: Dictionary<Card,String> = [Card:String]()
    // Variável que armazena um dicionário de card e emoji no game.
    
    /*
     Essa variável utiliza a função de chave e valor do dicionário para associar os emojis aos cards no game.
     */
    
    private(set) var flipCount: Int = 0 {
        // Variável com o valor de clicks utilizados no game.
        
        /*
         Inicializada com valor 0 e utiliza Computed Properties para sua alteração.
         */
        
        didSet {
            // Property Observer - verifica se o valor sofreu alteração e executa lógica
            
            updateFlipCountLabel()
        }
    }
    
    var numberOfPairsOfCards: Int {
        // Variável que armazena o valor de pares de cards no game.
        
        /*
         Utiliza Read-Only Computed Properties para gerar seu valor.
         */
        
        return (cardButtons.count + 1) / 2
        
        /*
         Conta quantos elementos existem no array de cardButtons acrescentando 1 pois foi inicializado pelo valor 0. Depois divide por 2 para gerar pares.
         */
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    // Variável com o objeto Concentration, passando o numberOfPairsOfCards na sua inicialização.
    
    /*
     Lazy é uma propertie cujo valor inicial não é calculado até a primeira vez que é usada. Graças a isso é possivel usar a variável "numberOfPairsOfCards" apenas quando ela for requisitada através de uma inicialização
     */
    
    let secondsToRemove = 0.5
    // Constante com valor do tempo em segundos para remover os cards combinados
    
    let secondsToFaceDown = 1.5
    // Constante com valor do tempo em segundos para virar os cards não combinados
    
    let cardColorFaceUp: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    // Constante com valor da cor para o card faceUp = true
    
    let cardColorFaceDown: UIColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    // Constante com valor da cor para o card faceUp = false
    
    let cardColorRemove: UIColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0)
    // Constante com valor da cor para o card isMatched = true

    
    // MARK: - IBOutlet
    
    @IBOutlet private var cardButtons: [UIButton]!
    // variável com array de cards conectados ao UI
    
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        // variável com texto da label que mostra quantos clicks foram feitos
        
        /*
         weak indica que é uma variável de referência fraca, o que significa que é apenas um ponteiro para um objeto que não o proteje de ser desalocado pelo ARC.
         Por ser fraca e poder ser nula, week é sempre declarada como Optional e precisa ser unwrap para acessar seu valor.
         */
        
        didSet {
            // Property Observer - verifica se o valor sofreu alteração e executa lógica
            updateFlipCountLabel()
        }
    }
    
    // MARK: - IBAction
    
    /// Método para capturar ação de toque no card
    @IBAction private func touchCard(_ sender: UIButton) {

        flipCount += 1
        // Acrescenta click no total de contagem
        
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
        
        updateViewFromModel()
        // Atualiza a view para gerar efeitos visuais.
    }
    
    // MARK: - Methods
    
    /// Mantém a visualização atualizada com base no estado do modelo
    private func updateViewFromModel() {
        
        for index in cardButtons.indices {
            // laço percorrendo todos os card pelos indices
            
            let button = cardButtons[index]
            // constante com o cardButton do indice atual
            
            let card = game.cards[index]
            // constante com o card do indice atual
            
            if card.isFaceUp {
                // Se o card estiver virado para cima (isFaceUp = true)
                
                button.setTitle(insertEmoji(for: card), for: UIControl.State.normal)
                // Inseri emoji no cardButton
                
                button.backgroundColor = cardColorFaceUp
                // Defini a cor frontal do cardButton
                
                if card.twoCardsFaceUp, !card.isMatched {
                    
                    /*
                     Se o card está virado para cima com mais algum e não combinaram, executa lógica
                     */
                    
                    timer(button: button, color: cardColorFaceDown, time: secondsToFaceDown)
                    // Efeito de card virando para baixo
                }
                else if card.twoCardsFaceUp, card.isMatched {
                    
                    /*
                     Se o card está virado para cima com mais algum e eles combinaram, executa lógica
                     */
                    
                    timer(button: button, color: cardColorRemove, time: secondsToRemove)
                    // Efeito de retirar os cards
                }
            } else {
                // Se o card estiver virado para baixo (isFaceUp = false)
                
                button.setTitle("", for: UIControl.State.normal)
                // Apaga o emoji do card
                
                button.backgroundColor = card.isMatched ? cardColorRemove : cardColorFaceDown
                // Defini a cor traseira do card
            }
        }
    }
    
    /// Método para gerar um temporizador de tela
    /// - Parameter button: UIButton que receberá o efeito
    /// - Parameter color: Cor que será atribuida ao card
    /// - Parameter time: Tempo que será atribuido ao efeito
    private func timer(button: UIButton, color: UIColor, time: Double) {
        Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = color
        }
    }
    
    /// Método para retornar um emoji ao card fornecido
    /// - Parameter card: Card que receberá um emoji e será associado.
    private func insertEmoji(for card: Card) -> String {
        
        assert(game.cards.contains(card), "ConcentrationViewController.emoji(at: \(card)): card was not in cards")
        
        /*
         Validação de dados de entrada no método, apenas cards existentes no array de cards serão aceitos.
         */
        
        // se o cartão não tiver um emoji definido, adicione um aleatório
        // a condicional precisa do "emojiChoices.count > 0" por conta do intervalo do arc4random_uniform
        if emoji[card] == nil, emojiChoices.count > 0 {
            
            /*
             Se o Dicionário emoji com o indice "card" enviado no método, for igual a nil e a quantidade de emojis disponiveis em emojiChoices.count for maior que 0, executa lógica
             */
            
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            
            /*
             Instancia uma constante com um valor de index aleatório
             */
            
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            // remove o emoji do emojiChoices para que não seja selecionado novamente
        }
        
        return emoji[card] ?? "?"
        // retorna o emoji ou "?" se nenhum disponível
    }
    
    /// Método para retornar atualizar a contagem de clicks na Label
    private func updateFlipCountLabel() {
        
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        
        let attributesString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributesString
        // altera o texto da label atualizando contagem
    }
    
}
