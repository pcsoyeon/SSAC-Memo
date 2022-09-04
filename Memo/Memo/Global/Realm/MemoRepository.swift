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
    
    func fetchPinnedItems() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isPinned == true").sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    func fetchUnPinnedItems() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isPinned == false").sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    func fetchFilter(_ filter: String) -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("memoContent CONTAINS '\(filter)' or memoTitle CONTAINS '\(filter)'")
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
    
    func updateItem(value: Any?) {
        do {
            try localRealm.write {
                localRealm.create(Memo.self, value: value as Any, update: .modified)
                print("Update Realm 성공!")
            }
        } catch let error {
            print(error)
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
