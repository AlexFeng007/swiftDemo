//
//  HomeCommonProductModel.swift
//  FKY
//
//  Created by 寒山 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

final class HomeCommonProductModel: NSObject, JSONAbleType, HandyJSON {
    required override init() {}
    /// cellType 1是订单类型 2是商品类型 此值目前只在订单列表推荐品中用到 非后台返回字段 3 空视图
    @objc var cellType:NSInteger = 2
    var promotionPrice: Float? // 客户组活动价
    var promotionlimitNum : Int? //特价限购
    @objc var spuCode: String = "" // 商品编码
    var weeklyPurchaseLimit: Int? // 周限购量
    var surplusBuyNum: Int? // 本周剩余限购数量
    var productionTime: String? // 生产日期
    var wholeSaleNum: Int? // 最小起批量
    var supplyName: String? // 供应商
    @objc var supplyId: Int = 0 // 供应商编号
    var isZiYingFlag: Int? // 是否是自营
    var spuName: String?  // 商品名称
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (spuName ?? "") + " " + (spec ?? "")
        }
    }
    var spec: String? // 规格
    var sortNum: String? // 序号
    var shortName: String? // 商品通用名
    var provinceName: String? //省名
    var productName: String? // 商品名
    var productInventory: String? // 库存
    var productId: Int?  //商品ID
    var price: Float? // 客户组原价
    var availableVipPrice : Float?         //可用会员价（会员才有这个字段）
    var visibleVipPrice : Float?           //可见会员价（非会员和会员都有）
    var vipLimitNum :NSInteger?            //vip限购数量
    var vipPromotionId :String?            //vip活动id
    @objc var packageUnit: String = "件"//
    var miniPackage: String? // 最小拆零包装
    var imgPath: String? // 图片地址
    var factoryName: String? // 生产厂家
    var expiryDate: String? // 有效期
    var batchNo: String? //批号
    var bigPackage:Int? // 大包装
    var statusMsg: String? //批号
    var productDesc: String? //价优信息
    var productDescType:NSInteger? //价优类型
    var sourceFrom: String? //来源
    var statusDesc:Int? // 账号状态
    @objc var showSequence:Int = 0 // 列表中第几个商品
    var stockCountDesc : String? //库存描述
    var pmDescription : String? // 本月已售数量
    var singleCanBuy :Int? //单品是否可购买，0-可购买，1-不可（显示套餐按钮）
    var dinnerPromotionRule :Int? // 2固定套餐 1 搭配套餐
    var shopExtendTag : String? //店铺扩展标签（商家，xx仓，旗舰店，加盟店）
    var shopExtendType : Int? //店铺扩展类型（0普通店铺，1旗舰店 2加盟店 3自营店）
    var priceChange:String? //    （商品价格-导入价格）/导入价格*100%(保留小数点后两位)    string
    var pmCount: Int? { // 本月已售数量
        didSet {
            detailStr = "近一月售出\(String(describing: pmCount!))份"
        }
    }
    var pvCount: Int? { // 浏览次数
        didSet {
            detailStr = "近一月浏览\(String(describing: pvCount!))次"
        }
    }
    var orderCount: Int? { // 购买次数
        didSet {
            detailStr = "采购\(String(describing: orderCount!))次"
        }
    }
    
    // 非接口返回字段
    var limitCanBuyNumber: Int = 0 // 限购数量
    @objc var carId: Int = 0 // 购物车id
    @objc var carOfCount: Int = 0 // 购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
    var detailStr: String = ""
    
    var shareStockDTO: HomeShareStockModel?   // 分享库存
    var disCountDesc: String?  // 折后价
    var productSign: ProductPromationSignModel? // 促销标签
    var shopCode: String?  //     店铺编码    String
    var shopName: String?  //     店铺名称    String
    var recommendPrice: Float?                  // 建议价格
    var productCodeCompany: String?         // 公司编码
    var frontSellerCode: Int?               // 前端展示的供应商ID
    var frontSellerName :String? //真实店铺名称
    var enterpriseId : Int? //卖家Id
    var liveStreamingFlag: Int?               // 直播价格标啥
    var livingIsCurrent: Int?               // 直播置顶正在讲解
    /**
     * 二级分类类名
     */
    var drugSecondCategoryName: String?
    var storage: String?{ //可购买数量 1
        get {
            var numList:[String] = []
            //本周剩余限购数量
            if vipLimitNum != nil && vipLimitNum! > 0{
                if let vipAvailableNum = availableVipPrice ,vipAvailableNum > 0{
                    numList.append(String(vipLimitNum!))
                }
            }
            var canBuyNum = 0
            if  surplusBuyNum != nil && surplusBuyNum! > 0 {
                canBuyNum = surplusBuyNum!
            }
            if let count = productInventory,NSInteger(count)!>0{
                if (canBuyNum > NSInteger(count)! || canBuyNum == 0){
                    canBuyNum = NSInteger(count)!
                }
            }
            numList.append(String(canBuyNum))
            return numList.count == 0 ? "0":numList.joined(separator: "|")
        }
    }
    var pm_price: String?{ //可购买价格  埋点专用 自定义
        get {
            var priceList:[String] = []
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
            
            return priceList.count == 0 ? ProductStausUntily.getProductStausDesc(statusDesc ?? 0):priceList.joined(separator: "|")
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
    
    var shortWarehouseName: String? //自营仓名
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeCommonProductModel {
        let json = JSON(json)
        let model = HomeCommonProductModel()
        
        model.sortNum = json["sortNum"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.spuName = json["spuName"].stringValue
        model.spec = json["spec"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.supplyName = json["supplyName"].stringValue
        model.supplyId = json["supplyId"].intValue
        model.isZiYingFlag = json["isZiYingFlag"].intValue
        model.promotionPrice = json["promotionPrice"].floatValue
        model.promotionlimitNum = json["promotionlimitNum"].intValue
        model.price = json["price"].floatValue
        if let vipAvailablePriceNum = Float(json["availableVipPrice"].stringValue), vipAvailablePriceNum > 0 {
            model.availableVipPrice = vipAvailablePriceNum
        }
        if let vipPriceNum = Float(json["visibleVipPrice"].stringValue), vipPriceNum > 0 {
            model.visibleVipPrice = vipPriceNum
        }
        if let vipNum = Int(json["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.imgPath = json["imgPath"].stringValue
        model.weeklyPurchaseLimit = json["weeklyPurchaseLimit"].intValue
        model.miniPackage = json["miniPackage"].stringValue
        model.wholeSaleNum = json["wholeSaleNum"].intValue
        model.productInventory = json["productInventory"].stringValue
        model.surplusBuyNum = json["surplusBuyNum"].intValue
        model.expiryDate = json["expiryDate"].stringValue
        model.productionTime = json["productionTime"].stringValue
        
        model.recommendPrice = json["recommendPrice"].floatValue
        model.productCodeCompany = json["productCodeCompany"].stringValue
        model.frontSellerCode = json["frontSellerCode"].intValue
        model.frontSellerName = json["frontSellerName"].stringValue
        model.enterpriseId = json["enterpriseId"].intValue
        model.liveStreamingFlag = json["liveStreamingFlag"].intValue
        model.livingIsCurrent = json["livingIsCurrent"].intValue
        
        model.bigPackage = json["bigPackage"].intValue
        model.batchNo = json["batchNo"].stringValue
        model.shortName = json["shortName"].stringValue
        model.productId = json["productId"].intValue
        model.packageUnit = json["packageUnit"].stringValue
        model.provinceName = json["provinceName "].stringValue
        model.productName = json["productName"].stringValue
        model.statusMsg  = json["statusMsg"].stringValue
        model.statusDesc = json["statusDesc"].intValue
        model.showSequence = json["showSequence"].intValue
        model.disCountDesc = json["disCountDesc"].stringValue
        model.stockCountDesc = json["stockCountDesc"].stringValue
        model.productDesc = json["productDesc"].stringValue
        model.sourceFrom = json["sourceFrom"].stringValue
        model.shopCode = json["shopCode"].stringValue
        model.shopName = json["shopName"].stringValue
        model.pmDescription = json["description"].stringValue
        model.priceChange = json["priceChange"].stringValue
        if json["pmCount"].intValue != 0 {
            model.pmCount = json["pmCount"].intValue
        }
        if json["pvCount"].intValue != 0 {
            model.pvCount = json["pvCount"].intValue
        }
        if json["orderCount"].intValue != 0 {
            model.orderCount = json["orderCount"].intValue
        }
        if let dic = json["productSign"].dictionary {
            model.productSign = (dic as NSDictionary).mapToObject(ProductPromationSignModel.self)
        }
        model.singleCanBuy = json["singleCanBuy"].intValue
        model.dinnerPromotionRule = json["dinnerPromotionRule"].intValue
        model.shopExtendTag = json["shopExtendTag"].stringValue
        model.shopExtendType = json["shopExtendType"].intValue
        model.drugSecondCategoryName = json["drugSecondCategoryName"].stringValue
        //与购物车数据对比
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == Int(model.supplyId) {
                model.carId = cartOfInfoModel.cartId.intValue
                model.carOfCount = cartOfInfoModel.buyNum.intValue
                break
            }
        }
        
        if let dic = json["shareStockDTO"].dictionary {
            model.shareStockDTO = (dic as NSDictionary).mapToObject(HomeShareStockModel.self)
        }
        
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        
        return model
    }
    /// 获取可购买价格的埋点值
    @objc func getPm_priceValue() -> String {
        return self.pm_price ?? ""
    }
    
    /// 获取可购买数量的埋点值
    @objc func getStorageValue() -> String {
        return self.storage ?? ""
    }
    
    /// 获取促销的埋点值
    @objc func getPm_pmtn_typeValue() -> String{
        return self.pm_pmtn_type ?? ""
    }
}

final class HomeShareStockModel: NSObject, JSONAbleType ,HandyJSON {
    required override init() {}
    var shareStockWarhouseId: Int? //     调拨仓ID    Integer
    var  shareStockDesc : String? //    调拨仓文描    String
    
    static func fromJSON(_ json: [String : AnyObject]) -> HomeShareStockModel {
        let json = JSON(json)
        let model = HomeShareStockModel()
        model.shareStockDesc  = json["shareStockDesc"].stringValue
        model.shareStockWarhouseId = json["shareStockWarhouseId"].intValue
        return model
    }
}

final class ProductStausUntily:NSObject{
    class func getProductStausDesc(_ statusType:NSInteger) -> String {
        var statusDesc = ""
        switch (statusType) {
        case -1: // 登录后可见
            statusDesc = "登录后可见"
            break
        case -2:
            statusDesc = "控销品种"
            break
        case -3:
            statusDesc = "资质未认证"
            break
        case -4:
            statusDesc = "控销品种"
            break
        case -5: //
            statusDesc = "到货通知"
            break
        case -6:
            statusDesc = "不可购买"
            break
        case 3:
            statusDesc = "不可购买"
            break
        case 2:
            //不可购买  因为没有经营范围
            statusDesc = "不可购买"
            break
        case -9: // 无采购权限
            statusDesc = "申请采购权限"
            break
        case -10: // 采购权限待审核
            statusDesc = "权限待审核"
            break
        case -11: // 权限审核不通过
            statusDesc = "申请采购权限"
            break
        case -12: // 采购权限已禁用
            statusDesc = "权限已禁用"
            break
        case -13: // 已达限购总数
            statusDesc = "已达限购总数"
            break
        case 1: //超过商家销售区域
            statusDesc = "超过商家销售区域"
            break
        case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
            statusDesc = ""
            break
        default:
            statusDesc = "不可购买"
            break
        }
        return statusDesc
    }
}
extension HomeCommonProductModel {
    /// 手动解析订单列表的推荐品商品对象
    @objc static func transformOrderListModelToHomeCommonProductModel(_ dic:[String : AnyObject]) -> HomeCommonProductModel{
        let json = JSON(dic)
        let model = HomeCommonProductModel()
        model.cellType = 2
        model.sortNum = json["sortNum"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.spuName = json["spuName"].stringValue
        model.spec = json["spec"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.supplyName = json["supplyName"].stringValue
        model.supplyId = json["supplyId"].intValue
        model.isZiYingFlag = json["isZiYingFlag"].intValue
        model.promotionPrice = json["promotionPrice"].floatValue
        model.promotionlimitNum = json["promotionlimitNum"].intValue
        model.price = json["price"].floatValue
        if let vipAvailablePriceNum = Float(json["availableVipPrice"].stringValue), vipAvailablePriceNum > 0 {
            model.availableVipPrice = vipAvailablePriceNum
        }
        if let vipPriceNum = Float(json["visibleVipPrice"].stringValue), vipPriceNum > 0 {
            model.visibleVipPrice = vipPriceNum
        }
        if let vipNum = Int(json["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.imgPath = json["imgPath"].stringValue
        model.weeklyPurchaseLimit = json["weeklyPurchaseLimit"].intValue
        model.miniPackage = json["miniPackage"].stringValue
        model.wholeSaleNum = json["wholeSaleNum"].intValue
        model.productInventory = json["productInventory"].stringValue
        model.surplusBuyNum = json["surplusBuyNum"].intValue
        model.expiryDate = json["expiryDate"].stringValue
        model.productionTime = json["productionTime"].stringValue
        
        model.bigPackage = json["bigPackage"].intValue
        model.batchNo = json["batchNo"].stringValue
        model.shortName = json["shortName"].stringValue
        model.productId = json["productId"].intValue
        model.packageUnit = json["packageUnit"].stringValue
        model.provinceName = json["provinceName "].stringValue
        model.productName = json["productName"].stringValue
        model.statusMsg  = json["statusMsg"].stringValue
        model.statusDesc = json["statusDesc"].intValue
        model.showSequence = json["showSequence"].intValue
        model.disCountDesc = json["disCountDesc"].stringValue
        model.stockCountDesc = json["stockCountDesc"].stringValue
        model.productDesc = json["productDesc"].stringValue
        model.sourceFrom = json["sourceFrom"].stringValue
        model.shopCode = json["shopCode"].stringValue
        model.shopName = json["shopName"].stringValue
        model.pmDescription = json["description"].stringValue
        if json["pmCount"].intValue != 0 {
            model.pmCount = json["pmCount"].intValue
        }
        if json["pvCount"].intValue != 0 {
            model.pvCount = json["pvCount"].intValue
        }
        if json["orderCount"].intValue != 0 {
            model.orderCount = json["orderCount"].intValue
        }
        if let dic = json["productSign"].dictionary {
            model.productSign = (dic as NSDictionary).mapToObject(ProductPromationSignModel.self)
        }
        
        //与购物车数据对比
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == Int(model.supplyId) {
                model.carId = cartOfInfoModel.cartId.intValue
                model.carOfCount = cartOfInfoModel.buyNum.intValue
                break
            }
        }
        
        if let dic = json["shareStockDTO"].dictionary {
            model.shareStockDTO = (dic as NSDictionary).mapToObject(HomeShareStockModel.self)
        }
        
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        
        return  model
    }
    @objc static func transformVideoDetailModelToHomeCommonProductModel(_ dic:[String : AnyObject]) -> HomeCommonProductModel{
        let json = JSON(dic)
        let model = HomeCommonProductModel()
        model.cellType = 2
        model.sortNum = json["sortNum"].stringValue
        model.spuCode = json["productCode"].stringValue
        model.spuName = json["productName"].stringValue
        model.spec = json["productSpec"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.supplyName = json["productSupplyName"].stringValue
        model.supplyId = json["productSupplyId"].intValue
        model.isZiYingFlag = json["isZiYingFlag"].intValue
        model.promotionPrice = json["specialPrice"].floatValue
        model.promotionlimitNum = json["promotionlimitNum"].intValue
        model.price = json["productPrice"].floatValue
        if let vipAvailablePriceNum = Float(json["availableVipPrice"].stringValue), vipAvailablePriceNum > 0 {
            model.availableVipPrice = vipAvailablePriceNum
        }
        if let vipPriceNum = Float(json["visibleVipPrice"].stringValue), vipPriceNum > 0 {
            model.visibleVipPrice = vipPriceNum
        }
        if let vipNum = Int(json["vipLimitNum"].stringValue),vipNum > 0{
            model.vipLimitNum = vipNum
        }
        model.vipPromotionId = json["vipPromotionId"].stringValue
        model.imgPath = json["imgPath"].stringValue
        model.weeklyPurchaseLimit = json["weeklyPurchaseLimit"].intValue
        model.miniPackage = json["inimumPacking"].stringValue
        model.wholeSaleNum = json["wholeSaleNum"].intValue
        model.productInventory = json["productInventory"].stringValue
        model.surplusBuyNum = json["surplusBuyNum"].intValue
        model.expiryDate = json["expiryDate"].stringValue
        model.productionTime = json["productionTime"].stringValue
        
        model.bigPackage = json["bigPackage"].intValue
        model.batchNo = json["batchNo"].stringValue
        model.shortName = json["productName"].stringValue
        model.productId = json["productId"].intValue
        model.packageUnit = json["unit"].stringValue
        model.provinceName = json["provinceName "].stringValue
        model.productName = json["productName"].stringValue
        model.statusMsg  = json["statusMsg"].stringValue
        model.statusDesc = json["statusDesc"].intValue
        model.showSequence = json["showSequence"].intValue
        model.disCountDesc = json["disCountDesc"].stringValue
        model.stockCountDesc = json["stockCountDesc"].stringValue
        model.productDesc = json["productDesc"].stringValue
        model.sourceFrom = json["sourceFrom"].stringValue
        model.shopCode = json["shopCode"].stringValue
        model.shopName = json["shopName"].stringValue
        model.pmDescription = json["description"].stringValue
        if json["pmCount"].intValue != 0 {
            model.pmCount = json["pmCount"].intValue
        }
        if json["pvCount"].intValue != 0 {
            model.pvCount = json["pvCount"].intValue
        }
        if json["orderCount"].intValue != 0 {
            model.orderCount = json["orderCount"].intValue
        }
        if let dic = json["productSign"].dictionary {
            model.productSign = (dic as NSDictionary).mapToObject(ProductPromationSignModel.self)
        }
        
        //与购物车数据对比
        for cartModel  in FKYCartModel.shareInstance().productArr {
            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == model.spuCode && cartOfInfoModel.supplyId.intValue == Int(model.supplyId) {
                model.carId = cartOfInfoModel.cartId.intValue
                model.carOfCount = cartOfInfoModel.buyNum.intValue
                break
            }
        }
        
        if let dic = json["shareStockDTO"].dictionary {
            model.shareStockDTO = (dic as NSDictionary).mapToObject(HomeShareStockModel.self)
        }
        
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        
        return  model
    }
}
//"createTime": "2020-11-03 19:53:55",
//"createUser": "liruian",
//"expiryDate": "2021-09-07",
//"factoryId": "36334",
//"factoryName": "山东阿胶股份有限公司",
//"id": 1425632,
//"imgPath": "https://p8.maiyaole.com/img/201603/22/20160322103627512.jpg",
//"indexMobileFloorId": 908554,
//"indexMobileId": 23291,
//"inimumPacking": 1,
//"inventory": 16006,
//"isChannel": 0,
//"isZiYingFlag": 1,
//"posIndex": 3,
//"shortName": "东阿阿胶",//"statusDesc": 0,
//"statusMsg": "正常可购买",
//"unit": "盒",

//"wholeSaleNum": 10
//"productName": "东阿阿胶 WMS东阿数据对接 阿胶",
//"productSupplyName": "广东壹号药业有限公司-ziying",
//"productSpec": "500g",
//"productSupplyId": "8353",
//"productPrice": 35.6,
//"productionTime": "2019-09-18",
//"promotionlimitNum": 500,
//"specialPrice": 0.02,
//"productId": "181949",
//"productInventory": 16006,
//"productCodeCompany": "0009752210",


//"productCode": "8353YCZ370012",

//"promotionId": "26199",
//"showPrice": "",
//"siteCode": "540000",



