//
//  FKYDiscountPackageViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/28.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  套餐优惠 优惠套餐 viewmodel

import UIKit
import HandyJSON

class FKYDiscountPackageViewModel: NSObject {
    
    /// 是请求的哪个界面的广告入口
    /// 33订单页面 34 商详 35 本地热销 36满折专区 37 特价专区 38支付完成 必传
    @objc var type:String = ""
    
    /// 套餐优惠model
    @objc var discountPackage:FKYDiscountPackageModel = FKYDiscountPackageModel()
    
}

//MARK: - 网络请求
extension FKYDiscountPackageViewModel {
    
    
    
    /// 获取套餐优惠信息
    @objc func requestDiscountPackageInfo(block:@escaping (_ isSuccess:Bool,_:String)->()){
        /*
        guard self.type.isEmpty == false else {
            block(false,"type为空")
            return
        }
        */
        FKYRequestService.sharedInstance()?.requestPostForDiscountPackageInfo(withParam: ["type":self.type], completionBlock: { [weak self] (success, error, response, model) in
            guard let weakSelf = self else{
                block(false,"")
                return
            }
            
            guard success else{
                block(false,"")
                return
            }
            
            guard let responseDic = response as? [String:Any] else {
                block(false,"")
                return
            }
            
            weakSelf.discountPackage = FKYDiscountPackageModel.deserialize(from: responseDic) ?? FKYDiscountPackageModel()
            block(true,"")
        })
    }
}

//MARK: - 优惠套餐model
class FKYDiscountPackageModel:NSObject,HandyJSON{
    required override init() {}
    
    /// 图片地址
    @objc var imgPath:String = ""
    
    /// 跳转地址
    @objc var jumpInfo:String = ""
    
    /// 名称
    @objc var name:String = ""
    
    /// 标题
    @objc var title:String = ""
    
    /// 类型
    @objc var type:String = ""
    
}
