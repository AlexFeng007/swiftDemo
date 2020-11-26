//
//  HomeRankModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  首页排行榜之排行榜model...<本周排行榜/区域热搜榜>

import SwiftyJSON

final class HomeRankModel: NSObject, JSONAbleType {
    var reportData: [HomeRankDataModel]?  // 排行榜对象数组
    
    init(reportData: [HomeRankDataModel]?) {
        self.reportData = reportData
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRankModel {
        let json = JSON(json)
        
        var reportData: [HomeRankDataModel]?
        if let list = json["reportData"].arrayObject {
            reportData = (list as NSArray).mapToObjectArray(HomeRankDataModel.self)
        }
        
        return HomeRankModel(reportData: reportData)
    }
}

//extension HomeRankModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeRankingListCell"
//    }
//}


final class HomeRankDataModel: NSObject, JSONAbleType {
    // 接口返回字段
    var floorname: String?          // 楼层名称
    var type: Int?                  // 排行榜类型 13-本周排行榜 12-(区域)热搜榜
    var data: [HomeRankItemModel]?  // 内容数组
    // 本地新增业务逻辑字段
    var pageIndex: Int = 0          // 当前页面索引
    
    init(floorname: String?, type: Int?, data: [HomeRankItemModel]?) {
        self.floorname = floorname
        self.type = type
        self.data = data
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRankDataModel {
        let json = JSON(json)
        
        let floorname = json["floorname"].stringValue
        let type = json["type"].intValue
        
        var data: [HomeRankItemModel]?
        if let list = json["data"].arrayObject {
            data = (list as NSArray).mapToObjectArray(HomeRankItemModel.self)
        }
        
        return HomeRankDataModel(floorname: floorname, type: type, data: data)
    }
}

final class HomeRankItemModel: NSObject, JSONAbleType {
    var showgood: String?    // 商品名称
    
    init(showgood: String?) {
        self.showgood = showgood
    }
    
    // dic转model
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRankItemModel {
        let json = JSON(json)
        
        let showgood = json["showgood"].stringValue
        
        return HomeRankItemModel(showgood: showgood)
    }
}
