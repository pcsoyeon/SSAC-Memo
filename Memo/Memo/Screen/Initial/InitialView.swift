//
//  InitialView.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

class InitialView: BaseView {
    
    // MARK: - UI Property
    
    private var backView = UIView().then {
        $0.backgroundColor = .darkGray
        $0.roundCorners(corners: .allCorners, radius: 15)
    }
    
    private var titleLabel = UILabel().then {
        $0.text = """
        처음 오셨군요!
        환영합니다 :)
        
        당신만의 메모를 작성하고
        관리해보세요!
        """
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private var button = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 17)
        $0.roundCorners(corners: .allCorners, radius: 8)
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = UIColor.colorSet(.background)
        
        addSubview(backView)
        backView.addSubviews([titleLabel, button])
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(120)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(47)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
