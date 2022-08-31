//
//  UIView+Extension.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
