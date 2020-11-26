//
//  FKYTogeterSearchNoDataView.swift
//  FKY
//
//  Created by hui on 2019/1/4.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterSearchNoDataView: UIView {
    fileprivate lazy var iconImageView : UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "empty_search")
        return img
    }()
    
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t16
        label.numberOfLines = 0
        label.text = "抱歉，没有找到相关商品\n请换个商品名重新试一下"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(WH(88))
            make.width.height.equalTo(WH(80))
        }
        self.addSubview(self.tipLabel)
        self.tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(WH(21))
            make.height.equalTo(WH(40))
            make.width.equalTo(WH(154))
        }
    }
    
}
