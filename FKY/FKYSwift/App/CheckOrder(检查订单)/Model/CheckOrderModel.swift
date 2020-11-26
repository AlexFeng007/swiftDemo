//
//  CheckOrderModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  检查订单接口返回model

import UIKit
import SwiftyJSON


/********************************************************************/
// 一级结构

// MARK: - 检查订单model
final class CheckOrderModel: NSObject, JSONAbleType {
    var allCouponMoney: NSNumber?                   // 所有店铺优惠码总额
    var allOrderCouponMoney: NSNumber?              // 所有订单店铺优惠券 + 优惠码优惠金额总和
    var allOrderGiftMsg: String?                    // 满赠礼品描述
    var allOrderPointValue: NSNumber?               // 所有订单可获得积分
    var allOrdersGetRebateMoney: NSNumber?          // 所有订单完成可获取的返利金总额
    var allOrdersUseRebateMoney: NSNumber?          // 所有订单用户输入的返利金总额
    var allOrdersUsePlatformRebateMoney: NSNumber?  //使用返利金总额中包含的平台返利金额度
    var allOrderCanUseRebateMoney : NSNumber?       //所有订单可用返利金额
    var allOrderRebateBalance : NSNumber?            //总共的返利金额
    var allPlatformCouponMoney: NSNumber?           // 所有订单平台优惠券优惠总金额
    var allProductCount: Int?                       // 当前商家订单中的总商品数
    var billType: String?                           // 发票类型 [该商家上一笔订单的发票类型 1:专票 2:普票 0:该商家没有下过单]
    var discountAmount: NSNumber?                   // 满减金额<立减>
    var freight: NSNumber?                          // 运费
    var fromWhere: Int?                             // 来源？？？
    var invoiceCanEdit: String?                     // 发票是否可编辑 [所有订单是否可以编辑发票 “-1”不能编辑   “1”可编辑]
    var isSupportEinvoice: String?                  // 是否支持电子发票 [是否支持电子发票 0-不支持， 1-支持]
    var payAmount: NSNumber?                        // 应付金额 = 总金额-优惠金额+运费
    //var platformCouponCode: String?                 // 平台券编码
    var platformCouponList : [COCouponModel]?       //平台优惠券列表
    var productRowDisplay: Int?                     // 商品展示的样式，0：多行多个  1：一行多个
    var totalAmount: NSNumber?                      // 总商品金额
    var userType: String?                           // 买家类型
    var allShareStockDesc: String?                  // 总订单共享天数文描
    var ziYingEnterpriseIdList: [Int]?              // 自营ID列表
    var receiveInfoVO: COAddressModel?              // 收货地址
    var orderBillInfoVO: InvoiceModel?              // 发票详细信息 COBillModel
    var orderSupplyCartVOs: [COSupplyOrderModel]?   // 订单列表...<商家维度>
    var invoiceTypeList : [Int]? //发票类型 1:专用 2:普通 3:电子普通
    var qualificationMark: String?                  // 资质过期提示 有就提示
    var invoiceTip : String? //发票下方文描
    //6.3.0新增
    var allTotalAmount: NSNumber?//总金额(一起购还是用老的totalAmount)
    var allCheckOrderShowDiscountAmount: NSNumber?//立减
    var totalProductNumber: Int? //商品数量
    
    var showSalesContract: Int? //销售合同随货显示与否，0：不显示，1：显示
    var salesContractFlowGoods: Int? //   销售合同随货与否，0：不随货，1：随货
    
    //平台卷信息（6.5.0版本使用字段）
    var platformCouponInfo : COCouponInfoVoModel? //
    var shareRebate : String?  //是否打开共享返利金(是否共享返利金 1-共享 0-不共享)
    
    //购物金（6.7.2版本开始使用字段）
    var allUseGwjBalance: NSNumber?          // 使用的总购物金
    var allCanUseGwjBalance: NSNumber?          //能够使用的购物金
    var allGwjBalance: NSNumber?  //账户的购物金余额
    var hasZiyingStatus: Int?  //0 :不包含自营   1:包含自营商家
    
    
    // dic转model...<OC中的YYModel无法解析当前Modal中的Int?类型>
    static func fromJSON(_ json: [String : AnyObject]) -> CheckOrderModel {
        let json = JSON(json)
        
        let model = CheckOrderModel()
        model.allCouponMoney = json["allCouponMoney"].numberValue
        model.allOrderCouponMoney = json["allOrderCouponMoney"].numberValue
        model.allOrderGiftMsg = json["allOrderGiftMsg"].stringValue
        model.allOrderPointValue = json["allOrderPointValue"].numberValue
        model.allOrdersGetRebateMoney = json["allOrdersGetRebateMoney"].numberValue
        model.allOrdersUseRebateMoney = json["allOrdersUseRebateMoney"].numberValue
        model.allOrdersUsePlatformRebateMoney = json["allOrdersUsePlatformRebateMoney"].numberValue
        model.allOrderCanUseRebateMoney = json["allOrderCanUseRebateMoney"].numberValue
        model.allOrderRebateBalance = json["allOrderRebateBalance"].numberValue
        model.allPlatformCouponMoney = json["allPlatformCouponMoney"].numberValue
        model.allProductCount = json["allProductCount"].intValue
        model.billType = json["billType"].stringValue
        model.discountAmount = json["discountAmount"].numberValue
        model.freight = json["freight"].numberValue
        model.fromWhere = json["fromWhere"].intValue
        model.invoiceCanEdit = json["invoiceCanEdit"].stringValue
        model.isSupportEinvoice = json["isSupportEinvoice"].stringValue
        model.payAmount = json["payAmount"].numberValue
        //model.platformCouponCode = json["platformCouponCode"].stringValue
        model.productRowDisplay = json["productRowDisplay"].intValue
        model.totalAmount = json["totalAmount"].numberValue
        model.userType = json["userType"].stringValue
        model.allShareStockDesc = json["allShareStockDesc"].stringValue
        model.ziYingEnterpriseIdList = json["ziYingEnterpriseIdList"].arrayObject as? [Int]
        model.invoiceTypeList = json["invoiceTypeList"].arrayObject as? [Int]
        model.invoiceTip = json["invoiceTip"].stringValue
        model.showSalesContract = json["showSalesContract"].intValue
        model.salesContractFlowGoods = json["salesContractFlowGoods"].intValue
        model.qualificationMark = json["qualificationMark"].stringValue
        var receiveInfoVO: COAddressModel? = nil
        let dicAddress = json["receiveInfoVO"].dictionaryObject
        if let dic = dicAddress {
            let data = dic as NSDictionary
            receiveInfoVO = data.mapToObject(COAddressModel.self)
        }
        model.receiveInfoVO = receiveInfoVO
        
        var platformCouponList: [COCouponModel]? = []
        if let list = json["platformCouponList"].arrayObject {
            platformCouponList = (list as NSArray).mapToObjectArray(COCouponModel.self)
        }
        model.platformCouponList = platformCouponList
        
        // 后期发票编辑/选择界面重写后，使用当前新版发票model
        //        var orderBillInfoVO: COBillModel? = nil
        //        let dicBill = json["orderBillInfoVO"].dictionaryObject
        //        if let dic = dicBill {
        //            let data = dic as NSDictionary
        //            orderBillInfoVO = data.mapToObject(COBillModel.self)
        //        }
        //        model.orderBillInfoVO = orderBillInfoVO
        
        // 为了兼容已有的发票编辑/选择界面，故使用之前定义的老版发票model
        var orderBillInfoVO: InvoiceModel? = nil
        let dicBill = json["orderBillInfoVO"].dictionaryObject
        if let dic = dicBill {
            let data = dic as NSDictionary
            orderBillInfoVO = data.mapToObject(InvoiceModel.self)
        }
        model.orderBillInfoVO = orderBillInfoVO
        
        var orderSupplyCartVOs: [COSupplyOrderModel]? = []
        let listProduct = json["orderSupplyCartVOs"].arrayObject
        if let list = listProduct {
            orderSupplyCartVOs = (list as NSArray).mapToObjectArray(COSupplyOrderModel.self)
        }
        model.orderSupplyCartVOs = orderSupplyCartVOs
        
        model.allTotalAmount = json["allTotalAmount"].numberValue
        model.allCheckOrderShowDiscountAmount = json["allCheckOrderShowDiscountAmount"].numberValue
        model.totalProductNumber = json["totalProductNumber"].intValue
        
        if let dic = json["platformCouponInfo"].dictionaryObject {
            let data = dic as NSDictionary
            model.platformCouponInfo = data.mapToObject(COCouponInfoVoModel.self)
        }
        model.shareRebate = json["shareRebate"].stringValue
        //购物金（6.7.2版本开始使用字段）
        model.allUseGwjBalance = json["allUseGwjBalance"].numberValue
        model.allCanUseGwjBalance = json["allCanUseGwjBalance"].numberValue
        model.allGwjBalance = json["allGwjBalance"].numberValue
//        model.allUseGwjBalance = 10
//        model.allCanUseGwjBalance = 100
//        model.allGwjBalance = 800
        model.hasZiyingStatus = json["hasZiyingStatus"].intValue
        return model
    }
}


/********************************************************************/
// 二级结构

// MARK: - 地址model
final class COAddressModel: NSObject, JSONAbleType {
    var id: Int?                            // 地址id
    var receiverName: String?               // 用户名
    var contactPhone: String?               // 手机号
    var address: String?                    // 地址
    var provinceCode: String?               // 省code
    var provinceName: String?               // 省名称
    var cityCode: String?                   // 市code
    var cityName: String?                   // 市名称
    var districtCode: String?               // 区code
    var districtName: String?               // 区名称
    var printAddress: String?               // 打印地址
    var purchaser: String?                  // 采购员姓名
    var purchaserPhone: String?             // 采购员联系电话
    
    static func fromJSON(_ json: [String : AnyObject]) -> COAddressModel {
        let json = JSON(json)
        
        let model = COAddressModel()
        model.address = json["address"].stringValue
        model.cityCode = json["cityCode"].stringValue
        model.cityName = json["cityName"].stringValue
        model.contactPhone = json["contactPhone"].stringValue
        model.districtCode = json["districtCode"].stringValue
        model.districtName = json["districtName"].stringValue
        model.id = json["id"].intValue
        model.printAddress = json["printAddress"].stringValue
        model.provinceCode = json["provinceCode"].stringValue
        model.provinceName = json["provinceName"].stringValue
        model.purchaser = json["purchaser"].stringValue
        model.purchaserPhone = json["purchaserPhone"].stringValue
        model.receiverName = json["receiverName"].stringValue
        return model
    }
    
    // 判断当前地址是否有效
    func addressIsValid() -> Bool {
        guard let aId = id, aId > 0 else {
            return false
        }
        guard let pName = provinceName, pName.isEmpty == false else {
            return false
        }
        guard let pCode = provinceCode, pCode.isEmpty == false else {
            return false
        }
        guard let cName = cityName, cName.isEmpty == false else {
            return false
        }
        guard let cCode = cityCode, cCode.isEmpty == false else {
            return false
        }
        guard let dName = districtName, dName.isEmpty == false else {
            return false
        }
        guard let dCode = districtCode, dCode.isEmpty == false else {
            return false
        }
        guard let adr = address, adr.isEmpty == false else {
            return false
        }
        guard let name = receiverName, name.isEmpty == false else {
            return false
        }
        guard let phone = contactPhone, phone.isEmpty == false else {
            return false
        }
        
        return true
    }
    
    // 判断当前地址中是否有采购员信息
    func hasPurchaser() -> Bool {
        guard let name = purchaser, name.isEmpty == false else {
            return false
        }
        guard let phone = purchaserPhone, phone.isEmpty == false else {
            return false
        }
        
        return true
    }
}

// MARK: - 发票model...<暂未使用>
final class COBillModel: NSObject, JSONAbleType {
    var bankAccount: String?                    // 银行账户
    var billId: Int?                            // 发票主键
    var billStatus: Int?                        // 发票状态 1待审核；2审核通过；3审核不通过
    var billType: Int?                          // 发票类型 1-增值税专用发票 2-增值税普通发票 3-增值税电子普通发票
    var enterpriseName: String?                 // 单位名称
    var license: String?                        // 纳税人识别号是否必填 1-必填 2-非必填
    var message: String?                        // 财务审核提示信息
    var openingBank: String?                    // 开户银行
    var registeredAddress: String?              // 注册地址
    var registeredTelephone: String?            // 注册电话
    var taxpayerIdentificationNumber: String?   // 纳税人识别号
    
    static func fromJSON(_ json: [String : AnyObject]) -> COBillModel {
        let json = JSON(json)
        
        let model = COBillModel()
        model.bankAccount = json["bankAccount"].stringValue
        model.billId = json["billId"].intValue
        model.billStatus = json["billStatus"].intValue
        model.billType = json["billType"].intValue
        model.enterpriseName = json["enterpriseName"].stringValue
        model.license = json["license"].stringValue
        model.message = json["message"].stringValue
        model.openingBank = json["openingBank"].stringValue
        model.registeredAddress = json["registeredAddress"].stringValue
        model.registeredTelephone = json["registeredTelephone"].stringValue
        model.taxpayerIdentificationNumber = json["taxpayerIdentificationNumber"].stringValue
        return model
    }
}

// MARK: - 订单model
final class COSupplyOrderModel: NSObject, JSONAbleType {
    var accountAmount: Int?                             // 供应商对采购商设置的账期额度，1:表示账期额度可以用； 0:表示账期额度已用完 或 没有设置账期额度
    var allOrderShareCouponMoneyTotal: NSNumber?        // 金额满减 [减xx]
    var canGetRebateMoney: NSNumber?                    // 本单可获返利金
    var checkCouponCodeStr: String?                     // 已选优惠券...[优惠券code]
    var checkPlatformCoupon: String?                    // 是否使用平台优惠券，[1是，0不是]
    var couponSum: String?                              // 金额满减 [满xx]
    var couponUUidFlag: Int?                            //
    var discountAmount: NSNumber?                       // 优惠金额（满减金额）
    var freeShippingAmount: NSNumber?                   // 供应商的订单还差多少金额包邮
    var freeShippingNeed: NSNumber?                     // 供应商的订单满免运费金额标准
    var giftFlag: String?                               // 是否送赠品 1:有
    var giftMessage: String?                            // 赠品描述
    var isAllMutexTeJia: Int?                           // 特价与优惠券互斥需求新增，订单中是否全为不可用券特价商品 (1:是 0:不是)
    var isOnlyZhongJinPay: String?                      //
    
    var noSelectCoupon4MutexTeJia: String?              // [优惠券]由于订单中全是优惠券互斥特价商品导致优惠券无法选择的原因
    var noSelectCouponCode4MutexTeJia: String?          // [优惠码]由于订单中全是优惠券互斥特价商品导致优惠码无法选择的原因
    var offPay: Int?                                    // 默认0:不支持线下转账，1:支持
    var orderCouponMoney: NSNumber?                     // 店铺优惠券金额
    var orderPayMoney: NSNumber?                        // 订单优惠后的金额
    var orderPlatformCouponMoney: NSNumber?             // 平台优惠券金额
    var orderPointValue: NSNumber?                      // 满送积分
    var orderUniqueNum: String?                         // 优惠券需求使用，供应商下订单的唯一标识
    var paymentTermCus: Int?                            // 供应商对采购商设置的账期，即客户账期
    var rebateLimitPercent: Int?                        // 该商家设置的可用返利金比例(只返回比例的值，如：8代表8%)
    var rebateMoney: NSNumber?                          // 本单可用返利金
    var rebateBalance: NSNumber?                        // 用户返利金余额
    var shareCouponMoney: NSNumber?                     // 优惠卷码均摊的金额
    var shareFreight: NSNumber?                         // 均摊运费
    var showCouponCode: String?                         // 优惠券需求，显示已输入的优惠券码 (不为空，则勾选) [优惠码code]
    var showCouponText: Bool?                           // 是否显示优惠码
    var supplyFreight: NSNumber?                        // 订单运费
    var supplyId: Int?                                  // 供应商ID
    var supplyName: String?                             // 供应商名称
    var supplyType: Int?                                // 是否是自营商家标识 0:自营，1:MP商家
    var totalAmount: NSNumber?                          // 总金额
    var useRebateMoney: NSNumber?                       // 本单使用返利金分摊总金额
    var useGwjBalance: NSNumber?                     //本单使用购物金分摊总金额(6.7.2开始使用)
    var usePlatformRebateMoney: NSNumber?               //其中使用的平台返利金
    var uuid: String?                                   // 区分哪些单是一起拆分出来的,均摊运费使用
    var payType: Int?                                   // 默认支付方式...[0-未选择 1-线上 3-线下]
    var freightRuleList: [String]?                      // 运费规则列表
    var adviserVOs: [COAdviserModel]?                   // 供应商销售信息
    var products: [COProductModel]?                     // 商品列表
    var firstMarketingQualifications: [COFollowQualificationsInfoVoModel]? //跟随订单企业首营资料、商品首营资料
    var enterpriseTypeSelState: Bool = false //自定义 字段 企业首营资质选中状态
    var productTypeSelState: Bool = false  //自定义字段商品首营资质选中状态
    var shortWarehouseName: String? //自营仓名
    
    
    //6.3.0新增
    var productTypes: Int? //品种数
    var productCount: Int? //商品件数
    var allTotalMoney: NSNumber? //总金额(一起购还是用老的totalAmount)
    var checkOrderShowDiscountAmount: NSNumber?//立减
    
    //店铺卷信息（6.5.0版本使用字段）
    var shopCouponInfoVO : COCouponInfoVoModel? //
    /**6.5.0版本移除字段 ，放入到了shopCouponInfoVO模型中
     */
    //var checkCouponNum: Int?                            // 优惠券使用数量 >0时勾选使用优惠券 =0时不勾选
    //var hasAvailableCoupon: Bool?                       // 是否有可用优惠券
    //var couponInfoVOList: [COCouponModel]?              // 优惠券列表
    //var noAvailableCouponTxt: String?                   // [优惠券]无可用优惠券
    
    // 本地新增字段
    //    var productCouponSelected: Bool = false             // 商品优惠券cell是否已勾选
    //    var couponCodeSelected: Bool = false                // 优惠券码cell是否已勾选
    
    static func fromJSON(_ json: [String : AnyObject]) -> COSupplyOrderModel {
        let json = JSON(json)
        
        let model = COSupplyOrderModel()
        model.accountAmount = json["accountAmount"].intValue
        model.allOrderShareCouponMoneyTotal = json["allOrderShareCouponMoneyTotal"].numberValue
        model.canGetRebateMoney = json["canGetRebateMoney"].numberValue
        model.checkCouponCodeStr = json["checkCouponCodeStr"].stringValue
        model.checkPlatformCoupon = json["checkPlatformCoupon"].stringValue
        model.couponSum = json["couponSum"].stringValue
        model.couponUUidFlag = json["couponUUidFlag"].intValue
        model.discountAmount = json["discountAmount"].numberValue
        model.freeShippingAmount = json["freeShippingAmount"].numberValue
        model.freeShippingNeed = json["freeShippingNeed"].numberValue
        model.giftFlag = json["giftFlag"].stringValue
        model.giftMessage = json["giftMessage"].stringValue
        model.isAllMutexTeJia = json["isAllMutexTeJia"].intValue
        model.isOnlyZhongJinPay = json["isOnlyZhongJinPay"].stringValue
        model.noSelectCoupon4MutexTeJia = json["noSelectCoupon4MutexTeJia"].stringValue
        model.noSelectCouponCode4MutexTeJia = json["noSelectCouponCode4MutexTeJia"].stringValue
        model.offPay = json["offPay"].intValue
        model.orderCouponMoney = json["orderCouponMoney"].numberValue
        model.orderPayMoney = json["orderPayMoney"].numberValue
        model.orderPlatformCouponMoney = json["orderPlatformCouponMoney"].numberValue
        model.orderPointValue = json["orderPointValue"].numberValue
        model.orderUniqueNum = json["orderUniqueNum"].stringValue
        model.paymentTermCus = json["paymentTermCus"].intValue
        model.rebateLimitPercent = json["rebateLimitPercent"].intValue
        model.rebateMoney = json["rebateMoney"].numberValue
        model.rebateBalance = json["rebateBalance"].numberValue
        model.shareCouponMoney = json["shareCouponMoney"].numberValue
        model.shareFreight = json["shareFreight"].numberValue
        model.showCouponCode = json["showCouponCode"].stringValue
        model.showCouponText = json["showCouponText"].boolValue
        model.supplyFreight = json["supplyFreight"].numberValue
        model.supplyId = json["supplyId"].intValue
        model.supplyName = json["supplyName"].stringValue
        model.supplyType = json["supplyType"].intValue
        model.totalAmount = json["totalAmount"].numberValue
        model.useRebateMoney = json["useRebateMoney"].numberValue
        model.usePlatformRebateMoney = json["usePlatformRebateMoney"].numberValue
        model.uuid = json["uuid"].stringValue
        model.payType = json["payType"].intValue
        model.freightRuleList = json["freightRuleList"].arrayObject as? [String]
        
        var adviserVOs: [COAdviserModel]? = []
        let listAdviser = json["adviserVOs"].arrayObject
        if let list = listAdviser {
            adviserVOs = (list as NSArray).mapToObjectArray(COAdviserModel.self)
        }
        model.adviserVOs = adviserVOs
        
        var followQualityList: [COFollowQualificationsInfoVoModel]? = []
        let firstMarketingQualifications = json["firstMarketingQualifications"].arrayObject
        if let list = firstMarketingQualifications {
            followQualityList = (list as NSArray).mapToObjectArray(COFollowQualificationsInfoVoModel.self)
        }
        model.firstMarketingQualifications = followQualityList
        
        var products: [COProductModel]? = []
        let listProduct = json["products"].arrayObject
        if let list = listProduct {
            products = (list as NSArray).mapToObjectArray(COProductModel.self)
        }
        model.products = products
        model.shortWarehouseName = json["shortWarehouseName"].stringValue
        model.productTypes = json["productTypes"].intValue
        model.productCount = json["productCount"].intValue
        
        model.allTotalMoney = json["allTotalMoney"].numberValue
        model.checkOrderShowDiscountAmount = json["checkOrderShowDiscountAmount"].numberValue
        if let dic = json["shopCouponInfoVO"].dictionaryObject {
            let data = dic as NSDictionary
            model.shopCouponInfoVO = data.mapToObject(COCouponInfoVoModel.self)
        }
        model.useGwjBalance = json["useGwjBalance"].numberValue
        
//        model.checkCouponNum = json["checkCouponNum"].intValue
//        model.hasAvailableCoupon = json["hasAvailableCoupon"].boolValue
//         model.noAvailableCouponTxt = json["noAvailableCouponTxt"].stringValue
//        var couponInfoVOList: [COCouponModel]? = []
//        let listCoupon = json["couponInfoVOList"].arrayObject
//        if let list = listCoupon {
//            couponInfoVOList = (list as NSArray).mapToObjectArray(COCouponModel.self)
//        }
//        model.couponInfoVOList = couponInfoVOList
        return model
    }
}


/********************************************************************/
//  三级结构

// MARK: - 订单之供应商销售信息model
final class COAdviserModel: NSObject, JSONAbleType {
    var adviserCode: String?                //
    var adviserName: String?                //
    var adviserPhoneNumber: String?         //
    var adviserRemark: String?              //
    
    static func fromJSON(_ json: [String : AnyObject]) -> COAdviserModel {
        let json = JSON(json)
        
        let model = COAdviserModel()
        model.adviserCode = json["adviserCode"].stringValue
        model.adviserName = json["adviserName"].stringValue
        model.adviserPhoneNumber = json["adviserPhoneNumber"].stringValue
        model.adviserRemark = json["adviserRemark"].stringValue
        return model
    }
}

// MARK: - 订单之商品model
final class COProductModel: NSObject, JSONAbleType {
    var batchNum: String?                   // 批号
    var checkStatus: Int?                   //
    var createTime: String?                 //
    var deadLine: String?                   // 有效期
    var fixComboYiShengPrice: NSNumber?     //
    var fromWhere: Int?                     // 0：普通，2：一起购
    var inChannel: Bool?                    // 是否渠道商品
    var isMutexTeJia: String?               // 是否为不可用券特价商品 (1:是 0:不是)
    var lessMinReson: String?               //
    var manufactures: String?               //
    var mdInfo: String?                     //
    var messageMap: String?                 //
    var minPackingNum: Int?                 //
    var nearEffect: String?                 // 商品是否近效期品 true = 1，false=其他
    var outMaxReason: String?               //
    var productCodeCompany: String?         // 公司编码
    var productCount: Int?                  // 商品购买数量
    var productGetRebateMoney: NSNumber?    // 该商品获取的返利金总额
    var productId: Int?                     // 商品id
    var productImageUrl: String?            // 商品图片url
    var productMaxNum: Int?                 //
    var productName: String?                // 商品名称
    var productPrice: NSNumber?             // 商品价格
    var realProductPrice: NSNumber?         // 商品实付金额
    var productStatus: Int?                 //
    var productType: String?                // 集采订单1，普通订单0
    var promotionCollectionId: String?      //
    var promotionId: Int?                   // 套餐(促销)id eg:15155
    var promotionType: String?              // 90:vip商品 1特价
    var reachLimitNum: String?              //
    var saleStartNum: Int?                  //
    var settlementPrice: String?            //
    var shoppingCartId: Int?                // 购物车id
    var specification: String?              // 商品规格
    var spuCode: String?                    //
    var supplyId: Int?                      // 供应商id（包含虚拟ID）
    var supplierId: Int?                    // PMS供应商Id...<若为寄售商品为寄售供应商的企业ID,若为非寄售商品则为0>
    var frontSellerCode: Int?               // 前端展示的供应商ID
    var unit: String?                       //
    var wisdomBuyVersion: Int?              //
    var canUseCouponFlag: Int?              // 商品是否不可用劵标识 0:不可用券, 1:可用券
    var productRebate: ProductRebateInfoModel?         // 商品返利 object
    var productLimitBuy: ProductLimitBuyInfoModel?       // 商品限购 object
    var promotionFlashSale: PromationInfoModel?    // 闪购促销 object
    var promotionHG: PromationInfoModel?           // 换购促销 object
    var promotionJF: PromationInfoModel?           // 送积分促销 object
    var promotionMZ: PromationInfoModel?           // 满赠促销 object
    var promotionTJ: PromationInfoModel?           // 特价促销 object
    var agreementRebate: PromationInfoModel?       // 协议奖励金 object
    var promotionMJ: PromationInfoModel?           // 满减促销 object
    var promotionVipVO: CartVipInfoModel?           //vip相关信息 4
    var shareStockVO: COShareStockModel?           // 共享库存字段 object 为空则为本地库存，有值则是共享库存
    var isMutexCouponCode: Int?  //优惠券码  0-可用， 1-不可用
    var showRebateMoneyFlag: Int?  //1展示返利，可能为null
    var unifiedPromotionList:[PromationInfoModel]?    //   底价活动4
    var customerRequestProductType: Int = 0            //  自定义 检查订单商品首营资质选择状态 0 枚选择 1选择批件 2选择全套
    static func fromJSON(_ json: [String : AnyObject]) -> COProductModel {
        let json = JSON(json)
        
        let model = COProductModel()
        model.batchNum = json["batchNum"].stringValue
        model.checkStatus = json["checkStatus"].intValue
        model.createTime = json["createTime"].stringValue
        model.deadLine = json["deadLine"].stringValue
        model.fixComboYiShengPrice = json["fixComboYiShengPrice"].numberValue
        model.fromWhere = json["fromWhere"].intValue
        model.inChannel = json["inChannel"].boolValue
        model.isMutexTeJia = json["isMutexTeJia"].stringValue
        model.lessMinReson = json["lessMinReson"].stringValue
        model.manufactures = json["manufactures"].stringValue
        model.mdInfo = json["mdInfo"].stringValue
        model.messageMap = json["messageMap"].stringValue
        model.minPackingNum = json["minPackingNum"].intValue
        model.nearEffect = json["nearEffect"].stringValue
        model.outMaxReason = json["outMaxReason"].stringValue
        model.productCodeCompany = json["productCodeCompany"].stringValue
        model.productCount = json["productCount"].intValue
        model.productGetRebateMoney = json["productGetRebateMoney"].numberValue
        model.productId = json["productId"].intValue
        model.productImageUrl = json["productImageUrl"].stringValue
        model.productMaxNum = json["productMaxNum"].intValue
        model.productName = json["productName"].stringValue
        model.productPrice = json["productPrice"].numberValue
        //model.realProductPrice = json["realProductPrice"].numberValue
        model.productStatus = json["productStatus"].intValue
        model.productType = json["productType"].stringValue
        model.promotionCollectionId = json["promotionCollectionId"].stringValue
        model.promotionId = json["promotionId"].intValue
        model.promotionType = json["promotionType"].stringValue
        model.reachLimitNum = json["reachLimitNum"].stringValue
        model.saleStartNum = json["saleStartNum"].intValue
        model.settlementPrice = json["settlementPrice"].stringValue
        model.shoppingCartId = json["shoppingCartId"].intValue
        model.specification = json["specification"].stringValue
        model.spuCode = json["spuCode"].stringValue
        model.supplyId = json["supplyId"].intValue
        model.supplierId = json["supplierId"].intValue
        model.frontSellerCode = json["frontSellerCode"].intValue
        model.unit = json["unit"].stringValue
        model.wisdomBuyVersion = json["wisdomBuyVersion"].intValue
        model.canUseCouponFlag = json["canUseCouponFlag"].intValue
        let lmimitDic = json["productLimitBuy"].dictionaryObject
        if let _ = lmimitDic {
            let t = lmimitDic! as NSDictionary
            model.productLimitBuy = t.mapToObject(ProductLimitBuyInfoModel.self)
        }else{
            model.productLimitBuy = nil
        }
        
        let rebateDic = json["productRebate"].dictionaryObject
        if let _ = rebateDic {
            let t = rebateDic! as NSDictionary
            model.productRebate = t.mapToObject(ProductRebateInfoModel.self)
        }else{
            model.productRebate = nil
        }
        
        let agreeRebateDic = json["agreementRebate"].dictionaryObject
        if let _ = agreeRebateDic {
            let t = agreeRebateDic! as NSDictionary
            model.agreementRebate = t.mapToObject(PromationInfoModel.self)
        }else{
            model.agreementRebate = nil
        }
        
        let FlashSaleDic = json["promotionFlashSale"].dictionaryObject
        if let _ = FlashSaleDic {
            let t = FlashSaleDic! as NSDictionary
            model.promotionFlashSale = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionFlashSale = nil
        }
        
        let HGDic = json["promotionHG"].dictionaryObject
        if let _ = HGDic {
            let t = HGDic! as NSDictionary
            model.promotionHG = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionHG = nil
        }
        
        let JFDic = json["promotionJF"].dictionaryObject
        if let _ = JFDic {
            let t = JFDic! as NSDictionary
            model.promotionJF = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionJF = nil
        }
        
        let MZDic = json["promotionMZ"].dictionaryObject
        if let _ = MZDic {
            let t = MZDic! as NSDictionary
            model.promotionMZ = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionMZ = nil
        }
        
        let TJDic = json["promotionTJ"].dictionaryObject
        if let _ = TJDic {
            let t = TJDic! as NSDictionary
            model.promotionTJ = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionTJ = nil
        }
        
        let array = json["unifiedPromotionList"].arrayObject
        var list: [PromationInfoModel]? = []
        if let arr = array{
            list = (arr as NSArray).mapToObjectArray(PromationInfoModel.self)
        }
        model.unifiedPromotionList = list
        
        
        let MJDic = json["promotionMJ"].dictionaryObject
        if let _ = MJDic {
            let t = MJDic! as NSDictionary
            model.promotionMJ = t.mapToObject(PromationInfoModel.self)
        }else{
            model.promotionMJ = nil
        }
        
        let vipDic = json["promotionVipVO"].dictionaryObject
        if let _ = vipDic {
            let t = vipDic! as NSDictionary
            model.promotionVipVO = t.mapToObject(CartVipInfoModel.self)
        }else{
            model.promotionVipVO = nil
        }
        
        // 无值时界面不展示，故需要确定是接口未返回值，还是有返回值但值为0
        if  json["realProductPrice"] != JSON.null {
            // 有值
            model.realProductPrice = json["realProductPrice"].numberValue
        }
        else {
            // 无值
            model.realProductPrice = nil
        }
        
        
        var shareStockVO: COShareStockModel? = nil
        let dicShareStock = json["shareStockVO"].dictionaryObject
        if let dic = dicShareStock {
            let data = dic as NSDictionary
            shareStockVO = data.mapToObject(COShareStockModel.self)
        }
        model.shareStockVO = shareStockVO
        
        if let isMutexCouponCode = json["isMutexCouponCode"].int {
            model.isMutexCouponCode = isMutexCouponCode
        }
        
        if let showRebateMoneyFlag = json["showRebateMoneyFlag"].int {
            model.showRebateMoneyFlag = showRebateMoneyFlag
        }
        return model
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
}

// MARK: - 订单之优惠券model
final class COCouponModel: NSObject, JSONAbleType {
    var begindate: String?                  //
    var couponCode: String?                 // 优惠券code
    var couponDtoShopList: String?          // ???
    var couponName: String?                 //
    var couponTempCode: String?             //
    var couponTempId: Int?                  //
    var createTime: String?                 //
    var denomination: Int?                  //
    var endDate: String?                    //
    var endTime: String?                    //
    var enterpriseId: String?               //
    var id: Int?                            //
    var isCheckCoupon: Int?                 //
    var isLimitProduct: Int?                //
    var isLimitShop: Int?                   //
    var isLimitThisShop: Int?               //
    var isUseCoupon: Int?                   //
    var limitShowText: String?              //
    var limitprice: Int?                    //
    var noCheckReason: String?              //
    var repeatAmount: String?               //
    var sellerCode: String?                 //
    var startTime: String?                  //
    var status: Int?                        //
    var tempEnterpriseId: String?           //
    var tempEnterpriseName: String?         //
    var tempType: Int?                      // 1-平台券
    var templateId: String?                 //
    var useOrderNo: String?                 //
    var useProductPrice: NSNumber?          //
    var useTime: String?                    //
    var useTimeStr: String?                 //
    var couponUseSpuList: [String]?         // 运费规则列表
    
    static func fromJSON(_ json: [String : AnyObject]) -> COCouponModel {
        let json = JSON(json)
        
        let model = COCouponModel()
        model.begindate = json["begindate"].stringValue
        model.couponCode = json["couponCode"].stringValue
        model.couponDtoShopList = json["couponDtoShopList"].stringValue
        model.couponName = json["couponName"].stringValue
        model.couponTempCode = json["couponTempCode"].stringValue
        model.couponTempId = json["couponTempId"].intValue
        model.createTime = json["createTime"].stringValue
        model.denomination = json["denomination"].intValue
        model.endDate = json["endDate"].stringValue
        model.endTime = json["endTime"].stringValue
        model.enterpriseId = json["enterpriseId"].stringValue
        model.id = json["id"].intValue
        model.isCheckCoupon = json["isCheckCoupon"].intValue
        model.isLimitProduct = json["isLimitProduct"].intValue
        model.isLimitShop = json["isLimitShop"].intValue
        model.isLimitThisShop = json["isLimitThisShop"].intValue
        model.isUseCoupon = json["isUseCoupon"].intValue
        model.limitShowText = json["limitShowText"].stringValue
        model.limitprice = json["limitprice"].intValue
        model.noCheckReason = json["noCheckReason"].stringValue
        model.repeatAmount = json["repeatAmount"].stringValue
        model.sellerCode = json["sellerCode"].stringValue
        model.startTime = json["startTime"].stringValue
        model.status = json["status"].intValue
        model.tempEnterpriseId = json["tempEnterpriseId"].stringValue
        model.tempEnterpriseName = json["tempEnterpriseName"].stringValue
        model.tempType = json["tempType"].intValue
        model.templateId = json["templateId"].stringValue
        model.useOrderNo = json["useOrderNo"].stringValue
        model.useProductPrice = json["useProductPrice"].numberValue
        model.useTime = json["useTime"].stringValue
        model.useTimeStr = json["useTimeStr"].stringValue
        model.couponUseSpuList = json["couponUseSpuList"].arrayObject as? [String]
        return model
    }
}


/********************************************************************/
//  四级结构

// MARK: - 商品之促销model...<待验证model结构>
final class COPromotionModel: NSObject, JSONAbleType {
    var shareMoney: String?                // 商品均摊的满减金额???
    
    static func fromJSON(_ json: [String : AnyObject]) -> COPromotionModel {
        let json = JSON(json)
        
        let model = COPromotionModel()
        model.shareMoney = json["shareMoney"].stringValue
        return model
    }
}

// MARK: - 商品之共享库存model
final class COShareStockModel: NSObject, JSONAbleType {
    var stockToFromWarhouseId: Int? // 库存调拨仓ID
    var desc: String?               // 发货文描：【该商品需从XX进行调拔，预计可发货时间：2000-01-01】
    var needAlert: Bool?            // 是否需要弹出提示
    
    static func fromJSON(_ json: [String : AnyObject]) -> COShareStockModel {
        let json = JSON(json)
        
        let model = COShareStockModel()
        model.stockToFromWarhouseId = json["stockToFromWarhouseId"].intValue
        model.desc = json["desc"].stringValue
        model.needAlert = json["needAlert"].boolValue
        return model
    }
}
// MARK: - 优惠券信息model
final class COCouponInfoVoModel: NSObject, JSONAbleType {
    var hasAvailableCoupon: Bool?   // 是否有可用优惠券
    var checkCouponNum: Int?        //优惠券数量
    var noAvailableCouponTxt: String?   // 有无可用优惠券文描
    var couponInfoVOList : [COCouponModel]?  //优惠卷列表信息
    
    static func fromJSON(_ json: [String : AnyObject]) -> COCouponInfoVoModel {
        let json = JSON(json)
        
        let model = COCouponInfoVoModel()
        model.hasAvailableCoupon = json["hasAvailableCoupon"].boolValue
        model.checkCouponNum = json["checkCouponNum"].intValue
        model.noAvailableCouponTxt = json["noAvailableCouponTxt"].stringValue
        if let list = json["couponInfoVOList"].arrayObject {
            model.couponInfoVOList = (list as NSArray).mapToObjectArray(COCouponModel.self)
        }
        return model
    }
}
// MARK: - 企业首营资料、商品首营资料信息model
final class COFollowQualificationsInfoVoModel: NSObject, JSONAbleType {
    var name: String?   // 名称
    var type : String?     //ID
    
    static func fromJSON(_ json: [String : AnyObject]) -> COFollowQualificationsInfoVoModel {
        let json = JSON(json)
        
        let model = COFollowQualificationsInfoVoModel()
        model.name = json["name"].stringValue
        model.type = json["type"].stringValue
        return model
    }
}
