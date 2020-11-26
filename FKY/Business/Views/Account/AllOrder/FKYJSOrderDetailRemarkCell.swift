//
//  FKYJSOrderDetailRemarkCell.swift
//  FKY
//
//  Created by mahui on 16/9/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit


@objc
enum FKYJSOrderDetailRemarkCellType : NSInteger{
    case reason
    case answer
}

class FKYJSOrderDetailRemarkCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var title : UILabel?
    fileprivate var subTitle : UILabel?
    
    fileprivate func setupView() -> (){
        let line = UIView()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(j1)
            make.right.equalTo(self.contentView).offset(j1)
            make.height.equalTo(FKYWHWith2ptWH(0.5))
            make.top.equalTo(self.contentView).offset(FKYWHWith2ptWH(40));
        }
        line.backgroundColor = m2;
        
        title = {
            let label = UILabel()
            self.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(j1)
                make.right.equalTo(self.contentView).offset(j1)
                make.bottom.equalTo(line.snp.top)
                make.top.equalTo(self.contentView)
            })
            label.textColor = t9.color
            label.font = t9.font
            return label
        }()
        
        subTitle = {
            let label = UILabel()
            self.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(j1)
                make.right.equalTo(self.contentView).offset(j1)
                make.top.equalTo(line.snp.bottom)
                make.bottom.equalTo(self.contentView)
            })
            label.textColor = t23.color
            label.font = t23.font
            label.numberOfLines = 0
            return label
        }()
    }
    
    @objc func configCellWithText(_ model : FKYOrderModel, type : FKYJSOrderDetailRemarkCellType) -> () {
        if type == .reason {
            title?.text = "申请原因"
            subTitle?.text = "\(model.returnDesc ?? "")"

        }else{
            title?.text = "商家回复"
            subTitle?.text = model.merchantDesc ?? ""
        }
    }
}
