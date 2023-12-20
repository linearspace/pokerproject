//
//  Game.swift
//  pokerproject
//
//  Created by Никита Лужбин on 20.12.2023.
//

import Foundation

struct CashGame: Codable {

    // MARK: - Instance Properties

    var id = UUID().uuidString

    var startDate: Date?
    var endDate: Date?

    var players: [Player] = []
}
