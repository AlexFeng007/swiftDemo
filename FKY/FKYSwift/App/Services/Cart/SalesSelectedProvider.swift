//
//  SalesSelectedProvider.swift
//  FKY
//
//  Created by mahui on 2016/11/14.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation

class SalesSelectedProvider: NSObject {
    var salesList = NSMutableArray()
    
    fileprivate lazy var publicService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    override init() {
        //
    }
    
    func salesListWithVenderId(_ venderId:String, callback:@escaping (_ salesList : NSArray)->()) {
        let dic = ["enterpriseId": venderId]
        _ = self.publicService?.getListAdviserBlock(withParam:dic, completionBlock: {(responseObject, anError)  in
            self.salesList.removeAllObjects()
            if anError == nil {
                if let data = responseObject as? NSDictionary  {
                    if let adviserList = data.value(forKeyPath: "adviserList") as? NSArray, let aryAdviserList = adviserList.mapToObjectArray(SalesModel.self) {
                        self.salesList.addObjects(from: aryAdviserList)
                    }
                }
            }
            else {
                if let err = anError {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        FKYAppDelegate!.showToast("用户登录过期, 请手动重新登录")
                    }
                }
            }
            callback(self.salesList)
        })
    }
}

