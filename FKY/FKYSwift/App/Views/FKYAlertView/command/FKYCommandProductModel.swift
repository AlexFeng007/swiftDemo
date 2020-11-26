//
//  FKYCommandProductModel.swift
//  FKY
//
//  Created by My on 2019/10/30.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYCommandProductModel: NSObject, JSONAbleType {
    
    var factoryName: String?
    var promotionProductGroupList: Array<Any>?
    var tejia: Bool?
    var fanli: Bool?
    var taocan: Bool?
    var xiangou: Bool?
    var manzeng: Bool?
    var manjian: Bool?
    var shangou: Bool?
    var spuCode: String?
    var brandName: String?
    var sortNum: Int?
    var promotionId: String?
    var lastBuyPrice: Double?
    var currentInventory: String?
    var settingState: String?
    var status: Int?
    var updateTime: String?
    var limitNum: Int?
    var limitInfo: String?
    var short_name: String?
    var stockDesc: String?
    var promotionPrice: Double?
    var createUser: String?
    var cst_cnt: String?
    var channelPrice: Double?
    var updateUser: String?
    var spec: String?
    var createTime: String?
    var groupName: String?
    var sort: String?
    var minimumPacking: Int?
    var id: String?
    var discountMoney: Double?
    var enterpriseName: String?
    var productcodeCompany: String?
    var enterpriseId: Int?
    var list: Array<Any>?
    var acPrice: Double?
    var recommedRemark: String?
    var reducePrice: Double?
    var deadLine: String?
    var productId: String?
    var promotionRuleList: Array<Any>?
    var unit: String?
    var stockStatus: String?
    var productImgUrl: String?
    var sellerCode: Int?
    var sumInventory: Int?
    var productName: String?
    var shareType: Int?
    var wholesaleNum: Int?
    var vipLimitNum: Int?
    var visibleVipPrice: Double?
    var availableVipPrice: Double?
    var vipPromotionId: String?
    var isZiYingFlag: Int?
    var statusDesc: Int?
    var protocolRebate: Bool?
    var recommendPrice: Double?
    var limitNumRemain: Int?
    var produceTime: String?
    var stockIsLocal: Bool?
    var DiscountPriceDesc: String?
    var promotionLimitNum: Int?
    var ziyingWarehouseName: String?
    var exclusivePrice: Double?  //BigDecimal专享价
    var doorsill: Int? //起售盒数
    var referencePrice: Double? //划线价
    
    static func fromJSON(_ dic: [String : AnyObject]) -> FKYCommandProductModel {
        let json = JSON(dic)
        let model = FKYCommandProductModel()
        
        model.factoryName = json["factoryName"].stringValue
        model.promotionProductGroupList = json["promotionProductGroupList"].arrayObject
        model.tejia = json["tejia"].boolValue
        model.fanli = json["fanli"].boolValue
        model.xiangou = json["xiangou"].boolValue
        model.spuCode = json["spuCode"].stringValue
        model.brandName = json["brandName"].stringValue
        model.sortNum = json["sortNum"].intValue
        model.promotionId = json["promotionId"].stringValue
        model.lastBuyPrice = json["lastBuyPrice"].doubleValue
        model.currentInventory = json["currentInventory"].stringValue
        model.settingState = json["settingState"].stringValue
        model.status = json["status"].intValue
        model.updateTime = json["updateTime"].stringValue
        model.limitNum = json["limitNum"].intValue
        model.limitInfo = json["limitNum"].stringValue
        model.short_name = json["short_name"].stringValue
        model.stockDesc = json["stockDesc"].stringValue
        model.promotionPrice = json["promotionPrice"].doubleValue
        model.createUser = json["createUser"].stringValue
        model.cst_cnt = json["cst_cnt"].stringValue
        model.manjian = json["manjian"].boolValue
        model.shangou = json["shangou"].boolValue
        model.channelPrice = json["channelPrice"].doubleValue
        model.updateUser = json["updateUser"].stringValue
        model.spec = json["spec"].stringValue
        model.createTime = json["createTime"].stringValue
        model.groupName = json["groupName"].stringValue
        model.sort = json["sort"].stringValue
        
        if json["minimumPacking"].int != nil && json["minimumPacking"].int != 0 {
            model.minimumPacking = json["minimumPacking"].intValue
        }else{
            model.minimumPacking = 1
        }
        
        model.id = json["id"].stringValue
        model.discountMoney = json["discountMoney"].doubleValue
        model.manzeng = json["manzeng"].boolValue
        model.enterpriseName = json["enterpriseName"].stringValue
        model.productcodeCompany = json["productcodeCompany"].stringValue
        model.enterpriseId = json["enterpriseId"].intValue
        model.list = json["list"].arrayObject
        model.acPrice = json["acPrice"].doubleValue
        model.recommedRemark = json["recommedRemark"].stringValue
        model.reducePrice = json["reducePrice"].doubleValue
        model.deadLine = json["deadLine"].stringValue
        model.productId = json["productId"].stringValue
        model.promotionRuleList = json["promotionRuleList"].arrayObject
        model.unit = json["unit"].stringValue
        model.stockStatus = json["stockStatus"].stringValue
        model.productImgUrl = json["productImgUrl"].stringValue
        model.sellerCode = json["sellerCode"].intValue
        model.sumInventory = json["sumInventory"].int
        model.productName = json["productName"].stringValue
        model.shareType = json["shareType"].intValue
        model.wholesaleNum = json["wholesaleNum"].intValue
        model.vipLimitNum = json["vipLimitNum"].intValue
        model.visibleVipPrice = json["visibleVipPrice"].doubleValue
        model.availableVipPrice = json["availableVipPrice"].doubleValue
        model.vipPromotionId = json["vipPromotionId"].stringValue
        if json["ziyingFlag"].int != nil {
            model.isZiYingFlag = json["ziyingFlag"].intValue
        }else {
            model.isZiYingFlag = 1
        }
        
        model.statusDesc = json["statusDesc"].intValue
        model.ziyingWarehouseName = json["ziyingWarehouseName"].stringValue
        
        model.protocolRebate = json["protocolRebate"].boolValue
        model.recommendPrice = json["recommendPrice"].doubleValue
        model.taocan = json["taocan"].boolValue
        model.limitNumRemain = json["limitNumRemain"].intValue
        model.produceTime = json["produceTime"].stringValue
        model.stockIsLocal = json["stockIsLocal"].boolValue
        model.DiscountPriceDesc = json["DiscountPriceDesc"].stringValue
        model.promotionLimitNum = json["promotionLimitNum"].intValue
        model.exclusivePrice =  json["exclusivePrice"].doubleValue
        model.doorsill =  json["doorsill"].intValue
        model.referencePrice = json["referencePrice"].doubleValue
        return model
    }
    
    
    //口令model转HomeProductModel
    func toHomeProductModel() -> HomeProductModel {
        let model = HomeProductModel()
        
        if let code = spuCode, code.isEmpty == false {
            model.productId = code
        }else {
            model.productId = productId ?? ""
        }
        
        model.productPicUrl = productImgUrl
        model.productName = productName
        model.shortName = short_name
        model.spec = spec
        model.stockCountDesc = currentInventory
        model.unit = unit ?? ""
        model.factoryName = factoryName
        model.vendorName = enterpriseName
        model.vendorId = sellerCode ?? 0
        model.isZiYingFlag = isZiYingFlag
        model.ziyingTag = ziyingWarehouseName
        model.deadLine = deadLine
        model.stepCount = minimumPacking
        model.surplusBuyNum = limitNumRemain
        model.limitInfo = limitInfo
        if let isRebate = fanli, isRebate == true {
            model.isRebate = 1
        }
        
        model.productPrice = Float(channelPrice ?? 0.0)
        model.statusDesc = statusDesc
        model.availableVipPrice = Float(availableVipPrice ?? 0.0)
        model.visibleVipPrice = Float(visibleVipPrice ?? 0.0)
        model.vipLimitNum = vipLimitNum
        model.vipPromotionId = vipPromotionId
        model.productCodeCompany = productcodeCompany
        model.stockCount = sumInventory
        
        //acPrice为特价,channelPrice为原价, 有特价活动
        if let acprice = acPrice, let channelprice = channelPrice, acprice > 0, acprice < channelprice {
            let promotion = ProductPromotionModel()
            promotion.promotionPrice = Float(acprice)
            promotion.minimumPacking = wholesaleNum
            promotion.limitNum = promotionLimitNum
            model.productPromotion = promotion
        }
        
        model.protocolRebate = protocolRebate
        model.recommendPrice = Float(recommendPrice ?? 0.0)
        model.productionTime = produceTime
        model.stockIsLocal = stockIsLocal
        model.discountPriceDesc = DiscountPriceDesc
        
        model.exclusivePrice = exclusivePrice
        model.referencePrice = referencePrice
        model.doorsill = doorsill
        model.isRebate = (fanli == true ) ? 1:0                     // 是否有返利，0无1有
        model.haveDinner = taocan                    // ture 有套餐 false 无套餐
        model.limitInfo = (xiangou == true ) ? "限购":""                    // 限购
        var promotionList:[PromotionModel] = []
        if manjian == true{
            let promotionModel = PromotionModel()
            promotionModel.promotionType = 2
            promotionList.append(promotionModel)
        }
        if manzeng == true{
            let promotionModel = PromotionModel()
            promotionModel.promotionType = 5
            promotionList.append(promotionModel)
        }
        model.promotionList = promotionList
        for cartModel in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode ==  model.productId && cartOfInfoModel.supplyId.intValue == Int(model.vendorId) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                }
            }
        }
        
        
        return model
    }
    
}
