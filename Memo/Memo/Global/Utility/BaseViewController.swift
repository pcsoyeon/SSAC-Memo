//
//  BaseViewController.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        configure()
    }
    
    func configure() { }
    
    func showDefaultAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okay = UIAlertAction(title: button, style: .default)
        
        alert.addAction(okay)
        present(alert, animated: true)
    }
}

