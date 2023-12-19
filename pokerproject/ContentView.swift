
import UIKit
import Foundation
import SwiftUI
struct ContentView: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UINavigationController(rootViewController: MainController())
    }
}

protocol PlayerType {
    var name: String { get }
    var amount: Int { get }
    var now: Int { get set }
}

class Player : PlayerType {
    let name: String
    let amount: Int
    var now: Int
    init(name: String, amount: Int) {
        self.name = name
        self.amount = amount
        self.now = amount
    }
}

var isStarted: Bool = true // bad?? TODO: make button for session start/end

final class MainController: UIViewController{
    private let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        button.setTitle("Start Game", for: .normal)
        view.addSubview(button)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 100, y: 500, width: 200, height: 50)
        
        button.layer.cornerRadius = button.frame.height/2
        button.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
    }
    @objc private func didTabButton(){
        let vc = TestController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


final class TestController: UIViewController {
    
    // MARK: - Private Properties
    
    private let tableView = UITableView()
    
    private var players = [
        Player(name: "Ivan", amount: 100),
        Player(name: "Masha", amount: 100),
        Player(name: "Misha", amount: 100),
        Player(name: "Sasha", amount: 100),
        Player(name: "Vasya", amount: 100),
    ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Money"
        // button add
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add
            , target: self, 
            action: #selector(AddPerson)
        )
        
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
    }
    //action of button on navig bar
    @objc private func AddPerson(){
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
}

// MARK: - UITextFieldDelegate
extension TestController: UITextFieldDelegate {
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
extension TestController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = players[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = player.name
        cell.textLabel?.textAlignment = .left // Здесь изменил .center на .left
        cell.textLabel?.font = .boldSystemFont(ofSize: CGFloat(integerLiteral: 20))
        
        let balanceLabel = UILabel()
        balanceLabel.text = "\(player.amount) £ —> \(player.now) £"
        balanceLabel.textColor = .black
        balanceLabel.font = .italicSystemFont(ofSize: CGFloat(integerLiteral: 15))
        balanceLabel.textAlignment = .center
        
        cell.accessoryView = balanceLabel
        balanceLabel.sizeToFit()
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TestController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isStarted else { tableView.deselectRow(at: indexPath, animated: true); return }
        let selectedPlayer = players[indexPath.row]
        
        let alert = UIAlertController(title: "Edit Amount", message: "Enter the current player's amount", preferredStyle: .alert)
        alert.addTextField {
            textField in
            textField.text = "\(selectedPlayer.now)"
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
