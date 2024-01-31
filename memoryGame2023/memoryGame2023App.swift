//
//  memoryGame2023App.swift
//  memoryGame2023
//
//  Created by Kevin Mathew on 12/21/23.
//
//This file is the entry point for your SwiftUI app.
//It creates an instance of EmojiMemoryGame and sets up the main app view (EmojiMemoryGameView).


import SwiftUI

@main
struct memoryGame2023App: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
