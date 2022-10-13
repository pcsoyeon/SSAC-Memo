//
//  Memo.swift
//  Memo
//
//  Created by 소연 on 2022/09/02.
//

import Foundation

import RealmSwift

class Memo: Object {
    @Persisted var memoTitle: String
    @Persisted var memoContent: String?
    @Persisted var memoDate = Date()
    @Persisted var isPinned: Bool
    
    @Persisted var isFavortie: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(memoTitle: String, memoContent: String?, memoDate: Date, isPinned: Bool = false) {
        self.init()
        self.memoTitle = memoTitle
        self.memoContent = memoContent
        self.memoDate = memoDate
        self.isPinned = isPinned
    }
}
