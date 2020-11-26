//
//  FKYCommandEnterTreasuryModel.swift
//  FKY
//
//  Created by 寒山 on 2020/11/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class FKYCommandEnterTreasuryModel: NSObject, JSONAbleType {
    /**
     * 标题
     */
    var  title:String?
    /**
     * 副标题
     */
    var  subtitle:String?
    
    /**
     * 按钮文描
     */
    var  buttonText:String?
    /**
     * 商品数据
     */
    var products:Array<HomeCommonProductModel>? //array<object>商品列表
    /**
     * 跳转列表
     */
    var  jumpUrl:String?
    /**
     * 文描
     */
    var  text:String?
    
    /**
     * 是否弹窗
     */
    var isPopup:Int?
    /**
     * 商家药店易状态
     */
    var status:Int?   // * RUNNING(1,"已开通"), OFFRUN(2,"已开通未运行"), , DISABLED(4,"禁用")* NOTOPEN(3,"未开通") ：NOTOPEN_APLLY(5, "未开通已申请"), NOTOPEN_NOAPLLY(6, "未开通未申请")
    
    /**
     * 背景图片链接
     */
    var backgroundUrl:String?
//    /**
//     * 了解更多按钮文描
//     */
//    var moreButtonText:String?
//    /**
//     * 了解更多跳转地址
//     */
//    var moreJumpUrl:String?
    
    static func fromJSON(_ dic: [String : AnyObject]) -> FKYCommandEnterTreasuryModel {
        let json = JSON(dic)
        let model = FKYCommandEnterTreasuryModel()
        model.title = json["title"].stringValue
        model.subtitle = json["subtitle"].stringValue
        model.buttonText = json["buttonText"].stringValue
        model.jumpUrl = json["jumpUrl"].stringValue
        model.text = json["text"].stringValue
        model.isPopup = json["isPopup"].intValue
        model.status = json["status"].intValue
        model.backgroundUrl = json["backgroundUrl"].stringValue
//        model.moreButtonText = json["moreButtonText"].stringValue
//        model.moreJumpUrl = json["moreJumpUrl"].stringValue
        let productList = json["products"].arrayObject
        var goodsInfo: [HomeCommonProductModel]? = []
        if let list = productList {
            goodsInfo = (list as NSArray).mapToObjectArray(HomeCommonProductModel.self)
        }
        model.products = goodsInfo
        return model
    }
}
final class FKYCommandTreasuryProductModel: NSObject, JSONAbleType {
    var MedicineStatus :NSNumber? //        number
    var analyseMessage:String? //    解析excel行未成功原因    string
    var analyseStatus:NSNumber? //     解析excel行状态 1已解析存库 0 未解析成功    number
    var approvalNum:String? //    (客户上传)国药准字    string
    var barCode:String? //    条形码    string
    var basePrice:NSNumber? //     采购清单初始自营商品价格，用于比价    number
    var batchNo:String? //    批次号    string
    var bcType :NSNumber? //    0不是本仓数据，1是本仓数据    number
    var bigPacking :String? //   大包装    string
    var buyedCount:NSNumber? //     已购数量    number
    var contractPrice:NSNumber? //     集采价/协议价    number
    var currentCount:NSNumber? //     记录当前商品所买数量    number
    var endDate:String? //    失效期
    var enterpriseId :NSNumber? //    企业id    number
    var expressDate:String? //    商品导入时间
    var extShopTag :String? //   店铺扩展标签（商家、xx仓、旗舰店、加盟店）    string
    var extType:NSNumber? //     店铺扩展类型（0 普通店铺 1 旗舰店 2 加盟店 3 自营店）    number
    var f_ywSkuNo:String? //    药网编码    string
    var factoryName:String? //    生产厂家    string
    var floor_spu_code:String? //        string
    var forder :NSNumber? //    供应商排序    number
    var frontSellerCode:NSNumber? //     前台用seller_code,JBP的就是自营了    number
    var herfNo :NSNumber? //    1 链接不可以点击    number
    var index :NSNumber? //    记录下标    number
    var inquiryNum :NSNumber? //    询价次数    number
    var inventory:NSNumber? //     库存量    number
    var inventoryDesc:String? //    库存描述    string
    var inventoryFlag :Bool?   //剩余库存小于用户采购数量的商品需有特殊颜色标记。    boolean
    var isActivity :NSNumber? //    活动标识 0：无活动 1：有活动    number
    var isChannel:String? //    是否渠道    string
    var isCheck:NSNumber? //     订单跳转过来，数量填充标志 * 0：填充 * 1：最小批包装零    number
    var limitBuyNum:NSNumber? //     上下架 小于0为下架    number
    var limit_num :NSNumber? //    特价周限购    number
    var minimumPacking:NSNumber?  //    最小拆零包装    string
    var moreThanPurchase :NSNumber? //    是否已购量是否大于协议限购量 0：未超过 1：超过    number
    var optional_spu_code:String? //    候选SPU编码(多个用逗号分隔)    string
    var price1:NSNumber? //         number
    var price2 :NSNumber? //        number
    var priceChange:String? //    （商品价格-导入价格）/导入价格*100%(保留小数点后两位)    string
    var priceChangeFlag:String? //    误差范围内都算优势品，1标识优势品    string
    var priceResult :NSNumber? //    当用户上传了1个采购价格字段之后,价差    number
    var price_status:NSNumber? //     商品状态    number
    var priority:NSNumber? //     序号    number
    var productId:String? //    商品id    string
    var productName:String? //    商品名    string
    var productType:NSNumber? //     商品类型 0:普通品 1:集采品    number
    var productcodeCompany:String? //    本公司产品编码    string
    var promotionPrice:NSNumber? //     特价    number
    var promotionQuantit:NSNumber? // y    特价的最小起批量    number
    //var promotionTags    促销活动标    array<string>
    var purchaseCount:NSNumber? //     导入后计算的采购数量    number
    var purchaseId:NSNumber? //     清单表id    number
    var quantity:NSNumber? //     excel导入的采购数量    numbe
    var rebateInfo:String? //      返利信息    string
    var redFalg:NSNumber? //     特效标识，0：商规厂加红加粗，1：不变    number
    var rmc_status :NSNumber? //    明细状态    number
    var rowNum:NSNumber? //     导入excel行号    number
    var self_approvalNum:String? //    药城批准文号    string
    var self_factoryName:String? //    药城厂家名称    string
    var self_mainImgFilePath:String? //    商品主图    string
    var self_productCode:String? //    69码    string
    var self_shortName :String? //   药城商品名称    string
    var self_spec:String? //    药城规格    string
    var seller_code:NSNumber? //     供应商企业id    number
    var seller_name:String? //      供应商名称    string
    var shortName:String? //    通用名    string
    var shortNamePinyin:String? //    助记码    string
    var sort :NSNumber? //    阿波罗得供应商排序    number
    var sourceType:NSNumber? //     来源，0匹配，1推荐品，规格不变，2推荐品，厂家不变    number
    var spec:String? //    规格    string
    var spuCode:String? //    SPU编码    string
    var spu_info_id:NSNumber? //     标品id    number
    var startDate :String? //     有效期
    var supplyType:NSNumber? //     0自营，1商家    number
    var unit:String? //    最小包装单位编码    string
    var weekLimit:String? //    限购信息    string
    var week_num:NSNumber? //    协议周限购    number
    var wisdomBuyVersion:String? //    购物车-订单：推送版本号    string
    var productFullName: String?{ //商品全名 名字加规格
        get {
            let productShortName = (productName ?? "") + " " + (self_shortName ?? "")
            return productShortName + " " + (self_spec ?? "")
        }
    }
    static func fromJSON(_ dic: [String : AnyObject]) -> FKYCommandTreasuryProductModel {
        let json = JSON(dic)
        let model = FKYCommandTreasuryProductModel()
        model.MedicineStatus = json["MedicineStatus"].numberValue
        model.analyseMessage = json["analyseMessage"].stringValue
        model.analyseStatus = json["analyseStatus"].numberValue
        model.approvalNum = json["approvalNum"].stringValue
        model.barCode = json["barCode"].stringValue
        model.basePrice = json["basePrice"].numberValue
        model.batchNo = json["batchNo"].stringValue
        model.bcType = json["bcType"].numberValue
        model.bigPacking = json["bigPacking"].stringValue
        model.buyedCount = json["buyedCount"].numberValue
        model.contractPrice = json["contractPrice"].numberValue
        model.currentCount = json["currentCount"].numberValue
        model.endDate = json["endDate"].stringValue
        model.enterpriseId = json["enterpriseId"].numberValue
        model.expressDate = json["expressDate"].stringValue
        model.extShopTag  = json["extShopTag"].stringValue
        model.extType = json["extType"].numberValue
        model.f_ywSkuNo = json["f_ywSkuNo"].stringValue
        model.factoryName = json["factoryName"].stringValue
        model.floor_spu_code = json["floor_spu_code"].stringValue
        model.forder = json["forder"].numberValue
        model.frontSellerCode = json["frontSellerCode"].numberValue
        model.herfNo = json["herfNo"].numberValue
        model.index = json["index"].numberValue
        model.inquiryNum = json["inquiryNum"].numberValue
        model.inventory = json["inventory"].numberValue
        model.inventoryDesc = json["nventoryDesc"].stringValue
        model.inventoryFlag = json["inventoryFlag "].boolValue
        model.isActivity = json["isActivity"].numberValue
        model.isChannel = json["isChannel"].stringValue
        model.isCheck = json["isCheck"].numberValue
        model.limitBuyNum = json["limitBuyNum"].numberValue
        model.limit_num  = json["limit_num"].numberValue
        model.minimumPacking = json["minimumPacking"].numberValue
        model.moreThanPurchase  = json["moreThanPurchase"].numberValue
        model.optional_spu_code = json["optional_spu_code"].stringValue
        model.price1 = json["price1"].numberValue
        model.price2  = json["price2"].numberValue
        model.priceChange = json["priceChange"].stringValue
        model.priceChangeFlag = json["priceChangeFlag"].stringValue
        model.priceResult = json["priceResult"].numberValue
        model.price_status = json["price_status"].numberValue
        model.priority = json["priority"].numberValue
        model.productId = json["productId"].stringValue
        model.productName = json["productName"].stringValue
        model.productType = json["productType"].numberValue
        model.productcodeCompany = json["productcodeCompany"].stringValue
        model.promotionPrice = json["promotionPrice"].numberValue
        model.promotionQuantit = json["promotionQuantit"].numberValue
        //var promotionTags    促销活动标    array<string>
        model.purchaseCount = json["purchaseCount"].numberValue
        model.purchaseId = json["purchaseId"].numberValue
        model.quantity = json["quantity"].numberValue
        model.rebateInfo = json["rebateInfo"].stringValue
        model.redFalg = json["redFalg"].numberValue
        model.rmc_status = json["rmc_status"].numberValue
        model.rowNum = json["rowNum"].numberValue
        model.self_approvalNum = json["self_approvalNum"].stringValue
        model.self_factoryName = json["self_factoryName"].stringValue
        model.self_mainImgFilePath = json["self_mainImgFilePath"].stringValue
        model.self_productCode = json["self_productCode"].stringValue
        model.self_shortName  = json["self_shortName"].stringValue
        model.self_spec = json["self_spec"].stringValue
        model.seller_code = json["seller_code"].numberValue
        model.seller_name = json["seller_name"].stringValue
        model.shortName = json["shortName"].stringValue
        model.shortNamePinyin = json["shortNamePinyin"].stringValue
        model.sort = json["sort"].numberValue
        model.sourceType = json["sourceType"].numberValue
        model.spec = json["spec"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.spu_info_id = json["spu_info_id"].numberValue
        model.startDate = json["startDate"].stringValue
        model.supplyType = json["supplyType"].numberValue
        model.unit = json["unit"].stringValue
        model.weekLimit = json["weekLimit"].stringValue
        model.week_num = json["week_num"].numberValue
        model.wisdomBuyVersion = json["wisdomBuyVersion"].stringValue
        return model
    }
}
