//
//  FKYReasonHandler.swift
//  FKY
//
//  Created by My on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit


@objc class FKYReasonHandler: NSObject {
    
    //过滤取消原因
    @objc class func filterReasons(_ response: [String: AnyObject]?) -> [FKYOrderResonModel]? {
        guard let reasonsDic = response, reasonsDic.count > 0 else {
            return nil
        }
        var reasonsArray  = [FKYOrderResonModel]()
        for (key, value) in reasonsDic {
            if StringValue(value) != "" {
                let reasonModel = FKYOrderResonModel()
                reasonModel.reason = StringValue(value)
                reasonModel.type = Int(key)
                reasonsArray.append(reasonModel)
            }
        }
        
        return reasonsArray.sorted(by: {
            $0.type! <= $1.type!
        })
    }
}
