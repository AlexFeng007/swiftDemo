//
//  FKYCouponDicModel.swift
//  FKY
//
//  Created by yyc on 2020/2/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYCouponDicModel: NSObject {
    var sellerCode: Int? //选择优惠卷的当前卖家id
    var platformCouponFlag: Bool? //是否操作选择平台卷
    var platformCouponCode: String? //平台卷编码
    var couponDTOList : [SingleShopCouponDTO]? //每个店铺下的优惠卷选择情况
    func getJson() -> NSMutableDictionary {
        let mutableDic = NSMutableDictionary()
        if let sellerId = self.sellerCode {
            mutableDic["sellerCode"] = sellerId
        }
        mutableDic["platformCouponFlag"] = self.platformCouponFlag == true ? "true" : "false"
        mutableDic["platformCouponCode"] = self.platformCouponCode
        
        if let arr = self.couponDTOList,arr.count > 0 {
            var desArr = [NSMutableDictionary]()
            for couponModel in arr {
                let dic = NSMutableDictionary()
                dic["sellerCode"] = couponModel.sellerCode
                dic["couponCodeList"] = couponModel.couponCodeList
                desArr.append(dic)
            }
            mutableDic["couponDTOList"] = desArr
        }
        //分享者ID
        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
            mutableDic["shareUserId"] = cpsbd
        }
        return mutableDic
    }
}
class SingleShopCouponDTO: NSObject {
    var sellerCode: Int? //选择优惠卷的当前卖家id
    var couponCodeList: [String]? //是否操作选择平台卷
}
