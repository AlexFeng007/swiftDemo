//
//  FKYPackageRateModel.swift
//  FKY
//
//  Created by yyc on 2020/8/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

final class FKYPackageRateModel: NSObject ,JSONAbleType,HandyJSON {
    override required init() {    }
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.stockDesc <-- ["stockCountDesc", "stockDesc"]
        mapper <<< self.deadLine <-- ["deadLine", "expiryDate"]
        mapper <<< self.unitName <-- ["packageUnit", "unitName"]
        mapper <<< self.minPackage <-- ["minPackage", "miniPackage"]
    }
    
    // 接口返回字段
    var beginTime: Int64? //活动开始时间
    var endTime : Int64? //活动结束时间
    var systemTime: Int64?//系统时间
   
    var enterpriseId : Int? //卖家Id
    var spuCode: String? //药城产品编码
    var productName: String? //商品名
    var spec: String? //规格
    var factoryName : String? //厂家
    var price: Float? //包邮价
    var originalPrice: Float? //原价
    var supplyName: String? //供应商名称
    var unitName: String? // 单位
    var inventory: Int? //单品包邮库存
    var limitNum: Int? //限购数量
    var baseNum : Int? //起购数量
    var sort: Int? //排序序号
    var isRelate: Int? //是否关联渠道
    var frontSellerCode: Int? //前台sellerCode<真实id>
    var deadLine: String? //药品效期
    var productionTime: String? //生产日期
    var consumedNum: Int? //已购买数量
    var inventoryLeft: Int? //活动剩余库存
    var productStatus: Int? //商品状态 0=正常 1=活动停止 2=商品未上架 3=活动未开始
    var percentage: Int? //进度
    var imgPath: String? //图片地址
    var stockDesc: String? //库存描述
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (productName ?? "") + " " + (spec ?? "")
        }
    }
    var minPackage: Int? //最小拆零包装
    var sessionId: Int? //活动场次id
    var surplusNum: Int? //客户剩余可购买
    var promotionId:Int? //单品包邮活动商品主键id
    var frontSellerName :String? //真实店铺名称
    
    var carId :Int = 0 //购物车id
    var carOfCount :Int = 0 //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）

    var pm_price: String?{ //可购买价格  埋点专用 自定义
        get {
            var priceList:[String] = []
            //包邮价
            if let priceStr = price {
                priceList.append(String(format: "%.2f",priceStr))
            }
            return priceList.count == 0 ? "":priceList.joined(separator: "|")
        }
    }
    var storage: String?{ //可购买数量 埋点专用 自定义
        get {
            var numList:[String] = []
            //本周剩余限购数量
            if let weekNum =  limitNum , weekNum > 0 {
                numList.append(String(weekNum))
            }
            return numList.count == 0 ? "0":numList.joined(separator: "|")
        }
    }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
        get {
            var pmList:[String] = []
            pmList.append("包邮价")
            return pmList.joined(separator: ",")
        }
    }
    
    // 数据解析
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYPackageRateModel {
        let j = JSON(json)
        
        let model = FKYPackageRateModel()
        model.beginTime = j["beginTime"].int64Value
        model.endTime = j["endTime"].int64Value
        model.systemTime = j["systemTime"].int64Value
        model.enterpriseId = j["enterpriseId"].intValue
        model.spuCode = j["spuCode"].stringValue
        model.productName = j["productName"].stringValue
        model.spec = j["spec"].stringValue
        model.factoryName = j["factoryName"].stringValue
        model.price = j["price"].floatValue
        model.originalPrice = j["originalPrice"].floatValue
        model.supplyName = j["supplyName"].stringValue
        model.unitName = j["unitName"].stringValue
        model.inventory = j["inventory"].intValue
        model.limitNum = j["limitNum"].intValue
        model.baseNum = j["baseNum"].intValue
        model.sort = j["sort"].intValue
        model.isRelate = j["isRelate"].intValue
        model.frontSellerCode = j["frontSellerCode"].intValue
        model.deadLine = j["deadLine"].stringValue
        model.productionTime = j["productionTime"].stringValue
        model.consumedNum = j["consumedNum"].intValue
        model.inventoryLeft = j["inventoryLeft"].intValue
        model.productStatus = j["productStatus"].intValue
        model.percentage = j["percentage"].intValue
        model.imgPath = j["imgPath"].stringValue
        model.stockDesc = j["stockDesc"].stringValue
        model.minPackage = j["minPackage"].intValue
        model.sessionId = j["sessionId"].intValue
        model.surplusNum = j["surplusNum"].intValue
        model.promotionId = j["id"].intValue
        model.frontSellerName = j["frontSellerName"].stringValue
//        for cartModel  in FKYCartModel.shareInstance().productArr {
//            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
//                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode! && cartOfInfoModel.supplyId.intValue == Int(model.sellerCode!) {
//                    model.carOfCount = cartOfInfoModel.buyNum.intValue
//                    model.carId = cartOfInfoModel.cartId.intValue
//                    break
//                }
//            }
//        }
        return model
    }
}
