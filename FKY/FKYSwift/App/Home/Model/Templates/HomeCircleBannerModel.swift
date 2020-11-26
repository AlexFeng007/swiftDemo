//
//  HomeCircleBannerModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)轮播视图（无限轮播banner）之活动model

import SwiftyJSON

final class HomeCircleBannerModel: NSObject, JSONAbleType {
    // 接口返回字段
    var banners: [HomeCircleBannerItemModel]?   // 活动列表
    // 本地新增业务逻辑字段
    var pageIndex: Int = 0                      // 当前页面索引
    
    init(banners: [HomeCircleBannerItemModel]?) {
        self.banners = banners
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> HomeCircleBannerModel {
        let json = JSON(json)
        
        var banners: [HomeCircleBannerItemModel]?
        if let list = json["banners"].arrayObject {
            banners = (list as NSArray).mapToObjectArray(HomeCircleBannerItemModel.self)
        }
        
        return HomeCircleBannerModel(banners: banners)
    }
}

extension HomeCircleBannerModel: HomeModelInterface {
    func floorIdentifier() -> String {
        return "HomeCircleBannerCell"
    }
}

extension HomeCircleBannerModel: ShopListModelInterface {
    func floorCellIdentifier() -> String {
        return "ShopListBannerCell"
    }
}

/*
 name:名称
 siteCode:分站编码
 imgPath:图片
 url:url链接
 jumpInfo:根据类型1为空，2商品supcode，3类目编码，4店铺id，5活动url
 jumpExpandOne:跳转内容扩展，2商品通用名，3关键字
 jumpExpandTwo:跳转内容扩展，2商品供应商id
 jumpExpandThree:跳转内容扩展，2商品供应商名称
 jumpType:跳转类型
 1未选择
 2商品详情页 jumpInfo为商品supcode，jumpExpandOne为商品名称， jumpExpandTwo为商品供应商id，jumpExpandThree为供应商名称
 3搜索详情页 jumpInfo类目编码，jumpExpandOne为关键字，这两个属性不会同时存在
 4店铺主页 jumpInfo店铺id
 5活动链接 jumpInfo活动url
 */
final class HomeCircleBannerItemModel: NSObject, JSONAbleType {
    var id: Int?                // 活动id
    var imgPath: String?        // 图片url
    var jumpInfo: String?       // 跳转内容（根据jumpType来确定跳转操作的类型） 1-空 2-商品spucode 3-类目编码 4-店铺id 5-活动url
    var jumpType: Int?          // 跳转类型 1-未选择 2-商品详情页 3-搜索详情页 4-店铺主页 5-活动链接
    var name: String?           // 活动名称
    var siteCode: String?       // 分站编码
    var type: Int?              // 楼层类型 1-轮播图
    var jumpExpandOne: String?      // 跳转内容扩展 2-商品通用名 3-关键字
    var jumpExpandTwo: String?      // 跳转内容扩展 2-商品供应商id
    var jumpExpandThree: String?    // 跳转内容扩展 2-商品供应商名称
    
    init(id: Int?, imgPath: String?, jumpInfo: String?, jumpType: Int?, name: String?, siteCode: String?, type: Int?, jumpExpandOne: String?, jumpExpandTwo: String?, jumpExpandThree: String?) {
        self.id = id
        self.imgPath = imgPath
        self.jumpInfo = jumpInfo
        self.jumpType = jumpType
        self.name = name
        self.siteCode = siteCode
        self.type = type
        self.jumpExpandOne = jumpExpandOne
        self.jumpExpandTwo = jumpExpandTwo
        self.jumpExpandThree = jumpExpandThree
    }
    
    // dic转model
    static func fromJSON(_ json: [String : AnyObject]) -> HomeCircleBannerItemModel {
        let json = JSON(json)
        
        let id = json["id"].intValue
        let imgPath = json["imgPath"].stringValue
        let jumpInfo = json["jumpInfo"].stringValue
        let jumpType = json["jumpType"].intValue
        let name = json["name"].stringValue
        let siteCode = json["siteCode"].stringValue
        let type = json["type"].intValue
        let jumpExpandOne = json["jumpExpandOne"].stringValue
        let jumpExpandTwo = json["jumpExpandTwo"].stringValue
        let jumpExpandThree = json["jumpExpandThree"].stringValue
        
        return HomeCircleBannerItemModel(id: id, imgPath: imgPath, jumpInfo: jumpInfo, jumpType: jumpType, name: name, siteCode: siteCode, type: type, jumpExpandOne: jumpExpandOne, jumpExpandTwo: jumpExpandTwo, jumpExpandThree: jumpExpandThree)
    }
}
