//
//  SeckillTabModel.swift
//  FKY
//
//  Created by Andy on 2018/11/24.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

//"data": [{
//"activityIcon": "",
//"beginTime": 1541827724000,
//"currentTime": 1543044399695,
//"endTime": 1543507200000,
//"id": 879,
//"imgPath": "http://p8.maiyaole.com/fky/img/1542360002436.jpg",
//"sessionName": "1",
//"siteCode": "420000",
//"status": "1"
//}, {
//"activityIcon": "",
//"beginTime": 1541827724000,
//"currentTime": 1543044399695,
//"endTime": 1543507200000,
//"id": 880,
//"imgPath": "http://p8.maiyaole.com/fky/img/1542360002436.jpg",
//"sessionName": "1",
//"siteCode": "420000",
//"status": "1"
//}],

import UIKit
import SwiftyJSON

final class SeckillTabModel: NSObject, JSONAbleType {
    // 接口返回字段
    var activityIcon: String?
    var beginTime: String?
    var currentTime: String?      //
    var endTime: String?
    var id: String?
    var imgPath: String?
    var sessionName : String?
    var siteCode : String?
    var status : String?
    
    init(activityIcon: String?,beginTime: String?,currentTime : String?,endTime : String?,id : String?,imgPath: String?,sessionName: String?,siteCode: String?,status: String?) {
        self.activityIcon = activityIcon
        self.beginTime = beginTime
        self.currentTime = currentTime
        self.endTime = endTime
        self.id = id
        self.imgPath = imgPath
        self.sessionName = sessionName
        self.siteCode = siteCode
        self.status = status
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> SeckillTabModel {
        let j = JSON(json)
        
        let activityIcon = j["activityIcon"].stringValue
        let beginTime = j["beginTime"].stringValue
        let currentTime = j["currentTime"].stringValue
        let endTime = j["endTime"].stringValue
        let id = j["id"].stringValue
        let imgPath = j["imgPath"].stringValue
        let sessionName = j["sessionName"].stringValue
        let siteCode = j["siteCode"].stringValue
        let status = j["status"].stringValue
        
        return SeckillTabModel(activityIcon: activityIcon,beginTime: beginTime,currentTime : currentTime,endTime:endTime,id:id,imgPath:imgPath,sessionName:sessionName,siteCode:siteCode,status:status)
    }
}
