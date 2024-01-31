//
//  EmojiMemoryGameView.swift
//  memoryGame2023
//
//  Created by Kevin Mathew on 12/21/23.
//
// MAIN VIEW


//EmojiMemoryGameView.swift:
//This file defines the main view of your app using SwiftUI.
//It interacts with the EmojiMemoryGame ViewModel to display the game state.
//Includes UI elements like buttons and card views.
//Manages user interactions and invokes ViewModel methods.



import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack{
            Text("Memorize!")
            .font(.largeTitle)
            .padding()
            Button("New Game"){
                viewModel.startNewGame()
            }
            ScrollView{
                cards
                .animation(.default, value: viewModel.cards)
            }
            HStack{
                Text("Theme: \(viewModel.chosenTheme.name)")                .font(.title2)
                Spacer()
                Text("Score: \(viewModel.score)")
                .font(.title2)
            }
            Spacer()
            Button("Shuffle"){
                viewModel.shuffle()
            }
            .imageScale(.large)
            .font(.largeTitle)
        }
        .padding()
    }
    
    
    var cards: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0){
            ForEach(viewModel.cards){ card in
                CardView(card)
                    .aspectRatio(2/3,contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(viewModel.chosenColor)
    }
    
    
    struct CardView: View{
        let card: MemoryGame<String>.Card
        
        init(_ card: MemoryGame<String>.Card) {
            self.card = card
        }
        
        var body: some View{
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                Group{
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                    Text(card.content)
                        .font(.system(size:200))
                        .minimumScaleFactor(0.01)
                        .aspectRatio(1, contentMode: .fit)
                }
                .opacity(card.isFaceUp ? 1: 0)
                base.fill().opacity(card.isFaceUp ? 0: 1)
            }
            .opacity(card.isFaceUp || !card.isMatched ? 1:0)
        }
    }
}



#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
