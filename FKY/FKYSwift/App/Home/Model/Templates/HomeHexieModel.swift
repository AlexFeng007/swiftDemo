//
//  HomeHexieModel.swift
//  FKY
//
//  Created by zengyao on 2018/2/8.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  消费者最爱

import Foundation
import SwiftyJSON

/*
 floorname:楼层名称
 datas:
     showpic:商品图片
 */

final class HomeHexieModel: NSObject, JSONAbleType {
    // MARK: - properties
    var floorname: String?
    var datas:[HomeHexieItemModel]?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeHexieModel {
        let json = JSON(json)
        
        let floorname = json["floorname"].stringValue
        var data: [HomeHexieItemModel]?
        if let list = json["data"].arrayObject {
            data = (list as NSArray).mapToObjectArray(HomeHexieItemModel.self)
        }
        return HomeHexieModel(floorname: floorname, data:data)
    }
    
    init(floorname: String?, data: [HomeHexieItemModel]?) {
        super.init()
        self.floorname = floorname
        self.datas = data
    }
}

extension HomeHexieModel: HomeModelInterface {
    func floorIdentifier() -> String {
        return "HomeHexieCell"
    }
}

final class HomeHexieItemModel: NSObject, JSONAbleType {
    // MARK: - properties
    var showpic: String?
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeHexieItemModel {
        let json = JSON(json)
        let showpic = json["showpic"].stringValue
        return HomeHexieItemModel(showpic: showpic)
    }
    
    init(showpic: String?) {
        super.init()
        self.showpic = showpic
    }
}
