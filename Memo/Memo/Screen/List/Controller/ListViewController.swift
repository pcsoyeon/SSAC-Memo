//
//  ViewController.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

final class ListViewController: BaseViewController {

    // MARK: - UI Property
    
    private var mainView = ListView()
    
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchResultsUpdater = self
    }
    
    // MARK: - Property
    
    private var totalCount: Int = 0
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        view.backgroundColor = .darkGray
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        title = "\(totalCount)개의 메모"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.delegate = self
    }
    
    private func configureTableView() {
        mainView.listTableView.delegate = self
        mainView.listTableView.dataSource = self
        
        mainView.listTableView.rowHeight = 80
        
        mainView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
    }
    
    // MARK: - Custom Method
    
    private func presentWalkThrough() {
        let viewController = WalkThroughViewController()
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

// MARK: - UITableView Protocol

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        return cell
    }
}

// MARK: - UISearchBar Protocol

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        // 검색
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
}
