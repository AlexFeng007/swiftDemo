//
//  HomeCategoryTypeModel.swift
//  FKY
//
//  Created by Rabe on 13/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import SwiftyJSON

final class HomeCategoryTypeModel: NSObject, JSONAbleType {
    // MARK: - properties
    var catagoryId: String?
    var catagoryName: String?
    
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> HomeCategoryTypeModel {
        let json = JSON(json)
        
        let catagoryId = json["catagoryId"].stringValue
        let catagoryName = json["catagoryName"].stringValue
        return HomeCategoryTypeModel(catagoryId: catagoryId, catagoryName: catagoryName)
    }
    
    init(catagoryId: String?, catagoryName: String?) {
        super.init()
        self.catagoryId = catagoryId
        self.catagoryName = catagoryName
    }
}
