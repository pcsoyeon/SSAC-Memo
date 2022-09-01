//
//  MainView.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

protocol ListViewDelegate: ListViewController {
    func touchUpWriteButton()
}

final class ListView: BaseView {
    
    // MARK: - UI Property
    
    lazy var listTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .background
        $0.separatorStyle = .none
    }
    
    lazy var bottomToolBar = UIToolbar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .systemOrange
    }
    
    // MARK: - Property
    
    weak var delegate: ListViewDelegate?
    
    override func configureUI() {
        backgroundColor = .background
        configureToolbar()
    }
    
    override func setConstraints() {
        addSubview(listTableView)
        addSubview(bottomToolBar)
        
        bottomToolBar.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomToolBar.snp.top)
        }
    }
    
    private func configureToolbar() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(touchUpWriteButton))
        
        bottomToolBar.items = [flexibleSpace, writeButton]
    }
    
    // MARK: - @objc
    
    @objc func touchUpWriteButton() {
        delegate?.touchUpWriteButton()
    }
}
