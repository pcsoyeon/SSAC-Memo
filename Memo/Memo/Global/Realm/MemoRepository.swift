//
//  MemoRepository.swift
//  Memo
//
//  Created by 소연 on 2022/09/02.
//

import Foundation

import RealmSwift

protocol MemoRepositoryType {
    func addItem(item: Memo)
    func fetch() -> Results<Memo>
    func fetchFilter(_ filter: String) -> Results<Memo>
    func updatePinned(item: Memo)
    func deleteItem(item: Memo)
}

class MemoRepository: MemoRepositoryType {
    
    let localRealm = try! Realm()
    
    func addItem(item: Memo) {
        do {
            try localRealm.write {
                localRealm.add(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetch() -> Results<Memo> {
        return localRealm.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    func fetchFilter(_ filter: String) -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("memoContent CONTAINS '\(filter)'")
    }
    
    func updatePinned(item: Memo) {
        do {
            try localRealm.write {
                item.isPinned.toggle()
            }
        } catch {
            print("ERROR")
        }
    }
    
    func deleteItem(item: Memo) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
            
        } catch {
            print("ERROR")
        }
    }
}
