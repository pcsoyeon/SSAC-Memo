//
//  WalkThroughViewController.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

final class WalkThroughViewController: BaseViewController {

    // MARK: - UI Property
    
    private let walkThroughView = WalkThroughView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = walkThroughView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom Method
    
    override func configure() {
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        configureButton()
    }

    private func configureButton() {
        walkThroughView.confirmButton.addTarget(self, action: #selector(touchUpConfirmButton), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc func touchUpConfirmButton() {
        dismiss(animated: true)
    }
}
