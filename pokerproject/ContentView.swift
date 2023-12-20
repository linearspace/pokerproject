
import UIKit
import Foundation
import SwiftUI

struct ContentView: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let navigationController = UINavigationController(rootViewController: MainViewController())

        navigationController.navigationBar.tintColor = .black
        
        return navigationController
    }
}

var isStarted: Bool = true // bad?? TODO: make button for session start/end
