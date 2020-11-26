//
//  UseShopModel.swift
//  FKY
//
//  Created by zhangxuewen on 2018/3/8.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import SwiftyJSON

final class UseShopModel: NSObject, JSONAbleType {
    var tempEnterpriseId : String?
    var tempEnterpriseName : String?
    
    init(tempEnterpriseId : String?, tempEnterpriseName: String?) {
        self.tempEnterpriseId = tempEnterpriseId
        self.tempEnterpriseName = tempEnterpriseName
    }
    
    @objc static func fromJSON(_ json: [String : AnyObject]) -> UseShopModel {
        let json = JSON(json)
        let tempEnterpriseId = json["tempEnterpriseId"].string
        let tempEnterpriseName = json["tempEnterpriseName"].string
        
        return UseShopModel(tempEnterpriseId: tempEnterpriseId,tempEnterpriseName:tempEnterpriseName)
    }
    
    static func pareDicWithCommonJSON(_ json: [String : AnyObject]) -> UseShopModel {
        let json = JSON(json)
        let tempEnterpriseId = json["enterpriseId"].string
        let tempEnterpriseName = json["enterpriseName"].string
        
        return UseShopModel(tempEnterpriseId: tempEnterpriseId,tempEnterpriseName:tempEnterpriseName)
    }
}
