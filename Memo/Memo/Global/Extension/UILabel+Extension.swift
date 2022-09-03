//
//  UILabel+Extension.swift
//  Memo
//
//  Created by 소연 on 2022/09/03.
//

import UIKit

extension UILabel {
    func setHighlighted(_ text: String, with search: String, font: UIFont) {
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSString(string: text).range(of: search, options: .caseInsensitive)
        let highlightFont = font
        let highlightColor = UIColor.systemOrange
        let highlightedAttributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.font: highlightFont, NSAttributedString.Key.foregroundColor: highlightColor]
        
        attributedText.addAttributes(highlightedAttributes, range: range)
        self.attributedText = attributedText
    }
}
