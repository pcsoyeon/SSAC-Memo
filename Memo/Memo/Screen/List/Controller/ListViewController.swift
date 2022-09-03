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
        $0.searchBar.placeholder = "검색"
        $0.searchBar.delegate = self
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
        $0.searchBar.tintColor = .systemOrange
    }
    
    // MARK: - Property
    
    private var totalCount: Int = 0 {
        didSet {
            title = "\(format(for: totalCount))개의 메모"
        }
    }
    
    private var pinnedList: [Memo] = []
    private var unPinnedList: [Memo] = []
    
    private let repository = MemoRepository()
    
    private var tasks: Results<Memo>! {
        didSet {
            totalCount = tasks.count
            var pinned: [Memo] = []
            var unPinned: [Memo] = []

            for item in tasks {
                if item.isPinned {
                    pinned.append(item)
                } else {
                    unPinned.append(item)
                }
            }

            self.pinnedList = pinned
            self.unPinnedList = unPinned

            listView.listTableView.reloadData()
        }
    }
    
    private var isSearching: Bool = false {
        didSet {
            if isSearching == false { listView.listTableView.reloadData() }
        }
    }
    private var searchedItemCount: Int = 0
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentWalkThrough()
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
    }
    
    private func configureTableView() {
        listView.listTableView.delegate = self
        listView.listTableView.dataSource = self
        
        listView.listTableView.rowHeight = 80
        
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        listView.listTableView.keyboardDismissMode = .onDrag
    }
    
    private func configureButton() {
        listView.delegate = self
    }
    
    // MARK: - Custom Method
    
    private func presentWalkThrough() {
        let viewController = WalkThroughViewController()
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
    
    private func showActionSheet(type: AlertType, index: Int, section: Int = 0) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let pinAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            if section == 0 {
                self.repository.deleteItem(item: self.pinnedList[index])
            } else {
                self.repository.deleteItem(item: self.unPinnedList[index])
            }
            
            self.fetchRealmData()
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
        isSearching = false
        tasks = repository.fetch()
    }
}

// MARK: - UITableView Protocol

extension ListViewController: UITableViewDelegate {
    
    // MARK: - Header UI
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return "\(searchedItemCount)개 찾음"
        } else {
            if pinnedList.count == 0 {
                return ListTableViewSection.memo.description
            } else {
                if section == 0 {
                    return ListTableViewSection.pinned.description
                } else {
                    return ListTableViewSection.memo.description
                }
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
    
    // MARK: - Swipe Gesture
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pinAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            if self.isSearching {
                if self.pinnedList.count >= 5 {
                    self.showActionSheet(type: .pin, index: indexPath.row)
                } else {
                    self.repository.updatePinned(item: self.tasks[indexPath.row])
                }
            } else {
                if self.pinnedList.count >= 5 {
                    if indexPath.section == 0 {
                        self.repository.updatePinned(item: self.pinnedList[indexPath.row])
                    } else {
                        self.showActionSheet(type: .pin, index: indexPath.row)
                    }
                } else {
                    if self.pinnedList.count == 0 {
                        self.repository.updatePinned(item: self.unPinnedList[indexPath.row])
                    } else {
                        if indexPath.section == 0 {
                            self.repository.updatePinned(item: self.pinnedList[indexPath.row])
                        } else {
                            self.repository.updatePinned(item: self.unPinnedList[indexPath.row])
                        }
                    }
                }
            }
            
            self.fetchRealmData()
            success(true)
        }
        pinAction.backgroundColor = .systemOrange
        
        if isSearching {
            pinAction.image = tasks[indexPath.row].isPinned ? UIImage(systemName: "pin.slash.fill") : UIImage(systemName: "pin.fill")
        } else {
            if self.pinnedList.count == 0 {
                pinAction.image = UIImage(systemName: "pin.fill")
            } else {
                if indexPath.section == 0 {
                    pinAction.image = UIImage(systemName: "pin.slash.fill")
                } else {
                    pinAction.image = UIImage(systemName: "pin.fill")
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [pinAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            if indexPath.section == 0 {
                self.showActionSheet(type: .delete, index: indexPath.row, section: 0)
            } else {
                self.showActionSheet(type: .delete, index: indexPath.row, section: 1)
            }
            
            success(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // MARK: - Tap
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WriteViewController()
        viewController.isNew = false
        
        if isSearching {
            viewController.memo = tasks[indexPath.row]
        } else {
            if pinnedList.count == 0 {
                viewController.memo = unPinnedList[indexPath.row]
            } else {
                if indexPath.section == 0 {
                    viewController.memo = pinnedList[indexPath.row]
                } else {
                    viewController.memo = unPinnedList[indexPath.row]
                }
            }
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            if pinnedList.count == 0 {
                return 1
            } else {
                return 2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return tasks.count
        } else {
            if pinnedList.count == 0 {
                return unPinnedList.count
            } else {
                if section == 0 {
                    return pinnedList.count
                } else {
                    return unPinnedList.count
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        if isSearching {
            cell.setData(tasks[indexPath.row])
        } else {
            if pinnedList.count == 0 {
                cell.setData(unPinnedList[indexPath.row])
            } else {
                if indexPath.section == 0 {
                    cell.setData(pinnedList[indexPath.row])
                } else {
                    cell.setData(unPinnedList[indexPath.row])
                }
            }
        }
       
        return cell
    }
}

// MARK: - UISearchBar Protocol

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        isSearching = true
        guard let text = searchController.searchBar.text else { return }
        tasks = repository.fetchFilter(text)
        searchedItemCount = tasks.count
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchRealmData()
        isSearching = false
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
