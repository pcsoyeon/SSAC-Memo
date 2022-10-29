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
        configure()
    }
    
    func configure() {
        view.backgroundColor = .background
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func presentAlert (
        title: String,
        message: String? = nil,
        isIncludedCancel: Bool = false,
        completion: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if isIncludedCancel {
            let deleteAction = UIAlertAction(title: "취소", style: .cancel)
            alertController.addAction(deleteAction)
        }
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: completion)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

