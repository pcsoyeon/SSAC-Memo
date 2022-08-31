//
//  ListTableViewSection.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import Foundation

enum ListTableViewSection: Int, CustomStringConvertible, CaseIterable {
    case pinned
    case memo
    
    var description: String {
        switch self {
        case .pinned:
            return "고정된 메모"
        case .memo:
            return "메모"
        }
    }
}
