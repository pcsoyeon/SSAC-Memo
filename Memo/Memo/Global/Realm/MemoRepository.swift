//
//  MemoRepository.swift
//  Memo
//
//  Created by 소연 on 2022/09/02.
//

import Foundation

import RealmSwift

protocol MemoRepositoryType {
    var count: Int { get }
    
    func printLocationOfDefaultRealm()
    func write(_ memo: Memo)
    func fetch() -> Results<Memo>
    func search(by keyword: String) -> Results<Memo>
    func update(_ memo: Memo, completion: ((Memo) -> Void)?)
    func delete(_ memo: Memo)
    func sort(by keyPath: String) -> Results<Memo>
}

class MemoRepository: MemoRepositoryType {
    private var database = try! Realm()
    
    var count: Int {
        return database.objects(Memo.self).count
    }
    
    func printLocationOfDefaultRealm() {
        guard let location = database.configuration.fileURL else { return }
        print(location)
    }
    
    func write(_ memo: Memo) {
        do {
            try database.write {
                database.add(memo)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetch() -> Results<Memo> {
        return database.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    func search(by keyword: String) -> Results<Memo> {
        return database.objects(Memo.self).where {
            ($0.memoTitle.contains(keyword)) || ($0.memoContent.contains(keyword))
        }
    }
    
    func update(_ memo: Any?) {
        do {
            try database.write {
                database.create(Memo.self, value: memo as Any, update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    
    func update(_ memo: Memo, completion: ((Memo) -> Void)?) {
        do {
            try database.write {
                completion?(memo)
            }
        } catch let error {
            print(error)
        }
    }
    
    func delete(_ memo: Memo) {
        do {
            try database.write {
                return database.delete(memo)
            }
        } catch let error {
            print(error)
        }
    }
    
    func sort(by keyPath: String = "memoDate") -> Results<Memo> {
        return database.objects(Memo.self).sorted(byKeyPath: keyPath, ascending: false)
    }
}
