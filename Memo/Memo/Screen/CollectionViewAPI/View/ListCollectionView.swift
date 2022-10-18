//
//  ListCollectionView.swift
//  Memo
//
//  Created by 소연 on 2022/10/18.
//

import UIKit

import SnapKit

final class ListCollectionView: BaseView {
    
    // MARK: - UI Property
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    private lazy var layout = UICollectionViewCompositionalLayout.list(using: configuration)
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = .systemBackground
    }
    
    override func setConstraints() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
