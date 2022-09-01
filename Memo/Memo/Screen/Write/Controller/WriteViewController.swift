//
//  WritingViewController.swift
//  Memo
//
//  Created by 소연 on 2022/09/01.
//

import UIKit

class WriteViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let writeView = WriteView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = writeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        configureNavigationBar()
        configuireTextView()
    }
    
    private func configureNavigationBar() {        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .systemOrange
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(touchUpShareButton))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action:  #selector(touchUpDoneButton))
        navigationItem.rightBarButtonItems = [doneButton, shareButton]
    }
    
    private func configuireTextView() {
        writeView.textView.becomeFirstResponder()
    }
    
    // MARK: - @objc
    
    @objc func touchUpShareButton() {
        
    }
    
    @objc func touchUpDoneButton() {
        
    }
}

// MARK: - UITextView Protocol

extension WriteViewController: UITextViewDelegate {
    
}
