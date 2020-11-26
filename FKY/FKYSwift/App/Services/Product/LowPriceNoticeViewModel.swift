//
//  LowPriceNoticeViewModel.swift
//  FKY
//
//  Created by 寒山 on 2020/3/12.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LowPriceNoticeViewModel: NSObject {
    var produdModel:FKYProductObject?//商品信息
    // 预期价格
    var lowPrice: String?
    
    // 用户电话
    var userPhoneNum: String = (UserDefaults.standard.object(forKey: "user_mobile") ?? "") as! String
    
    // tableview结构数组...
    var cellTypeList: [PDLowPriceTextInputType]{
        get {
            // cell数组
            return [PDLowPriceTextInputType.lowPriceInfoType
                ,PDLowPriceTextInputType.userPhoneType]
            
        }
    }
    // 获取各cell的文本内容
    func getCellValue(_ type: PDLowPriceTextInputType) -> String? {
        switch type {
        case .lowPriceInfoType:
            //
            return lowPrice
        case .userPhoneType:
            //
            return userPhoneNum
        }
    }
    
    // 保存各cell的文本内容
    func setCellValue(_ type: PDLowPriceTextInputType, _ txt: String?) {
        switch type {
        case .lowPriceInfoType:
            //
            lowPrice = txt
        case .userPhoneType:
            //
            userPhoneNum = txt ?? ""
        }
    }
    //提交低价信息
    func postLowPriceInfo(block: @escaping (Bool, String?)->()) {
        // 传参
        let dic = NSMutableDictionary()
        dic["buyPrice"] =  lowPrice
        if let promotionNum =  self.produdModel?.productPromotion?.promotionPrice , promotionNum.floatValue > 0  {
             //会员
             dic["currentPrice"] = promotionNum
        }else if let pVip = self.produdModel?.vipPromotionInfo,let _ = pVip.vipPromotionId,let _ = pVip.visibleVipPrice, let vipNum = Float(pVip.visibleVipPrice), vipNum > 0 {
            if let vipAvailableNum = Float(pVip.availableVipPrice) ,vipAvailableNum > 0 {
                //会员
                dic["currentPrice"] = vipAvailableNum
            }else{
                dic["currentPrice"] = self.produdModel?.priceInfo.price ?? 0
            }
        }else{
            dic["currentPrice"] = self.produdModel?.priceInfo.price ?? 0
        }
        dic["phoneNumber"] = userPhoneNum

        if let recommendModel = self.produdModel?.recommendModel,let enterpriseInfo = recommendModel.enterpriseInfo{
            dic["sellerCode"] =  enterpriseInfo.enterpriseId
        }else{
            dic["sellerCode"] = self.produdModel?.sellerCode
        }
        dic["spuCode"] = self.produdModel?.spuCode
        
        FKYRequestService.sharedInstance()?.postLowPriceInfo(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                block(false, "提交失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "提交失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            // 请求成功
             block(true, "提交成功")
        })
    }
}
