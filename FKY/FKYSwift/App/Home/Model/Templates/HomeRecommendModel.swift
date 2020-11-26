//
//  HomeRecommendModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  首页首推特价（药城精选）之数据model

import SwiftyJSON

final class HomeRecommendModel: NSObject, JSONAbleType {
    // 接口返回字段
    var salesDynamics: [String]?                // 消息列表
    var recommend: HomeRecommendItemModel?      // 商品列表对象
    // 本地新增业务逻辑字段
    var indexMsg: Int = 0                       // 消息列表索引
    var indexItem: Int = 0                      // 当前商品索引<用于分页>
    var floorName: String?                      // 楼层名称
    
    init(salesDynamics: [String]?, recommend:HomeRecommendItemModel?) {
        self.salesDynamics = salesDynamics
        self.recommend = recommend
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRecommendModel {
        let json = JSON(json)
        
        var salesDynamics: [String]?
        if let list = json["salesDynamics"].arrayObject {
            salesDynamics = list as? [String]
        }
        
        var recommend: HomeRecommendItemModel?
        if let dic = json["recommend"].dictionary {
            recommend = (dic as NSDictionary).mapToObject(HomeRecommendItemModel.self)
        }
        
        return HomeRecommendModel(salesDynamics: salesDynamics, recommend: recommend)
    }
}

//extension HomeRecommendModel: HomeModelInterface {
//    func floorIdentifier() -> String {
//        return "HomeRecommendListCell"
//    }
//}


/*
 recommend
 name:名称
 siteCode:分站编码
 imgPath:图片
 url:url链接
 jumpInfo:根据类型 1为空，2商品supcode，3类目编码，4店铺id，5活动url
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
final class HomeRecommendItemModel: NSObject, JSONAbleType {
    var createTime: String?
    var id: Int?
    var type: Int?
    var imgPath: String?
    var jumpInfo: String?
    var jumpType: String?
    var name: String?
    var posIndex: Int?
    var siteCode: String?
    var indexMobileId: Int?
    var jumpExpandOne: String?
    var jumpExpandTwo: String?
    var jumpExpandThree: String?
    var floorProductDtos: [HomeRecommendProductItemModel]? // 商品列表
    var jumpInfoMore: String? //更多链接
    
    init(floorProductDtos: [HomeRecommendProductItemModel]?) {
        self.floorProductDtos = floorProductDtos
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRecommendItemModel {
        let json = JSON(json)
        
        let createTime = json["createTime"].stringValue
        let id = json["id"].intValue
        let type = json["type"].intValue
        let imgPath = json["imgPath"].stringValue
        let jumpInfo = json["jumpInfo"].stringValue
        let jumpType = json["jumpType"].stringValue
        let name = json["name"].stringValue
        let posIndex = json["posIndex"].intValue
        let siteCode = json["siteCode"].stringValue
        let indexMobileId = json["indexMobileId"].intValue
        let jumpExpandOne = json["jumpExpandOne"].stringValue
        let jumpExpandTwo = json["jumpExpandTwo"].stringValue
        let jumpExpandThree = json["jumpExpandThree"].stringValue
        let jumpInfoMore = json["jumpInfoMore"].stringValue
        
        var floorProductDtos: [HomeRecommendProductItemModel]?
        if let list = json["floorProductDtos"].arrayObject {
            floorProductDtos = (list as NSArray).mapToObjectArray(HomeRecommendProductItemModel.self)
        }
        
        let model = HomeRecommendItemModel(floorProductDtos: floorProductDtos)
        model.createTime = createTime
        model.id = id
        model.type = type
        model.imgPath = imgPath
        model.jumpInfo = jumpInfo
        model.jumpType = jumpType
        model.name = name
        model.posIndex = posIndex
        model.siteCode = siteCode
        model.indexMobileId = indexMobileId
        model.jumpExpandOne = jumpExpandOne
        model.jumpExpandTwo = jumpExpandTwo
        model.jumpExpandThree = jumpExpandThree
        model.jumpInfoMore = jumpInfoMore
        return model
    }
}

/*
 floorProductDtos
 factoryId：//厂商ID
 factoryName;//厂商名称
 inimumPacking;//商品起批量
 inventory;//活动存在时为活动库存，不存在则为商品实际库存
 promotionlimitNum;//活动限购数量
 productId;//商品ID
 productCodeCompany;//本公司编码
 promotionId;// //满赠 活动id
 promotionCollectionId;//满减活动ID
 unit;//单位
 statusDesc; //购买状态 //0:正常显示价格, -1:登录后可见, -2:加入渠道后可见, -3:资质认证后可见, -4:渠道待审核, -5:缺货, -6:不显示, -7:下架,-8 无采购权限 -9:申请权限后可见 -10：权限审核后可见
 statusMsg; //购买值
 productInventory; // 商品实际库存
 isChannel; //是否渠道商品
 productName;//药品名称
 productCode;//药品编码
 imgPath;//药品图片路径
 productSupplyId;//药品供应商编码
 productSupplyName;//供应商名称
 productSpec;//药品规格
 */
final class HomeRecommendProductItemModel: NSObject, JSONAbleType {
    var createTime: String?         //
    var factoryId: String?          // 厂商ID
    var factoryName: String?        // 厂商名称
    var id: Int?                    //
    var imgPath: String?            // 药品图片路径
    var indexMobileFloorId: Int?    //
    var indexMobileId: Int?         //
    var inimumPacking: Int?         // 最小拆零包装
    var wholeSaleNum: Int?        // 最小起批量
    var weeklyPurchaseLimit: Int?   // 活动楼层商品的周限购量
    var inventory: Int?             // 活动存在时为活动库存，不存在则为商品实际库存
    var isChannel: Int?             // 是否渠道商品
    var posIndex: Int?              //
    var productCode: String?        // 药品编码
    var productInventory: Int?      // 商品实际库存
    var productName: String?        // 药品名称
    var productPrice: Double?       // 价格...<原价>
    var availableVipPrice :Float?   //会员价格，有值，大于0 代表是会员
    var visibleVipPrice : Float?           //可见会员价（非会员和会员都有）
    var vipLimitNum :NSInteger?            //vip限购数量
    var vipPromotionId :String?            //vip活动id
    var productSpec: String?        // 药品规格
    var productSupplyId: String?    // 药品供应商编码
    var productSupplyName: String?  // 供应商名称
    var shortName: String?          // 商品通用名
    var siteCode: String?           //
    var specialPrice: Double?       // 优惠价...<现价>
    var statusDesc: Int?            // 购买状态
    var statusMsg: String?          // 购买值
    var unit: String?               // 单位
    
    var spuCode: String? // 商品编码
    var supplyId: Int? // 供应商编号
    var isZiYingFlag: Int?            // 有效期
    var expiryDate: String?               // 单位
    var productionTime: String?               // 生产日期
    var soldPercent: Int?               // 已售百分比
    var orderNum: Int?               //已下单人数（2019.2.30需要只有秒杀与一起购需要,从订单接口获取）
    var tagArr = [String]() //标签<自定义字段>
    var vipTag : Bool?     //是否有会员标<自定义字段>
    
    // 一起系列增加的数据
    var showPrice: String?              //
    var buyTogetherJumpInfo: String?    // 一起购商品详情链接
    var buyTogetherId: Int?             // 一起购商品活动id
    
    // 秒杀专区新增字段
    var promotionId: String?            // 活动id
    var productCodeCompany: String?     // 本公司编码
    var downTime: String?               //
    var upTime: String?                 //
    var productId: String?              // 商品ID
    var promotionCollectionId: String?  //
    var promotionTotalInventory: Int?    //活动总库存/活动总限购量
    var promotionlimitNum: Int?     // 活动限购数量
    var surplusBuyNum: Int?     // /本周剩余限购数量就行了，这个值=0了就不能加车了，特价限购量到了还是可以加车的
    // 店铺馆列表页改版-促销标签打标
    var productSign: ProductSignModel?
    var brandLable: Int? // 商品标签：1.无 2.专供 3.限量 4.独家
    
    var singleCanBuy :Int? //单品是否可购买，0-可购买，1-不可（显示套餐按钮）
    //新首页推荐
    var lowestPrice : Double?  //最低价
    var sellerCount : Int?  //商家总数
    
    @objc var carId: Int = 0 // 购物车id
    @objc var carOfCount: Int = 0 // 购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    
    var showSequence:Int = 1 // 列表中第几个活动 自定义字段
    
    var  isTogetherProduct: Bool = false  //是否是一起购商品
    
    
    var  shareStock: HomeShareStockModel? //分享库存
    
    var  disCountDesc: String? // 折后价
    //var  inventory : Int? //不返回则隐藏全部抢完图标，为<=0显示
    
    var stockCountDesc : String? //库存描述
    var productFullName: String?{ //商品全名 名字加规格
           get {
               return (shortName ?? "")
           }
       }
    var storage: String?{ //可购买数量
        get {
            var numList:[String] = []
            
            //剩余限购数量
            if promotionlimitNum != nil &&  promotionlimitNum! > 0 {
                numList.append(String(promotionlimitNum!))
            }else if vipLimitNum != nil &&  vipLimitNum! > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0{
                    numList.append(String(vipLimitNum!))
                }
            }
            var canBuyNum = 0
            if  surplusBuyNum != nil && surplusBuyNum! > 0 {
                canBuyNum = surplusBuyNum!
            }
            if let count = productInventory ,count>0{
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
            if let promotionNum =  specialPrice , promotionNum > 0  {
                //特价
                priceList.append(String(format: "%.2f",promotionNum))
            }else if let _ = vipPromotionId, let vipNum = visibleVipPrice, vipNum > 0 {
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                    //会员
                    priceList.append(String(format: "%.2f",vipAvailableNum))
                }
            }
            //原价
            if let priceStr = productPrice, priceStr > 0 {
                priceList.append(String(format: "%.2f",priceStr))
            }
            return priceList.count == 0 ?  ProductStausUntily.getProductStausDesc(statusDesc ?? 0):priceList.joined(separator: "|")
        }
    }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
        get {
            var pmList:[String] = []
            if let sign = productSign {
                if sign.fullScale == true{
                    pmList.append("满减")
                }
                if sign.fullGift == true{
                    pmList.append("满赠")
                }
                // 15:单品满折,16多品满折
                if sign.fullDiscount == true{
                    pmList.append("满折")
                }
                // 返利金
                if sign.rebate == true{
                    pmList.append("返利")
                }
                // 协议返利金
                if sign.bounty == true{
                    pmList.append("协议奖励金")
                }
                // 套餐
                if sign.packages == true{
                    pmList.append("套餐")
                }
                // 限购
                if sign.purchaseLimit == true{
                    pmList.append("限购")
                }
                //特价
                if sign.specialOffer == true{
                    pmList.append("特价")
                }
                //会员  会员才加入 有会员价的商品
                if let _ = vipPromotionId, let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0 {
                    pmList.append("会员")
                }
                // 优惠券
                if sign.ticket == true{
                    pmList.append("券")
                }
            }
            return pmList.joined(separator: ",")
        }
    }
    
    // 界面展示所需的必要字段
    init(id: Int?, imgPath: String?, productName: String?, productSpec: String?, productPrice: Double?) {
        self.id = id
        self.imgPath = imgPath
        self.productName = productName
        self.productSpec = productSpec
        self.productPrice = productPrice
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeRecommendProductItemModel {
        let json = JSON(json)
        
        let createTime = json["createTime"].stringValue
        let factoryId = json["factoryId"].stringValue
        let factoryName = json["factoryName"].stringValue
        let id = json["id"].intValue
        let imgPath = json["imgPath"].stringValue
        let indexMobileFloorId = json["indexMobileFloorId"].intValue
        let indexMobileId = json["indexMobileId"].intValue
        let inimumPacking = json["inimumPacking"].intValue
        let wholeSaleNum = json["wholeSaleNum"].intValue
        let weeklyPurchaseLimit = json["weeklyPurchaseLimit"].intValue
        
        let inventory = json["inventory"].int
        let isChannel = json["isChannel"].intValue
        let posIndex = json["posIndex"].intValue
        let productCode = json["productCode"].stringValue
        let productInventory = json["productInventory"].intValue
        let productName = json["productName"].stringValue
        let productPrice = json["productPrice"].doubleValue
        let productSpec = json["productSpec"].stringValue
        let productSupplyId = json["productSupplyId"].stringValue
        let productSupplyName = json["productSupplyName"].stringValue
        let promotionlimitNum = json["promotionlimitNum"].intValue
        let shortName = json["shortName"].stringValue
        let siteCode = json["siteCode"].stringValue
        let specialPrice = json["specialPrice"].doubleValue
        let statusDesc = json["statusDesc"].intValue
        let statusMsg = json["statusMsg"].stringValue
        let unit = json["unit"].stringValue
        
        let spuCode = json["productCode"].stringValue
        let supplyId = json["productSupplyId"].intValue
        let isZiYingFlag = json["isZiYingFlag"].intValue
        let orderNum = json["orderNum:"].intValue
        let expiryDate = json["expiryDate"].stringValue
        let productionTime = json["productionTime"].stringValue
        
        var soldPercent: Int?
        if  json["soldPercent"] != JSON.null {
            soldPercent = json["soldPercent"].intValue
        }
        let showSequence = json["showSequence"].intValue
        
        let showPrice = json["showPrice"].stringValue
        let buyTogetherJumpInfo = json["buyTogetherJumpInfo"].stringValue
        let buyTogetherId = json["buyTogetherId"].intValue
        
        let promotionId = json["promotionId"].stringValue
        let productCodeCompany = json["productCodeCompany"].stringValue
        let downTime = json["downTime"].stringValue
        let upTime = json["upTime"].stringValue
        let productId = json["productId"].stringValue
        let promotionCollectionId = json["promotionCollectionId"].stringValue
        let promotionTotalInventory = json["promotionTotalInventory"].intValue
        var productSign: ProductSignModel?
        if let dic = json["productSign"].dictionary {
            productSign = (dic as NSDictionary).mapToObject(ProductSignModel.self)
        }
        let brandLable = json["brandLable"].intValue
        
        
        let model = HomeRecommendProductItemModel(id: id, imgPath: imgPath, productName: productName, productSpec: productSpec, productPrice: productPrice)
        model.createTime = createTime
        model.factoryId = factoryId
        model.factoryName = factoryName
        model.indexMobileFloorId = indexMobileFloorId
        model.indexMobileId = indexMobileId
        model.inimumPacking = inimumPacking
        model.weeklyPurchaseLimit = weeklyPurchaseLimit
        model.wholeSaleNum = wholeSaleNum
        
        model.inventory = inventory
        model.isChannel = isChannel
        model.posIndex = posIndex
        model.productCode = productCode
        model.productInventory = productInventory
        model.productSupplyId = productSupplyId
        model.productSupplyName = productSupplyName
        model.promotionlimitNum = promotionlimitNum
        model.shortName = shortName
        model.siteCode = siteCode
        model.specialPrice = specialPrice
        model.statusDesc = statusDesc
        model.statusMsg = statusMsg
        model.unit = unit
        model.showPrice = showPrice
        
        model.buyTogetherJumpInfo = buyTogetherJumpInfo
        model.buyTogetherId = buyTogetherId
        model.promotionId = promotionId
        model.productCodeCompany = productCodeCompany
        model.downTime = downTime
        model.upTime = upTime
        model.productId = productId
        model.promotionCollectionId = promotionCollectionId
        model.productSign = productSign
        model.brandLable = brandLable
        
        model.isZiYingFlag = isZiYingFlag
        model.orderNum = orderNum
        model.expiryDate = expiryDate
        model.productionTime = productionTime
        model.soldPercent = soldPercent
        model.promotionTotalInventory = promotionTotalInventory
        
        model.supplyId = supplyId
        model.spuCode = spuCode
        model.showSequence = showSequence
        model.disCountDesc = json["disCountDesc"].stringValue
        //model.inventory = json["inventory"].int
        model.availableVipPrice = json["availableVipPrice"].floatValue
        if let vipPriceNum = Float(json["visibleVipPrice"].stringValue), vipPriceNum > 0 {
            model.visibleVipPrice = vipPriceNum
        }
        if let vipNum = Int(json["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = json["vipPromotionId"].stringValue
        if let dic = json["shareStock"].dictionary {
            model.shareStock = (dic as NSDictionary).mapToObject(HomeShareStockModel.self)
        }
        model.stockCountDesc = json["stockCountDesc"].stringValue
        model.lowestPrice = json["lowestPrice"].doubleValue
        model.sellerCount = json["sellerCount"].intValue
        model.singleCanBuy = json["singleCanBuy"].intValue
        //店铺中，热销商品使用到的数据
        
        if let sign = model.productSign {
            if sign.liveStreamingFlag == true {
                model.tagArr.append("直播价")
            }
            if sign.slowPay == true {
                model.tagArr.append("慢必赔")
            }
            if sign.holdPrice == true {
                model.tagArr.append("保价")
            }
            //奖励金的标
            if sign.bonusTag == true {
                model.tagArr.append("奖励金")
            }
            //特价
            if sign.specialOffer == true{
                model.tagArr.append("特价")
            }
            // 优惠券
            if sign.ticket == true{
                model.tagArr.append("券")
            }
            //会员  会员才加入 有会员价的商品
            if let _ = model.vipPromotionId, let vipAvailableNum = model.availableVipPrice ,vipAvailableNum > 0 {
                model.tagArr.append("会员")
                model.vipTag = true
            }else {
                model.vipTag = false
            }
            // 返利金
            if sign.rebate == true{
                model.tagArr.append("返利")
            }
            
            if sign.fullScale == true{
                model.tagArr.append("满减")
            }
            if sign.fullGift == true{
                model.tagArr.append("满赠")
            }
            // 15:单品满折,16多品满折
            if sign.fullDiscount == true{
                model.tagArr.append("满折")
            }
            // 套餐
            if sign.packages == true{
                model.tagArr.append("套餐")
            }
        }
        
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                if cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == (model.supplyId ?? 0) {
                    model.carOfCount = cartOfInfoModel.buyNum.intValue
                    model.carId = cartOfInfoModel.cartId.intValue
                    break
                } else {
                    model.carOfCount = 0
                    model.carId = 0
                }
            }
        }
        
        return model
    }
}
