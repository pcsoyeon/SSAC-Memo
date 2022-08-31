//
//  UIViewController+Extension.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

extension UIViewController {
    func checkAppearance(_ viewController: UIViewController) {
        guard let appearance = UserDefaults.standard.string(forKey: Constant.UserDefaults.Appearance) else { return }
        if appearance == "Dark" {
            viewController.overrideUserInterfaceStyle = .dark
            if #available(iOS 13.0, *) {
                UIApplication.shared.statusBarStyle = .lightContent
            } else {
                UIApplication.shared.statusBarStyle = .default
            }
        } else {
            viewController.overrideUserInterfaceStyle = .light
            if #available(iOS 13.0, *) {
                UIApplication.shared.statusBarStyle = .darkContent
            } else {
                UIApplication.shared.statusBarStyle = .default
            }
        }
    }
}
