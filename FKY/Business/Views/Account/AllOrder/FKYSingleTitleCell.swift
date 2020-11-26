//
//  FKYSingleTitleCell.swift
//  FKY
//
//  Created by mahui on 16/9/12.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit

@objc
enum FKYSingleTitleCellType : NSInteger {
    case factory
    case logisticsId
    case cancleTime
    case cancleReason
    case personName
    case receiveTime
    case telephone

}

class FKYSingleTitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   fileprivate var title : UILabel?
    var cellType : FKYSingleTitleCellType?
    
    fileprivate func setupView() -> () {
        title = {
            let label = UILabel()
            self.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(j1)
                make.right.equalTo(self.snp.right).offset(-j1)
                make.centerY.equalTo(self.snp.centerY)
            })
            label.textColor = t9.color
            label.font = t9.font
            return label
        }()
    }
    
    @objc func configCellWithText(_ text : String, cellType : FKYSingleTitleCellType) -> () {
        switch cellType {
        case .factory:
            title?.text = "运输公司: " + text
        case .logisticsId:
            title?.text = "物流单号: " + text
        case .cancleTime:
            title?.text = "取消时间: " + text
        case .cancleReason:
            title?.text = "取消原因: " + text
        case .personName:
            title?.text = "联系人: " + text
        case .telephone:
            title?.text = "联系电话: " + text
        default:
            title?.text = "预计送达时间: " + text
        }
    }
}
