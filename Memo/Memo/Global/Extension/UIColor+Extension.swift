//
//  UIColor+Extension.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

enum Color: String {
    case background = "BackgroundColor"
    case foreground = "ForegroundColor"
    case orange = "OrangeColor"
    case text = "TextColor"
}

extension UIColor {
    static func colorSet(_ colorRawValue: Color) -> UIColor {
        var color: UIColor = .black
        color = UIColor(named: colorRawValue.rawValue)!
        return color
    }
}
