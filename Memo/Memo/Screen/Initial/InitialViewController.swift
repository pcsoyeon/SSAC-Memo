//
//  InitialViewController.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

class InitialViewController: BaseViewController {
    
    // MARK: - UI Method
    
    private var initialView = InitialView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = initialView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom Method
    
    override func configure() {
        view.backgroundColor = UIColor(red: 0.0 / 255.0 , green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.5)
    }
}
