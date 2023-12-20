//
//  ArchiveViewController.swift
//  pokerproject
//
//  Created by Никита Лужбин on 20.12.2023.
//

import Foundation
import UIKit

final class ArchiveViewController: UIViewController {
    
    // MARK: - Instance Properties

    private let tableView = UITableView()

    // MARK: -

    private let gameService = DefaultGameService.shared
    private var games: [CashGame] = []
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInisialState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        games = gameService.getAllGames()
        tableView.reloadData()
    }
    
    // MARK: - Instance Methods
    
    private func setupInisialState() {
        title = "Архив"

        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(GameArchiveCell.self, forCellReuseIdentifier: GameArchiveCell.reuseIdentifier)

        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDelegate

extension ArchiveViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource

extension ArchiveViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameArchiveCell.reuseIdentifier) as! GameArchiveCell

        cell.configure(with: games[indexPath.row])

        return cell
    }
    
}
