//
//  ShopArrivalProvider.swift
//  FKY
//
//  Created by 路海涛 on 2017/4/14.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class ShopArrivalProvider: NSObject {
    fileprivate lazy var publicService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    override  init() {
        //
    }
    
    func submitArrivalInfo(_ spu:String, sellerCode:String, phoneNumber:String, numberInput:String, callback:@escaping (_ dic : String)->(),failCallback:@escaping ()->()){

        let dic = ["spuCode":spu,
                   "sellerCode":sellerCode,
                   "phoneNumber":phoneNumber,
                   "buyAmount":numberInput] as [String : Any]

        _ = self.publicService?.addArrivalNoticeBlock(withParam: dic, completionBlock: {(responseObject, anError)  in
            if anError == nil && responseObject != nil {
                callback(responseObject as! String)
            }
            else {
                if let errorUserInfo : String = ((anError as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    callback(errorUserInfo)
                }
                else {
                    failCallback()
                }
            }
        })
    }
}
