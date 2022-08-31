//
//  ViewController.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentPopUpView()
    }
    
    override func configure() {
        
    }
    
    // MARK: - Custom Method
    
    private func presentPopUpView() {
        let initialViewController = InitialViewController()
        initialViewController.modalPresentationStyle = .overFullScreen
        present(initialViewController, animated: true)
    }
}

