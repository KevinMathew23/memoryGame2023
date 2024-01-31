//
//  MemorizeGame.swift
//  memoryGame2023
//
//  Created by Kevin Mathew on 1/2/24.
//
// MODEL
//MemoryGame.swift:
//Defines the main model (MemoryGame) for your card-matching game.
//Represents the structure of the cards, game logic, and methods for managing gameplay.
//Utilizes a nested Card struct to represent individual cards.


import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private (set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = []
        //add numberOfPairsOfCards x 2 cards
        
        for pairIndex in 0..<max(2,numberOfPairsOfCards){
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
    }
    mutating func resetHasBeenSeen() {
            cards.indices.forEach { cards[$0].hasBeenSeen = false }
    }
    var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get{ cards.indices.filter {index in cards[index].isFaceUp}.only}
        set{cards.indices.forEach{cards[$0].isFaceUp = (newValue == $0)}}
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        // Matched
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2 // Award 2 points for a match
                    } else {
                        // Mismatched
                        if cards[chosenIndex].hasBeenSeen || cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1 // Penalize 1 point for a mismatch involving a previously seen card
                        }
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
                cards[chosenIndex].hasBeenSeen = true
            }
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
        print(cards)
    }
    var score = 0
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        var hasBeenSeen = false
        var id: String
        
        var debugDescription: String{
            return "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? "matched" : "")"
        }
    }
}
struct Theme {
    let name: String
    let emojis: [String]
    let numberOfPairs: Int
    let cardColor: String
    var hasBeenSeen = false
}

extension Array {
    var only: Element?{
        count == 1 ? first: nil
    }
}
