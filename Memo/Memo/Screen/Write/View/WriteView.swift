//
//  WriteView.swift
//  Memo
//
//  Created by 소연 on 2022/09/01.
//

import UIKit

import SnapKit
import Then

final class WriteView: BaseView {
    
    // MARK: - UI Property
    
    private var textView = UITextView().then {
        $0.backgroundColor = .background
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.tintColor = .systemOrange
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = .background
        
        addSubview(textView)
    }
    
    override func setConstraints() {
        textView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
}
