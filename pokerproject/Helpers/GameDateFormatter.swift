//
//  GameDateFormatter.swift
//  pokerproject
//
//  Created by Никита Лужбин on 20.12.2023.
//

import Foundation

struct GameDateFormatter {

    // MARK: - Type Properties

    static let shared = GameDateFormatter()

    // MARK: - Instance Ptoperties

    private var outputDateFormater: DateFormatter {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d MMMM | y"
        dateFormatter.locale = .init(identifier: "ru_RU")

        return dateFormatter
    }

    // MARK: - Init

    private init() { }

    // MARK: - Instance Methods

    func date(from string: String) -> Date? {
        return ISO8601DateFormatter().date(from: string)
    }

    func string(from date: Date) -> String {
        return outputDateFormater.string(from: date)
    }
}
