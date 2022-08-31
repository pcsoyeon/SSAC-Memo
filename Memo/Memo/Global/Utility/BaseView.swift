//
//  BaseView.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

class BaseView: UIView {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 런타임 오류
    }
    
    // MARK: - UI Method
    
    func configureUI() { }
    
    func setConstraints() { }
}
