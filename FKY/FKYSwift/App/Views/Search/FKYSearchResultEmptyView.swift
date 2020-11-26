//
//  FKYSearchResultEmptyView.swift
//  FKY
//
//  Created by mahui on 16/8/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit

@objc
enum FKYSearchResultEmptyViewType : NSInteger {
    case product
    case shop
    case factory
}

class FKYCommonEmptyView: UIView {
    
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
    
    var emptyType : FKYSearchResultEmptyViewType{
        get{
            return self.emptyType
        }
        set(newValue){
            if newValue ==  FKYSearchResultEmptyViewType.product{
                subTitle?.text = "您所在的省份暂无供应商销售此商品"
            }
            if newValue ==  FKYSearchResultEmptyViewType.shop {
                subTitle?.text = "没有为您找到相关店铺"
            }
            if newValue ==  FKYSearchResultEmptyViewType.factory {
                subTitle?.text = "没有为您找到相关厂家"
            }
        }
    }
    
    func setupView() -> () {
        self.backgroundColor = RGBColor(0xf3f3f3);
        iconImage = UIImageView()
        self.addSubview(iconImage!)
        iconImage!.image = UIImage.init(named: "empty_search")
        iconImage!.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(FKYWHWith2ptWH(-20))
            make.centerX.equalTo(self.snp.centerX)
            make.width.height.equalTo(FKYWHWith2ptWH(66))
        }
        
        mainTitle = UILabel()
        self.addSubview(mainTitle!)
        
        mainTitle!.snp.makeConstraints { (make) in
            make.top.equalTo(iconImage!.snp.bottom).offset(FKYWHWith2ptWH(10))
            make.centerX.equalTo(self.snp.centerX)
        }
        mainTitle!.font = UIFont.systemFont(ofSize: FKYWHWith2ptWH(18))
        mainTitle!.text = "很抱歉"

        subTitle = UILabel()
        self.addSubview(subTitle!)
        subTitle?.font = UIFont.systemFont(ofSize: FKYWHWith2ptWH(14))
        subTitle?.snp.makeConstraints({ (make) in
            make.top.equalTo(mainTitle!.snp.bottom).offset(FKYWHWith2ptWH(10))
            make.centerX.equalTo(self.snp.centerX)
        })
        subTitle!.text = "没有为您找到相关商品"
    }
    
    func configEmptyView(_ imageString:String?,title:String?,subtitle:String?) {
        self.iconImage?.image = UIImage.init(named: imageString!)
        self.mainTitle?.text = title
        self.subTitle?.text = subtitle
    }
}
