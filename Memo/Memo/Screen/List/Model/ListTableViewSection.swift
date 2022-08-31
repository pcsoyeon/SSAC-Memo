//
//  ListTableViewSection.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import Foundation

enum ListTableViewSection: Int, CustomStringConvertible, CaseIterable {
    case fixed
    case memo
    
    var description: String {
        switch self {
        case .fixed:
            return "고정된 메모"
        case .memo:
            return "메모"
        }
    }
}
