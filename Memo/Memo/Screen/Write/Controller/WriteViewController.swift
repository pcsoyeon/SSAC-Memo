//
//  WritingViewController.swift
//  Memo
//
//  Created by 소연 on 2022/09/01.
//

import UIKit

import RealmSwift

final class WriteViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = WriteView()
    
    // MARK: - Property
    
    var isNew: Bool = true {
        didSet {
            if isNew {
                rootView.titleTextView.becomeFirstResponder()
                showNavigationItem()
            } else {
                navigationItem.rightBarButtonItems = nil
            }
        }
    }
    
    private var isDoneButtonTapped: Bool = false
    
    private let repository = MemoRepository()
    private let folderRepository = FolderRepository()
    
    var memo = Memo(memoTitle: "", memoContent: "", memoDate: Date()) {
        didSet {
            rootView.titleTextView.text = "\(memo.memoTitle)"
            rootView.contentTextView.text = "\(memo.memoContent ?? "")"
        }
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        writeMemo()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        super.configure()
        configureNavigationBar()
        configuireTextView()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .systemOrange
    }
    
    private func showNavigationItem() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(touchUpShareButton))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action:  #selector(touchUpDoneButton))
        navigationItem.rightBarButtonItems = [doneButton, shareButton]
    }
    
    private func configuireTextView() {
        rootView.titleTextView.delegate = self
        rootView.titleTextView.isScrollEnabled = false
        
        rootView.contentTextView.delegate = self
    }
    
    func writeMemo() {
        // nil 값일 때 저장 X
        guard let title = rootView.titleTextView.text,
              let content = rootView.contentTextView.text
        else { return }
        
        // 내용 없을 때 삭제
        if title.isEmpty && (content.isEmpty || content.trimmingCharacters(in: .newlines).isEmpty) {
            // 작성 중인 상태가 아니면 삭제
            return
        }
        
        // 값이 각각 없는 경우가 있으면 nil로 저장하기 위함
        let newTitle: String? = title.isEmpty ? nil : title
        let newContent: String? = (content.isEmpty || content.trimmingCharacters(in: .newlines).isEmpty) ? nil : content
        
        let memo = Memo(memoTitle: newTitle ?? "", memoContent: newContent, memoDate: Date())
        
        // 새롭게 작성하면, 추가하고 기존의 것을 수정하면 업데이트
    }
    
    // MARK: - @objc
    
    @objc func touchUpShareButton() {
        guard let title = rootView.titleTextView.text,
              let content = rootView.contentTextView.text
        else { return }

        let activityViewController = UIActivityViewController(activityItems: ["\(title)\n\n\(content)"], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    @objc func touchUpDoneButton() {
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
        let estimatedSize = rootView.titleTextView.sizeThatFits(size)
        rootView.titleTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && textView == rootView.titleTextView {
            textView.resignFirstResponder()
            rootView.contentTextView.becomeFirstResponder()
        }
        
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                if rootView.contentTextView.text == "" {
                    let newPosition = rootView.titleTextView.endOfDocument
                    rootView.titleTextView.selectedTextRange = rootView.titleTextView.textRange(from: newPosition, to: newPosition)
                    
                    rootView.titleTextView.becomeFirstResponder()
                    rootView.contentTextView.resignFirstResponder()
                }
            }
        }
        
        return true
    }
}
