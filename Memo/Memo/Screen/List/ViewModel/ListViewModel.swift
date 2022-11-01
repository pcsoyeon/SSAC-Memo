//
//  ListViewModel.swift
//  Memo
//
//  Created by 소연 on 2022/10/29.
//

import Foundation

import RxCocoa
import RxSwift

final class MemoListViewModel {
    private let repository = MemoRepository()
    
    var memo: BehaviorRelay<[[Memo]]> = BehaviorRelay(value: [])
    var memoCount: BehaviorRelay<String> = BehaviorRelay(value: "0개의 메모")
    var isSearching: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

extension MemoListViewModel: CommonViewModel {
    struct Input {
        let searchText: ControlProperty<String?>
        let searchCancelTap: ControlEvent<Void>
    }
    
    struct Output {
        let searchText: ControlProperty<String>
        let searchCancelTap: ControlEvent<Void>
        
        let memo: BehaviorRelay<[[Memo]]>
        let memoCount: BehaviorRelay<String>
    }
    
    func transform(from input: Input) -> Output {
        let searchText = input.searchText.orEmpty
        let searchCancelTap = input.searchCancelTap
        
        return Output(searchText: searchText,
                      searchCancelTap: searchCancelTap,
                      memo: memo,
                      memoCount: memoCount)
    }
}

// MARK: - TableView

extension MemoListViewModel {
    func titleForHeaderInSection(at section: Int, isSearchMode: Bool = false) -> String? {
        
        if memo.value[section].isEmpty {
            return nil
        }
        
        if memo.value.count == 1 {
            return isSearchMode ? "\(memo.value[section].count)개 찾음" : "메모"
            
        } else {
            if section == 0 {
                return memo.value[section].isEmpty ? nil : "고정된 메모"
                
            } else {
                return isSearchMode ? "\(memo.value[section].count)개 찾음" : "메모"
            }
        }
    }
    
    var numberOfSections: Int {
        return memo.value.count
    }
    
    func numberOfRowsInSection(at section: Int) -> Int {
        return memo.value[section].count
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> Memo {
        return memo.value[indexPath.section][indexPath.row]
    }
}

// MARK: - Realm

extension MemoListViewModel {
    func fetchMemo() {
        let allMemo = repository.fetch()
        
        var task: [Memo] = []
        allMemo.forEach { memo in
            task.append(memo)
        }
        
        let pinned = task.filter { $0.isPinned == true }
        let unPinned = task.filter { $0.isPinned == false }
        
        if pinned.count == 0 {
            memo.accept([unPinned])
        } else {
            memo.accept([pinned, unPinned])
        }
        
        memoCount.accept("\(format(for: memo.value.flatMap { $0 }.count))개의 메모")
    }
    
    private func format(for number: Int) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        return numberFormat.string(for: number) ?? ""
    }
    
    func deleteMemo(indexPath: IndexPath) {
        let memo = memo.value[indexPath.section][indexPath.row]
        repository.delete(memo)
        fetchMemo()
    }
    
    func pinMemo(indexPath: IndexPath, handler: @escaping () -> Void) {
        let memo = memo.value[indexPath.section][indexPath.row]
        
        let pinned = self.memo.value.flatMap { $0 }.filter { $0.isPinned == true }

        if memo.isPinned {
            repository.update(memo) { memo in
                memo.isPinned.toggle()
            }
        } else {
            if pinned.count >= 5 {
                handler()
            } else {
                repository.update(memo) { memo in
                    memo.isPinned.toggle()
                }
            }
        }
        
        fetchMemo()
    }
    
    func searchMemo(by keyword: String) {
        let allMemo = repository.search(by: keyword)
        
        var task: [Memo] = []
        allMemo.forEach { memo in
            task.append(memo)
        }
        
        memo.accept([task])
    }
}
