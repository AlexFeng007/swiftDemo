//
//  HotSaleHeaderModel.swift
//  FKY
//
//  Created by Rabe on 27/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - HotSaleHeaderModel 对象
final class HotSaleHeaderModel: NSObject, JSONAbleType {
    
    // MARK: - properties
    var catgoryName : String?
    var catgoryCode : String?
    
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> HotSaleHeaderModel {
        let json = JSON(json)
        
        let catgoryName = json["catgoryName"].stringValue
        let catgoryCode = json["catgoryCode"].stringValue
        return HotSaleHeaderModel(catgoryName: catgoryName, catgoryCode: catgoryCode)
    }
    
    init(catgoryName: String?, catgoryCode: String?) {
        self.catgoryName = catgoryName
        self.catgoryCode = catgoryCode
    }
}
