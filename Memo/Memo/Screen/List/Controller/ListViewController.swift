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
    
    private var listView = ListView()
    
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchResultsUpdater = self
    }
    
    // MARK: - Property
    
    private var totalCount: Int = 0 {
        didSet {
            title = "\(format(for: totalCount))개의 메모"
        }
    }
    
    private var pinnedCount: Int = 0
    
    private let repository = MemoRepository()
    
    private var tasks: Results<Memo>! {
        didSet {
            for item in tasks {
                if item.isPinned { pinnedCount += 1 }
            }
            listView.listTableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        fetchRealmData()
    }
    
    // MARK: - UI Method
    
    override func configure() {
        configureNavigationBar()
        configureTableView()
        configureButton()
    }
    
    private func configureNavigationBar() {
        title = "\(format(for: totalCount))개의 메모"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.delegate = self
    }
    
    private func configureTableView() {
        listView.listTableView.delegate = self
        listView.listTableView.dataSource = self
        
        listView.listTableView.rowHeight = 80
        
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
    }
    
    private func configureButton() {
        listView.delegate = self
    }
    
    // MARK: - Custom Method
    
    private func presentWalkThrough() {
        let viewController = WalkThroughViewController()
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    private func showActionSheet(type: AlertType, index: Int) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let pinAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            print("삭제")
        })
        
        switch type {
        case .pin:
            optionMenu.title = "최대 5개까지만 고정할 수 있어요"
            optionMenu.addAction(pinAction)
        case .delete:
            optionMenu.title = "이 메모를 삭제하시겠어요?"
            optionMenu.addAction(deleteAction)
        }
        
        self.present(optionMenu, animated: true)
    }
    
    private func format(for number: Int) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        return numberFormat.string(for: number) ?? ""
    }
    
    private func fetchRealmData() {
        tasks = repository.fetch()
    }
}

// MARK: - UITableView Protocol

extension ListViewController: UITableViewDelegate {
    // UI
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if pinnedCount == 0 {
            return ListTableViewSection.memo.description
        } else {
            if section == 0 {
                return ListTableViewSection.pinned.description
            } else {
                return ListTableViewSection.memo.description
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .background
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .text
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // Swipe Gesture
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pinAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            if let cell = self.listView.listTableView.cellForRow(at: indexPath) as? ListTableViewCell {
                if self.pinnedCount > 5 {
                    self.showActionSheet(type: .pin, index: indexPath.row)
                } else {
                    self.pinnedCount += 1
                    print("고정")
                }
            }
            
            success(true)
        }
        pinAction.backgroundColor = .systemOrange
        pinAction.image = UIImage(systemName: "pin.fill")
        
        return UISwipeActionsConfiguration(actions: [pinAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            if let cell = self.listView.listTableView.cellForRow(at: indexPath) as? ListTableViewCell {
                self.showActionSheet(type: .delete, index: indexPath.row)
            }
            success(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WriteViewController()
        viewController.isNew = false
        let backBarButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if pinnedCount == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pinnedCount == 0 {
            return tasks.count
        } else {
            if section == 0 {
                return pinnedCount
            } else {
                return tasks.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        cell.setData(tasks[indexPath.row])
        return cell
    }
}

// MARK: - UISearchBar Protocol

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
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
