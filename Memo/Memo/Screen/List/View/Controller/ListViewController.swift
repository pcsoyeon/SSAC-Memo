//
//  ViewController.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift
import SnapKit
import Then

final class ListViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private var rootView = ListView()
    
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "검색"
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
        $0.searchBar.tintColor = .systemOrange
    }
    
    // MARK: - Property
    
    private let viewModel = MemoListViewModel()
    private let disposeBag = DisposeBag()
    
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
        rootView.tableView.sectionHeaderHeight = 50
        
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
}

extension ListViewController {
    private func bind() {
        viewModel.memo
            .withUnretained(self)
            .bind { vc, _ in
                vc.rootView.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.memoCount
            .bind { countString in
                self.navigationItem.title = countString
            }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .withUnretained(self)
            .bind { vc, value in
                vc.viewModel.fetchMemo()
            }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .withUnretained(self)
            .bind { vc, value in
                if value == "" { return }
                vc.viewModel.searchMemo(by: value)
            }
            .disposed(by: disposeBag)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let writeViewController = WriteViewController()
        let memo = viewModel.memo.value[indexPath.section][indexPath.row]
        writeViewController.viewModel.memo.accept(memo)
        writeViewController.viewModel.isNew.accept(false)
        self.navigationController?.pushViewController(writeViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHaldler in
            self.viewModel.pinMemo(indexPath: indexPath) {
                self.presentAlert(title: "메모는 최대 5개까지 고정할 수 있어요!")
            }
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

// MARK: - Custom Delegate

extension ListViewController: ListViewDelegate {
    func touchUpWriteButton() {
        let viewController = WriteViewController()
        viewController.viewModel.isNew.accept(true)
        
        let backBarButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(viewController, animated: true)
    }
}
