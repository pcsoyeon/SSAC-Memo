//
//  ViewController.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

final class MainViewController: UIViewController {

    // MARK: - UI Property
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        
    }
    
    private func configureUI() {
        view.backgroundColor = .darkGray
    }
    
    private func setConstraints() {
        
    }
    
    private func presentWalkThrough() {
        let viewController = WalkThroughViewController()
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

