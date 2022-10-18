//
//  FolderListCollectionViewController.swift
//  Memo
//
//  Created by 소연 on 2022/10/18.
//

import UIKit

import RealmSwift

final class FolderListCollectionViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = ListCollectionView()
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Folder>!
    
    // MARK: - Property
    
    private var tasks: Results<Folder>!
    private let repository = FolderRepository()
    
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
        
        // cell rendering
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.count)"
            
            cell.contentConfiguration = content
        })
        
        // cell delegate
        rootView.collectionView.delegate = self
    }
    
    private func fetchRealmData() {
        tasks = repository.fetch()
    }
}

extension FolderListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ListCollectionViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FolderListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tasks[indexPath.row]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        return cell
    }
}
