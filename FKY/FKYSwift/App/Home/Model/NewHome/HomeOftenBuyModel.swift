//
//  HomeOftenBuyModel.swift
//  FKY
//
//  Created by 寒山 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeOftenBuyModel: NSObject {
    var dataSource: Array<HomeBaseCellProtocol> = []
    var nextPageId = 1
    var pageId = 1
    var pageSize = 20
    var totalItemCount = 22
    var totalPageCount = 2
    var hasNextPage = true //首页常购清单判断数据
}
final class HomeOftenBuyProductModel: NSObject, JSONAbleType {
    var cityHotSale: HomeOftenBuyProductListModel?      // 热销
    var frequentlyBuy: HomeOftenBuyProductListModel?    // 常买
    var frequentlyView: HomeOftenBuyProductListModel?   // 常看
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeOftenBuyProductModel {
        let json = JSON(json)
        
        var cityHotSale: HomeOftenBuyProductListModel?
        if let dic = json["cityHotSale"].dictionary {
            cityHotSale = (dic as NSDictionary).mapToObject(HomeOftenBuyProductListModel.self)
        }
        
        var frequentlyBuy: HomeOftenBuyProductListModel?
        if let dic = json["frequentlyBuy"].dictionary {
            frequentlyBuy = (dic as NSDictionary).mapToObject(HomeOftenBuyProductListModel.self)
        }
        
//        var frequentlyView: HomeOftenBuyProductListModel?
//        if let dic = json["frequentlyView"].dictionary {
//            frequentlyView = (dic as NSDictionary).mapToObject(HomeOftenBuyProductListModel.self)
//        }
        
        let model = HomeOftenBuyProductModel()
        model.cityHotSale = cityHotSale
        model.frequentlyBuy = frequentlyBuy
       // model.frequentlyView = frequentlyView
        return model
    }
}

final class HomeOftenBuyProductListModel: NSObject, JSONAbleType {
    var pageId: Int?                     // 当前页索引
    var pageSize: Int?                     // 每页条数
    var totalItemCount: String?             // 总条数
    var totalPageCount: String?             // 总页数
    var floorName: String?                  // 标题
    var nextPageId: Int?                   // 下一页页码
    var hasNextPage: Bool?                // 是否还有下一页
    var list: [HomeBaseCellProtocol]?   // 商品列表
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeOftenBuyProductListModel {
        let json = JSON(json)
        
        var list:Array<HomeBaseCellProtocol> = []
        if let arr = json["list"].arrayObject {
            for dic in arr{
                 if let desDic = dic as? Dictionary<String,AnyObject> {
                    //if  desDic.keys.contains("type") {
//                        if let typeId = desDic["type"] as? NSNumber{
//                            //3 首推特价  7 广告 20 一起系列 （一起闪m，一起返，一起购） 21 秒杀
//                            if typeId.intValue == 3{
//                                let commonModel =  HomeOtherProductCellModel.init()
//                                let productModel = (desDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
//                                commonModel.model = productModel
//
//                                if productModel.floorProductDtos != nil && productModel.floorProductDtos!.count != 0{
//                                    list.append(commonModel)
//                                }
//                            }else if typeId.intValue == 7{
//                                let adModel =  HomeADCellModel.init()
//                                let productModel = (desDic as NSDictionary).mapToObject(HomeADInfoModel.self)
//                                adModel.model = productModel
//                                list.append(adModel)
//                            }else if typeId.intValue == 20{
//                                let productModel = (desDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
//                                // 1 一起购  2一起返一起闪
//                                if  productModel.togetherMark == 1{
//                                    let commonModel =  HomeYQGCellModel.init()
//                                    commonModel.model = productModel
//                                    if productModel.floorProductDtos != nil && productModel.floorProductDtos!.count != 0{
//                                         list.append(commonModel)
//                                    }
//                                }else if productModel.togetherMark == 2{
//                                    let commonModel =  HomeOtherProductCellModel.init()
//                                    commonModel.model = productModel
//                                    if productModel.floorProductDtos != nil && productModel.floorProductDtos!.count != 0{
//                                        list.append(commonModel)
//                                    }
//                                }
//                            }else if typeId.intValue == 21{
//                                let commonModel =  HomeSecKillCellModel.init()
//                                let productModel = (desDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
//                                commonModel.model = productModel
//                                if productModel.floorProductDtos != nil && productModel.floorProductDtos!.count != 0{
//                                    list.append(commonModel)
//                                }
//                            }
//                        }
//                    }else{
                        let commonModel =  HomeCommonProductCellModel.init()
                        let productModel = (desDic as NSDictionary).mapToObject(HomeCommonProductModel.self)
                        commonModel.model = productModel
                        list.append(commonModel)
                   // }
                }
            }
            //list = (arr as NSArray).mapToObjectArray(OftenBuyProductItemModel.self)
        }
        
        let model = HomeOftenBuyProductListModel()
        model.pageId = json["pageId"].intValue
        model.pageSize = json["pageSize"].intValue
        model.totalItemCount = json["totalItemCount"].stringValue
        model.totalPageCount = json["totalPageCount"].stringValue
        model.floorName = json["floorName"].stringValue
        model.hasNextPage = json["hasNextPage"].boolValue
        model.nextPageId = json["nextPageId"].intValue
        model.list = list
        return model
    }
    
    
}
