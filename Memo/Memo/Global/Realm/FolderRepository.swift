//
//  FolderRepository.swift
//  Memo
//
//  Created by 소연 on 2022/10/18.
//

import Foundation

import RealmSwift

protocol FolderRepositoryType {
    func addItem(item: Folder)
    func fetch() -> Results<Folder>
}

class FolderRepository: FolderRepositoryType {
    
    let localRealm = try! Realm()
    
    func addItem(item: Folder) {
        do {
            try localRealm.write {
                localRealm.add(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetch() -> Results<Folder> {
        return localRealm.objects(Folder.self).sorted(byKeyPath: "count", ascending: false)
    }
}
