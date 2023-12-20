//
//  GameViewController.swift
//  pokerproject
//
//  Created by on 20.12.2023.
//

import Foundation
import UIKit

final class GameViewController: UIViewController {
    
    // MARK: - Private Properties

    private var game = CashGame()

    private var isStarted = false
    
    private lazy var statusBarButton = UIBarButtonItem(title: "Start",
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(onStatusButtonDidTapped))
    private let tableView = UITableView()
    
    private var players = [
        Player(name: "Ivan", amount: 100),
        Player(name: "Masha", amount: 100),
    ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Game"

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(AddPerson)
            ),
            statusBarButton
        ]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds

        view.addSubview(tableView)
    }

    // MARK: - Actions

    @objc private func AddPerson() {
        
        let alert = UIAlertController(title: "Adding", message: "Add a new person", preferredStyle: .alert)
        
        alert.addTextField {
            textField in textField.placeholder = "Имя"
        }
        
        alert.addTextField{
            textField in textField.placeholder = "Сумма"
            textField.delegate = self
        }
        
        alert.addAction(UIAlertAction(title: "Окей", style: .default, handler: { _ in
            if let name = alert.textFields?[0].text,
               let amountString = alert.textFields?[1].text,
                let amount = Int(amountString) {
                
                self.players.append(.init(name: name, amount: amount))
                
                self.tableView.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }

    @objc private func onStatusButtonDidTapped() {
        if !isStarted {
            game.startDate = Date()

            statusBarButton.title = "Finish"
            navigationItem.rightBarButtonItems = [statusBarButton]
        } else {
            game.players = players
            game.endDate = Date()
            DefaultGameService.shared.saveGame(game: game)

            navigationController?.popToRootViewController(animated: true)
        }

        isStarted.toggle()
        tableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate

extension GameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return hasNumber(string: string)
    }
    
    func hasNumber(string: String) -> Bool {
        let Numbers = "1234567890"
        for char in string{
            if !Numbers.contains(char){
                return false
            }
        }
        return true
    }
}


// MARK: - UITableViewDataSource
extension GameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = players[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = player.name
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = .boldSystemFont(ofSize: CGFloat(integerLiteral: 20))
        
        let balanceLabel = UILabel()

        let baseBalanceText = "\(player.amount) ₽"
        let extraBalanceText = " → \(player.now != nil ? String(player.now ?? 0) : "?") ₽"
        balanceLabel.text = baseBalanceText + (isStarted ? extraBalanceText : "")
        balanceLabel.textColor = .black
        balanceLabel.font = .italicSystemFont(ofSize: CGFloat(integerLiteral: 15))
        balanceLabel.textAlignment = .center
        
        cell.accessoryView = balanceLabel
        balanceLabel.sizeToFit()
        
        return cell
    }

    
}

// MARK: - UITableViewDelegate

extension GameViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isStarted
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isStarted else { tableView.deselectRow(at: indexPath, animated: true); return }
        let selectedPlayer = players[indexPath.row]
        
        let alert = UIAlertController(title: "Edit Amount", message: "Enter the current player's amount", preferredStyle: .alert)
        alert.addTextField {
            textField in
            textField.text = "\(selectedPlayer.amount)"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let amountString = alert.textFields?[0].text,
               let newAmount = Int(amountString) {
                self.players[indexPath.row].now = newAmount
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
