//
//  DealyRebateEmptyView.swift
//  FKY
//
//  Created by 寒山 on 2019/2/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class DealyRebateEmptyView: UIView {
    fileprivate var iconImage:UIImageView?
    var mainTitle:UILabel?
    var subTitle:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() -> () {
        self.backgroundColor = RGBColor(0xffffff);
        iconImage = UIImageView()
        self.addSubview(iconImage!)
        iconImage!.image = UIImage.init(named: "empty_money")
        iconImage!.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(FKYWHWith2ptWH(-50))
            make.centerX.equalTo(self.snp.centerX)
            make.width.height.equalTo(FKYWHWith2ptWH(66))
        }
        
        mainTitle = UILabel()
        self.addSubview(mainTitle!)
        
        mainTitle!.snp.makeConstraints { (make) in
            make.top.equalTo(iconImage!.snp.bottom).offset(FKYWHWith2ptWH(10))
            make.centerX.equalTo(self.snp.centerX)
        }
        mainTitle!.font = UIFont.boldSystemFont(ofSize: FKYWHWith2ptWH(15))
        subTitle?.textColor = RGBColor(0x333333);
        mainTitle!.text = "很抱歉"
        
        subTitle = UILabel()
        self.addSubview(subTitle!)
        subTitle?.font = UIFont.systemFont(ofSize: FKYWHWith2ptWH(14))
        subTitle?.textColor = RGBColor(0x414142);
        subTitle?.snp.makeConstraints({ (make) in
            make.top.equalTo(mainTitle!.snp.bottom).offset(FKYWHWith2ptWH(10))
            make.centerX.equalTo(self.snp.centerX)
        })
        subTitle!.text = "您还没有相关记录哦"
    }
    
    func configEmptyView(_ imageString:String?,title:String?,subtitle:String?) {
        self.iconImage?.image = UIImage.init(named: imageString!)
        self.mainTitle?.text = title
        self.subTitle?.text = subtitle
    }
}
