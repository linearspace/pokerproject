//
//  MainViewController.swift
//  pokerproject
//
//  Created by  on 20.12.2023.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private Properties

    private let button = UIButton()
    private let archiveButton = UIButton()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
    }

    // MARK: - Drawnings

    private func drawSelf() {
        view.backgroundColor = .systemBackground
        
        button.setTitle("Start Game", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 100, y: 500, width: 200, height: 50)
        button.layer.cornerRadius = button.frame.height/2
        button.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)

        archiveButton.setTitle("Archive", for: .normal)
        archiveButton.backgroundColor = .black
        archiveButton.setTitleColor(.white, for: .normal)
        archiveButton.frame = CGRect(x: 100, y: 570, width: 200, height: 50)
        archiveButton.layer.cornerRadius = archiveButton.frame.height/2
        archiveButton.addTarget(self, action: #selector(didTapArchiveButton), for: .touchUpInside)

        view.addSubview(button)
        view.addSubview(archiveButton)
    }

    // MARK: - Actions
    
    @objc private func didTabButton(){
        navigationController?.pushViewController(GameViewController(), animated: true)
    }

    @objc private func didTapArchiveButton() {
        navigationController?.pushViewController(ArchiveViewController(), animated: true)
    }
}
