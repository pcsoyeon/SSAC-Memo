//
//  ViewController.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import RealmSwift
import SnapKit
import Then

final class ListViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private var rootView = ListView()
    
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = "검색"
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
        $0.searchBar.tintColor = .systemOrange
    }
    
    // MARK: - Property
    
    private let viewModel = MemoListViewModel()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.standard.bool(forKey: Constant.UserDefaults.isNotFirst) {
            presentWalkThrough()
        }
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMemo()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        super.configure()
        configureTableView()
        configureButton()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
    private func configureTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        rootView.tableView.rowHeight = 80
        
        rootView.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        rootView.tableView.keyboardDismissMode = .onDrag
    }
    
    private func configureButton() {
        rootView.delegate = self
    }
    
    // MARK: - Custom Method
    
    private func presentWalkThrough() {
        let viewController = WalkThroughViewController()
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
    
    func checkIfSearchMode() {
        if self.viewModel.isSearching.value {
            self.viewModel.searchMemo(by: self.viewModel.searchKeyword.value)
        } else {
            self.viewModel.fetchMemo()
        }
    }
}


extension ListViewController {
    private func bind() {
        viewModel.memo.bind { _ in
            self.rootView.tableView.reloadData()
        }
        
        viewModel.memoCount.bind { countString in
            self.navigationItem.title = countString
        }
        
        viewModel.isSearching.bind { isSearchMode in
            let backButton = UIBarButtonItem()
            var backButtonTitle = ""
            
            if isSearchMode {
                self.viewModel.searchMemo(by: self.viewModel.searchKeyword.value)
                backButtonTitle = "검색"
                
            } else {
                self.viewModel.fetchMemo()
                backButtonTitle = "메모"
            }
            
            backButton.title = backButtonTitle
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
            self.rootView.tableView.reloadData()
        }
    }
}

// MARK: - UITableView Protocol

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(at: section, isSearchMode: viewModel.isSearching.value)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let writeViewController = WriteViewController()
        let memo = viewModel.memo.value[indexPath.section][indexPath.row]
        writeViewController.memo = memo
        self.navigationController?.pushViewController(writeViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHaldler in
            self.viewModel.pinMemo(indexPath: indexPath) {
                self.presentAlert(title: "메모는 최대 5개까지 고정할 수 있어요!")
            }
            self.checkIfSearchMode()
            completionHaldler(true)
        }
        
        let memo = viewModel.memo.value[indexPath.section][indexPath.row]
        pinAction.backgroundColor = .systemOrange
        pinAction.image = memo.isPinned ? UIImage(systemName: "pin.slash.fill") : UIImage(systemName: "pin.fill")
        return UISwipeActionsConfiguration(actions: [pinAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHaldler in
            self.presentAlert(title: "정말로 삭제하실건가요?", isIncludedCancel: true) { _ in
                self.viewModel.deleteMemo(indexPath: indexPath)
                self.checkIfSearchMode()
            }
            completionHaldler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        if let keyword = searchController.searchBar.text {
            cell.setData(viewModel.cellForRowAt(at: indexPath), viewModel.isSearching.value, keyword)
        }

        return cell
    }
}

// MARK: - UISearchBar Protocol

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.isSearching.value = true
        guard let keyword = searchBar.text else { return }
        viewModel.searchKeyword.value = keyword
        viewModel.searchMemo(by: keyword)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard let keyword = searchBar.text else { return true }
        viewModel.searchKeyword.value = keyword
        
        if keyword == "" {
            viewModel.fetchMemo()
        } else {
            viewModel.searchMemo(by: keyword)
        }
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearching.value = false
        viewModel.fetchMemo()
    }
}

// MARK: - Custom Delegate

extension ListViewController: ListViewDelegate {
    func touchUpWriteButton() {
        let viewController = WriteViewController()
        viewController.isNew = true
        
        let backBarButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(viewController, animated: true)
    }
}
