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
    
    var titleTextView = UITextView().then {
        $0.backgroundColor = .systemRed
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.tintColor = .systemOrange
    }
    
    var contentTextView = UITextView().then {
        $0.backgroundColor = .systemBlue
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.tintColor = .systemOrange
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = .background
        
        addSubviews([titleTextView, contentTextView])
    }
    
    override func setConstraints() {
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
