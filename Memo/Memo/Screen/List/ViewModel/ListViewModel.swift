//
//  ListViewModel.swift
//  Memo
//
//  Created by 소연 on 2022/10/29.
//

import Foundation

import RxCocoa
import RxSwift

final class ListViewModel {
    private let repository = MemoRepository()
    
    var memo: CObservable<[Memo]> = CObservable([])
    
    var pinnedList = CObservable<[Memo]>([])
    var unPinnedList = CObservable<[Memo]>([])
    
    var totalMemoCount = CObservable<Int>(0)
    var searchedMemoCount = CObservable<Int>(0)
    
    var isSearching = CObservable(false)
    var searchKeyword = CObservable("")
}

// MARK: - TableView

extension ListViewModel {
    
    func titleForHeaderInSection(at section: Int) -> String? {
        if isSearching.value {
            return "\(searchedMemoCount.value)개 찾음"
        } else {
            return pinnedList.value.isEmpty ? ListTableViewSection.memo.description : (section == 0 ? ListTableViewSection.pinned.description : ListTableViewSection.memo.description)
        }
    }
    
    var heightForHeaderInSection: CGFloat {
        return 40
    }
    
    var heightForFooterInSection: CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    

}

// MARK: - Realm
