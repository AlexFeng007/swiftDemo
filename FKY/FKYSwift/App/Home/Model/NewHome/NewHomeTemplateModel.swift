//
//  NewHomeTemplateModel.swift
//  FKY
//
//  Created by 寒山 on 2019/7/9.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class HomeRecommendProductModel: NSObject, JSONAbleType {
    var pageId: Int?                     // 当前页索引
    var pageSize: Int?                     // 每页条数
    var totalItemCount: String?             // 总条数
    var totalPageCount: String?             // 总页数
    var floorName: String?                  // 标题
    var pageTimeStamp: String?                  // 时间戳
    var hasNavFunc: Bool = false                 // 判断是否有导航按钮 UI用
    /// 楼层列表
    var list: [HomeBaseCellProtocol]?
    
    var hotSearchArr : [String]? //热搜词
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRecommendProductModel {
        let json = JSON(json)
        let model = HomeRecommendProductModel()
        model.pageId = json["pageId"].intValue
        model.pageSize = json["pageSize"].intValue
        model.totalItemCount = json["totalItemCount"].stringValue
        model.totalPageCount = json["totalPageCount"].stringValue
        model.floorName = json["floorName"].stringValue
        model.pageTimeStamp = json["pageTimeStamp"].stringValue
        
        var list:Array<HomeBaseCellProtocol> = []
        if let arr = json["list"].arrayObject {
            for dic in arr{
                if let desDic = dic as? Dictionary<String,AnyObject> {
                    if  desDic.keys.contains("templateType") {
                        if let templateType = desDic["templateType"] as? NSNumber{
                            if templateType.intValue == 4{
                                //中通广告
                                if  desDic.keys.contains("contents") {
                                    if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,contentsDic.keys.contains("recommend"){
                                        if let recommendDic = contentsDic["recommend"] as? Dictionary<String,AnyObject>{
                                            // 1：中通广告一行1个，2：中通广告一行2个，3：中通广告一行3个，
                                            if recommendDic.keys.contains("floorStyle"){
                                                if let floorStyle = recommendDic["floorStyle"] as? NSNumber{
                                                    if  floorStyle.intValue == 1{
                                                        let adModel =  HomeADCellModel.init()
                                                        let productModel = (recommendDic as NSDictionary).mapToObject(HomeADInfoModel.self)
                                                        adModel.model = productModel
                                                        list.append(adModel)
                                                    }else if floorStyle.intValue == 2{
                                                        let adModel =  HomeTwoADCellModel.init()
                                                        let productModel = (recommendDic as NSDictionary).mapToObject(HomeADInfoModel.self)
                                                        adModel.model = productModel
                                                        list.append(adModel)
                                                    }else if floorStyle.intValue == 3{
                                                        let adModel =  HomeThreeADCellModel.init()
                                                        let productModel = (recommendDic as NSDictionary).mapToObject(HomeADInfoModel.self)
                                                        adModel.model = productModel
                                                        list.append(adModel)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else if templateType.intValue == 1{
                                //轮播图
                                if  desDic.keys.contains("contents") {
                                    if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,contentsDic.keys.contains("banners"){
                                        // if let bannersArray = contentsDic["banners"] as? NSDictionary{
                                        let bannersModel:HomeCircleBannerModel = (contentsDic as NSDictionary).mapToObject(HomeCircleBannerModel.self)
                                        let bannerCellModel =  HomeBannerCellModel.init()
                                        bannerCellModel.model = bannersModel
                                        list.append(bannerCellModel)
                                        //  }
                                    }
                                }
                            }
                            else  if templateType.intValue == 13{
                                //药城公告
                                if  desDic.keys.contains("contents") {
                                    if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,contentsDic.keys.contains("ycNotice"){
                                        //if let navArray = contentsDic["Navigation"] as? NSDictionary{
                                        let noticeModel:HomePublicNoticeModel = (contentsDic as NSDictionary).mapToObject(HomePublicNoticeModel.self)
                                        let noticeCellModel =  HomeNoticeCellModel.init()
                                        noticeCellModel.model = noticeModel
                                        list.append(noticeCellModel)
                                        //  }
                                    }
                                }
                            }
                            else  if templateType.intValue == 14{
                                //导航按钮
                                if  desDic.keys.contains("contents") {
                                    if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,contentsDic.keys.contains("Navigation"){
                                        //if let navArray = contentsDic["Navigation"] as? NSDictionary{
                                        let navModel:HomeFucButtonModel = (contentsDic as NSDictionary).mapToObject(HomeFucButtonModel.self)
                                        if navModel.navigations?.isEmpty == false{
                                            let navCellModel =  HomeNavFucCellModel.init()
                                            navCellModel.model = navModel
                                            list.append(navCellModel)
                                            if  navModel.navigations!.count >= 5{
                                                model.hasNavFunc = true
                                            }
                                            var navigations = [HomeFucButtonItemModel]()
                                            if let arr = navModel.navigations,arr.count > 0 {
                                                if  arr.count < 5 {
                                                    //小于5个不展示
                                                }else if arr.count >= 5 &&  arr.count < 10 {
                                                    //大于等于5个，小于10个，只展示5个
                                                    navigations.append(contentsOf: arr.prefix(5))
                                                }else {
                                                    //大于等于10个只展示10个
                                                    navigations.append(contentsOf: arr.prefix(10))
                                                }
                                                navModel.navigations = navigations
                                            }
                                        }
                                    }
                                }
                            }
                            else if templateType.intValue == 3 {
                                //一起系列
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendDic = contentsDic["recommend"] as? Dictionary<String,AnyObject> {
                                    let togeterModel = (recommendDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
                                    let togeterCellModel = HomeYQGCellModel.init()
                                    togeterCellModel.model = togeterModel
                                    list.append(togeterCellModel)
                                }
                            }
                            else if templateType.intValue == 6 {
                                //2*3样式(首推特价)
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendDic = contentsDic["recommend"] as? Dictionary<String,AnyObject> {
                                    let otherModel = (recommendDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
                                    let otherCellModel = HomeOtherProductCellModel.init()
                                    otherCellModel.model = otherModel
                                    list.append(otherCellModel)
                                }
                            }
                            else if templateType.intValue == 17 {
                                //品牌
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let brandRecommendDic = contentsDic["recommend"] as? Dictionary<String,AnyObject> {
                                    let brandModel = (brandRecommendDic as NSDictionary).mapToObject(HomeBrandModel.self)
                                    let brandCellModel = HomeBrandCellModel.init()
                                    brandCellModel.model = brandModel
                                    list.append(brandCellModel)
                                }
                            }
                            else if templateType.intValue == 16 {
                                //秒杀
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendDic = contentsDic["recommend"] as? Dictionary<String,AnyObject> {
                                    if let floorStyle = recommendDic["floorStyle"] as? Int ,floorStyle == 5 {
                                        //多品秒杀
                                        let killModel = (recommendDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
                                        let killCellModel = HomeSecKillCellModel.init()
                                        killCellModel.model = killModel
                                        list.append(killCellModel)
                                    }
                                    if let floorStyle = recommendDic["floorStyle"] as? Int ,floorStyle == 4 {
                                        //单品品秒杀
                                        let killModel = (recommendDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
                                        let killCellModel = HomeSingleSecKillCellModel.init()
                                        killCellModel.model = killModel
                                        list.append(killCellModel)
                                    }
                                }
                            }
                                /*
                            else if templateType.intValue == 21 {
                                //单行秒杀
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
                                    let killCellModel = HomeOnlySecKillCellModel.init()
                                    killCellModel.modelList = killModel
                                    list.append(killCellModel)
                                }
                            } // 废弃
                            else if templateType.intValue == 22 {
                                //单行商家精选
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
                                    let killCellModel = HomeOnlyShopRecommCellModel.init()
                                    killCellModel.modelList = killModel
                                    list.append(killCellModel)
                                }
                            } // 废弃*/
//                            else if templateType.intValue == 27 {
//                                 //单行套餐
//                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
//                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
//                                    let killCellModel = HomeOnlyComboCellModel.init()
//                                    killCellModel.modelList = killModel
//                                    list.append(killCellModel)
//                                }
//                            }else if templateType.intValue == 29 {
//                                //一行两个 套餐商家精选
//                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
//                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
//                                    let killCellModel = HomeComboAndShopRecommCellModel.init()
//                                    killCellModel.modelList = killModel
//                                    list.append(killCellModel)
//                                }
//                            }
//                            else if templateType.intValue == 28 {
//                                //一行两个 秒杀套餐
//                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
//                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
//                                    let killCellModel = HomeSecKillAndComboCellModel.init()
//                                    killCellModel.modelList = killModel
//                                    list.append(killCellModel)
//                                }
//                            }
                            /*
                            else if templateType.intValue == 23 {
                                //一行两个 秒杀商家精选
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
                                    let killCellModel = HomeSecKillAndShopRecommCellModel.init()
                                    killCellModel.modelList = killModel
                                    list.append(killCellModel)
                                }
                            } // 废弃*/
                            else if templateType.intValue == 24 {
                                //1个系统推荐
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
                                    let killCellModel = HomeOneSystemRecommCellModel.init()
                                    killCellModel.modelList = killModel
                                    if list.isEmpty == false{
                                        if let lastModel:HomeBaseCellProtocol = list.last{
                                            if let secKillModel = lastModel as? HomeFloorModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }
                                            /*
                                            else if let secKillModel = lastModel as? HomeSecKillAndShopRecommCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeOnlySecKillCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeOnlyComboCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeComboAndShopRecommCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeSecKillAndComboCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }
                                            */
                                        }
                                    }
                                    list.append(killCellModel)
                                }
                            }
                            else if templateType.intValue == 25 {
                                //2个系统推荐
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
                                    let killCellModel = HomeTwoSystemRecommCellModel.init()
                                    killCellModel.modelList = killModel
                                    if list.isEmpty == false{
                                        if let lastModel:HomeBaseCellProtocol = list.last {
                                            if let secKillModel = lastModel as? HomeFloorModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }
                                            /*
                                            else if let secKillModel = lastModel as? HomeSecKillAndShopRecommCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeOnlySecKillCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeOnlyComboCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeComboAndShopRecommCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeSecKillAndComboCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }
                                            */
                                        }
                                    }
                                    list.append(killCellModel)
                                }
                            }
                            else if templateType.intValue == 26 {
                                //3个系统推荐；
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendList"] as? NSArray {
                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
                                    let killCellModel = HomeThreeSystemRecommCellModel.init()
                                    killCellModel.modelList = killModel
                                    if list.isEmpty == false{
                                        if let lastModel:HomeBaseCellProtocol = list.last{
                                            if let secKillModel = lastModel as? HomeFloorModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }
                                            /*
                                            else if let secKillModel = lastModel as? HomeSecKillAndShopRecommCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeOnlySecKillCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeOnlyComboCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeComboAndShopRecommCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }else if let secKillModel = lastModel as? HomeSecKillAndComboCellModel{
                                                killCellModel.hasTop = true
                                                secKillModel.hasBtttom = true
                                            }
                                             */
                                        }
                                    }
                                    list.append(killCellModel)
                                }
                            }
                            else if templateType.intValue == 20 {
                                //3个系统推荐；
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["hotSearch"] as? [String] {
                                    model.hotSearchArr = recommendArray
                                }
                            }
                            /// 一行两个 相同模块 套餐 HomeFloorModel HomeSecKillAndShopRecommCellModel
                            else if templateType.intValue == 27 {
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendDinnerList"] as? NSArray {
                                    let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
                                    let model_t = HomeFloorModel()
                                    model_t.cellType = .HomeCellTypeOneComponents
                                    model_t.modelList = killModel
                                    
                                    list.append(model_t)
                                }
                            }
                            /// 一行两个模块 两个模块不同
                            else if templateType.intValue == 28 {
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendArray = contentsDic["recommendDinnerList"] as? NSArray {
                                let killModel = recommendArray.mapToObjectArray(HomeSecdKillProductModel.self)
                                
                                
                                let model_t = HomeFloorModel()
                                model_t.cellType = .HomeCellTypeTwoComponents
                                model_t.modelList = killModel
                                
                                list.append(model_t)
                                }
                            }
                        }
                    }
                }
            }
        }
        model.list = list
        return model
    }
    
    
}
