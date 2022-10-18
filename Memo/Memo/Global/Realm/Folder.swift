//
//  Folder.swift
//  Memo
//
//  Created by 소연 on 2022/10/18.
//

import Foundation

import RealmSwift

class Folder: Object {
    @Persisted var title: String
    @Persisted var count: Int
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    @Persisted var memoList: List<Folder>
    
    convenience init(title: String, count: Int) {
        self.init()
        self.title = title
        self.count = count
    }
}
