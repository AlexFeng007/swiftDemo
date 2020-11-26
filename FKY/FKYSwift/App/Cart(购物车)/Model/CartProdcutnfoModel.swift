//
//  CartProdcutnfoModel.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class CartProdcutnfoModel: NSObject, JSONAbleType {
    var checkStatus:Bool?   //    商品勾选状态    number    @mock=14
    var productImageUrl:String?    //    商品图片地址    string    4 @mock=https://p8.maiyaole.com//fky/img/%E5%B9%BF%E5%91%8A.jpg?x-oss-process=image/resize,h_120
    var manufactures:String?     //    生产企业    string    @mock=上海APP生产商4
    var messageMap:ProductInventoryInfoModel?    //   4 提示消息：实际库存展示信息，超出实际最大可售库存时提示等    object
    var minPackingNum:Int?    //    商品最小拆零包装    number    @mock=1 4
    var productMaxNum:Int?    //    商品最大可购买数量    number 4
    var promoteJoinedDesc:String?      //  已参与过促销的描述 number。4
    var productCount:Int?     //    商品购买数量    number    @mock=5 4
    var productLimitBuy:ProductLimitBuyInfoModel?    //    商品限购    object 4
    var productName:String?
    var productFullName: String?{ //商品全名 名字加规格
        get {
            return (productName ?? "") + " " + (specification ?? "")
        }
    }
    var originalPrice:NSNumber?    //    商品原价    number    @mock=11 4
    var productPrice:NSNumber?    //    商品单价    number    @mock=11 4
    var productRebate:ProductRebateInfoModel?    //    商品返利    object 4
    var productStatus:Int?    //    商品状态    number    @mock=0 4
    var promotionFlashSale:PromationInfoModel?        //   闪购    object    @mock= 4
    var promotionHG:PromationInfoModel?        //    换购促销活动    array<object> 4
    var promotionJF:PromationInfoModel?        //    送积分促销活动    object 4
    var promotionMJ:FKYPromationInfoModel?        //       object4
    var promotionMZ:PromationInfoModel?        //       object4
    var promotionTJ:PromationInfoModel?        //        object4
    var promotionManzhe:FKYPromationInfoModel?     //        object4
    var agreementRebate:PromationInfoModel?    //    协议返利金 4
    var unifiedPromotionList:[PromationInfoModel]?    //   底价活动4
    var saleStartNum:Int?    //    商品起售门槛/起订量    number    @mock=1 4
    var settlementPrice:NSNumber?   //    商品结算金    number    @mock=55 4
    var shoppingCartId:Int?   //    购物车商品ID    string    @mock=240836 4
    var specification:String?      //    商品规格    string    @mock=10g 4
    var spuCode:String?    //    SPU编码  compileAddDesc   string    @mock=012345AAAZ40001 4
    var unit:String?      //    商品的最小包装单位    string    @mock=袋 4
    var supplyId:Int?  //4
    var deadLine:String?  //有效时间4
    var batchNum:String?  ;//截止时间4
    var outMaxReason:String?  //超出最大可售数量，最多只能购买9999 4
    var lessMinReson:String?  //该普通商品最小起批量为1 4
    var editStatus:Int = 0; //  自定义0:(默认)未编辑状态, 1:编辑未选中, 2: 编辑已选中
    var canUseCouponFlag:Bool? //商品是否不可用劵标识 0:不可用券, 1:可用券4
    var promotionVip:CartVipInfoModel? //vip相关信息 4
    // var shareStockVO:ShareStockInfoModel? //分享库存信息
    
    var reachLimitNum:Bool?    //    是否达到限购
    var nearEffect:Bool?   //    是否是近效期
    var productCodeCompany:NSNumber?
    var promotionId:NSNumber?
    var shareStockDesc:String?  //共享库存需要弹窗的信息，有则提示
    var isMixRebate:Bool?    //   自定义 判断是不是多品返利
    // var compileAddDesc:String?  //与加车时比较描述
    var frontSellerCode:Int?  //前端展示供应商ID
    var periodFlag:Int?   //账期品标识 可使用账期的用户： 0.非账期品 1.是账期品 不可使用账期的用户：信息为空
    var supplierId:Int?   //聚宝盆商品真是供应商Id
    
    ///cell 行高
    var cellHeight:CGFloat?
    var isTaoCanType:Bool = false // 自定义字段 判断是否套餐类型
    var comboProductLimitNum:Int?   //搭配套餐 主品每次限购标
    var mainProductFlag:Bool = false // 搭配套餐主品标
    var storage: String?{ //可购买数量 1
        get {
            var numList:[String] = []
            //本周剩余限购数量
            if let vipModel = promotionVip, let vipAvailableNum = vipModel.availableVipPrice ,vipAvailableNum > 0{
                numList.append(String(vipModel.vipLimitNum ?? 0))
            }
            numList.append(String(productMaxNum ?? 0))
            return numList.count == 0 ? "0":numList.joined(separator: "|")
        }
    }
    var pm_price: String?{ //可购买价格  埋点专用 自定义,
        get {
            var priceList:[String] = []
            if let tjModel = promotionTJ, let promotionNum = tjModel.teJiaPrice?.doubleValue,promotionNum  > 0{
                //特价
                priceList.append(String(format: "%.2f",promotionNum))
            }else if let vipModel = promotionVip, let vipAvailableNum = vipModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceList.append(String(format: "%.2f",vipAvailableNum))
            }
            //原价
            if let priceStr = productPrice?.doubleValue, priceStr > 0 {
                priceList.append(String(format: "%.2f",priceStr))
            }
            
            return priceList.count == 0 ? "":priceList.joined(separator: "|")
        }
    }
    var pm_pmtn_type: String?{ //促销类型数据  埋点专用 自定义
        get {
            var pmList:[String] = []
            if  let  _ = promotionMJ{
                pmList.append("满减")
            }
            if   let  _ = promotionMZ{
                pmList.append("满赠")
            }
            // 15:单品满折,16多品满折
            if  let  _ = promotionManzhe{
                pmList.append("满折")
            }
            // 返利金
            if   let sign = productRebate,sign.rebateTextMsg?.isEmpty == false{
                pmList.append("返利")
            }
            // 协议返利金
            if     let _ = agreementRebate{
                pmList.append("协议奖励金")
            }
            //套餐
            if isTaoCanType == true{
                pmList.append("套餐")
            }
            // 限购
            if      let  _ =  productLimitBuy{
                pmList.append("限购")
            }
            //特价
            if      let  _ = promotionTJ{
                pmList.append("特价")
            }
            //会员  会员才加入 有会员价的商品
            if let vipModel = promotionVip, let vipAvailableNum = vipModel.availableVipPrice ,vipAvailableNum > 0 {
                pmList.append("会员")
            }
            
            return pmList.joined(separator: ",")
        }
    }
    
    @objc static func fromJSON(_ json: [String : AnyObject]) ->CartProdcutnfoModel {
        let json = JSON(json)
        let model = CartProdcutnfoModel()
        model.checkStatus = json["checkStatus"].boolValue
        model.productImageUrl = json["productImageUrl"].stringValue
        model.minPackingNum = json["minPackingNum"].intValue
        model.productMaxNum = json["productMaxNum"].intValue
        model.promoteJoinedDesc = json["promoteJoinedDesc"].stringValue
        model.productCount = json["productCount"].intValue
        model.productName = json["productName"].stringValue
        model.supplyId = json["supplyId"].intValue
        
        model.outMaxReason = json["outMaxReason"].stringValue
        model.lessMinReson = json["lessMinReson"].stringValue
        model.manufactures = json["manufactures"].stringValue
        
        model.productPrice = json["productPrice"].numberValue
        model.productStatus = json["productStatus"].intValue
        model.saleStartNum = json["saleStartNum"].intValue
        model.settlementPrice = json["settlementPrice"].numberValue
        model.originalPrice = json["originalPrice"].numberValue
        model.shoppingCartId = json["shoppingCartId"].intValue
        model.specification = json["specification"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.unit = json["unit"].stringValue
        model.deadLine = json["deadLine"].stringValue
        model.batchNum = json["batchNum"].stringValue
        
        // model.compileAddDesc = json["compileAddDesc"].stringValue
        model.frontSellerCode = json["frontSellerCode"].intValue
        model.periodFlag = json["periodFlag"].intValue
        model.supplierId = json["supplierId"].intValue
        
        model.reachLimitNum = json["reachLimitNum"].boolValue
        model.nearEffect = json["nearEffect"].boolValue
        model.productCodeCompany = json["productCodeCompany"].numberValue
        model.canUseCouponFlag = json["canUseCouponFlag"].boolValue
        model.promotionId = json["promotionId"].numberValue
        
        // model.isMutexTeJia = json["isMutexTeJia"].intValue
        model.shareStockDesc = json["shareStockDesc"].stringValue
        model.isMixRebate = json["isMixRebate"].boolValue
        
        model.comboProductLimitNum = json["comboProductLimitNum"].intValue
        model.mainProductFlag = json["mainProductFlag"].boolValue
        
        //        let dic = json["shareStockVO"].dictionaryObject
        //        if let _ = dic {
        //            let t = dic! as NSDictionary
        //            model.shareStockVO = t.mapToObject(ShareStockInfoModel.self)
        //        }else{
        //            model.shareStockVO = nil
        //        }
        let vipDic = json["promotionVipVO"].dictionaryObject
        if let _ = vipDic {
            let t = vipDic! as NSDictionary
            model.promotionVip = t.mapToObject(CartVipInfoModel.self)
        }else{
            model.promotionVip = nil
        }
        let rebateDic = json["productRebate"].dictionaryObject
        if let _ = rebateDic {
            let t = rebateDic! as NSDictionary
            model.productRebate = t.mapToObject(ProductRebateInfoModel.self)
        }else{
            model.productRebate = nil
        }
        
        let lmimitDic = json["productLimitBuy"].dictionaryObject
        if let _ = lmimitDic {
            let t = lmimitDic! as NSDictionary
            model.productLimitBuy = t.mapToObject(ProductLimitBuyInfoModel.self)
        }else{
            model.productLimitBuy = nil
        }
        
        let inventoryDic = json["productLimitBuy"].dictionaryObject
        if let _ = inventoryDic {
            let t = inventoryDic! as NSDictionary
            model.messageMap = t.mapToObject(ProductInventoryInfoModel.self)
        }else{
            model.messageMap = nil
        }
        
        let hgDic = json["promotionHG"].dictionaryObject
        if let _ = hgDic {
            let t = hgDic! as NSDictionary
            model.promotionHG = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionHG = nil
        }
        
        let jfDic = json["promotionJF"].dictionaryObject
        if let _ = jfDic {
            let t = jfDic! as NSDictionary
            model.promotionJF = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionJF = nil
        }
        
        let mjDic = json["promotionMJ"].dictionaryObject
        if let _ = mjDic {
            let t = mjDic! as NSDictionary
            model.promotionMJ = (FKYTranslatorHelper.translateModel(fromJSON: (t as! [AnyHashable : Any]), with: FKYPromationInfoModel.self) as! FKYPromationInfoModel)
            model.promotionMJ?.promationDescription = (t["description"] as! String)
            model.promotionMJ?.promotionType = NSNumber(nonretainedObject: model.promotionMJ?.type)
        }else{
            model.promotionMJ = nil
        }
        
        let mzDic = json["promotionMZ"].dictionaryObject
        if let _ = mzDic {
            let t = mzDic! as NSDictionary
            model.promotionMZ = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionMZ = nil
        }
        
        let tjDic = json["promotionTJ"].dictionaryObject
        if let _ = tjDic {
            let t = tjDic! as NSDictionary
            model.promotionTJ = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionTJ = nil
        }
        
        let manzDic = json["promotionManzhe"].dictionaryObject
        if let _ = manzDic {
            let t = manzDic! as NSDictionary
            //model.promotionManzhe = t.mapToObject(FKYPromationInfoModel.self)
            model.promotionManzhe = (FKYTranslatorHelper.translateModel(fromJSON: (t as! [AnyHashable : Any]), with: FKYPromationInfoModel.self) as! FKYPromationInfoModel)
            model.promotionManzhe?.promationDescription = (t["description"] as! String)
            model.promotionManzhe?.promotionType = NSNumber(nonretainedObject:  model.promotionManzhe?.type)
        }else{
            model.promotionManzhe = nil
        }
        
        let agreeRebateDic = json["agreementRebate"].dictionaryObject
        if let _ = agreeRebateDic {
            let t = agreeRebateDic! as NSDictionary
            model.agreementRebate = t.mapToObject(PromationInfoModel.self)
        }else{
            model.agreementRebate = nil
        }
        
        let array = json["unifiedPromotionList"].arrayObject
        var list: [PromationInfoModel]? = []
        if let arr = array{
            list = (arr as NSArray).mapToObjectArray(PromationInfoModel.self)
        }
        model.unifiedPromotionList = list
        
        return model
    }
}
//MARK: -私有方法
extension CartProdcutnfoModel{
    @objc override func value(forKey key: String) -> Any? {
        switch key {
        case "editStatus":
            return editStatus
        default:
            return nil
        }
    }
    func isHasSomeKindPromotion(_ promotionTypeArray:[String]) -> Bool {
           if let promotonList = self.unifiedPromotionList, promotonList.count > 0 {
            let predicate: NSPredicate = NSPredicate(format: "self.stringPromotionType IN %@",promotionTypeArray)
            let result = (promotonList as NSArray).filtered(using: predicate)
            if result.count > 0 {
                return true
            }else {
                return false
            }
        }else{
            return false
        }
    }
    //取专享价文描
    func getExclusivePromotionDesc(_ promotionTypeArray:[String]) -> String? {
        if let promotonList = self.unifiedPromotionList, promotonList.count > 0 {
            let predicate: NSPredicate = NSPredicate(format: "self.stringPromotionType IN %@",promotionTypeArray)
            let result = (promotonList as NSArray).filtered(using: predicate)
            if result.count > 0 {
                if let promotionInfoMoel = result[0] as? PromationInfoModel{
                    return promotionInfoMoel.joinDesc ?? ""
                }
            }
        }
        return ""
    }
    //判断是否享受了专享价
    func getExclusivePromotionFlag(_ promotionTypeArray:[String]) -> Bool{
        if let promotonList = self.unifiedPromotionList, promotonList.count > 0 {
            let predicate: NSPredicate = NSPredicate(format: "self.stringPromotionType IN %@",promotionTypeArray)
            let result = (promotonList as NSArray).filtered(using: predicate)
            if result.count > 0 {
                if let promotionInfoMoel = result[0] as? PromationInfoModel{
                    return promotionInfoMoel.exclusiveFlag ?? false
                }
            }
        }
        return false
        //return true
    }
}

