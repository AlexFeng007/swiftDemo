//
//  UITableView+iPhoneX.swift
//  FKY
//
//  Created by Rabe on 21/09/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

import Foundation

extension UITableView {
    @objc func emptyFooterView() {
        var rect = CGRect.zero
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                rect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: iPhoneX_SafeArea_BottomInset)
            }
        }
        let footer = UIView.init(frame: rect)
        footer.backgroundColor = .clear
        self.tableFooterView = footer
    }
}

