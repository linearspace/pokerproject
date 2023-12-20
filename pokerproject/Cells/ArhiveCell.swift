//
//  ArhiveCell.swift
//  pokerproject
//
//  Created by Никита Лужбин on 20.12.2023.
//

import UIKit
import Foundation
import PureLayout

final class GameArchiveCell: UITableViewCell {

    // MARK: - Type Properties

    static let reuseIdentifier = "GameArchiveCell"

    // MARK: - Instance Properties

    private let dateLabel = UILabel()

    private let horizontalSeparator = UIView()
    private let verticalSeparator = UIView()

    private let playersAmountView = UIStackView()
    private let totalBankView = UIStackView()
    
    private let playersLabel = UILabel()
    private let bankLabel = UILabel()

    private let typeLabel = UILabel()

    // MARK: - UITableViewCell

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods
    
    func configure(with game: CashGame) {
        selectionStyle = .none

        if let startDate = game.startDate {
            dateLabel.text = GameDateFormatter.shared.string(from: startDate)
            dateLabel.font = .systemFont(ofSize: 18, weight: .bold)

            playersLabel.text = "\(game.players.count)"
            bankLabel.text = "\(game.players.map{ $0.amount }.reduce(0, +)) ₽"

            typeLabel.text = "КЭШ"
        }
    }

    private func setupInitialState() {
        let contentView = UIView()

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15.0
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 1

        horizontalSeparator.backgroundColor = .gray.withAlphaComponent(0.5)
        verticalSeparator.backgroundColor = .gray.withAlphaComponent(0.5)

        let playersAmountImageView = UIImageView()
        playersAmountImageView.image = .init(systemName: "person.3")
        playersAmountImageView.tintColor = .black

        let totalBankImageView = UIImageView()
        totalBankImageView.image = .init(systemName: "rublesign.circle")
        totalBankImageView.tintColor = .black

        playersAmountView.axis = .horizontal
        playersAmountView.spacing = 10
        playersAmountView.addArrangedSubview(playersAmountImageView)
        playersAmountView.addArrangedSubview(playersLabel)

        totalBankView.axis = .horizontal
        totalBankView.spacing = 10
        totalBankView.addArrangedSubview(totalBankImageView)
        totalBankView.addArrangedSubview(bankLabel)

        typeLabel.font = .systemFont(ofSize: 18, weight: .bold)

        addSubview(contentView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(horizontalSeparator)
        contentView.addSubview(verticalSeparator)
        contentView.addSubview(playersAmountView)
        contentView.addSubview(totalBankView)
        contentView.addSubview(typeLabel)

        contentView.autoPinEdgesToSuperviewEdges(with: .init(top: 20, left: 20, bottom: 5, right: 20))

        dateLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: 20)
        dateLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: 10)

        horizontalSeparator.autoSetDimension(.height, toSize: 1)
        horizontalSeparator.autoPinEdge(.left, to: .left, of: contentView)
        horizontalSeparator.autoPinEdge(.right, to: .right, of: contentView)
        horizontalSeparator.autoPinEdge(.top, to: .bottom, of: dateLabel, withOffset: 10)

        verticalSeparator.autoSetDimension(.width, toSize: 1)
        verticalSeparator.autoPinEdge(.top, to: .bottom, of: horizontalSeparator)
        verticalSeparator.autoPinEdge(.bottom, to: .bottom, of: contentView)
        verticalSeparator.autoAlignAxis(toSuperviewAxis: .vertical)
        verticalSeparator.autoSetDimension(.height, toSize: 50)

        playersAmountView.autoAlignAxis(.horizontal, toSameAxisOf: verticalSeparator)
        playersAmountView.autoAlignAxis(.vertical, toSameAxisOf: horizontalSeparator, withMultiplier: 0.5)

        totalBankView.autoAlignAxis(.horizontal, toSameAxisOf: verticalSeparator)
        totalBankView.autoAlignAxis(.vertical, toSameAxisOf: horizontalSeparator, withMultiplier: 1.5)

        typeLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        typeLabel.autoAlignAxis(.horizontal, toSameAxisOf: dateLabel)
    }
}
