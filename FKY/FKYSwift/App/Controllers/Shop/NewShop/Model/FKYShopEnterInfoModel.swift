//
//  FKYShopEnterInfoModel.swift
//  FKY
//
//  Created by hui on 2019/11/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

//新店铺头部商家信息
final class FKYShopEnterInfoModel: NSObject, JSONAbleType {
    // MARK: - properties
    var account : String?               //开户
    var afterSale : String?             //售后
    var allProductCount : Int?       // 所有商品数
    var cellPhone: String?              //手机号
    var deliveryInstruction: String?    //物流
    var deliveryThreshold: String?    //起送门槛
    var enterpriseId: String?    //企业id
    var enterpriseName: String?    //企业名称
    var invoice: String?    //发票
    var notice: String?    //公告
    var postageThreshold: String?    //包邮门槛
    var telPhone: String?    //固定电话
    var ziYing: Bool?    //是否自营
    var ziyingWarehouseName: String? //自营仓名
    var realEnterpriseName : String?// 专区的自营企业名称
    var realEnterpriseId : String?// 专区的自营企业id
    var logo : String? //店铺logo图片
    var topAdList :[FKYShopAdArrModel]? //专区广告
    var tagArr = [FKYEnterTagTypeModel]() //本地处理字段
    var drugWelfareFlag : Bool? //是否是药福利<true是 false不是>
    var shopExtendTag : String? //店铺扩展标签（商家，xx仓，旗舰店，加盟店）
    var shopExtendType : Int? //店铺扩展类型（0普通店铺，1旗舰店 2加盟店 3自营店）
    
    // MARK: - life cycle
    @objc  static func fromJSON(_ json: [String : AnyObject]) -> FKYShopEnterInfoModel {
        let json = JSON(json)
        
        let model = FKYShopEnterInfoModel()
        model.account = json["account"].stringValue
        model.afterSale = json["afterSale"].stringValue
        model.allProductCount = json["allProductCount"].intValue
        model.cellPhone = json["cellPhone"].stringValue
        model.deliveryInstruction = json["deliveryInstruction"].stringValue
        model.deliveryThreshold = json["deliveryThreshold"].stringValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.enterpriseName = json["enterpriseName"].stringValue
        model.invoice = json["invoice"].stringValue
        model.notice = json["notice"].stringValue
        model.postageThreshold = json["postageThreshold"].stringValue
        model.telPhone = json["telPhone"].stringValue
        model.ziYing = json["ziYing"].boolValue
        model.ziyingWarehouseName = json["ziyingWarehouseName"].stringValue
        model.realEnterpriseName = json["realEnterpriseName"].stringValue
        model.realEnterpriseId = json["realEnterpriseId"].stringValue
        model.drugWelfareFlag = json["drugWelfareFlag"].boolValue
        if let list = json["topAdList"].arrayObject {
            model.topAdList = (list as NSArray).mapToObjectArray(FKYShopAdArrModel.self)
        }
        model.shopExtendTag = json["shopExtendTag"].stringValue
        model.shopExtendType = json["shopExtendType"].intValue
        model.logo = json["logo"].stringValue
        
        //（0普通店铺，1旗舰店 2加盟店 3自营店）
        if let str = model.shopExtendTag,str.isEmpty == false {
            let ziyingModel = FKYEnterTagTypeModel()
            if model.shopExtendType == 0 {
                ziyingModel.typeStr = "0"
                ziyingModel.typeName = ""
            }else if model.shopExtendType == 1 {
                ziyingModel.typeStr = "1"
                ziyingModel.typeName = str
            }else if model.shopExtendType == 2 {
                ziyingModel.typeStr = "2"
                ziyingModel.typeName = str
            }else if model.shopExtendType == 3 {
                ziyingModel.typeStr = "3"
                ziyingModel.typeName = str
            }
            model.tagArr.append(ziyingModel)
        }else if let isZY = model.ziYing, isZY == true {
            let ziyingModel = FKYEnterTagTypeModel()
            if let houseName = model.ziyingWarehouseName, houseName.isEmpty == false {
                if let _ = FKYSelfTagManager.shareInstance.tagNameImage(tagName: houseName, colorType: .red) {
                    ziyingModel.typeStr = "3"
                    ziyingModel.typeName = houseName
                }else {
                    ziyingModel.typeStr = "-1"
                    ziyingModel.typeName = "自营"
                }
            }else {
                ziyingModel.typeStr = "-1"
                ziyingModel.typeName = "自营"
            }
            model.tagArr.append(ziyingModel)
        }
        
        if let deliveryThreshold = model.deliveryThreshold, deliveryThreshold.isEmpty == false {
            let model1 = FKYEnterTagTypeModel()
            model1.typeStr = "-1"
            model1.typeName = "\(deliveryThreshold)元起送"
            model.tagArr.append(model1)
        }
        if let postageThreshold = model.postageThreshold, postageThreshold.isEmpty == false {
            let model2 = FKYEnterTagTypeModel()
            model2.typeStr = "-1"
            model2.typeName = "\(postageThreshold)元包邮"
            model.tagArr.append(model2)
        }
        return model
    }
}
//新店铺的广告轮播图
final class FKYShopAdArrModel: NSObject, JSONAbleType {
    // MARK: - properties
    var adUrl : String?            //广告图
    var jumpUrl : String?          //跳转地址
    var adName : String?          //广告图的名称
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopAdArrModel {
        let json = JSON(json)
        
        let model = FKYShopAdArrModel()
        model.jumpUrl = json["jumpUrl"].stringValue
        model.adUrl = json["adUrl"].stringValue
        model.adName = json["adName"].stringValue
        return model
    }
}

//新店铺促销信息及优惠券
final class FKYShopPromotionInfoModel: NSObject, JSONAbleType {
    // MARK: - properties
    var couponInfo : [FKYShopCouponsInfoModel]? //优惠券列表
    var floorInfo : [FKYShopPromotionBaseInfoModel]? //促销商品列表
    var floorTab : [FKYShopPromotionTabModel]?    // 促销tab列表
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopPromotionInfoModel {
        let json = JSON(json)
        
        let model = FKYShopPromotionInfoModel()
        if let list = json["couponInfo"].arrayObject {
            model.couponInfo = (list as NSArray).mapToObjectArray(FKYShopCouponsInfoModel.self)
        }
        if let list = json["floorInfo"].arrayObject {
            model.floorInfo = (list as NSArray).mapToObjectArray(FKYShopPromotionBaseInfoModel.self)
        }
        if let list = json["floorTab"].arrayObject {
            model.floorTab = (list as NSArray).mapToObjectArray(FKYShopPromotionTabModel.self)
        }
        return model
    }
}
//新店铺优惠券
final class FKYShopCouponsInfoModel: NSObject, JSONAbleType {
    // MARK: - properties
    var couponEndTime : String?               //结束时间
    var couponName : String?             //名称
    var couponSequence : String?       // 优惠券生成序号
    var couponStartTime: String?              //开始时间
    var tempType: Int?    //类型，0-店铺券 1-平台券
    var denomination: Float?    //面额
    var couponsId: String?    //优惠券id
    var isLimitAmount: Int?    //是否限制张数，1-限制 0-不限制
    var isLimitProduct: Int?    //是否限制商品，0-不限制 1-限制
    var isLimitShop: Int?    //是否限制店铺 0-不限 1-限制
    var limitprice: Float?    //满多少元可用
    var received: Bool?    //是否已领
    var repeatAmount: Int?    //用户可领数量
    var status: Int?    //状态
    var templateCode: String?    //模板号
    var couponTimeText : String?    //文描述
    var allowShops : [UseShopModel]? //可用商家模型
    var couponFullName: String?{ //优惠券名称
        get {
            return String(format: "满%.f减%.f",(limitprice ?? 0),(denomination ?? 0))
        }
    }
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopCouponsInfoModel {
        let json = JSON(json)
        
        let model = FKYShopCouponsInfoModel()
        model.couponEndTime = json["couponEndTime"].stringValue
        model.couponName = json["couponName"].stringValue
        model.couponSequence = json["couponSequence"].stringValue
        model.couponStartTime = json["couponStartTime"].stringValue
        model.tempType = json["tempType"].intValue
        model.denomination = json["denomination"].floatValue
        model.couponsId = json["id"].stringValue
        model.isLimitAmount = json["isLimitAmount"].intValue
        model.isLimitProduct = json["isLimitProduct"].intValue
        model.isLimitShop = json["isLimitShop"].intValue
        model.limitprice = json["limitprice"].floatValue
        model.received = json["received"].boolValue
        model.repeatAmount = json["repeatAmount"].intValue
        model.status = json["status"].intValue
        model.templateCode = json["templateCode"].stringValue
        model.couponTimeText = json["couponTimeText"].stringValue
        
        var couponDtoShopList = [UseShopModel]()
        if let arr = json["allowShops"].arrayObject {
            for dic in arr {
                if let json = dic as? [String : AnyObject] {
                    couponDtoShopList.append(UseShopModel.pareDicWithCommonJSON(json))
                }
                
            }
        }
        model.allowShops = couponDtoShopList
        return model
    }
}

//新店铺tab
final class FKYShopPromotionTabModel: NSObject, JSONAbleType {
    // MARK: - properties
    var floorId : String?            //楼层id
    var theme : String?             //楼层标题
    var str_w :CGFloat = 0   // 本地字段，记录标题的宽度
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopPromotionTabModel {
        let json = JSON(json)
        
        let model = FKYShopPromotionTabModel()
        model.floorId = json["floorId"].stringValue
        model.theme = json["theme"].stringValue
        if let str = model.theme {
            model.str_w = str.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t7.font], context: nil).size.width
        }
        return model
    }
}
//新店铺促销楼层
final class FKYShopPromotionBaseInfoModel: NSObject, JSONAbleType {
    // MARK: - properties
    var productList : [HomeRecommendProductItemModel]?    // 商品列表
    
    var countDownFlag: Int?
    var createTime: String?
    var createUser: String?
    var hotsaleFlag: Int?
    var iconImgPath: Int?
    var indexMobileId: Int?
    var newOrder: Int?
    var oftenBuyFlag: Int?
    var oftenViewFlag: Int?
    var originalPriceFlag: Int?   //只针对秒杀楼层进行判断（1显示，）
    var posIndex: Int?
    var promotionId: Int?  //一起购使用 促销ID
    var showNum: String?  //更多类型的文描
    // var show_num: String?
    
    var floorColor : Int? //楼层头部背景颜色
    var id: Int?
    var type: Int?//楼层类型
    var imgPath: String?
    var jumpInfo: String?
    var jumpType: Int? //
    var name: String?  //楼层名字
    var siteCode: Int?  //站点
    var indexFloor: String?
    var jumpExpandOne: String?
    var jumpExpandTwo: String?
    var jumpExpandThree: String?
    var downTime: String?//倒计时时间
    var upTime: String?//倒计时时间
    var downTimeMillis:Int64?//倒计时时间
    var upTimeMillis:Int64? //倒计时时间
    var sysTimeMillis: Int64?       // 系统当前时间戳
    
    var title: String?
    var jumpInfoMore: String? //更多链接
    var togetherMark: Int? // 1 一起购  2一起返 一起
    var showSequence: Int? //第几个品 或者活动
    var disCountDesc: String? //折后价
    var hasMore :Bool? //是否有更多按钮
    
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopPromotionBaseInfoModel {
        let json = JSON(json)
        let model = FKYShopPromotionBaseInfoModel()
        model.countDownFlag = json["countDownFlag"].intValue
        model.createTime = json["createTime"].string
        model.createUser = json["createUser"].string
        model.hotsaleFlag = json["hotsaleFlag"].intValue
        model.iconImgPath = json["iconImgPath"].intValue
        model.indexMobileId = json["indexMobileIde"].intValue
        model.newOrder = json["newOrder"].intValue
        model.oftenBuyFlag = json["oftenBuyFlage"].intValue
        model.oftenViewFlag = json["oftenViewFlag"].intValue
        model.originalPriceFlag = json["originalPriceFlag"].intValue
        model.posIndex = json["posIndex"].intValue
        model.promotionId = json["promotionId"].intValue
        model.showNum = json["showNum"].string
        //model.show_num = json["show_num"].string
        model.showSequence = json["showSequence"].intValue
        
        model.floorColor = json["floorColor"].intValue
        model.id = json["id"].intValue
        model.type = json["type"].intValue
        model.imgPath = json["imgPath"].string
        model.jumpInfo = json["jumpInfo"].string
        
        model.togetherMark = json["togetherMark"].intValue
        model.jumpType = json["jumpType"].intValue
        model.name = json["name"].string
        model.siteCode = json["siteCode"].intValue
        model.indexFloor = json["indexFloor"].string
        model.jumpExpandOne = json["jumpExpandOne"].string
        model.jumpExpandTwo = json["jumpExpandTwo"].string
        model.jumpExpandThree = json["jumpExpandThree"].string
        model.downTimeMillis = json["downTimeMillis"].int64Value
        model.upTimeMillis = json["upTimeMillis"].int64Value
        model.sysTimeMillis = json["sysTimeMillis"].int64Value
        model.downTime = json["downTime"].string
        model.upTime = json["upTime"].string
        model.title = json["title"].string
        model.jumpInfoMore = json["jumpInfoMore"].string
        model.disCountDesc = json["disCountDesc"].string
        if let list = json["floorProductDtos"].arrayObject {
            model.productList = (list as NSArray).mapToObjectArray(HomeRecommendProductItemModel.self)
        }
        model.hasMore = json["hasMore"].boolValue
        return model
    }
}
//新店铺促销楼层
final class FKYShopPromotionBaseProductModel: NSObject, JSONAbleType {
    // MARK: - properties
    
    var maxPackage : Int?     //大包装
    var minPackage : Int?     //最小包装
    var productImg : String?     //商品图
    var productStatus : Bool?     //购买状态
    var shortName : String?     //通用名
    var showPrice : String?     //显示购买价格
    
    var otherPromotionTag : Bool?     //是否有其他促销标
    var couponTag : Bool?       //是否有领券标
    var rebateTag : Bool?     //是否有返利标签
    var specialTag : Bool?     //是否有特价标
    var vipTag : Bool?     //是否有会员标
    var promotionType : [String]?     //其他促销类型
    var spuCode : String?     //
    var statusComplain : String?     //价格描述
    var statusDesc : String?     //价格状态
    var sellerCode : String?     //店铺id
    var specialPromotionLimitNum : Int?     //特价限购数量
    var weekLimitNum : Int?     //周限购数量
    var surplusBuyNum : Int?     //周剩余限购数量
    var unit : String? //单位
    var productName : String? //商品名称
    var price : Float? //原价格
    var promotionPrice : Float? //特价
    var availableVipPrice : Float?              // 可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?                // 可见会员价（非会员和会员都有）
    var vipLimitNum :NSInteger?                 // vip限购数量
    var vipPromotionId :String?                 // vip活动id
    var discountPrice: String?                  // 折后价
    var discountPriceDesc: String?                  // 折后价
    var stockCountDesc : String?                  // 库存描述
    var deadLine : String?                  // 有效期
    var productionTime : String?                  // 生产日期
    var currentInventory : Int? //库存数量
    var spec : String?                  // 规格
    var productPromotion: ShopItemProductPromotionModel?
    
    var tagArr = [String]() //标签
    //购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var carId :Int = 0
    var carOfCount :Int = 0
    //埋点字段
    var storage: String?{ //可购买数量
        get {
            var numList:[String] = []
            
            //剩余限购数量
            if let limitNum = specialPromotionLimitNum ,limitNum > 0 {
                numList.append("\(limitNum)")
            }else if let limitNum = vipLimitNum ,limitNum > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0{
                    numList.append("\(limitNum)")
                }
            }
            var canBuyNum = 0
            if let limitNum = surplusBuyNum ,limitNum > 0 {
                canBuyNum = limitNum
            }
            if let count = currentInventory ,count>0{
                if (canBuyNum > count || canBuyNum == 0){
                    canBuyNum = count
                }
            }
            numList.append(String(canBuyNum))
            return numList.count == 0 ? "0":numList.joined(separator: "|")
        }
    }
    var pm_price: String?{ //可购买价格  埋点专用 自定义
        get {
            var priceList:[String] = []
            //会员价 特价 原价
            if let promotionNum =  promotionPrice , promotionNum > 0  {
                //特价
                priceList.append(String(format: "%.2f",promotionNum))
            }else if let _ = vipPromotionId, let vipNum = visibleVipPrice, vipNum > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                    //会员
                    priceList.append(String(format: "%.2f",vipAvailableNum))
                }
            }
            //原价
            if let priceStr = price, priceStr > 0 {
                priceList.append(String(format: "%.2f",priceStr))
            }
            return priceList.count == 0 ?  ProductStausUntily.getProductStausDesc(Int(statusDesc ?? "0") ?? 0):priceList.joined(separator: "|")
        }
    }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
        get {
            var pmList:[String] = []
            pmList.append(contentsOf: tagArr)
            // 协议返利金
            //            if sign.bounty == true{
            //                pmList.append("协议奖励金")
            //            }
            if let limitNum = weekLimitNum , limitNum > 0{
                pmList.append("限购")
            }
            if let _ = vipPromotionId, let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                pmList.append("会员")
            }
            return pmList.joined(separator: ",")
        }
    }
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopPromotionBaseProductModel {
        let json = JSON(json)
        
        let model = FKYShopPromotionBaseProductModel()
        model.maxPackage = json["maxPackage"].intValue
        model.minPackage = json["minPackage"].intValue
        model.productImg = json["productImg"].stringValue
        model.productStatus = json["productStatus"].boolValue
        model.shortName = json["shortName"].stringValue
        model.productName = json["productName"].stringValue
        model.showPrice = json["showPrice"].stringValue
        model.otherPromotionTag = json["otherPromotionTag"].boolValue
        model.couponTag = json["couponTag"].boolValue
        model.rebateTag = json["rebateTag"].boolValue
        model.specialTag = json["specialTag"].boolValue
        model.spuCode = json["spuCode"].stringValue
        model.minPackage = json["minPackage"].intValue
        model.statusComplain = json["statusComplain"].stringValue
        model.statusDesc = json["statusDesc"].stringValue
        if let list = json["promotionType"].arrayObject as? [String] {
            model.promotionType = list
        }
        model.sellerCode = json["sellerCode"].stringValue
        model.specialPromotionLimitNum = json["specialPromotionLimitNum"].intValue
        model.weekLimitNum = json["weekLimitNum"].intValue
        model.unit = json["unit"].stringValue
        model.price = json["price"].floatValue
        model.promotionPrice = json["promotionPrice"].floatValue
        model.availableVipPrice = json["availableVipPrice"].floatValue
        model.visibleVipPrice = json["visibleVipPrice"].floatValue
        model.vipLimitNum = json["vipLimitNum"].intValue
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.discountPrice = json["promotionPrice"].stringValue
        model.discountPriceDesc = json["discountPriceDesc"].stringValue
        model.stockCountDesc = json["stockCountDesc"].stringValue
        model.deadLine = json["deadLine"].stringValue
        model.productionTime = json["productionTime"].stringValue
        model.currentInventory = json["currentInventory"].intValue
        model.spec = json["spec"].stringValue
        model.surplusBuyNum = json["surplusBuyNum"].intValue
        if let dic = json["productPromotion"].dictionaryObject as NSDictionary? {
            model.productPromotion = dic.mapToObject(ShopItemProductPromotionModel.self)
        }
        
        if model.specialTag == true {
            model.tagArr.append("特价")
        }
        if model.couponTag == true {
            model.tagArr.append("券")
        }
        //会员  会员才加入 有会员价的商品
        if let _ = model.vipPromotionId, let visibleVipPrice = model.visibleVipPrice ,visibleVipPrice > 0 {
            model.tagArr.append("会员")
            model.vipTag = true
        }else{
            model.vipTag = false
        }
        if model.rebateTag == true {
            model.tagArr.append("返利")
        }
        if let arr = model.promotionType ,arr.count > 0 {
            if arr.contains("2") || arr.contains("3") {
                //满减
                model.tagArr.append("满减")
            }
            if arr.contains("5") || arr.contains("6") || arr.contains("7") || arr.contains("8") {
                //满赠
                model.tagArr.append("满赠")
            }
            if arr.contains("13") {
                //套餐
                model.tagArr.append("套餐")
            }
            if arr.contains("15") ||  arr.contains("16") {
                //满折
                model.tagArr.append("满折")
            }
        }
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == Int(model.sellerCode ?? "0") {
                model.carOfCount = cartOfInfoModel.buyNum.intValue
                model.carId = cartOfInfoModel.cartId.intValue
                break
            }
        }
        return model
    }
}

final class FKYEnterTagTypeModel: NSObject, JSONAbleType {
    // MARK: - properties
    var typeStr : String?            //标签类型
    var typeName : String?             //标签名字
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYEnterTagTypeModel {
        let json = JSON(json)
        
        let model = FKYEnterTagTypeModel()
        model.typeStr = json["typeStr"].stringValue
        model.typeName = json["typeName"].stringValue
        return model
    }
}
final class FKYfullReductionInfoVoModel: NSObject, JSONAbleType {
    // MARK: - properties
    var promotionDesc : String?            //满折描述
    var promotionId : String?             //满折促销id
    var promotionType : String?             //促销类型
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYfullReductionInfoVoModel {
        let json = JSON(json)
        let model = FKYfullReductionInfoVoModel()
        model.promotionDesc = json["promotionDesc"].stringValue
        model.promotionId = json["promotionId"].stringValue
        model.promotionType = json["promotionType"].stringValue
        return model
    }
}


//新店铺头部信息及优惠券列表
final class FKYShopEnterAndCouponInfoModel: NSObject, JSONAbleType {
    // MARK: - properties
    var couponInfo : [FKYShopCouponsInfoModel]? //优惠券列表
    var enterpriseInfoVO : FKYShopEnterInfoModel? //店铺头部信息
    var fullReductionInfoVo : FKYfullReductionInfoVoModel? //促销
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopEnterAndCouponInfoModel {
        let json = JSON(json)
        
        let model = FKYShopEnterAndCouponInfoModel()
        if let list = json["couponInfo"].arrayObject {
            model.couponInfo = (list as NSArray).mapToObjectArray(FKYShopCouponsInfoModel.self)
        }
        if let dic = json["enterpriseInfoVO"].dictionary {
            model.enterpriseInfoVO = (dic as NSDictionary).mapToObject(FKYShopEnterInfoModel.self)
        }
        if let dic = json["fullReductionInfoVo"].dictionary {
            model.fullReductionInfoVo = (dic as NSDictionary).mapToObject(FKYfullReductionInfoVoModel.self)
        }
        return model
    }
}
//新店铺为你推荐商品列表
final class FKYShopRecommendInfoModel: NSObject, JSONAbleType {
    // MARK: - properties
    var totalPageCount : Int? //优惠券列表
    var floorName : String? //楼层名称
    var productList : [HomeCommonProductModel]? //店铺头部信息
    
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopRecommendInfoModel {
        let json = JSON(json)
        
        let model = FKYShopRecommendInfoModel()
        model.totalPageCount = json["totalPageCount"].intValue
        if let arr = json["list"].arrayObject {
            model.productList = (arr as NSArray).mapToObjectArray(HomeCommonProductModel.self)
        }
        return model
    }
}
//新店铺配置楼层cell
final class FKYShopOperateCellModel: NSObject, JSONAbleType {
    // MARK: - properties
    var cellList : [Any]? //店铺头部信息
    var hasNavList : Bool = false //判断是否有导航按钮栏目
    // MARK: - life cycle
    @objc static func fromJSON(_ json: [String : AnyObject]) -> FKYShopOperateCellModel {
        let json = JSON(json)
        
        let model = FKYShopOperateCellModel()
        var desArr = [Any]()
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
                                                        let productModel = (recommendDic as NSDictionary).mapToObject(HomeADInfoModel.self)
                                                        if let arr = productModel.iconImgDTOList ,arr.count > 0 {
                                                            let adModel =  HomeADCellModel.init()
                                                            adModel.model = productModel
                                                            desArr.append(adModel)
                                                        }
                                                    }else if floorStyle.intValue == 2{
                                                        
                                                        let productModel = (recommendDic as NSDictionary).mapToObject(HomeADInfoModel.self)
                                                        if let arr = productModel.iconImgDTOList ,arr.count > 0 {
                                                            let adModel =  HomeTwoADCellModel.init()
                                                            adModel.model = productModel
                                                            desArr.append(adModel)
                                                        }
                                                    }else if floorStyle.intValue == 3{
                                                        
                                                        let productModel = (recommendDic as NSDictionary).mapToObject(HomeADInfoModel.self)
                                                        if let arr = productModel.iconImgDTOList ,arr.count > 0 {
                                                            let adModel =  HomeThreeADCellModel.init()
                                                            adModel.model = productModel
                                                            desArr.append(adModel)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }else if templateType.intValue == 1{
                                //轮播图
                                if  desDic.keys.contains("contents") {
                                    if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,contentsDic.keys.contains("banners"){
                                        // if let bannersArray = contentsDic["banners"] as? NSDictionary{
                                        let bannersModel:HomeCircleBannerModel = (contentsDic as NSDictionary).mapToObject(HomeCircleBannerModel.self)
                                        if let bannerList = bannersModel.banners,bannerList.isEmpty == false{
                                            desArr.append(bannersModel)
                                        }
                                        
                                        //  }
                                    }
                                }
                            }else  if templateType.intValue == 14{
                                //导航按钮
                                if  desDic.keys.contains("contents") {
                                    if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,contentsDic.keys.contains("Navigation"){
                                        //if let navArray = contentsDic["Navigation"] as? NSDictionary{
                                        let navModel:HomeFucButtonModel = (contentsDic as NSDictionary).mapToObject(HomeFucButtonModel.self)
                                        if let navigations = navModel.navigations,navigations.isEmpty == false{
                                            desArr.append(navModel)
                                            model.hasNavList = true
                                        }else{
                                           model.hasNavList = false
                                        }
                                        
                                        //  }
                                    }
                                }
                            }else if templateType.intValue == 18 {
                                //3*n 热销（普通商品）
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendDic = contentsDic["recommend"] as? Dictionary<String,AnyObject> {
                                    let hotModel = (recommendDic as NSDictionary).mapToObject(FKYShopPromotionBaseInfoModel.self)
                                    desArr.append(hotModel)
                                }
                            }else if templateType.intValue == 19 {
                                //3*n （特价，会员，套餐）
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendDic = contentsDic["recommend"] as? Dictionary<String,AnyObject> {
                                    let hotModel = (recommendDic as NSDictionary).mapToObject(FKYShopPromotionBaseInfoModel.self)
                                    desArr.append(hotModel)
                                }
                            }else if templateType.intValue == 16 {
                                //秒杀
                                if let contentsDic = desDic["contents"] as? Dictionary<String,AnyObject> ,let recommendDic = contentsDic["recommend"] as? Dictionary<String,AnyObject> {
                                    if let floorStyle = recommendDic["floorStyle"] as? Int ,floorStyle == 5 {
                                        //多品秒杀
                                        let killModel = (recommendDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
                                        let killCellModel = HomeSecKillCellModel.init()
                                        killCellModel.model = killModel
                                        desArr.append(killCellModel)
                                    }
                                    if let floorStyle = recommendDic["floorStyle"] as? Int ,floorStyle == 4 {
                                        //单品品秒杀
                                        let killModel = (recommendDic as NSDictionary).mapToObject(HomeSecdKillProductModel.self)
                                        let killCellModel = HomeSingleSecKillCellModel.init()
                                        killCellModel.model = killModel
                                        desArr.append(killCellModel)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        model.cellList = desArr
        return model
    }
}
