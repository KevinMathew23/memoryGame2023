//
//  EmojiMemoryGame.swift
//  memoryGame2023
//
//  Created by Kevin Mathew on 1/2/24.
//
// VIEW MODEL

//EmojiMemoryGame.swift:
//This is your ViewModel file, representing the ViewModel in the MVVM architecture.
//It creates and manages the MemoryGame model.
//Provides data and behaviors needed by the view (EmojiMemoryGameView).
//Uses the Combine framework to make the ViewModel observable (@Published property).



import SwiftUI




class EmojiMemoryGame: ObservableObject{
    private static let emojis = ["👻","🎃","🕷️","😈","💀","🕸️","🧙","🙀","👹","😱","☠️","🍭"]
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String>{
        let shuffledEmojis = theme.emojis.shuffled()
        return MemoryGame(numberOfPairsOfCards: 8){ (pairIndex) in
            if shuffledEmojis.indices.contains(pairIndex){
                return shuffledEmojis[pairIndex]
            }else{
                return "⁉️"
            }
            
        }
    }
    private(set) var chosenTheme: Theme
    private(set) var chosenColor: Color
    
    @Published private var model: MemoryGame<String>
    private var internalScore = 0 {
           didSet {
               score = internalScore
           }
    }
    @Published private(set) var score = 0

    static var allThemes = [
        Theme(name: "Animals", emojis: ["🐶", "🐱", "🐰", "🐼", "🦁", "🐯", "🐨", "🐻"], numberOfPairs: 8, cardColor: "blue"),
        Theme(name: "Food", emojis: ["🍔", "🍕", "🌮", "🍣", "🍦", "🍰", "🍩", "🍪"], numberOfPairs: 8, cardColor: "orange"),
        Theme(name: "Sports", emojis: ["⚽️", "🏀", "🎾", "🏓", "🏈", "🏐", "🎱", "🏒"], numberOfPairs: 8, cardColor: "green"),
        Theme(name: "Faces", emojis: ["😀", "😎", "😍", "😜", "😊", "😇", "😂", "😇"], numberOfPairs: 8, cardColor: "yellow"),
        Theme(name: "Weather", emojis: ["🌞", "🌧️", "❄️", "⛈️", "🌈", "🌪️", "🌊", "⛅️"], numberOfPairs: 8, cardColor: "pink"),
        Theme(name: "Transportation", emojis: ["🚗", "🚕", "🚁", "🚀", "🛴", "🚢", "🚂", "🚲"], numberOfPairs: 8, cardColor: "purple"),
    ]
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    init(){
       chosenTheme = EmojiMemoryGame.allThemes.randomElement()!
        chosenColor = EmojiMemoryGame.chooseColor(of: chosenTheme)
        model = EmojiMemoryGame.createMemoryGame(theme: chosenTheme)
        model.resetHasBeenSeen()
        shuffle()
        score = 0
        
    }
    
    //MARK: - Intents
    
    private static func chooseColor(of chosenTheme: Theme) -> Color {
        switch chosenTheme.cardColor{
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "purple":
            return .purple
        default:
            return .black
        }
    }
    
    static func getRandomTheme() -> Theme {
        return allThemes.randomElement()!
    }
    func startNewGame() {
        chosenTheme = EmojiMemoryGame.allThemes.randomElement()!
        chosenColor = EmojiMemoryGame.chooseColor(of: chosenTheme)
        model = EmojiMemoryGame.createMemoryGame(theme: chosenTheme)
        model.resetHasBeenSeen() // Reset hasBeenSeen property
        shuffle()
        score = 0
    }
    
    func shuffle(){
        model.shuffle()
        
    }
    func choose(_ card: MemoryGame<String>.Card) {
        // Save the current score before choosing the card
        let previousScore = score
        
        // Let the model handle the card choosing logic
        model.choose(card)
        
        // Check if a new card is revealed (not matched)
        if previousScore != score {
            // Card was matched, award 2 points
            score += 2
        } else {
            // Card was not matched, penalize 1 point
            score -= 1
        }
    }
}
