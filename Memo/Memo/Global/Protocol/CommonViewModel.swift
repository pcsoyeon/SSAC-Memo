//
//  CommonViewModel.swift
//  Memo
//
//  Created by 소연 on 2022/11/01.
//

import Foundation

protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input) -> Output
}
