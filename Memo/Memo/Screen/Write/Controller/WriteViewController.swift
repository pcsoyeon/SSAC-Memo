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
    
    // MARK: - Property
    
    var isNew: Bool = true {
        didSet {
            if isNew {
                writeView.titleTextView.becomeFirstResponder()
                showNavigationItem()
            } else {
                navigationItem.rightBarButtonItems = nil
            }
        }
    }
    
    private let repository = MemoRepository()
    
    var memo = Memo(memoTitle: "", memoContent: "", memoDate: Date()) {
        didSet {
            writeView.titleTextView.text = "\(memo.memoTitle)"
            writeView.contentTextView.text = "\(memo.memoContent ?? "")"
        }
    }
    
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
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .systemOrange
    }
    
    private func showNavigationItem() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(touchUpShareButton))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action:  #selector(touchUpDoneButton))
        navigationItem.rightBarButtonItems = [doneButton, shareButton]
    }
    
    private func configuireTextView() {
        writeView.titleTextView.delegate = self
        writeView.titleTextView.isScrollEnabled = false
        
        writeView.contentTextView.delegate = self
    }
    
    // MARK: - @objc
    
    @objc func touchUpShareButton() {
        var objectsToShare = [String]()
        
        if let titleText = writeView.titleTextView.text, let contentText = writeView.contentTextView.text {
            objectsToShare.append(titleText)
            objectsToShare.append(contentText)
        }
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func touchUpDoneButton() {
        if isNew {
            let task = Memo(memoTitle: writeView.titleTextView.text, memoContent: writeView.contentTextView.text, memoDate: Date())
            repository.addItem(item: task)
        } else {
            repository.updateItem(value: ["objectId": memo.objectId,
                                          "memoTitle" : writeView.titleTextView.text,
                                          "memoContent" : writeView.contentTextView.text])
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextView Protocol

extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        showNavigationItem()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = writeView.titleTextView.sizeThatFits(size)
        writeView.titleTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && textView == writeView.titleTextView {
            textView.resignFirstResponder()
            writeView.contentTextView.becomeFirstResponder()
        }
        return true
    }
}
