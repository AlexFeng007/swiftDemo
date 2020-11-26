//
//  UITableViewCell+AddSubView.swift
//  FKY
//
//  Created by 寒山 on 2020/9/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

extension UITableViewCell{
    open override func addSubview(_ view: UIView) {
        if view == contentView {
            super.addSubview(view)
            return
        }
        contentView.addSubview(view)
    }
}
extension UICollectionViewCell{
    open override func addSubview(_ view: UIView) {
        if view == contentView {
            super.addSubview(view)
            return
        }
        contentView.addSubview(view)
    }
}
 
