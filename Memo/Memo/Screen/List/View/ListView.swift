//
//  MainView.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

final class ListView: BaseView {
    
    // MARK: - UI Property
    
    lazy var listTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    var writeButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.setImage(UIImage(systemName: "write"), for: .normal)
        $0.tintColor = .systemOrange
    }
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
    }
    
    override func setConstraints() {
        self.addSubview(listTableView)
        self.addSubview(writeButton)
        
        writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.trailing.bottom.equalToSuperview()
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(writeButton.snp.top)
        }
    }
}
