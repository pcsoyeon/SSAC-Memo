//
//  CObservable.swift
//  Memo
//
//  Created by 소연 on 2022/10/29.
//

import Foundation

final class CObservable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ completion: @escaping((T) -> Void)) {
        completion(value)
        listener = completion
    }
}
