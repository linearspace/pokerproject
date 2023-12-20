//
//  DefaultGameService.swift
//  pokerproject
//
//  Created by Никита Лужбин on 20.12.2023.
//

import Foundation

final class DefaultGameService {

    // MARK: - Locals

    private enum Locals {
        static let gamesKey = "games"
    }

    // MARK: - Public Properties

    static let shared = DefaultGameService()

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard

    // MARK: - Init

    private init() { }

    // MARK: - Public Methods

    func saveGame(game: CashGame) {
        var games: [CashGame] = []

        if let data = userDefaults.data(forKey: Locals.gamesKey),
            let savedGames = try? PropertyListDecoder().decode([CashGame].self, from: data) {
            games = savedGames
        }
        
        games.append(game)

        if let data = try? PropertyListEncoder().encode(games) {
            userDefaults.set(data, forKey: Locals.gamesKey)
        }
    }

    func getAllGames() -> [CashGame] {
        if let data = userDefaults.data(forKey: Locals.gamesKey),
            let games = try? PropertyListDecoder().decode([CashGame].self, from: data) {
            return games
        }

        return []
    }
}
