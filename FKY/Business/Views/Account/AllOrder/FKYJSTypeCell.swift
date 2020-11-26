//
//  FKYJSTypeCell.swift
//  FKY
//
//  Created by mahui on 16/9/20.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

@objc
enum FKYJSTypeCellType : NSInteger {
    case js
    case bh
}

typealias CellIsSelelcted = (_ isselected : Bool)->()

class FKYJSTypeCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        cellIsSelected = {(isSelected) in
            if isSelected {
                self.icon?.image = UIImage.init(named: "icon_order_selected")
            }else{
                self.icon?.image = UIImage.init(named: "icon_order_unselected")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var title : UILabel?
    fileprivate var icon : UIImageView?
    @objc var cellIsSelected : CellIsSelelcted?
    
    func setupView() -> () {
        title = {
            let v = UILabel()
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(WH(j1))
                make.centerY.equalTo(self.contentView)
            })
            v.font = t9.font
            v.textColor = t9.color
            return v
        }()
        
        icon = {
            let v = UIImageView()
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView.snp.right).offset(WH(-j1))
                make.centerY.equalTo(self.contentView)
                make.height.width.equalTo(WH(16))
            })
            v.image = UIImage.init(named: "icon_order_unselected")
            return v
        }()
        
        let line = UIView()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(j1)
            make.right.equalTo(self.contentView).offset(-j1)
            make.bottom.equalTo(self.contentView.snp.bottom)
            make.height.equalTo(WH(0.5))
        }
        line.backgroundColor = m2
    }
    
    @objc func configCellWithTypw(_ type : FKYJSTypeCellType) -> () {
        if type == .bh {
            title?.text = "申请补货"
        }else{
            title?.text = "申请拒收"
        }
    }
}

