//
//  ListCollectionViewController.swift
//  Memo
//
//  Created by 소연 on 2022/10/18.
//

import UIKit

import RealmSwift

final class ListCollectionViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = ListCollectionView()
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Memo>!
    
    // MARK: - Property
    
    private var tasks: Results<Memo>!
    private let repository = MemoRepository()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRealmData()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        // cell data
        rootView.collectionView.dataSource = self
        
        // cell layout
//        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
//        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
//        rootView.collectionView.collectionViewLayout = layout
        
        // cell rendering
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.memoTitle
            content.secondaryText = itemIdentifier.memoContent
            content.image = itemIdentifier.count < 2 ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
            
            cell.contentConfiguration = content
        })
    }
    
    private func fetchRealmData() {
        tasks = repository.fetch()
    }
}

extension ListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tasks[indexPath.row]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        return cell
    }
}
