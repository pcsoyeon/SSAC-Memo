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
    @Persisted var memoInfo: String
    @Persisted var count: Int
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted(originProperty: "memo") var folder: LinkingObjects<Folder>
    
    convenience init(memoTitle: String, memoContent: String?, memoDate: Date, isPinned: Bool = false) {
        self.init()
        self.memoTitle = memoTitle
        self.memoContent = memoContent
        self.memoDate = memoDate
        self.isPinned = isPinned
    }
}
