//
//  SeckillActivityProductsModel.swift
//  FKY
//
//  Created by Andy on 2018/11/26.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class SeckillActivityProductsModel: NSObject, JSONAbleType {
    // 接口返回字段
    var bigPacking: String? //大包装
    var countOfWeekLimit: String? //已购买限购的商品数
    var inventory : String? //前端可售库存
    var isChannel : String? //是否渠道
    var limitInfo : String? //限购文描
    var limitNum: String? //活动库存
    var minimumPacking: String? //最小包装
    var price: String? //商品原价
    var priceDesc: String? //价格状态描述
    var priceStatus: String? //价格状态
    var productId: String? //商品id
    var productName: String? //商品名称
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (productName ?? "") + " " + (spec ?? "")
        }
    }
    var productPicPath: String? //商品主图
    var productStatus: Int? //商品状态
    var productcodeCompany: String? //本公司产品编码
    var rowNum: String?
    var seckillCurrentInventory: String? //秒杀活动当前库存,-1表示不限
    var seckillInventory: String? //秒杀活动库存(秒杀限量)，-1表示不限
    var seckillMinimumPacking: String? //秒杀起批量
    var seckillOut: String? //是否抢购完
    var seckillPrice: String? //秒杀价
    var seckillProgress: String? //抢购进度
    var sellerCode: String? //卖家编码
    var showPrice: String?
    var spec: String? //规格型号
    var spuCode: String? //商品编码
    var unitName: String? //单位
    var weekLimitNum: String?//限购周限购量
    var deadLine: String? // 有效期
    var stockCountDesc: String? // 库存描述字段
    var productionTime: String? // 生产日期
    
    var factoryName: String? // 厂家名
    var frontSellerName: String? // 商家
    //共享库存相关字段
    var stockCount : Int? //共享库存
    var stockIsLocal :Bool? // 是否本地仓库存false 使用共享库存
    var stockToDays : Int? // 调拨周期（天）
    var stockToFromWarhouseId : Int? //库存调拨仓ID
    var stockToFromWarhouseName :String?// 库存调拨仓名称
    var shareStockDesc :String?// 共享仓文描
    
    var carId :Int = 0 //购物车id
    var carOfCount :Int = 0 //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var enterpriseId : String = "0"
    var actIcon : String = ""
    var pm_price: String?{ //可购买价格  埋点专用 自定义
        get {
            var priceList:[String] = []
            //秒杀价格
            if let priceStr = Float(seckillPrice ?? "0") {
                priceList.append(String(format: "%.2f",priceStr))
            }
            //原价
            if let priceStr = Float(price ?? "0") {
                priceList.append(String(format: "%.2f",priceStr))
            }
            return priceList.count == 0 ? "":priceList.joined(separator: "|")
        }
    }
    var storage: String?{ //可购买数量 埋点专用 自定义
        get {
            var numList:[String] = []
            //本周剩余限购数量
            if let weekNum =  Int(limitNum ?? "0") , weekNum > 0 {
                numList.append(String(weekNum))
            }
            var canBuyNum = 0
            if stockIsLocal == true{
                if let count = Int(inventory ?? "0"),count>0 {
                    canBuyNum = count
                }
            }else{
                if let count = stockCount,count>0 {
                    canBuyNum = count
                }
            }
            var limitNum = 0
            if let weekLimitNum =  Int(weekLimitNum ?? "0") , weekLimitNum > 0 {
                if let countWeekLimitNum =  Int(countOfWeekLimit ?? "0"){
                    limitNum = weekLimitNum - countWeekLimitNum
                }
            }
            canBuyNum = (limitNum > 0 && canBuyNum > limitNum) ? limitNum:canBuyNum
            numList.append(String(canBuyNum))
            return numList.count == 0 ? "0":numList.joined(separator: "|")
        }
    }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
        get {
            var pmList:[String] = []
            if let limitNumSign = Int(self.weekLimitNum ?? "0"),limitNumSign > 0{
                pmList.append("限购")
            }
            pmList.append("特价")
            return pmList.joined(separator: ",")
        }
    }
    
    // 数据解析
    @objc static func fromJSON(_ json: [String : AnyObject]) -> SeckillActivityProductsModel {
        let j = JSON(json)
        
        let model = SeckillActivityProductsModel()
        
        model.bigPacking = j["bigPacking"].stringValue
        model.minimumPacking = j["minimumPacking"].stringValue
        model.price = j["price"].stringValue
        model.priceDesc = j["priceDesc"].stringValue
        model.limitNum = j["limitNum"].stringValue
        model.countOfWeekLimit = j["countOfWeekLimit"].stringValue
        model.inventory = j["inventory"].stringValue
        model.isChannel = j["isChannel"].stringValue
        model.limitInfo = j["limitInfo"].stringValue
        model.priceStatus = j["priceStatus"].stringValue
        model.productId = j["productId"].stringValue
        model.productName = j["productName"].stringValue
        model.productPicPath = j["productPicPath"].stringValue
        model.productStatus = j["productStatus"].intValue
        model.productcodeCompany = j["productcodeCompany"].stringValue
        model.rowNum = j["rowNum"].stringValue
        model.seckillCurrentInventory = j["seckillCurrentInventory"].stringValue
        model.seckillInventory = j["seckillInventory"].stringValue
        model.seckillMinimumPacking = j["seckillMinimumPacking"].stringValue
        model.seckillOut = j["seckillOut"].stringValue
        model.seckillPrice = j["seckillPrice"].stringValue
        model.seckillProgress = j["seckillProgress"].stringValue
        model.sellerCode = j["sellerCode"].stringValue
        model.showPrice = j["showPrice"].stringValue
        model.spec = j["spec"].stringValue
        model.spuCode = j["spuCode"].stringValue
        model.unitName = j["unitName"].stringValue
        model.weekLimitNum = j["weekLimitNum"].stringValue
        model.deadLine = j["deadLine"].stringValue
        
        model.stockCount = j["stockCount"].intValue
        model.stockIsLocal = j["stockIsLocal"].boolValue
        model.stockToDays = j["stockToDays"].intValue
        model.stockToFromWarhouseId = j["stockToFromWarhouseId"].intValue
        model.stockToFromWarhouseName = j["stockToFromWarhouseName"].stringValue
        model.shareStockDesc = j["shareStockDesc"].stringValue
        model.factoryName = j["factoryName"].stringValue
        model.frontSellerName = j["frontSellerName"].stringValue
        model.stockCountDesc = j["stockCountDesc"].stringValue
        model.productionTime = j["productionTime"].stringValue
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.productId! && cartOfInfoModel.supplyId.intValue == Int(model.productcodeCompany!) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        return model
    }
}
