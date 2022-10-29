//
//  WriteViewModel.swift
//  Memo
//
//  Created by 소연 on 2022/10/29.
//

import Foundation

import RxCocoa
import RxSwift

final class WriteViewModel {
    private let repository = MemoRepository()
    
    var isNew: CObservable<Bool> = CObservable(true)
    var memo: CObservable<Memo> = CObservable(Memo(memoTitle: "", memoContent: "", memoDate: Date()))
}

extension WriteViewModel {
    func write(_ memo: Memo) {
        repository.write(memo)
    }
    
    func update(_ memo: Memo, newTitle: String, newContent: String?) {
        repository.update(memo) { memo in
            memo.memoTitle = newTitle
            memo.memoContent = newContent
        }
    }
    
    func deleteMemo(_ memo: Memo) {
        repository.delete(memo)
    }
}

