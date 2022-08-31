//
//  WalkThroughView.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

final class WalkThroughView: BaseView {
    
    private var backView = UIView().then {
        $0.backgroundColor = .foreground
        $0.layer.cornerRadius = 10
    }
    
    private var label = UILabel().then {
        $0.text = """
                  처음 오셨군요!
                  환영합니다 :)
                  
                  당신만의 메모를 작성하고
                  관리해보세요!
                  """
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    var confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.text, for: .normal)
        $0.backgroundColor = .systemOrange
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        $0.layer.cornerRadius = 8
    }
    
    override func configureUI() {
        self.addSubview(backView)
        
        backView.addSubview(label)
        backView.addSubview(confirmButton)
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(230)
        }
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(130)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(47)
        }
    }
}
