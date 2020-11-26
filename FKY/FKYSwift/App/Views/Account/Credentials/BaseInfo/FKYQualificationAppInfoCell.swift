//
//  FKYQualificationAppInfoCell.swift
//  FKY
//
//  Created by airWen on 2017/7/18.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  原资料界面底部信息视图

import UIKit

class FKYQualificationAppInfoCell: UICollectionViewCell {
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelLine1 = UILabel()
        labelLine1.font = UIFont.systemFont(ofSize: WH(13))
        labelLine1.numberOfLines = 1
        labelLine1.textColor = RGBColor(0x666666)
        labelLine1.text = "如有纸质资料变更，请将资料邮寄至："
        self.contentView.addSubview(labelLine1)
        labelLine1.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(WH(16))
            make.top.equalTo(self.contentView.snp.top).offset(WH(16))
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-WH(16))
        }
        
        let labelLine2 = UILabel()
        labelLine2.font = UIFont.systemFont(ofSize: WH(16))
        labelLine2.numberOfLines = 2
        labelLine2.textColor = RGBColor(0x3333333)
        labelLine2.text = "广东省广州市越秀区共和西路1号2层A区"
        self.contentView.addSubview(labelLine2)
        labelLine2.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(WH(16))
            make.top.equalTo(labelLine1.snp.bottom).offset(8)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-WH(16))
        }
        
        let labelLine3 = UILabel()
        labelLine3.font = UIFont.systemFont(ofSize: WH(14))
        labelLine3.numberOfLines = 1
        labelLine3.textColor = RGBColor(0x3333333)
        labelLine3.text = "收件人：苏小宁"
        self.contentView.addSubview(labelLine3)
        labelLine3.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(WH(16))
            make.top.equalTo(labelLine2.snp.bottom).offset(16)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-WH(16))
        }
        
        let labelLine4 = UILabel()
        labelLine4.font = UIFont.systemFont(ofSize: WH(14))
        labelLine4.numberOfLines = 1
        labelLine4.textColor = RGBColor(0x3333333)
        labelLine4.text = "邮编：510000"
        self.contentView.addSubview(labelLine4)
        labelLine4.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(WH(16))
            make.top.equalTo(labelLine3.snp.bottom).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-WH(16))
        }
        
        let labelLine5 = UILabel()
        labelLine5.font = UIFont.systemFont(ofSize: WH(14))
        labelLine5.numberOfLines = 1
        labelLine5.textColor = RGBColor(0x3333333)
        labelLine5.text = "电话：020-62352149"
        self.contentView.addSubview(labelLine5)
        labelLine5.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(WH(16))
            make.top.equalTo(labelLine4.snp.bottom).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-WH(16))
        }
        
        let viewBottom = UIView()
        viewBottom.backgroundColor = RGBColor(0xF2F7FF)
        self.contentView.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leading)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom)
            make.height.equalTo(WH(65))
        }
        
        let labelLine6 = UILabel()
        labelLine6.font = UIFont.systemFont(ofSize: WH(13))
        labelLine6.numberOfLines = 2
        labelLine6.textColor = RGBColor(0x3580FA)
        labelLine6.text = "友情提示：当前我们暂不支持到付邮件，请不要选择到付的方式将资料邮寄，以免产生不必要的收费，谢谢！"
        viewBottom.addSubview(labelLine6)
        labelLine6.snp.makeConstraints { (make) in
            make.leading.equalTo(viewBottom.snp.leading).offset(WH(16))
            make.centerY.equalTo(viewBottom.snp.centerY)
            make.trailing.equalTo(viewBottom.snp.trailing).offset(-WH(16))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
