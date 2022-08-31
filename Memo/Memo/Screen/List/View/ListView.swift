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
        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        $0.tintColor = .systemOrange
    }
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
    }
    
    override func setConstraints() {
        self.addSubview(listTableView)
        self.addSubview(writeButton)
        
        writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(writeButton.snp.top)
        }
    }
}
