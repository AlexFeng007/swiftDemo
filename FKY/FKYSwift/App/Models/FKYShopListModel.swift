//
//  FKYShopListModel.swift
//  FKY
//
//  Created by hui on 2018/5/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYSpecialPriceModel: NSObject, JSONAbleType {
    var prductName: String?
    var productPicUrl: String?
    //let isRebate:String?//0非特价，1特价
    /*//0:正常显示价格, -1:登录后可见, -2:加入渠道后可见, -3:资质认证后可见, -4:渠道待审核, -5:缺货, -6:不显示 ,-7:已下架,-9:无采购权限,-10:采购权限待审核,-11:权限审核不通过,-12:采购权限已禁用*/
    var statusDesc: Int?//商品状态
    var spuCode: String?
    var showPrice: Float? //商品价格
    var productId: String?//
    var vendorId: String = "0"//外层获取
    var enterpriseId: String?//店铺id
    
    var statusMsg: String?
    
    var statusComplain:String? //店铺馆新的商品模型
    
    var hasCoupon: String?//有优惠券(1代表有)
    var hasFullSub: String? //有满减(1代表有)
    var hasRebate: String? //有返利(1代表有)
    var spec: String? //商品规格
    
    //自定义字段
    var spePrice: Float? //特价
    var hasSpePrice: String? //有特价(1代表有)
    var pm_price: String?{ //可购买价格  埋点专用 自定义
         get {
           var priceList:[String] = []
           //会员价 特价 原价
            if let promotionNum = hasSpePrice,promotionNum == "1"{
               //特价
                priceList.append(String(format: "%.2f",spePrice!))
            }
           //原价
              if let priceStr = showPrice, priceStr > 0 {
                  priceList.append(String(format: "%.2f",priceStr))
              }
           return priceList.count == 0 ?  ProductStausUntily.getProductStausDesc(statusDesc ?? 0):priceList.joined(separator: "|")
         }
     }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
          get {
           var pmList:[String] = []
            if hasFullSub == "1"{
                pmList.append("满减")
             }
            // 返利金
            if hasRebate == "1"{
              pmList.append("返利")
             }
           //特价
             if hasSpePrice == "1" {
                  pmList.append("特价")
             }
            // 优惠券
             if hasCoupon == "1" {
              pmList.append("券")
             }
           return pmList.joined(separator: ",")
          }
      }

    static func fromJSON(_ json: [String : AnyObject]) -> FKYSpecialPriceModel {
        
        let model = FKYSpecialPriceModel()
        let j = JSON(json)
        
        model.prductName = j["productName"].string
        model.productPicUrl = j["productPicUrl"].string
        model.statusDesc = j["statusDesc"].int
        model.spuCode = j["spuCode"].string
        model.productId = j["productId"].string
        model.showPrice = j["showPrice"].float
        if model.showPrice! < 0 {
            model.showPrice = 0
        }
        model.statusMsg = j["statusMsg"].string
        model.hasCoupon = j["hasCoupon"].string
        model.hasFullSub = j["hasFullSub"].string
        model.hasRebate = j["hasRebate"].string
        model.spec = j["spec"].string
        //特价商品促销信息
        model.hasSpePrice = "0"
        //有特价
        if let productPromotion = j["productPromotion"].dictionary {
            model.spePrice = productPromotion["promotionPrice"]?.float
            model.hasSpePrice = "1"
        }
        model.enterpriseId = j["enterpriseId"].string
        model.statusComplain = j["statusComplain"].string
        
        return model
    }
    
}

//旗舰店icon
final class FKYUltimateShopModel: NSObject, JSONAbleType {
    var enterpriseId: Int? //店铺id
    var enterpriseName: String? //店铺名称
    var enterpriseTypeList: String?
    var imgPath: String? //图片
    var title: String?    //标题
    var type:Int? //0普通店铺，1聚宝盆自由市场店铺
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYUltimateShopModel {
        let model = FKYUltimateShopModel()
        let j = JSON(json)
        model.enterpriseId = j["enterpriseId"].intValue
        model.enterpriseName = j["enterpriseName"].stringValue
        model.enterpriseTypeList = j["enterpriseTypeList"].stringValue
        model.imgPath = j["imgPath"].stringValue
        model.title = j["title"].stringValue
        model.type = j["type"].intValue
        return model
    }
}

final class FKYShopListModel: NSObject, JSONAbleType {
    var shopId: Int? //店铺id
    var shopName: String? //店铺名称
    var imgUrl: String? //
    var logo: String?
    
    var productCount: Int?//商品总数量
    var aloneCount : Int? //独家商品数量
    var accountType : String?//电子开户
    var shopPromotion : String?//店铺促销
    var tagStr : String?//标签
    var delivery : String?//快递
    
    var shop_url : String?
    var promotionListInfo :[FKYSpecialPriceModel]?//特价商品
    var couponsDes : String?//优惠券描述
    var mjPromotionDes : String? //满减描述
    var mzPromotionDes : String? //满赠描述
    var orderSamount : String?//起售最低金额
    var freefee : String?//包邮最低金额
    var tagArr :[Any]? //多快好省标签
    var typeArr :[String]? //类型标签
    var type:Int? //0普通店铺，1聚宝盆自由市场店铺
    
    var showOneActivity :Bool = false //自定活动1显示与否
    var showTwoActivity :Bool = false //自定活动2显示与否
    var showThreeActivity :Bool = false //自定义活动3显示与否
    var showTypeName: Bool = false //自定义店铺标签显示与否
    var typeNameH: CGFloat = 0.0 //自定义店铺标签的高度
    var collectionOffX : CGFloat = 0.0 //本地字段记录collecion的x偏移
    var follow :String? //默认关注 0未关注，1已关注
    
    static func fromJSON(_ json: [String : AnyObject]) -> FKYShopListModel {
        let j = JSON(json)
        
        let model = FKYShopListModel()
        model.shopId = j["enterpriseId"].intValue
        model.shopName = j["shopName"].stringValue
        model.imgUrl = j["imgUrl"].stringValue
        model.productCount = j["productCount"].intValue
        
        model.aloneCount = j["aloneCount"].intValue
        model.accountType = j["accountType"].stringValue
        model.shopPromotion = j["shopPromotion"].stringValue
        model.tagStr = j["label"].stringValue
        model.delivery = j["delivery"].stringValue
        
        model.shop_url = j["shop_url"].stringValue
        model.logo = j["logo"].stringValue
        model.type = j["type"].intValue
        model.follow = j["follow"].stringValue
        
        model.orderSamount = j["orderSamount"].stringValue
        if j["freefee"].numberValue == 0 {
            
        }else {
            model.freefee =  j["freefee"].numberValue.stringValue
        }
        
        let productList = j["promotionListInfo"].arrayObject
        //var promotionListInfo: [FKYSpecialPriceModel]? = []
        if let list = productList {
            model.promotionListInfo = (list as NSArray).mapToObjectArray(FKYSpecialPriceModel.self)
        }
        var tagArr :[Any] = []
        if let countNum = model.productCount ,countNum > 0 {
            tagArr.append(["多":"\(countNum)品种在售"])
        }
        if let str = model.delivery, str.count  > 0 {
            tagArr.append(["快":str])
        }
        if let countNum = model.aloneCount, countNum > 0 {
            tagArr.append(["好":"\(countNum)个独家品种"])
        }
        if let str = model.shopPromotion, str.count  > 0 {
            tagArr.append(["省":str])
        }
        model.tagArr = tagArr
        
        var typeArr :[String] = []
        if let str = model.orderSamount,str.count > 0 {
             typeArr.append(str+"元起送")
        }
        if let str = model.freefee ,str.count > 0{
            typeArr.append(str+"元包邮")
        }
        if let str = model.accountType ,str.count > 0 {
            typeArr.append(str)
        }
        if let str = model.tagStr ,str.count > 0 {
           let arr = str.components(separatedBy: CharacterSet(charactersIn: ","))
            typeArr =  typeArr + arr
        }
        if typeArr.count == 0 {
            typeArr.append("")
        }
        model.typeArr = typeArr
        
        //满减描述
        var mjPromotionDes = ""
        if  let mjArr = j["mjPromotionList"].array {
            for dic in mjArr  {
                if let des = dic["promotionDesc"].string{
                    if mjPromotionDes == "" {
                        mjPromotionDes = des
                    }else {
                        mjPromotionDes = mjPromotionDes + des
                    }
                }
            }
        }
        model.mjPromotionDes = mjPromotionDes
        
        //拼接优惠券描述信息
        var couponsDes :String = ""
        let couponsArr = j["coupons"].arrayObject
        if let list = couponsArr {
            for dic in list {
                let coupDetail = (dic as! NSDictionary).mapToObject(CouponTempModel.self)
                if couponsDes == "" {
                    couponsDes = "满\(coupDetail.limitprice!)减\(coupDetail.denomination!)"
                }else {
                    couponsDes = couponsDes+";满\(coupDetail.limitprice!)减\(coupDetail.denomination!)"
                }
               
            }
            if couponsDes != "" {
                couponsDes = couponsDes+";"
            }
            
        }
        model.couponsDes = couponsDes
       //满赠描述
        var mzPromotionDes = ""
        if  let mjArr = j["mzPromotionList"].array {
            for dic in mjArr  {
                if let des = dic["promotionDesc"].string{
                    if mzPromotionDes == "" {
                        mzPromotionDes = des
                    }else {
                        mzPromotionDes = mzPromotionDes + des
                    }
                }
            }
        }
        model.mzPromotionDes = mzPromotionDes
        
        return model
    }
}
//筛选模型
final class FKYShopSiftModel: NSObject, JSONAbleType {
    var tagId: String? //活动批号
    var tagName: String? //一起购开始时间
    static func fromJSON(_ json: [String : AnyObject]) -> FKYShopSiftModel {
        let model = FKYShopSiftModel()
        let j = JSON(json)
        model.tagId = j["id"].stringValue
        model.tagName = j["name"].stringValue
        return model
    }
}
