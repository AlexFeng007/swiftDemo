//
//  FKYSplashModel.swift
//  FKY
//
//  Created by hui on 2018/7/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  开屏广告的模型

import SwiftyJSON

final class FKYSplashModel: NSObject, JSONAbleType {
    // 接口返回字段
    @objc var imgPath: String?        // 开屏广告图片
    @objc var holdTime: Int = 3       // 显示多少秒后关闭
    @objc var jumpType: Int = 1       //
    @objc var jumpExpandOne: String?
    @objc var jumpExpandTwo: String?
    @objc var jumpExpandThree: String?
    /*
    jumpType 为1:未选择
    2商品详情页 jumpInfo为商品supcode jumpExpandOne为商品名称， jumpExpandTwo为商品供应商id，jumpExpandThree为供应商名称
     3搜索详情页 jumpInfo类目编码，jumpExpandOne为关键字，这两个属性不会同时存在
     4店铺主页 jumpInfo店铺id
     5活动链接 jumpInfo活动url 跳转链接
    */
    @objc var jumpInfo : String?
    @objc var skipFlag : String? //控制是否可以跳过的标识符 1为跳过 0为不跳过
    @objc var advertisementName : String? //广告名称
    
    init(imgPath: String?,holdTime: Int,jumpInfo : String?,skipFlag : String?,advertisementName : String?,jumpType: Int,jumpExpandOne: String?,jumpExpandTwo: String?,jumpExpandThree: String?) {
        self.imgPath = imgPath
        self.holdTime = holdTime
        self.jumpInfo = jumpInfo
        self.skipFlag = skipFlag
        self.advertisementName = advertisementName
        self.jumpType = jumpType
        self.jumpExpandOne = jumpExpandOne
        self.jumpExpandTwo = jumpExpandTwo
        self.jumpExpandThree = jumpExpandThree
    }
    
    // 数据解析
    static func fromJSON(_ json: [String : AnyObject]) -> FKYSplashModel {
        let j = JSON(json)
        
        let imgPath = j["imgPath"].stringValue
        let holdTime = j["holdTime"].intValue
        let jumpInfo = j["jumpInfo"].stringValue
        let skipFlag = j["skipFlag"].stringValue
        let advertisementName = j["advertisementName"].stringValue
        let jumpType = j["jumpType"].intValue
        let jumpExpandOne = j["jumpExpandOne"].stringValue
        let jumpExpandTwo = j["jumpExpandTwo"].stringValue
        let jumpExpandThree = j["jumpExpandThree"].stringValue
        
        return FKYSplashModel(imgPath: imgPath,holdTime: holdTime,jumpInfo : jumpInfo,skipFlag:skipFlag,advertisementName:advertisementName,jumpType:jumpType,jumpExpandOne:jumpExpandOne,jumpExpandTwo:jumpExpandTwo,jumpExpandThree:jumpExpandThree)
    }
}
