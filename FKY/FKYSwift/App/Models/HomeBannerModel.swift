//
//  HomeBannerModel.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SwiftyJSON

final class HomeBannerModel: NSObject,JSONAbleType {
    let imgUrl: String?
    let schema: String?
    
    init(imgUrl: String?, schema: String?) {
        self.imgUrl = imgUrl
        self.schema = schema
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeBannerModel {
        let j = JSON(json)
        let imgUrl = j["imgUrl"].string
        let schema = j["schema"].string
        return HomeBannerModel(imgUrl: imgUrl, schema: schema)
    }
}
