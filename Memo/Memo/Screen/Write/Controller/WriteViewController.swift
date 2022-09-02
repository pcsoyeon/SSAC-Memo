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
                writeView.textView.becomeFirstResponder()
                showNavigationItem()
            } else {
                navigationItem.rightBarButtonItems = nil
            }
        }
    }
    
    private let repository = MemoRepository()
    
    private var memoTitle: String = ""
    private var memoContent: String = ""
    
    private var returnCount: Int = 0
    
    var memo = Memo(memoTitle: "", memoContent: "", memoDate: Date()) {
        didSet {
            writeView.textView.text = """
                                      \(memo.memoTitle)\n\n
                                      \(memo.memoContent ?? "")\n
                                      \(memo.memoDate)
                                      """
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    // MARK: - UI Method
    
    override func configure() {
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
        writeView.textView.delegate = self
    }
    
    // MARK: - @objc
    
    @objc func touchUpShareButton() {
        var objectsToShare = [String]()
        
        if let text = writeView.textView.text {
            objectsToShare.append(text)
        }
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func touchUpDoneButton() {
        let task = Memo(memoTitle: "제목", memoContent: "내용", memoDate: Date())
        repository.addItem(item: task)
        print(memoTitle, memoContent)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextView Protocol

extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        isNew.toggle()
        showNavigationItem()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n", returnCount == 1 {
//            memoTitle = textView.text
//            returnCount += 1
//        } else {
//            memoContent = textView.text.replacingOccurrences(of: memoTitle, with: "")
//        }
        return true
    }
}
