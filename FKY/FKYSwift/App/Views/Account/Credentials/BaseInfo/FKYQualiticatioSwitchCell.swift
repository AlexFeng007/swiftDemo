//
//  FKYQualiticatioSwitchCell.swift
//  FKY
//
//  Created by airWen on 2017/7/19.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  上传资质之“是否三证合一”ccell

import UIKit

class FKYQualiticatioSwitchCell: UICollectionViewCell {
    var switchButton = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isClick = false
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var isClick : Bool?
    var isSelectedStatus : commonClosure?
    
    func setupView() -> () {
        contentView.backgroundColor = .white
        let label = UILabel()
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(WH(18))
            make.centerY.equalTo(self)
        }
        label.text = "是否三证合一"
        label.font = t9.font
        label.textColor = t9.color
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xeeeeee)
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.right.bottom.equalTo(contentView)
            make.left.equalTo(label)
        }
        
        switchButton.onTintColor = RGBColor(0xFE5050)
        switchButton.addTarget(self, action: #selector(switchDidChange), for:.valueChanged)
        self.contentView.addSubview(switchButton)
        switchButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView.snp.right).offset(-j1)
            make.centerY.equalTo(contentView)
        }
    }
    
    @objc func switchDidChange() {
        self.isClick = self.switchButton.isOn;
        if self.isSelectedStatus != nil{
            self.isSelectedStatus!(self.isClick!)
        }
    }
    
    func configCell(_ is3merge1 : Bool) {
        if is3merge1 == false {
            self.isClick = false
        }else{
            self.isClick = true
        }
        self.switchButton.isOn = self.isClick!
    }
}
