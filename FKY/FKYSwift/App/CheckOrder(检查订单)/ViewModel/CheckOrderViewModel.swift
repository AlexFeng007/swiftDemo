//
//  CheckOrderViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  检查订单viewmodel

//  接口文档wiki地址：
//  1.检查订单 http://wiki.yiyaowang.com/pages/viewpage.action?pageId=18798987
//  2.提交订单 http://wiki.yiyaowang.com/pages/viewpage.action?pageId=18782977
//  3.获取用户在商家下最近一笔订单支付方式 http://wiki.yiyaowang.com/pages/viewpage.action?pageId=19531461


import UIKit

// (一级)支付方式
enum COPayType: Int {
    case online = 0     // 在线支付
    case offline = 1    // 线下转账
}


//  检查订单刷新失败错误码类型
enum CORefreshFailType: String {
    // 购物车中商品信息发生变化，需返回重新结算
    case shouldBackToCart = "002090009999"
    // 优惠码相关错误
    // 1.优惠券码不正确，请检查后重输
    // 2.优惠券码已使用，不可重复使用。
    // 3.此优惠券码面值为满50.00减20.00，您的订单未达到该优惠券码的最低使用金额，暂不可使用,您可以提高订单金额后再试试。
    case couponCodeError = "002090000000"
    // 其它...<无操作>
    case noAction = "noAction"
}



class CheckOrderViewModel: NSObject {
    // MARK: - Property
    
    // 默认值为0-普通订单类型 一起购业务必填2
    // 注：一起购之立即认购传1 或 空  <5 :单品包邮-立即下单>
    var fromWhere: Int = 0
    
    // 一起购之商品列表
    var productArray: [Any]?
    //立即下单商品列表
    var orderProductArray: [Any]?
    // 默认...[非一起购订单]
    var isGroupBuy: Bool = false
    
    // 默认为检查订单初始化 [true-刷新 false-初始化]
    fileprivate var refreshFlagCO: Bool = false
    
    /*******************************************************/
    
    // 检查订单接口返回数据model
    var modelCO: CheckOrderModel?
    var followQualityCOModel: CheckOrderModel? //跟随资质的model,防止其他优惠券刷新把这个改变
    
    /*******************************************************/
    
    // 说明：检查订单刷新时不清空...<纯本地保存>
    // 留言...<key应该使用商家id>...<若商家id为空，才用商家index>
    fileprivate var dicMessage: Dictionary<Int, String> = [Int: String]()
    
    // 说明：检查订单刷新时不清空...<商家id对应的支付type有值时不处理，无值时需用接口返回数据进行赋值>
    // 支付方式...<key应该使用商家id>...<若商家id为空，才用商家index>
    fileprivate var dicPayType: Dictionary<Int, COPayType> = Dictionary<Int, COPayType>()
    
    //平台券（共享平台券使用）
    var platformCouponCode = ""
    //输入的返利金（共享返利金使用）
    var allUseRebateStr = 0.0
    //输入的购物金
    var allShopBuyMoneyStr = 0.0
    // 说明：检查订单刷新时需清空~!@
    // 商品优惠券code内容...<key应该使用商家id>...<若商家id为空，才用商家index>
    fileprivate var dicProductCoupon: Dictionary<Int, String> = [Int: String]()
    
    // 说明：检查订单刷新时需清空~!@
    // 优惠券码code内容...<key应该使用商家id>...<若商家id为空，才用商家index>
    fileprivate var dicCouponCode: Dictionary<Int, String> = [Int: String]()
    
    // 说明：检查订单刷新时需清空~!@
    // 使用返利金...<key应该使用商家id>...<若商家id为空，才用商家index>
    fileprivate var dicRebate: Dictionary<Int, Double> = [Int: Double]()
    
    // 说明：检查订单刷新时需清空~!@
    // 是否使用平台券...<key应该使用商家id>...<若商家id为空，才用商家index>
    //fileprivate var dicUsePlatformCoupon: Dictionary<Int, Bool> = [Int: Bool]()
    
    // 说明：检查订单刷新时不清空...<商家id对应的selected状态有值时不处理，无值时需用接口返回数据进行赋值>
    // 商品优惠券selected(勾选)状态...<key应该使用商家id>...<若商家id为空，才用商家index>
    fileprivate var dicProductCouponSelected: Dictionary<Int, Bool> = [Int: Bool]()
    
    // 说明：检查订单刷新时不清空...<商家id对应的selected状态有值时不处理，无值时需用接口返回数据进行赋值>
    // 优惠券码selected(勾选)状态...<key应该使用商家id>...<若商家id为空，才用商家index>
    fileprivate var dicCouponCodeSelected: Dictionary<Int, Bool> = [Int: Bool]()
    
    
    // 说明：用于实时保存选择的销售单是否随货，，检查订单刷新时不清空，有值用本地，无值用接口
    // 销售合同随货与否，0：不随货，1：随货 2:未肤质
    fileprivate var salesContractFlowGoods: Int = 2
    
    
    // 说明：用于实时保存用户每次输入的优惠码。用户输入优惠码结束后进行刷新操作，若刷新失败，说明当前优惠码错误，需要立即清除
    // 所有用户输入过的优惠码数组
    fileprivate var listForAllCouponCodeInput: [String] = [String]()
    
    // 说明: 保存用户发票信息
    // 订单发票model
    var invoiceModel: InvoiceModel?
    
    /*******************************************************/
    
    // 提交订单成功时接口返回的model
    var modelSO: COSubmitOrderModel?
    
    //封装数据源
    var coSections = [FKYCOContainer]()
}


// MARK: - 封装入参
extension CheckOrderViewModel {
    // 封装入参...<检查订单>...<包括普通订单、一起购订单>
    fileprivate func getCheckOrderData() -> Dictionary<String, Any>? {
        // 1.用户id
        let userid: String = (FKYLoginAPI.loginStatus() == .unlogin) ? "" : FKYLoginAPI.currentUserId()
        
        // 2. 设备号
        var appUuid = ""
        if let deviceId = UIDevice.readIdfvForDeviceId(), deviceId.isEmpty == false {
            appUuid = deviceId
        }
        
        // 3.优惠券标识 [固定填“1”]
        // let couponVersion = "1"
        
        // 4.订单检查页提交类型 [默认0-普通订单检查，1-智采订单检查，2-一起购订单检查]
        var checkType = 0
        if isGroupBuy {
            checkType = 2
        }
        //单品包邮-立即下单
        if self.fromWhere == 5 {
            checkType = 5
        }
        
        // 5.来源 [普通订单类型:0 一起购业务:2]
        let fromwhereValue = self.fromWhere
        
        // 6.是否初始化订单检查页（从购物车跳过来）[1-是，0-不是] [非初始化状态填0, 默认为1]
        var initCheckPage = 1
        if refreshFlagCO {
            initCheckPage = 0
        }
        
        // 7.订单中的商品在购物车中的唯一id
        // [initCheckPage不为1，且checkType不为0时必填]
        var shoppingCartList = [Any]()
        
        // 针对一起购之立即认购
        if let list = productArray, list.count > 0 {
            for product in list {
                if let obj: FKYCartGroupInfoModel = product as? FKYCartGroupInfoModel {
                    // 价格改为string，防止精度丢失~!@
                    var price = "0.0"
                    if let productPrice = obj.productPrice, productPrice.doubleValue > 0 {
                        price = String(format: "%.2f", productPrice.doubleValue)
                    }
                    
                    var param: Dictionary<String, Any> = [String: Any]()
                    param["PromotionId"] = obj.promotionId ?? 0
                    param["ProductNum"] = obj.productCount ?? 0
                    param["ProductName"] = obj.productName ?? ""
                    param["ProductPrice"] = price
                    shoppingCartList.append(param)
                }
            } // for
        }
        
        
        // 检查订单初始化
        if initCheckPage == 1 {
            var param: Dictionary<String, Any> = [String: Any]()
            param["userId"] = userid
            param["appUuid"] = appUuid
            param["checkType"] = checkType
            param["fromwhere"] = fromwhereValue
            // param["couponVersion"] = couponVersion
            param["initCheckPage"] = initCheckPage
            if isGroupBuy == true, shoppingCartList.count > 0 {
                param["shoppingCartList"] = shoppingCartList
            }
            if let list = orderProductArray, list.count > 0 {
                //立即下单
                param["shoppingCartList"] = list
                param["checkType"] = 3
            }
            //分享bd 的佣金Id
            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                param["shareUserId"] = cpsbd
            }
            // 最终入参
            let jsonParams: Dictionary<String, Any> = ["jsonParams": param]
            return jsonParams
        }
        
        // error
        guard let model = modelCO, let listShop = model.orderSupplyCartVOs, listShop.count > 0 else {
            // 默认仅初始化
            var param: Dictionary<String, Any> = [String: Any]()
            param["userId"] = userid
            param["appUuid"] = appUuid
            param["checkType"] = checkType
            param["fromwhere"] = fromwhereValue
            //param["couponVersion"] = couponVersion
            param["initCheckPage"] = initCheckPage
            if isGroupBuy == true, shoppingCartList.count > 0 {
                param["shoppingCartList"] = shoppingCartList
            }
            //分享bd 的佣金Id
            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                param["shareUserId"] = cpsbd
            }
            // 最终入参
            let jsonParams: Dictionary<String, Any> = ["jsonParams": param]
            return jsonParams
        }
        
        // 以上是(检查订单)初始化
        /*******************************************/
        // 以下是(检查订单)刷新
        
        // 8.平台券编码
        // [initCheckPage为0时，必填]
        //        var platformCouponCode = ""
        //        if let pCouponCode = model.platformCouponCode, pCouponCode.isEmpty == false {
        //            platformCouponCode = pCouponCode
        //        }
        
        // 9.后台返回的订单唯一编码，用户重选优惠券，优惠码等需求
        // [initCheckPage为0时，必填]
        var orderUniqueNumList = [String]()
        for shop: COSupplyOrderModel in listShop {
            if let number = shop.orderUniqueNum, number.isEmpty == false {
                orderUniqueNumList.append(number)
            }
            else {
                orderUniqueNumList.append("")
            }
        }
        
        //未使用共享返利金，单个店铺使用返利金
        var useRebateMoneyList = [String]()
        if model.shareRebate != "1" {
            // 10.所有订单输入的返利金抵扣，每个元素是一个订单的
            // [initCheckPage为0时，必填]
            for shop: COSupplyOrderModel in listShop {
                if let sid = shop.supplyId {
                    if let value = dicRebate[sid], value > 0 {
                        // 有使用返利金
                        let content = String(format: "%.2f", value)
                        useRebateMoneyList.append(content)
                    }
                    else {
                        // 未使用返利金
                        useRebateMoneyList.append("0")
                    }
                }
            }
        }
        
        // 11.所有订单已选的优惠券，每个元素是一个订单的（多张卷用，分割）
        // [initCheckPage为0时，必填] [优惠券code数组]
        var allCheckCouponCodeList = [String]()
        var allPayTypeList = [String]()   //支付方式列表，
        for shop: COSupplyOrderModel in listShop {
            if let sid = shop.supplyId {
                if let code = dicProductCoupon[sid], code.isEmpty == false {
                    // 不为空
                    allCheckCouponCodeList.append(code)
                }
                else {
                    // 为空
                    allCheckCouponCodeList.append("")
                }
                //支付方式列表
                if let type: COPayType = dicPayType[sid] {
                    if type == .online {
                        //在线支付
                        allPayTypeList.append("1")
                    }else if type == .offline {
                        //线下转账
                        allPayTypeList.append("3")
                    }
                }
            }
        }
        
        // 12.已输入的优惠码
        // [initCheckPage为0时，必填] [优惠码code数组]
        var couponCodeList = [String]()
        for shop: COSupplyOrderModel in listShop {
            if let sid = shop.supplyId {
                if let code = dicCouponCode[sid], code.isEmpty == false {
                    // 不为空
                    couponCodeList.append(code)
                }
                else {
                    // 为空
                    couponCodeList.append("")
                }
            }
        }
        
        // 13.使用优惠券还是优惠券码，1-优惠券码，0-优惠券
        // [initCheckPage为0时，必填]
        var couponTypeList = [String]()
        for shop: COSupplyOrderModel in listShop {
            if let sid = shop.supplyId {
                // 判断是否使用优惠券
                var hasProductCoupon = false
                if let code = dicProductCoupon[sid], code.isEmpty == false {
                    // 不为空
                    hasProductCoupon = true
                }
                // 判断是否使用优惠码
                var hasCouponCode = false
                if let code = dicCouponCode[sid], code.isEmpty == false {
                    // 不为空
                    hasCouponCode = true
                }
                // 赋值
                if hasProductCoupon == true, hasCouponCode == false {
                    // 优惠券
                    couponTypeList.append("0")
                }
                else if hasProductCoupon == false, hasCouponCode == true {
                    // 优惠码
                    couponTypeList.append("1")
                }
                else if hasProductCoupon == false, hasCouponCode == false {
                    // 两者均无...<传空>
                    couponTypeList.append("")
                }
                else {
                    // 两者均有...<error>...<默认优惠券>
                    couponTypeList.append("0")
                }
            }
        }
        
        // 14.是否使用平台券的订单，对应优惠券的列表 [1-当前订单使用平台券，0-当前订单不使用平台券]
        //        var usePlatformCoupon = [String]()
        //        for shop: COSupplyOrderModel in listShop {
        //            if let sid = shop.supplyId {
        //                if let useFlag = dicUsePlatformCoupon[sid] {
        //                    // 不为空
        //                    let use = useFlag ? "1" : "0"
        //                    usePlatformCoupon.append(use)
        //                }
        //                else {
        //                    // 为空...<默认不使用>
        //                    usePlatformCoupon.append("0")
        //                }
        //            }
        //        }
        
        // 平台券特殊逻辑...<默认未使用>
        //        var hasUsePlatformCoupon = false
        //        for flag: String in usePlatformCoupon {
        //            if flag == "1" {
        //                hasUsePlatformCoupon = true
        //                break
        //            }
        //        } // for
        //        if hasUsePlatformCoupon == false {
        //            // 未使用平台优惠券
        //            platformCouponCode = ""
        //        }
        
        var param: Dictionary<String, Any> = [String: Any]()
        param["userId"] = userid
        param["appUuid"] = appUuid
        param["checkType"] = checkType
        param["fromwhere"] = fromwhereValue
        //param["couponVersion"] = couponVersion
        param["initCheckPage"] = initCheckPage
        param["platformCouponCode"] = self.platformCouponCode
        param["orderUniqueNumList"] = orderUniqueNumList
        
        param["allCheckCouponCodeList"] = allCheckCouponCodeList
        param["couponCodeList"] = couponCodeList
        param["couponTypeList"] = couponTypeList
        //param["usePlatformCoupon"] = usePlatformCoupon
        if isGroupBuy == true, shoppingCartList.count > 0 {
            param["shoppingCartList"] = shoppingCartList
        }
        if model.shareRebate == "1" {
            //使用共享返利金
            param["useRebateMoney"] = String(format: "%.2f", self.allUseRebateStr)
        }else {
            //单个店铺使用返利金
            param["useRebateMoneyList"] = useRebateMoneyList
        }
        //分享bd 的佣金Id
        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
            param["shareUserId"] = cpsbd
        }
        /**6.7.2增加字段**/
        //购物金
        param["useGwjBalance"] = String(format: "%.2f", self.allShopBuyMoneyStr)
        //支付方式
        param["payTypeList"] = allPayTypeList
        // 最终入参
        let jsonParams: Dictionary<String, Any> = ["jsonParams": param]
        return jsonParams
    }
    
    // 封装入参...<请求当前商家的可用优惠券>
    func getProductCouponData(_ shopOrder: COSupplyOrderModel?) -> FKYCouponDicModel {
        let dicModel = FKYCouponDicModel()
        if let shopModel = shopOrder {
            //店铺券
            dicModel.sellerCode = shopModel.supplyId ?? 0
            dicModel.platformCouponFlag = false
        }else {
            //平台券
            dicModel.platformCouponFlag = true
        }
        dicModel.platformCouponCode = self.platformCouponCode
        
        var couponDTOList = [SingleShopCouponDTO]()
        if let model = modelCO, let listShop = model.orderSupplyCartVOs, listShop.count > 0 {
            for shop in listShop {
                // 非当前商家加入
                let dicM = SingleShopCouponDTO()
                if let sid = shop.supplyId {
                    dicM.sellerCode = sid
                    if let str = dicProductCoupon[sid] {
                        dicM.couponCodeList = str.components(separatedBy: ",")
                    }
                }
                couponDTOList.append(dicM)
            }
        } 
        dicModel.couponDTOList = couponDTOList
        return dicModel
        
        // 5.数组...<商品维度>
        // var fullReduceList: [String] = [String]()
        //        // 6.数组...<商品维度>
        //        var shopCartIdList: [Int] = [Int]()
        //        // 遍历当前商家订单中的所有商品model
        //        if let list = shopOrder.products, list.count > 0 {
        //            for product: COProductModel in list {
        //                //
        //                if let promotionMJ = product.promotionMJ, let shareMoney = promotionMJ.shareMoney?.stringValue, shareMoney.isEmpty == false {
        //                    fullReduceList.append(shareMoney)
        //                }
        //                else {
        //                    fullReduceList.append("0")
        //                }
        //                //
        //                if let shoppingCartId = product.shoppingCartId {
        //                    shopCartIdList.append(shoppingCartId)
        //                }
        //                else {
        //                    shopCartIdList.append(0)
        //                }
        //            } // for
        //        }
        
        //        if fullReduceList.count > 0 {
        //            param["fullReduceList"] = fullReduceList
        //        }
        //        if shopCartIdList.count > 0 {
        //            param["shopCartIdList"] = shopCartIdList
        //        }
    }
    
    // 封装入参...<提交订单>...<普通订单，非一起购>
    fileprivate func getSubmitOrderData() -> Dictionary<String, Any>? {
        // 最终入参...<一级>
        var jsonParams = Dictionary<String, Any>()
        
        // [1].ycToken
        var yctoken = ""
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            yctoken = token
        }
        
        // [2].业务参数...<二级>
        var param = Dictionary<String, Any>()
        
        /***************************************************************/
        
        // 1. 设备号
        var appUuid = ""
        if let deviceId = UIDevice.readIdfvForDeviceId(), deviceId.isEmpty == false {
            appUuid = deviceId
        }
        
        // error
        guard let model = modelCO else {
            // 业务参数
            param["appUuid"] = appUuid
            //分享bd 的佣金Id
            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                param["cpsbd"] = cpsbd
            }
            // 最终入参
            jsonParams["ycToken"] = yctoken
            jsonParams["jsonParams"] = param
            return jsonParams
        }
        
        // 2. 地址id
        var addressId = 0
        if let address = model.receiveInfoVO, let aid = address.id {
            addressId = aid
        }
        
        
        // 3. 发票类型 [1-增值税专用发票 2-增值税普通发票 3-增值税电子普通发票]
        var billType = 2 // 默认增值税普通发票
        if let bill = invoiceModel, let type = bill.billType, type.isEmpty == false {
            if type == "1" || type == "2" || type == "3" {
                if let value = Int(type) {
                    billType = value
                }
            }
        }
        // 4. 用户维护的发票信息JSON字符串
        var billInfoJson = ""
        if let bill = invoiceModel {
            // model转dic
            let dicBill: [String : Any] = bill.reverseJSON()
            // dic转string
            do {
                // dic转data
                let jsonData = try JSONSerialization.data(withJSONObject: dicBill, options: JSONSerialization.WritingOptions.prettyPrinted)
                // data转string
                let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8)
                // 非空判断
                if let json = jsonString, json.isEmpty == false {
                    billInfoJson = json
                }
            } catch {
                print("dic转string失败")
            }
        }
        
        // error
        guard let listShop = model.orderSupplyCartVOs, listShop.count > 0 else {
            // 业务参数
            param["appUuid"] = appUuid
            param["addressId"] = addressId
            param["billType"] = billType
            param["billInfoJson"] = billInfoJson
            param["platformCouponCode"] = self.platformCouponCode //平台券
            //分享bd 的佣金Id
            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                param["cpsbd"] = cpsbd
            }
            // 最终入参
            jsonParams["ycToken"] = yctoken
            jsonParams["jsonParams"] = param
            return jsonParams
        }
        
        // 5.订单信息列表...<三级>
        var orderList: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
        
        
        // 遍历商家订单model
        for order: COSupplyOrderModel in listShop {
            // 初始化map字典
            var dic: Dictionary<String, Any> = Dictionary<String, Any>()
            
            // 1.供应商ID
            var supplyId = 0
            if let sid = order.supplyId {
                supplyId = sid
            }
            
            // 2.用户输入的返利金抵扣
            var orderUseRebateMoney: String = "0"
            if let value = order.useRebateMoney, value.doubleValue > 0 {
                orderUseRebateMoney = String(format: "%.2f", value.doubleValue)
            }
            // 用户输入的购物金分摊金额
            var orderShopRechargeMoney = "0"
            if let value = order.useGwjBalance, value.doubleValue > 0 {
                orderShopRechargeMoney = String(format: "%.2f", value.doubleValue)
            }
            
            //用户输入的返利金中平台返利金抵扣
            var orderUsePlatformRebateMoney : String = "0"
            if let value = order.usePlatformRebateMoney, value.doubleValue > 0 {
                orderUsePlatformRebateMoney = String(format: "%.2f", value.doubleValue)
            }
            
            // 3.订单完成可获得的返利金
            var orderCanGetRebateMoney: String = "0"
            if let value = order.canGetRebateMoney, value.doubleValue > 0 {
                orderCanGetRebateMoney = String(format: "%.2f", value.doubleValue)
            }
            
            // 4.订单运费
            var orderFreight: String = "0"
            if let value = order.supplyFreight, value.doubleValue > 0 {
                orderFreight = String(format: "%.2f", value.doubleValue)
            }
            
            // 5.均摊运费
            var freight: String = "0"
            if let value = order.shareFreight, value.doubleValue > 0 {
                freight = String(format: "%.2f", value.doubleValue)
            }
            
            // 6.拆单标示
            var orderUuid: String = ""
            if let content = order.orderUniqueNum, content.isEmpty == false {
                orderUuid = content
            }
            
            // 7.优惠券code
            var checkCouponCodeStr: String = ""
            if let content = order.checkCouponCodeStr, content.isEmpty == false {
                checkCouponCodeStr = content
            }
            
            // 8.优惠码code
            var couponCode: String = ""
            if let content = order.showCouponCode, content.isEmpty == false {
                couponCode = content
            }
            
            // 9.优惠券优惠总金额
            var orderAllCouponMoney: String = "0.00"
            var orderCouponMoney: Double = 0.0
            if let value = order.orderCouponMoney, value.doubleValue > 0 {
                orderCouponMoney += value.doubleValue
            }
            //            if let value = order.orderPlatformCouponMoney, value.doubleValue > 0 {
            //                orderCouponMoney += value.doubleValue
            //            }
            if orderCouponMoney > 0 {
                orderAllCouponMoney = String(format: "%.2f", orderCouponMoney)
            }
            
            // 10.满减优惠金额
            var orderFullReductionMoney: String = "0"
            if let value = order.discountAmount, value.doubleValue > 0 {
                orderFullReductionMoney = String(format: "%.2f", value.doubleValue)
            }
            
            // 11.满送积分
            var orderFullReductionIntegration: String = "0"
            if let value = order.orderPointValue, value.doubleValue > 0 {
                orderFullReductionIntegration = String(format: "%.2f", value.doubleValue)
            }
            
            // 12.当前订单优惠券均摊金额
            var couponMoney: String = "0"
            if let value = order.shareCouponMoney, value.doubleValue > 0 {
                couponMoney = String(format: "%.2f", value.doubleValue)
            }
            
            // 13.支付类型 [1-在线支付(默认) 3-线下支付]
            var payType = 1
            if let type: COPayType = dicPayType[supplyId] {
                // 有保存的支付方式
                switch type {
                case .online:
                    // 在线支付
                    payType = 1
                case .offline:
                    // 线下转账
                    payType = 3
                }
            }
            else {
                // 无保存的支付方式...<error>
            }
            
            // 14.留言
            var leaveMsg = ""
            if let content = dicMessage[supplyId], content.isEmpty == false {
                leaveMsg = content
            }
            
            var customerRequestOrderType = ""
            // 15. 跟随企业首营资质
            if let shopModel = self.getSameSupplyFollowQualityInfo("\(order.supplyId ?? 0)"){
                if shopModel.enterpriseTypeSelState == true{
                    customerRequestOrderType = "a"
                }
            }
            
            dic["supplyId"] = supplyId // 供应商ID
            dic["orderUseRebateMoney"] = orderUseRebateMoney // 用户输入的总的返利金抵扣
            dic["shopRechargeMoney"] = orderShopRechargeMoney // 用户输入的购物金每个店铺平摊金额
            dic["usePlatformRebateMoney"] = orderUsePlatformRebateMoney // 用户输入的返利金抵扣中平台返利金抵扣
            dic["orderCanGetRebateMoney"] = orderCanGetRebateMoney // 订单完成可获得的返利金
            dic["orderFreight"] = orderFreight // 订单运费
            dic["freight"] = freight // 均摊运费
            dic["orderUuid"] = orderUuid // 拆单标示
            dic["checkCouponCodeStr"] = checkCouponCodeStr // 优惠券code
            dic["couponCode"] = couponCode // 优惠码code
            dic["orderCouponMoney"] = orderAllCouponMoney // 优惠券优惠总金额
            dic["orderFullReductionMoney"] = orderFullReductionMoney // 满减优惠金额
            dic["orderFullReductionIntegration"] = orderFullReductionIntegration // 满送积分
            dic["couponMoney"] = couponMoney // 当前订单优惠券均摊金额
            dic["payType"] = payType // 支付类型 [1-在线支付(默认) 3-线下支付]
            dic["leaveMsg"] = leaveMsg // 留言
            dic["customerRequestOrderType"] = customerRequestOrderType // 企业首营资质
            // 销售顾问...<已去掉>
            //dic["adviser"] = ""
            
            // 16.购物车id数组...<无换购逻辑>
            var shopCartIdList: [Int] = [Int]()
            // 17.促销(套餐)类型数组
            var promotionTypeList: [Int] = [Int]()
            // 18.促销(套餐)id数组
            var promotionIdList: [Int] = [Int]()
            // 19 跟随商品首营资料
            var shopProductDetails: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
            
            if let shopModel = self.getSameSupplyFollowQualityInfo("\(order.supplyId ?? 0)"){
                // 遍历所有商品model
                if let products = shopModel.products, products.count > 0 {
                    var productDic: Dictionary<String, Any> = Dictionary<String, Any>()
                    for item: COProductModel in products {
                        // cartid
                        if let cartid = item.shoppingCartId {
                            shopCartIdList.append(cartid)
                            productDic["shopCartId"] = cartid
                        }
                        else {
                            shopCartIdList.append(0)
                        }
                        // promotion-type
                        if let type = item.promotionType, type.isEmpty == false, let value = Int(type), value >= 0 {
                            promotionTypeList.append(value)
                        }
                        else {
                            promotionTypeList.append(0)
                        }
                        // promotion-id
                        if let id = item.promotionId, id >= 0 {
                            promotionIdList.append(id)
                        }
                        else {
                            promotionIdList.append(0)
                        }
                        //customerRequestProductType 1选择批件 2选择全套
                        if item.customerRequestProductType == 1 {
                            productDic["customerRequestProductType"] = "a"
                            shopProductDetails.append(productDic)
                        }else if item.customerRequestProductType == 2{
                            productDic["customerRequestProductType"] = "b"
                            shopProductDetails.append(productDic)
                        }
                    } // for
                }
            }
            else{
                // 遍历所有商品model
                if let products = order.products, products.count > 0 {
                    for item: COProductModel in products {
                        // cartid
                        if let cartid = item.shoppingCartId {
                            shopCartIdList.append(cartid)
                        }
                        else {
                            shopCartIdList.append(0)
                        }
                        // promotion-type
                        if let type = item.promotionType, type.isEmpty == false, let value = Int(type), value >= 0 {
                            promotionTypeList.append(value)
                        }
                        else {
                            promotionTypeList.append(0)
                        }
                        // promotion-id
                        if let id = item.promotionId, id >= 0 {
                            promotionIdList.append(id)
                        }
                        else {
                            promotionIdList.append(0)
                        }
                    } // for
                }
            }
            dic["shopCartIdList"] = shopCartIdList
            dic["promotionTypeList"] = promotionTypeList
            dic["promotionIdList"] = promotionIdList
            dic["shopProductDetails"] = shopProductDetails
            // 加入数组
            orderList.append(dic)
        } // for
        // 销售合同随货显示与否，0：不显示，1：显示
        if  model.showSalesContract == 1{
            if self.salesContractFlowGoods != 2{
                // 未初始化  销售合同随货与否，0：不随货，1：随货
                param["isPrintContract"] = self.salesContractFlowGoods
            }
        }
        //分享bd 的佣金I
        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
            param["cpsbd"] = cpsbd
        }
        // 业务参数
        param["appUuid"] = appUuid
        param["addressId"] = addressId
        param["billType"] = billType
        param["billInfoJson"] = billInfoJson
        param["platformCouponCode"] = self.platformCouponCode //平台券
        param["orderList"] = orderList
        // 最终入参
        jsonParams["ycToken"] = yctoken
        jsonParams["jsonParams"] = param
        return jsonParams
    }
    
    // 封装入参...<一起购提交订单>
    fileprivate func getSubmitGroupBuyOrderData() -> Dictionary<String, Any>? {
        // 最终入参...<一级>
        var jsonParams = Dictionary<String, Any>()
        
        // [1].ycToken
        var yctoken = ""
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            yctoken = token
        }
        
        // [2].业务参数...<二级>
        var param = Dictionary<String, Any>()
        
        /***************************************************************/
        
        // 1. 设备号
        var appUuid = ""
        if let deviceId = UIDevice.readIdfvForDeviceId(), deviceId.isEmpty == false {
            appUuid = deviceId
        }
        
        // 2. version...[一起购固定传0]
        let version = 0
        
        // error
        guard let model = modelCO else {
            // 业务参数
            param["appUuid"] = appUuid
            param["version"] = version
            //分享bd 的佣金Id
            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                param["cpsbd"] = cpsbd
            }
            // 最终入参
            jsonParams["ycToken"] = yctoken
            jsonParams["jsonParams"] = param
            return jsonParams
        }
        
        // 2. 地址id
        var addressId = 0
        if let address = model.receiveInfoVO, let aid = address.id {
            addressId = aid
        }
        
        // 3. 发票类型 [1-增值税专用发票 2-增值税普通发票 3-增值税电子普通发票]
        var billType = 2 // 默认增值税普通发票
        if let bill = invoiceModel, let type = bill.billType, type.isEmpty == false {
            if type == "1" || type == "2" || type == "3" {
                if let value = Int(type) {
                    billType = value
                }
            }
        }
        
        // 4. 用户维护的发票信息JSON字符串
        var billInfoJson = ""
        if let bill = invoiceModel {
            // model转dic
            let dicBill: [String : Any] = bill.reverseJSON()
            // dic转string
            do {
                // dic转data
                let jsonData = try JSONSerialization.data(withJSONObject: dicBill, options: JSONSerialization.WritingOptions.prettyPrinted)
                // data转string
                let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8)
                // 非空判断
                if let json = jsonString, json.isEmpty == false {
                    billInfoJson = json
                }
            } catch {
                print("dic转string失败")
            }
        }
        
        // error
        guard let listShop = model.orderSupplyCartVOs, listShop.count > 0 else {
            // 业务参数
            param["appUuid"] = appUuid
            param["version"] = version
            param["addressId"] = addressId
            param["billType"] = billType
            param["billInfoJson"] = billInfoJson
            //分享bd 的佣金Id
            if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
                param["cpsbd"] = cpsbd
            }
            // 最终入参
            jsonParams["ycToken"] = yctoken
            jsonParams["jsonParams"] = param
            return jsonParams
        }
        
        // 5.订单信息列表...<三级>
        var orderList: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
        // 遍历商家订单model
        for order: COSupplyOrderModel in listShop {
            // 初始化map字典
            var dic: Dictionary<String, Any> = Dictionary<String, Any>()
            
            // 1.供应商ID
            var supplyId = 0
            if let sid = order.supplyId {
                supplyId = sid
            }
            
            // 2.订单运费
            var orderFreight: String = "0"
            if let value = order.supplyFreight, value.doubleValue > 0 {
                orderFreight = String(format: "%.2f", value.doubleValue)
            }
            
            // 3.支付类型 [1-在线支付(默认) 3-线下支付]
            var payType = 1
            if let type: COPayType = dicPayType[supplyId] {
                // 有保存的支付方式
                switch type {
                case .online:
                    // 在线支付
                    payType = 1
                case .offline:
                    // 线下转账
                    payType = 3
                }
            }
            else {
                // 无保存的支付方式...<error>
            }
            
            // 4.商品金额
            var orderTotal: String = "0.0"
            if let value = order.totalAmount, value.doubleValue > 0 {
                orderTotal = String(format: "%.2f", value.doubleValue)
            }
            
            // 5.实付金额...<一起购没活动,价格相同>
            var finalPay: String = "0.0"
            if let value = order.totalAmount, value.doubleValue > 0 {
                finalPay = String(format: "%.2f", value.doubleValue)
            }
            
            // 6.留言
            var leaveMsg: String = ""
            if let content = dicMessage[supplyId], content.isEmpty == false {
                leaveMsg = content
            }
            
            //7 用户输入的购物金分摊金额
            var orderShopRechargeMoney = "0"
            if let value = order.useGwjBalance, value.doubleValue > 0 {
                orderShopRechargeMoney = String(format: "%.2f", value.doubleValue)
            }
            
            var customerRequestOrderType = ""
            // 8. 跟随企业首营资质
            if let shopModel = self.getSameSupplyFollowQualityInfo("\(order.supplyId ?? 0)"){
                if shopModel.enterpriseTypeSelState == true{
                    customerRequestOrderType = "a"
                }
            }
            
            dic["supplyId"] = supplyId // 供应商ID
            dic["orderFreight"] = orderFreight // 订单运费
            dic["payType"] = payType // 支付类型 [1-在线支付(默认) 3-线下支付]
            dic["orderTotal"] = orderTotal // 商品金额
            dic["finalPay"] = finalPay // 实付金额
            dic["leaveMsg"] = leaveMsg // 留言
            dic["shopRechargeMoney"] = orderShopRechargeMoney //用户输入的购物金每个店铺平摊金额
            dic["customerRequestOrderType"] = customerRequestOrderType // 企业首营资质
            // 9.商品相关信息数组
            var productDtoList: [Any] = [Any]()
            // 10 跟随商品首营资料
            var shopProductDetails: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
            // 遍历所有商品model
            if let shopModel = self.getSameSupplyFollowQualityInfo("\(order.supplyId ?? 0)"){
                // 遍历所有商品model
                if let products = shopModel.products, products.count > 0 {
                    var productDic: Dictionary<String, Any> = Dictionary<String, Any>()
                    for item: COProductModel in products {
                        // 初始化map字典
                        var dicProduct: Dictionary<String, Any> = Dictionary<String, Any>()
                        
                        // 1.套餐(促销)id
                        var promotionId = ""
                        if let value = item.promotionId {
                            promotionId = "\(value)"
                        }
                        
                        // 2.购物车id
                        var shoppingCartId = ""
                        if let value = item.shoppingCartId {
                            shoppingCartId = "\(value)"
                            productDic["shopCartId"] = value
                        }
                        
                        // 3.公司编码
                        var productCodeCompany = ""
                        if let value = item.productCodeCompany, value.isEmpty == false {
                            productCodeCompany = value
                        }
                        
                        // 4.商品数量
                        var productCount = 0
                        if let value = item.productCount, value > 0 {
                            productCount = value
                        }
                        
                        // 5.商品价格
                        var productPrice = "0.0"
                        if let value = item.productPrice, value.doubleValue > 0 {
                            productPrice = String(format: "%.2f", value.doubleValue)
                        }
                        
                        // 6.商品名称
                        var productName = ""
                        if let value = item.productName {
                            productName = "\(value)"
                        }
                        
                        // 7.
                        var supplierId = 0
                        if let value = item.supplierId, value >= 0 {
                            supplierId = value
                        }
                        
                        // 8.
                        var fictitiousId = 0
                        if let value = item.supplyId, value >= 0 {
                            fictitiousId = value
                        }
                        
                        dicProduct["promotionId"] = promotionId // 套餐(促销)id
                        dicProduct["shoppingCartId"] = shoppingCartId // 购物车id
                        dicProduct["productCodeCompany"] = productCodeCompany // 公司编码
                        dicProduct["productCount"] = productCount // 商品数量
                        dicProduct["productPrice"] = productPrice // 商品价格
                        dicProduct["productName"] = productName // 商品名称
                        dicProduct["supplierId"] = supplierId // PMS供应商Id
                        dicProduct["fictitiousId"] = fictitiousId // 供应商id（包含虚拟ID）
                        
                        // 加入数组
                        productDtoList.append(dicProduct)
                        //customerRequestProductType 1选择批件 2选择全套
                        if item.customerRequestProductType == 1 {
                            productDic["customerRequestProductType"] = "a"
                            shopProductDetails.append(productDic)
                        }else if item.customerRequestProductType == 2{
                            productDic["customerRequestProductType"] = "b"
                            shopProductDetails.append(productDic)
                        }
                    } // for
                }
            }
            else {
                if let products = order.products, products.count > 0 {
                    for item: COProductModel in products {
                        // 初始化map字典
                        var dicProduct: Dictionary<String, Any> = Dictionary<String, Any>()
                        
                        // 1.套餐(促销)id
                        var promotionId = ""
                        if let value = item.promotionId {
                            promotionId = "\(value)"
                        }
                        
                        // 2.购物车id
                        var shoppingCartId = ""
                        if let value = item.shoppingCartId {
                            shoppingCartId = "\(value)"
                        }
                        
                        // 3.公司编码
                        var productCodeCompany = ""
                        if let value = item.productCodeCompany, value.isEmpty == false {
                            productCodeCompany = value
                        }
                        
                        // 4.商品数量
                        var productCount = 0
                        if let value = item.productCount, value > 0 {
                            productCount = value
                        }
                        
                        // 5.商品价格
                        var productPrice = "0.0"
                        if let value = item.productPrice, value.doubleValue > 0 {
                            productPrice = String(format: "%.2f", value.doubleValue)
                        }
                        
                        // 6.商品名称
                        var productName = ""
                        if let value = item.productName {
                            productName = "\(value)"
                        }
                        
                        // 7.
                        var supplierId = 0
                        if let value = item.supplierId, value >= 0 {
                            supplierId = value
                        }
                        
                        // 8.
                        var fictitiousId = 0
                        if let value = item.supplyId, value >= 0 {
                            fictitiousId = value
                        }
                        
                        dicProduct["promotionId"] = promotionId // 套餐(促销)id
                        dicProduct["shoppingCartId"] = shoppingCartId // 购物车id
                        dicProduct["productCodeCompany"] = productCodeCompany // 公司编码
                        dicProduct["productCount"] = productCount // 商品数量
                        dicProduct["productPrice"] = productPrice // 商品价格
                        dicProduct["productName"] = productName // 商品名称
                        dicProduct["supplierId"] = supplierId // PMS供应商Id
                        dicProduct["fictitiousId"] = fictitiousId // 供应商id（包含虚拟ID）
                        
                        // 加入数组
                        productDtoList.append(dicProduct)
                    } // for
                }
                
            }
            dic["productDtoList"] = productDtoList
            dic["shopProductDetails"] = shopProductDetails
            // 加入数组
            orderList.append(dic)
        } // for
        //销售单随货  销售合同随货显示与否，0：不显示，1：显示
        if  model.showSalesContract == 1{
            if self.salesContractFlowGoods != 2{
                // 未初始化  销售合同随货与否，0：不随货，1：随货
                param["isPrintContract"] = self.salesContractFlowGoods
            }
        }
        //分享bd 的佣金ID
        if let cpsbd = FKYLoginAPI.shareInstance()?.bdShardId, cpsbd.isEmpty == false {
            param["cpsbd"] = cpsbd
        }
        // 业务参数
        param["appUuid"] = appUuid
        param["version"] = version
        param["addressId"] = addressId
        param["billType"] = billType
        param["billInfoJson"] = billInfoJson
        param["orderList"] = orderList
        // 最终入参
        jsonParams["ycToken"] = yctoken
        jsonParams["jsonParams"] = param
        return jsonParams
    }
}


// MARK: - Request
extension CheckOrderViewModel {
    // 检查订单接口请求...<包括普通订单、一起购订单>
    func requestForCheckOrder(_ refreshFlag: Bool, block: @escaping (Bool, String?, CORefreshFailType?)->()) {
        // 保存
        refreshFlagCO = refreshFlag
        // 传参
        let param: [String: Any]? = getCheckOrderData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForCheckOrder(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                var actionType: CORefreshFailType? = nil // 默认刷新失败时不做任何操作
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                    // 接口返回不同的错误码，需进行不同的处理
                    if let rtncode = e.userInfo[HJErrorCodeKey] as? NSString, rtncode.length > 0 {
                        // 购物车数据变化，需返回重新结算~!@
                        if rtncode.isEqual(to: CORefreshFailType.shouldBackToCart.rawValue) {
                            actionType = .shouldBackToCart
                        }
                        else if rtncode.isEqual(to: CORefreshFailType.couponCodeError.rawValue) {
                            actionType = .couponCodeError
                        }
                    }
                }
                // 失败回调
                block(false, msg, actionType)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                // 检查订单初始化/刷新成功
                let orderMainModel = data.mapToObject(FKYCheckOrderMainModel.self)
                if let code = orderMainModel.code, code == 0 {
                    //请求正常
                    // 保存整个model
                    strongSelf.modelCO = orderMainModel.orderModel
                    
                    //封装数据源
                    strongSelf.configContainersSource()
                    
                    // 保存发票model
                    strongSelf.saveOrderInvoiceData()
                    // 保存商家支付方式
                    strongSelf.saveShopOrderPayType()
                    // 保存各商家已使用的返利金抵扣金额
                    strongSelf.saveRebateInputContent()
                    //保存使用的购物金
                    strongSelf.saveShopBuyMoneyInputContent()
                    // 保存各商品优惠券code
                    strongSelf.saveAllProductCouponContent()
                    // 保存平台优惠券码
                    strongSelf.savePlatformProductCouponContent()
                    // 保存各优惠码code
                    strongSelf.saveAllCouponCodeContent()
                    // 保存各商家是否使用平台优惠券状态
                    //strongSelf.saveAllUsePlatformCouponStatus()
                    // 保存用户手动勾选优惠券状态
                    strongSelf.saveAllProductCouponSelectStatus()
                    // 保存用户手动勾选优惠码状态
                    strongSelf.saveAllCouponCodeSelectStatus()
                }else {
                    if let code = orderMainModel.code, code == 3, let errorCode = orderMainModel.errorCode, errorCode == "002090000100" {
                        //异常了，遍历原有的商品信息打标刷新
                        if let msg = orderMainModel.msg, msg.isEmpty == false {
                            FKYAppDelegate!.showToast(msg)
                        }
                        strongSelf.markCouponProducts(orderMainModel.attachment)
                    }else {
                        // 失败回调
                        block(false, "请求失败", nil)
                        return
                    }
                }
                // 成功回调
                block(true, "", nil)
                return
            }
            // 检查订单初始化/刷新失败
            block(false, "", nil)
        })
    }
    // MARK:自营首营资质-根据ID获取对应的首营资料选择情况
    func getSameSupplyFollowQualityInfo(_ suppluId:String) -> COSupplyOrderModel?{
        if let checkOrderModel = self.followQualityCOModel,let orderSupplyCartVOs = checkOrderModel.orderSupplyCartVOs,orderSupplyCartVOs.isEmpty == false{
            for supplyModel in orderSupplyCartVOs{
                if ("\(supplyModel.supplyId ?? 0)" == suppluId){
                    return supplyModel
                }
            }
        }
        return nil
    }
    // MARK:提交订单...<普通订单>
    func requestForSubmitOrder(_ block: @escaping (Bool, String?, Bool?)->()) {
        // 先置空
        modelSO = nil
        // 传参
        let param: [String: Any]? = getSubmitOrderData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForSubmitOrder(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 提交失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                var flag: Bool?
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                    // 接口返回不同的错误码，需进行不同的处理
                    if let rtncode = e.userInfo[HJErrorCodeKey] as? NSString, rtncode.length > 0 {
                        if rtncode == "001" {
                            // 001-失败返回购物车
                            flag = true
                        }
                        else if rtncode == "002" {
                            // 002--失败不返回购物车...<默认>
                        }
                    }
                }
                // 失败回调
                block(false, msg, flag)
                return
            }
            // 请求成功
            if let obj = model as? COSubmitOrderModel {
                //清空bd分享佣金ID
                FKYLoginAPI.shareInstance()?.bdShardId = nil
                // 保存整个model
                strongSelf.modelSO = obj
                // 提交成功
                block(true, nil, nil)
                return
            }
            // 提交失败
            block(false, nil, nil)
        })
    }
    
    // MARK:提交订单...<一起购订单>
    func requestForSubmitGroupBuyOrder(_ block: @escaping (Bool, String?, Bool?)->()) {
        // 先置空
        modelSO = nil
        // 传参
        let param: [String: Any]? = getSubmitGroupBuyOrderData()
        // 请求
        FKYRequestService.sharedInstance()?.requestForSubmitGroupBuyOrder(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            // 提交失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                var flag: Bool? = nil
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                    // 接口返回不同的错误码，需进行不同的处理
                    if let rtncode = e.userInfo[HJErrorCodeKey] as? NSString, rtncode.length > 0 {
                        if rtncode == "001" {
                            // 001-失败返回购物车
                            flag = true
                        }
                        else if rtncode == "002" {
                            // 002--失败不返回购物车...<默认>
                        }
                    }
                }
                // 失败回调
                block(false, msg, flag)
                return
            }
            // 请求成功
            if let obj = model as? COSubmitOrderModel {
                //清空bd分享佣金ID
                FKYLoginAPI.shareInstance()?.bdShardId = nil
                // 保存整个model
                strongSelf.modelSO = obj
                // 提交成功
                block(true, nil, nil)
                return
            }
            // 提交失败
            block(false, nil, nil)
        })
    }
    
    // (提交订单前)判断资质
    func requestForCheckEnterpriseQualification(_ block: @escaping (Bool, String?, Bool)->()) {
        // 传参
        var yctoken = ""
        if let token: String = UserDefaults.standard.value(forKey: "user_token") as? String, token.isEmpty == false {
            yctoken = token
        }
        let param: [String: Any]? = ["ycToken": yctoken]
        // 请求
        FKYRequestService.sharedInstance()?.requestForCheckEnterpriseQualification(withParam: param, completionBlock: { (success, error, response, model) in
            // 请求失败
            guard success else {
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    // token过期
                    if e.code == 2 {
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                // 失败回调
                block(false, msg, false)
                return
            }
            // 请求成功
            if let data = response as? NSDictionary {
                // 保存生成的各商家订单id
                let flag: NSNumber? = data["flag"] as? NSNumber
                if let status = flag, status.boolValue == true {
                    // 审核通过
                    block(true, nil, true)
                    return
                }
            }
            // 非审核通过状态
            block(false, nil, true)
        })
    }
}


/***************************************************************************/
// MARK: - 各类型数据处理

// MARK: - PayType<(一级)支付方式>
extension CheckOrderViewModel {
    // 检查订单接口请求成功后，需保存(填充)支付方式dic
    // 说明：以用户手动选中的支付方式为准。若某商家(维度)中，用户选择的支付方式为空，则用接口返回的支付方式填充；若商家已有保存的支付方式，则不考虑接口返回的支付方式。
    fileprivate func saveShopOrderPayType() {
        guard let model = modelCO, let listShop = model.orderSupplyCartVOs, listShop.count > 0 else {
            return
        }
        
        // 保存本地
        for item in listShop {
            if let shopId = item.supplyId {
                if dicPayType[shopId] != nil {
                    // 有保存的支付方式
                    if dicPayType[shopId] == .online {
                        item.payType = 1
                    }else if dicPayType[shopId] == .offline {
                        item.payType = 3
                    }
                }
                else {
                    // 无保存的支付方式
                    if let type = item.payType, type != 0 {
                        if type == 1 {
                            // 线上
                            dicPayType[shopId] = .online
                        }
                        else if type == 3 {
                            // 线下
                            dicPayType[shopId] = .offline
                        }
                    }
                }
            }
        } // for
    }
    
    // 获取当前商家model保存的支付方式
    func getPayTypeForShop(_ shop: COSupplyOrderModel) -> Int {
        guard let shopId = shop.supplyId else {
            return 0
        }
        
        if let type: COPayType = dicPayType[shopId] {
            // 有保存的支付方式
            switch type {
            case .online:
                // 在线支付
                return 1
            case .offline:
                // 线下转账
                return 3
            }
        }
        else {
            // 无保存的支付方式
            return 0
        }
    }
    
    // 获取第一个商家的支付方式...<当检查订单界面只有唯一的商家时，订单不需要拆单，直接进行支付>
    func getPayTypeForFirstShop() -> Int {
        guard let model = modelCO, let listShop = model.orderSupplyCartVOs, listShop.count > 0 else {
            return 0
        }
        return getPayTypeForShop(listShop.first!)
    }
    
    // 更新所有商家的支付方式
    func updatePayTypeForAllShopOrder(_ selectedShop: COSupplyOrderModel, _ selectedPayType: Int) {
        guard let model = modelCO, let listShop = model.orderSupplyCartVOs, listShop.count > 0 else {
            return
        }
        
        // 更新
        for itemShop in listShop {
            if let idShop = itemShop.supplyId, let idSelected = selectedShop.supplyId, idSelected == idShop {
                itemShop.payType = selectedPayType
                break
            }
        }
        
        // 保存本地
        if let shopId = selectedShop.supplyId {
            if selectedPayType == 1 {
                // 线上
                dicPayType[shopId] = .online
            }
            else if selectedPayType == 3 {
                // 线下
                dicPayType[shopId] = .offline
            }
        }
    }
    
    // 判断所有商家的支付方式是否已选择
    func checkAllPayTypeSelectedStatus() -> Bool {
        guard let model = modelCO, let listShop = model.orderSupplyCartVOs, listShop.count > 0 else {
            return false
        }
        
        // 所有商家的支付方式是否均已选择...<默认均已选择>
        var hasAllType = true
        
        // 遍历所有商家model
        for item in listShop {
            if let shopId = item.supplyId {
                if let type: COPayType = dicPayType[shopId] {
                    // 有保存的支付方式
                    switch type {
                    case .online:
                        // 在线支付
                        print("在线支付")
                    case .offline:
                        // 线下转账
                        print("线下转账")
                    }
                }
                else {
                    // 无保存的支付方式
                    hasAllType = false
                    break
                }
            }
        } // for
        
        return hasAllType
    }
}

// MARK: - Invoice<发票>
extension CheckOrderViewModel {
    // 保存(上次)发票信息
    fileprivate func saveOrderInvoiceData() {
        // 未下过单
        guard let model = modelCO, let type = model.billType, let value = Int(type), value > 0 else {
            // 不初始化发票model
            return
        }
        
        // 为空...<仅有发票类型>...<mp商家只需要发票类型>
        guard let invoice = model.orderBillInfoVO else {
            invoiceModel = InvoiceModel.init(billType: type)
            return
        }
        
        // 不为空
        invoiceModel = invoice
    }
    
    // 判断当前订单是否可编辑发票...<是否包含1号药业>
    func getInvoiceEditStatus() -> Bool {
        guard let model = modelCO else {
            return false
        }
        
        // 默认
        var canEdit = false
        if let edit = model.invoiceCanEdit, edit.isEmpty == false {
            // 有值
            if edit == "1" {
                canEdit = true
            }
        }
        else {
            // 无值
            if let list = model.orderSupplyCartVOs, list.count > 0 {
                for order in list {
                    if let type = order.supplyType, type == 0 {
                        // 自营
                        canEdit = true
                        break
                    }
                } // for
            }
        }
        return canEdit
    }
    
    // 判断是否支持电子发票
    func getSupportEinvoiceStatu() -> Bool {
        // 默认不支持电子发票
        guard let model = modelCO, let support = model.isSupportEinvoice, support == "1" else {
            return false
        }
        // 支持
        return true
    }
    
    // 获取发票类型
    func getInvoiceContent() -> String? {
        guard let model = invoiceModel, let type = model.billType, type.isEmpty == false else {
            return nil
        }
        var invoice: String? = nil
        if type == "1" {
            invoice = "专用发票"
        }
        else if type == "2" {
            invoice = "纸质普通发票"
        }
        else if type == "3" {
            invoice = "电子普通发票"
        }
        return invoice
    }
    
    // 校验发票是否为空...<若只有MP订单，则只需要确定发票类型；若包含自营订单，则需要校验发票内容>
    func checkInvoiceStatus() -> (Bool, String?) {
        guard let invoice = invoiceModel, let type = invoice.billType, type.isEmpty == false else {
            return (false, "请选择发票信息")
        }
        
        // 若有自营店铺，则需要对纳税人识别号进行校验
        if checkHasSelfShop() {
            guard let number = invoice.taxpayerIdentificationNumber, number.isEmpty == false else {
                return (false, "请完善发票信息")
            }
        }
        
        return (true, nil)
    }
    
    // 判断当前检查订单界面是否有自营店铺
    func checkHasSelfShop() -> Bool {
        guard let model = modelCO, let listOrder = model.orderSupplyCartVOs, listOrder.count > 0 else {
            return false
        }
        
        // 是否有自营...<默认无>
        var hasSelf = false
        for order in listOrder {
            if let type = order.supplyType, type == 0 {
                // 自营
                hasSelf = true
                break
            }
        } // for
        return hasSelf
    }
}

// MARK: - ProductCoupon<商品优惠券>
extension CheckOrderViewModel {
    // 接口请求成功后对优惠券码dic进行code赋值
    fileprivate func saveAllProductCouponContent() {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
            return
        }
        
        dicProductCoupon.removeAll()
        for shop: COSupplyOrderModel in list {
            if let sid = shop.supplyId, let code = shop.checkCouponCodeStr, code.isEmpty == false {
                // 保存
                dicProductCoupon[sid] = code
            }
        } // for
    }
    //接口请求成功后，获取用户选择的平台券码
    fileprivate func savePlatformProductCouponContent() {
        guard let model = modelCO, let platformModel = model.platformCouponInfo,let list = platformModel.couponInfoVOList, list.count > 0 else {
            return
        }
        
        self.platformCouponCode = ""
        var platformArr = [String]()
        for couponModel: COCouponModel in list {
            if couponModel.isUseCoupon == 1 && couponModel.isCheckCoupon == 1 {
                if let couponStr = couponModel.couponCode {
                    platformArr.append(couponStr)
                }
            }
        }
        if platformArr.count > 0 {
            let muArr = NSMutableArray(array: platformArr)
            self.platformCouponCode = muArr.componentsJoined(by: ",")
        }
    }
    
    // 保存当前商家id对应商家的商品优惠券code
    func saveProductCouponContent(_ content: String, _ shopId: Int) {
        // 保存
        dicProductCoupon[shopId] = content
    }
    
    // 删除当前商家id对应商家的商品优惠券code
    func removeProductCouponContent(_ shopId: Int) {
        // 删除
        dicProductCoupon.removeValue(forKey: shopId)
    }
    
    // 获取保存的当前商家id对应商家的商品优惠券code
    func getProductCouponContent(_ shopId: Int) -> String? {
        return dicProductCoupon[shopId]
    }
    
    /***************************************************/
    
    // 请求到检查订单数据后保存用户手动勾选状态
    fileprivate func saveAllProductCouponSelectStatus() {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
            return
        }
        
        for shop: COSupplyOrderModel in list {
            if let sid = shop.supplyId {
                if dicProductCouponSelected[sid] != nil {
                    // 有保存的状态...<不做操作>
                }
                else {
                    // 无保存的状态
                    if let code = shop.checkCouponCodeStr, code.isEmpty == false {
                        // 有使用优惠券...<需展开>
                        dicProductCouponSelected[sid] = true
                    }
                }
            }
        } // for
    }
    
    // 选中or取消选中的状态保存/更新
    func updateProductCouponSelectStatus(_ selected: Bool, _ shopId: Int) {
        // 保存
        dicProductCouponSelected[shopId] = selected
    }
    
    // 获取当前商家id对应商家的(本地保存)优惠券勾选状态
    func getProductCouponSelectStatus(_ shopId: Int) -> Bool {
        if let status = dicProductCouponSelected[shopId] {
            // 勾选状态
            return status
        }
        else {
            // 默认未勾选
            return false
        }
    }
    
    /***************************************************/
    
    // 接口请求成功后保存当前各商家是否使用平台券状态数据
    //    fileprivate func saveAllUsePlatformCouponStatus() {
    //        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
    //            return
    //        }
    //
    //        dicUsePlatformCoupon.removeAll()
    //        for shop: COSupplyOrderModel in list {
    //            // checkPlatformCoupon是否使用平台优惠券，[1是，0不是]
    //            if let sid = shop.supplyId, let useFlag = shop.checkPlatformCoupon, useFlag.isEmpty == false {
    //                let flag = (useFlag == "1" ? true : false)
    //                dicUsePlatformCoupon[sid] = flag
    //            }
    //        } // for
    //    }
    
    // 更新当前商家是否使用平台优惠券的状态数据
    //    func updateUsePlatformCouponStatus(_ content: String, _ shopIndex: Int) {
    //        // 不为空
    //        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
    //            return
    //        }
    //
    //        // 商家订单model
    //        let shop: COSupplyOrderModel = list[shopIndex]
    //        // key
    //        var shopKey = shopIndex
    //        if let shopId = shop.supplyId, shopId > 0 {
    //            shopKey = shopId
    //        }
    //
    //        // 无券数组则一定未使用平台券
    //        guard let listCoupon = shop.couponInfoVOList, listCoupon.count > 0 else {
    //            // 当前商家无优惠券...<即，不可能使用平台优惠券>
    //            dicUsePlatformCoupon[shopKey] = false
    //            return
    //        }
    //
    //        // 内容为空表示用户不使用券
    //        guard content.isEmpty == false else {
    //            // 不使用任何优惠券...<即，不可能使用平台优惠券>
    //            dicUsePlatformCoupon[shopKey] = false
    //            return
    //        }
    //
    //        // 判断当前商家是否使用平台优惠券...<默认未使用>
    //        var usePlatform = false
    //        // 当前用户已(选择)使用券code数组
    //        let listCode: [String] = content.components(separatedBy: ",")
    //        // 遍历已使用的券code
    //        for code: String in listCode {
    //            if code.isEmpty {
    //                // 为空
    //                continue
    //            }
    //            if usePlatform {
    //                break
    //            }
    //            // 遍历当前商家所有可用的券model数组
    //            for coupon: COCouponModel in listCoupon {
    //                if let cid = coupon.couponCode, cid.isEmpty == false, let type = coupon.tempType, type == 1, cid == code {
    //                    // 两个优惠券code相同，且券类型为平台券
    //                    usePlatform = true
    //                    break
    //                }
    //            } // for
    //        } // for
    //        // 保存
    //        dicUsePlatformCoupon[shopKey] = usePlatform
    //    }
    
    // 删除当前商家使用平台券状态...<即不使用平台券>
    //    func removeUsePlatformCouponStatus(_ shopId: Int) {
    //        // 删除
    //        dicUsePlatformCoupon.removeValue(forKey: shopId)
    //    }
}

// MARK: - CouponCode<优惠券码>
extension CheckOrderViewModel {
    // 接口请求成功后对优惠券码dic进行code赋值
    fileprivate func saveAllCouponCodeContent() {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
            return
        }
        
        dicCouponCode.removeAll()
        for shop: COSupplyOrderModel in list {
            if let sid = shop.supplyId, let code = shop.showCouponCode, code.isEmpty == false {
                // 保存
                dicCouponCode[sid] = code
            }
        } // for
    }
    
    // 保存当前商家id对应商家的优惠券码code
    func saveCouponCodeContent(_ content: String, _ shopId: Int) {
        // 保存
        dicCouponCode[shopId] = content
    }
    
    // 删除当前商家id对应商家的优惠券码code
    func removeCouponCodeContent(_ shopId: Int) {
        // 删除
        dicCouponCode.removeValue(forKey: shopId)
    }
    
    // 获取当前商家id对应商家的优惠券码code
    func getCouponCodeContent(_ shopId: Int) -> String? {
        // 查询
        return dicCouponCode[shopId]
    }
    
    /***************************************************/
    
    // 请求到检查订单数据后更新用户手动勾选状态
    fileprivate func saveAllCouponCodeSelectStatus() {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
            return
        }
        
        for shop: COSupplyOrderModel in list {
            if let sid = shop.supplyId {
                if dicCouponCodeSelected[sid] != nil {
                    // 有保存的状态...<不做操作>
                }
                else {
                    // 无保存的状态
                    if let code = shop.showCouponCode, code.isEmpty == false {
                        // 有使用优惠码，需展开
                        dicCouponCodeSelected[sid] = true
                    }
                }
            }
        } // for
    }
    
    // 选中or取消选中的状态保存/更新
    func updateCouponCodeSelectStatus(_ selected: Bool, _ shopId: Int) {
        // 保存
        dicCouponCodeSelected[shopId] = selected
    }
    
    // 获取当前商家id对应商家的(本地保存)优惠码勾选状态
    func getCouponCodeSelectStatus(_ shopId: Int) -> Bool {
        if let status = dicCouponCodeSelected[shopId] {
            // 勾选状态
            return status
        }
        else {
            // 默认未勾选
            return false
        }
    }
    
    /***************************************************/
    
    // 保存用户最后输入的优惠码code
    func saveLastInputCouponCodeContent(_ code: String) {
        listForAllCouponCodeInput.append(code)
    }
    
    // 删除用户最后输入的优惠码code
    // 场景: 用户每次只能输一个优惠码，并立即进行刷新操作。当优惠码输入有误时，需要清除最后输入的优惠码，其它之前输入的不清除
    func deleteLastInputCouponCodeContent() {
        guard listForAllCouponCodeInput.count > 0 else {
            return
        }
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
            return
        }
        
        let code = listForAllCouponCodeInput.last
        // 遍历以删除当前用户本地保存的错误优惠码code
        for shop: COSupplyOrderModel in list {
            if let sid = shop.supplyId {
                if let codeSaved = dicCouponCode[sid], codeSaved.isEmpty == false, codeSaved == code {
                    // 删除
                    dicCouponCode.removeValue(forKey: sid)
                    // 重置
                    if let content = shop.showCouponCode, content.isEmpty == false {
                        dicCouponCode[sid] = content
                    }
                    break
                }
            } // shopid
        } // for
        // 删除数组中的错误优惠码code
        listForAllCouponCodeInput.removeLast()
    }
}

// MARK: - Rebate<使用返利金>
extension CheckOrderViewModel {
    // 接口请求成功后保存当前各商家已使用的返利金数据
    fileprivate func saveRebateInputContent() {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
            return
        }
        dicRebate.removeAll()
        self.allUseRebateStr = 0
        if model.shareRebate == "1" {
            //使用共享返利金
            if let allRebate = model.allOrdersUseRebateMoney ,allRebate.doubleValue > 0 {
                self.allUseRebateStr = allRebate.doubleValue
            }
        }else {
            //各个店铺使用返利金
            for shop: COSupplyOrderModel in list {
                if let sid = shop.supplyId, let rebate = shop.useRebateMoney, rebate.doubleValue > 0 {
                    // 保存
                    dicRebate[sid] = rebate.doubleValue
                }
            } // for
        }
    }
    
    // 更新/保存用户输入的返利金抵扣
    func updateRebateInputContent(_ shopIndex: Int, _ content: String?) {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return
        }
        if model.shareRebate == "1" {
            if let rebate = content, rebate.isEmpty == false, let value = Double(rebate), value > 0{
                self.allUseRebateStr = value
            }else {
                self.allUseRebateStr = 0
            }
        }else {
            // key
            let shop: COSupplyOrderModel = list[shopIndex]
            var shopKey = shopIndex // key
            if let shopId = shop.supplyId, shopId > 0 {
                shopKey = shopId
            }
            if let rebate = content, rebate.isEmpty == false, let value = Double(rebate), value > 0 {
                dicRebate[shopKey] = value
            }
            else {
                dicRebate.removeValue(forKey: shopKey)
            }
        }
    }
    
    // 获取本地保存的(用户输入)返利金抵扣
    func getRebateInputContent(_ shopIndex: Int) -> Double {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return 0
        }
        if model.shareRebate == "1" {
            //共享返利金
            return self.allUseRebateStr
        }else {
            //各个店铺使用返利金
            // key
            let shop: COSupplyOrderModel = list[shopIndex]
            var shopKey = shopIndex // key
            if let shopId = shop.supplyId, shopId > 0 {
                shopKey = shopId
            }
            guard let value = dicRebate[shopKey], value > 0 else {
                // 无返利金抵扣
                return 0
            }
            // 有返利金抵扣
            return value
        }
        
    }
    
    // 获取当前商家最大可用返利金抵扣数值
    func getMaxRebateUseValue(_ shopIndex: Int) -> Double {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return 0
        }
        if model.shareRebate == "1" {
            //共享返利金
            if let rebate = model.allOrderCanUseRebateMoney ,rebate.doubleValue > 0 {
                return rebate.doubleValue
            }else {
                return 0
            }
        }else {
            //各个店铺使用返利金
            let shop: COSupplyOrderModel = list[shopIndex]
            if let rebate = shop.rebateMoney, rebate.doubleValue > 0 {
                return rebate.doubleValue
            }
            else {
                return 0
            }
        }
    }
}
// MARK: - 购物金
extension CheckOrderViewModel {
    // 接口请求成功后保存购物金数据
    fileprivate func saveShopBuyMoneyInputContent() {
        guard let model = modelCO else {
            return
        }
        self.allShopBuyMoneyStr = 0
        if let buyMoney = model.allUseGwjBalance ,buyMoney.doubleValue > 0 {
            self.allShopBuyMoneyStr = buyMoney.doubleValue
        }
    }
    
    // 更新/保存用户输入的购物金
    func updateShopBuyMoneyInputContent( _ content: String?) {
        if let rebate = content, rebate.isEmpty == false, let value = Double(rebate), value > 0{
            self.allShopBuyMoneyStr = value
        }else {
            self.allShopBuyMoneyStr = 0
        }
    }
    
    // 获取本地保存的(用户输入)购物金
    func getShopBuyMoneyInputContent() -> Double {
        return self.allShopBuyMoneyStr
    }
    //获取最大的可用购物金额
    func getMaxShopBuyMoneyUseValue() -> Double {
        guard let model = modelCO else{
            return 0
        }
        if let rebate = model.allCanUseGwjBalance ,rebate.doubleValue > 0 {
            return rebate.doubleValue
        }else {
            return 0
        }
    }
}
// MARK: - Message<留言>
extension CheckOrderViewModel {
    // 获取本地保存的留言
    func getLeaveMessageContent(_ shopIndex: Int) -> String? {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return nil
        }
        // key
        let shop: COSupplyOrderModel = list[shopIndex]
        var shopKey = shopIndex // key
        if let shopId = shop.supplyId, shopId > 0 {
            shopKey = shopId
        }
        guard let msg = dicMessage[shopKey], msg.isEmpty == false else {
            // 无留言
            return nil
        }
        // 有留言
        return msg
    }
    
    // 保存用户输入的留言
    func saveLeaveMessageContent(_ shopIndex: Int, _ content: String?) {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return
        }
        // key
        let shop: COSupplyOrderModel = list[shopIndex]
        var shopKey = shopIndex // key
        if let shopId = shop.supplyId, shopId > 0 {
            shopKey = shopId
        }
        // save
        dicMessage[shopKey] = content
    }
}

// MARK: - Fright<运费>
extension CheckOrderViewModel {
    // 获取各商家维度的运费规则
    func getRuleList(_ sectionType: FKYCOSectionType, _ section: Int) -> [COFrightRuleData]? {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
            return nil
        }
        
        if sectionType == .sectionShop {
            if list.count > section {
                let supplyShop = list[section]
                let rule = COFrightRuleData()
                rule.shopId = supplyShop.supplyId
                rule.shopName = supplyShop.supplyName
                rule.freightRuleList = supplyShop.freightRuleList
                return [rule]
            }
            return nil
        }
        
        var ruleList = [COFrightRuleData]()
        for item: COSupplyOrderModel in list {
            let rule = COFrightRuleData()
            rule.shopId = item.supplyId
            rule.shopName = item.supplyName
            rule.freightRuleList = item.freightRuleList
            ruleList.append(rule)
        }
        return ruleList
    }
}
// MARK: -  salesContractFlowGoods 销售单随货方式
extension CheckOrderViewModel{
    // 更新销售单随货方式
    func updateSaleContactType(_ selectedFollowType: Int) {
        self.salesContractFlowGoods = selectedFollowType
    }
    // 保存销售单随货方式
    fileprivate func saveSaleContactType() {
        // 未下过单
        guard let model = modelCO, let type = model.salesContractFlowGoods  else {
            // 不初始化售单随货方式
            return
        }
        if self.salesContractFlowGoods == 2{
            self.salesContractFlowGoods = type
        }
    }
    // 获取售单随货方式
    func getRebateInputContent() -> Int {
        return self.salesContractFlowGoods == 2 ? 0:self.salesContractFlowGoods
    }
}
/***************************************************************************/
// MARK: - Tableview数据展示逻辑0
// MARK: - TableView Data
extension CheckOrderViewModel {
    
    // 获取指定索引处的商家订单model
    func getShopOrder(_ shopIndex: Int) -> COSupplyOrderModel? {
        // error
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return nil
        }
        return list[shopIndex]
    }
    
    // 获取指定索引处的商品model
    func getProductObj(_ productIndex: Int, _ shopOrder: COSupplyOrderModel) -> COProductModel? {
        guard let list = shopOrder.products, list.count > 0, list.count > productIndex else {
            return nil
        }
        return list[productIndex]
    }
    
    // 获取table中的section数量...<前：支付方式>...<中：商品相关>...<后：发票、金额相关>
    func getSections() -> Int {
        return coSections.count
    }
    
    // 获取当前section下的row数量
    func getRowsInSection(_ section: Int) -> Int {
        guard coSections.count > section else {
            return 0
        }
        
        let container = coSections[section]
        if let items = container.items {
            return items.count
        }
        return 0
    }
    
    // 获取各row高度
    func getHeight(_ indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        guard coSections.count > section else {
            return 0
        }
        let container = coSections[section]
        
        guard let items = container.items, items.count > row else {
            return 0
        }
        
        var rowHeight: CGFloat = 0
        
        let item = items[row]
        
        // 当前商家索引
        var shopIndex = 0
        if let sectionType = item.sectionType, sectionType == .sectionShop {
            shopIndex = section - 1
        }
        
        switch item.cellType {
        case .address:
            if let addressInfo = modelCO?.receiveInfoVO {
                rowHeight = COAddressView.calculateAddressHeight(addressInfo.printAddress)
            }
        case .payTypeSingle,
             .payTypeDouble,
             .invoice,
             .shopName,
             .gift:
            rowHeight = WH(44)
        case .useRebate:
            rowHeight = CORebateInputCell.calculateRebateViewsHeight(modelCO)
        case .shopBuyMoney:
            rowHeight = CORebateInputCell.calculateSopBuyMoneyViewsHeight(modelCO)
        case .productMore:
            //多品一行
            rowHeight = WH(95)
        case .productSingle:
            //单品只有一个商品
            rowHeight = getProductCellHeight(shopIndex)
        case .leaveMessage:
            rowHeight = getLeaveMessageCellHeight(shopIndex)
        case .productCoupon:
            rowHeight = getProductCouponCellHeight(shopIndex)
        case .couponCode:
            rowHeight = getCouponCodeCellHeight(shopIndex)
        case .platform:
            rowHeight = getPlatformCouponCellHeight()
        case .productAmount,
             .discountAmount,
             .rebateMoney,
             .rebatePlatformMoney,
             .shopCouponMoney,
             .platformCouponMoney,
             .allShopBuyMoney, //购物金
             .freight,
             .getRebate,
             .payAmount:
            rowHeight = WH(35)
        case .invoiceTip:
            rowHeight = WH(25)
        case .followQualification:
            rowHeight = WH(49)
        case .saleAgreement:
            rowHeight = WH(61)
        default:
            break
        }
        return rowHeight
    }
}

// MARK: - Cell Height
extension CheckOrderViewModel {
    
    // [商品详情]必展示
    func getProductCellHeight(_ shopIndex: Int) -> CGFloat {
        guard modelCO != nil else {
            return 0
        }
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex, let pList = list[shopIndex].products, pList.count > 0 else {
            return 0
        }
        
        // 商品model
        let product: COProductModel = pList.first!
        return COProductInfoCell.getContentHeight(product)
    }
    
    // [留言]必展示
    func getLeaveMessageCellHeight(_ shopIndex: Int) -> CGFloat {
        guard modelCO != nil else {
            return 0
        }
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return 0
        }
        // key
        let shop: COSupplyOrderModel = list[shopIndex]
        var shopKey = shopIndex // key
        if let shopId = shop.supplyId, shopId > 0 {
            shopKey = shopId
        }
        guard let msg = dicMessage[shopKey], msg.isEmpty == false else {
            // 无留言
            return WH(58)
        }
        // 有留言...<计算动态高度>
        let height = COLeaveMessageCell.calculateCellHeight(msg)
        return height
    }
    
    // [商品优惠券]必展示...<一起购不显示>
    func getProductCouponCellHeight(_ shopIndex: Int) -> CGFloat {
        guard modelCO != nil else {
            return 0
        }
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return 0
        }
        if isGroupBuy {
            // 一起购不显示优惠券cell
            return 0
        }
        if self.fromWhere == 5 {
            // 单品包邮不显示优惠券cell
            return 0
        }
        let shop: COSupplyOrderModel = list[shopIndex]
        if let allTJ = shop.isAllMutexTeJia, allTJ == 1 {
            // 订单中全部商品均为特价商品...<不可用券>
            return WH(44)
        }
        guard let hasCoupon = shop.shopCouponInfoVO?.hasAvailableCoupon, hasCoupon == true else {
            // 无可用优惠券
            return WH(44)
        }
        // 有可用优惠券
        //if let number = shop.checkCouponNum, number > 0 {
        if let code = shop.checkCouponCodeStr, code.isEmpty == false {
            // 有使用优惠券，需勾选
            return WH(44) * 2
        }
        else {
            // 未使用优惠券，不勾选
            //return WH(44)
            
            /*
             说明：未使用优惠券分两种情况...<考虑checkCouponCodeStr为空情况>...[考虑checkCouponNum=0情况...<不再使用>]
             1. 已勾选，已展开
             2. 未勾选，未展开
             */
            
            // shopid
            var shopKey = shopIndex
            if let sid = shop.supplyId {
                shopKey = sid
            }
            if let selected = dicProductCouponSelected[shopKey], selected == true {
                // 展开
                return WH(44) * 2
            }
            else {
                // 不展开
                return WH(44)
            }
        }
    }
    //获取平台优惠券的高度
    func getPlatformCouponCellHeight() -> CGFloat {
        guard let model = modelCO else {
            return 0
        }
        guard let platformCouponModel = model.platformCouponInfo , let hasCoupon = platformCouponModel.hasAvailableCoupon, hasCoupon == true else {
            // 无可用平台优惠券
            return WH(49)
        }
        if self.platformCouponCode.count > 0 {
            return WH(68)
        }else {
            return WH(49)
        }
    }
    
    // [优惠券码]接口控制...<优惠码不受一起购控制>
    func getCouponCodeCellHeight(_ shopIndex: Int) -> CGFloat {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0, list.count > shopIndex else {
            return 0
        }
        let shop: COSupplyOrderModel = list[shopIndex]
        
        if let allTJ = shop.isAllMutexTeJia, allTJ == 1 {
            // 订单中全部商品均为特价商品...<不可用券>
            return WH(44)
        }
        if let code = shop.showCouponCode, code.isEmpty == false {
            // 有使用优惠码，需勾选
            return WH(44) * 2
        }
        else {
            // 未使用优惠码，不勾选
            //return WH(44)
            
            /*
             说明：未使用优惠码分两种情况...<考虑showCouponCode为空情况>
             1. 已勾选，已展开
             2. 未勾选，未展开
             */
            
            // shopid
            var shopKey = shopIndex
            if let sid = shop.supplyId {
                shopKey = sid
            }
            if let selected = dicCouponCodeSelected[shopKey], selected == true {
                // 展开
                return WH(44) * 2
            }
            else {
                // 不展开
                return WH(44)
            }
        }
    }
}


extension CheckOrderViewModel {
    //封装数据源  created by My => 
    func configContainersSource() {
        guard let model = modelCO, let list = model.orderSupplyCartVOs, list.count > 0 else {
            //无商家信息
            return
        }
        //sections
        var sections = [FKYCOContainer]()
        
        //收货地址
        var addressItems = [FKYCODetailContainer]()
        let addressSection = FKYCOContainer()
        let addressItem = FKYCODetailContainer()
        addressItem.sectionType = .sectionAddress
        addressItem.cellType = .address
        addressItems.append(addressItem)
        addressSection.sectionType = .sectionAddress
        addressSection.items = addressItems
        sections.append(addressSection)
        
        //遍历所有商家 对应的展示信息
        for (_, shop) in list.enumerated() {
            var shopsItems = [FKYCODetailContainer]()
            let shopSection = FKYCOContainer()
            
            //店铺名
            let nameItem = FKYCODetailContainer()
            nameItem.sectionType = .sectionShop
            nameItem.cellType = .shopName
            shopsItems.append(nameItem)
            
            //商品
            if let products = shop.products, products.count > 0 {
                let productItem = FKYCODetailContainer()
                productItem.sectionType = .sectionShop
                if products.count > 1 {
                    //多品
                    productItem.cellType = .productMore
                } else {
                    //单品
                    productItem.cellType = .productSingle
                }
                shopsItems.append(productItem)
            }
            
            //            //留言
            //            let messageItem = FKYCODetailContainer()
            //            messageItem.sectionType = .sectionShop
            //            messageItem.cellType = .leaveMessage
            //            shopsItems.append(messageItem)
            
            //跟随企业资质
            if let qualificationList = shop.firstMarketingQualifications,qualificationList.isEmpty == false{
                let qualificationItem = FKYCODetailContainer()
                qualificationItem.sectionType = .sectionShop
                qualificationItem.cellType = .followQualification
                shopsItems.append(qualificationItem)
            }
            
            //赠品 有则展示
            if let giftFlag = shop.giftFlag, let value = Int(giftFlag), value == 1, let gift = shop.giftMessage, gift.isEmpty == false {
                
                let list: [String] = gift.components(separatedBy: "|")
                var listFinal = [String]()
                for item in list {
                    if item.isEmpty == false {
                        listFinal.append(item)
                    }
                }
                
                if listFinal.count > 0 {
                    // 有赠品...<赠品标记为1，则赠品内容不为空>
                    let giftItem = FKYCODetailContainer()
                    giftItem.sectionType = .sectionShop
                    giftItem.cellType = .gift
                    giftItem.data = listFinal
                    shopsItems.append(giftItem)
                }
            }
            
            if isGroupBuy == false && self.fromWhere != 5 {
                // 一起购不显示商品优惠券
                let couponItem = FKYCODetailContainer()
                couponItem.sectionType = .sectionShop
                couponItem.cellType = .productCoupon
                shopsItems.append(couponItem)
            }
            
            //优惠券码
            var showCoupon = true
            if let supplyType = shop.supplyType, supplyType == 1 {
                // mp不显示优惠码cell...<非自营>
                showCoupon = false
            } else if let showFlag = shop.showCouponText, showFlag == false {
                // 不显示优惠码cell
                showCoupon = false
            }
            if showCoupon {
                let codeItem = FKYCODetailContainer()
                codeItem.sectionType = .sectionShop
                codeItem.cellType = .couponCode
                shopsItems.append(codeItem)
            }
            
            
            if isGroupBuy == false && (self.fromWhere != 5 || (self.fromWhere == 5 && model.hasZiyingStatus != 1)) {
                if model.shareRebate != "1" {
                    // 一起购不显示返利金抵扣cell 单品包邮mp 显示返利金
                    let useRebateItem = FKYCODetailContainer()
                    useRebateItem.sectionType = .sectionShop
                    useRebateItem.cellType = .useRebate
                    shopsItems.append(useRebateItem)
                }
            }
            
            //支付方式
            let payItem = FKYCODetailContainer()
            payItem.sectionType = .sectionShop
            if let offPay = shop.offPay, offPay == 1 {
                //线上 + 线下
                payItem.cellType = .payTypeDouble
            }else {
                //线上
                payItem.cellType = .payTypeSingle
            }
            shopsItems.append(payItem)
            
            
            //多店铺则每个店铺加
            /*
             商品金额：固定展示
             立减优惠金额：(有则展示，无则不展示）
             店铺优惠券优惠金额：（有则展示，无则不展示）
             平台优惠券优惠金额：（有则展示，无则不展示）
             使用返利金抵扣：（有则展示，无则不展示）
             运费：固定展示
             可获返利金: 有则展示，无则不展示）
             总金额 固定展示
             */
            if list.count > 1 {
                //商品金额
                let productAmountItem = FKYCODetailContainer()
                productAmountItem.sectionType = .sectionShop
                productAmountItem.cellType = .productAmount
                var totalAmount = "¥ 0.00"
                
                if let amount = shop.totalAmount, amount.doubleValue > 0 {
                    totalAmount = String(format: "¥ %.2f", amount.doubleValue)
                }
                
                productAmountItem.data = totalAmount
                shopsItems.append(productAmountItem)
                
                //立减优惠
                if let amount = shop.discountAmount, amount.doubleValue > 0 {
                    let discountAmountItem = FKYCODetailContainer()
                    discountAmountItem.sectionType = .sectionShop
                    discountAmountItem.cellType = .discountAmount
                    discountAmountItem.data = String(format: "-¥ %.2f", amount.doubleValue)
                    shopsItems.append(discountAmountItem)
                }
                
                if model.shareRebate != "1" {
                    //使用返利金
                    if let amount = shop.useRebateMoney, amount.doubleValue > 0 {
                        let rebateMoneyItem = FKYCODetailContainer()
                        rebateMoneyItem.sectionType = .sectionShop
                        rebateMoneyItem.cellType = .rebateMoney
                        rebateMoneyItem.data = String(format: "-¥ %.2f", amount.doubleValue)
                        shopsItems.append(rebateMoneyItem)
                    }
                }
                //店铺优惠券
                if let amount = shop.orderCouponMoney, amount.doubleValue > 0 {
                    let shopCouponMoneyItem = FKYCODetailContainer()
                    shopCouponMoneyItem.sectionType = .sectionShop
                    shopCouponMoneyItem.cellType = .shopCouponMoney
                    shopCouponMoneyItem.data = String(format: "-¥ %.2f", amount.doubleValue)
                    shopsItems.append(shopCouponMoneyItem)
                }
                
                
                //平台优惠券
                //                if let amount = shop.orderPlatformCouponMoney, amount.doubleValue > 0 {
                //                    let platformCouponMoneyItem = FKYCODetailContainer()
                //                    platformCouponMoneyItem.sectionType = .sectionShop
                //                    platformCouponMoneyItem.cellType = .platformCouponMoney
                //                    platformCouponMoneyItem.data = String(format: "-¥ %.2f", amount.doubleValue)
                //                    shopsItems.append(platformCouponMoneyItem)
                //                }
                
                //运费
                let freightItem = FKYCODetailContainer()
                freightItem.sectionType = .sectionShop
                freightItem.cellType = .freight
                var freightContent = "¥ 0.00" // 默认值
                if let amount = shop.supplyFreight, amount.doubleValue > 0 {
                    freightContent = String(format: "¥ %.2f", amount.doubleValue)
                }
                freightItem.data = freightContent
                shopsItems.append(freightItem)
                
                
                //可获返利金
                if let amount = shop.canGetRebateMoney, amount.doubleValue > 0 {
                    let getRebateItem = FKYCODetailContainer()
                    getRebateItem.sectionType = .sectionShop
                    getRebateItem.cellType = .getRebate
                    getRebateItem.data = String(format: "¥ %.2f", amount.doubleValue)
                    shopsItems.append(getRebateItem)
                }
                
                //总金额
                let payAmountItem = FKYCODetailContainer()
                payAmountItem.sectionType = .sectionShop
                payAmountItem.cellType = .payAmount
                var orderPayMoney = "¥ 0.00"
                if let amount = shop.orderPayMoney, amount.doubleValue > 0 {
                    orderPayMoney = String(format: "¥ %.2f", amount.doubleValue)
                }
                
                let tip = "小计："
                var countTip = ""
                if let count = shop.productCount, count > 0 {
                    countTip = "共\(count)件"
                }
                
                let tips = [
                    COPayAmountCell.COPayInfoKey.payAmountKey.rawValue: orderPayMoney,
                    COPayAmountCell.COPayInfoKey.countKey.rawValue: countTip,
                    COPayAmountCell.COPayInfoKey.tipKey.rawValue: tip
                ]
                payAmountItem.data = tips
                shopsItems.append(payAmountItem)
            }
            
            shopSection.sectionType = .sectionShop
            shopSection.items = shopsItems
            sections.append(shopSection)
        }
        
        if isGroupBuy == false && (self.fromWhere != 5 || (self.fromWhere == 5 && model.hasZiyingStatus != 1)) {
            //平台优惠券(一起购or单品包邮不展示平台券) 单品包邮mp 显示返利金
            var platformItems = [FKYCODetailContainer]()
            let platformSection = FKYCOContainer()
            if self.fromWhere != 5{
                let platformItem = FKYCODetailContainer()
                platformItem.sectionType = .sectionPlatform
                platformItem.cellType = .platform
                platformItems.append(platformItem)
            }
            
            if model.shareRebate == "1" {
                // 一起购不显示返利金抵扣cell
                let useRebateItem = FKYCODetailContainer()
                useRebateItem.sectionType = .sectionPlatform
                useRebateItem.cellType = .useRebate
                platformItems.append(useRebateItem)
            }
            if model.hasZiyingStatus == 1 {
                //购物金
                let shopBuyMoneyItem = FKYCODetailContainer()
                shopBuyMoneyItem.sectionType = .sectionPlatform
                shopBuyMoneyItem.cellType = .shopBuyMoney
                platformItems.append(shopBuyMoneyItem)
            }
            
            platformSection.sectionType = .sectionPlatform
            platformSection.items = platformItems
            sections.append(platformSection)
        }else {
            if model.hasZiyingStatus == 1 {
                //一起购平台or单品包邮
                var platformItems = [FKYCODetailContainer]()
                let platformSection = FKYCOContainer()
                //购物金
                let shopBuyMoneyItem = FKYCODetailContainer()
                shopBuyMoneyItem.sectionType = .sectionPlatform
                shopBuyMoneyItem.cellType = .shopBuyMoney
                platformItems.append(shopBuyMoneyItem)
                
                platformSection.sectionType = .sectionPlatform
                platformSection.items = platformItems
                sections.append(platformSection)
            }
        }
        
        
        //发票信息
        var invoiceItems = [FKYCODetailContainer]()
        let invoiceSection = FKYCOContainer()
        let invoiceItem = FKYCODetailContainer()
        invoiceItem.sectionType = .sectionInvoice
        invoiceItem.cellType = .invoice
        invoiceItems.append(invoiceItem)
        // 发票提示
        if let arr = model.invoiceTypeList,arr.contains(2) == false {
            //不包含增值税普通发票
            let invoiceTipItem = FKYCODetailContainer()
            invoiceTipItem.sectionType = .sectionInvoice
            invoiceTipItem.cellType = .invoiceTip
            invoiceItems.append(invoiceTipItem)
        }
        
        invoiceSection.sectionType = .sectionInvoice
        invoiceSection.items = invoiceItems
        sections.append(invoiceSection)
        
        
        // 销售合同随货显示
        if let showFlag = model.showSalesContract,showFlag == 1{
            let salesContractSection = FKYCOContainer()
            salesContractSection.sectionType = .sectionSaleContact
            
            var salesContractItems = [FKYCODetailContainer]()
            let salesContractItem = FKYCODetailContainer()
            
            salesContractItem.sectionType = .sectionSaleContact
            salesContractItem.cellType = .saleAgreement
            salesContractItems.append(salesContractItem)
            salesContractSection.items = salesContractItems
            sections.append(salesContractSection)
        }
        
        //总的信息
        var totalItems = [FKYCODetailContainer]()
        let totalSection = FKYCOContainer()
        
        //商品金额
        let productAmountItem = FKYCODetailContainer()
        productAmountItem.sectionType = .sectionTotal
        productAmountItem.cellType = .productAmount
        var content = "¥ 0.00" // 默认值
        
        if let amount = model.totalAmount, amount.doubleValue > 0 {
            content = String(format: "¥ %.2f", amount.doubleValue)
        }
        productAmountItem.data = content
        totalItems.append(productAmountItem)
        
        //立减优惠
        if let amount = model.discountAmount, amount.doubleValue > 0 {
            let discountAmountItem = FKYCODetailContainer()
            discountAmountItem.sectionType = .sectionTotal
            discountAmountItem.cellType = .discountAmount
            discountAmountItem.data = String(format: "-¥ %.2f", amount.doubleValue)
            totalItems.append(discountAmountItem)
        }
        
        //使用店铺返利金
        if let amount = model.allOrdersUseRebateMoney, amount.doubleValue > 0 {
            let rebateMoneyItem = FKYCODetailContainer()
            rebateMoneyItem.sectionType = .sectionTotal
            rebateMoneyItem.cellType = .rebateMoney
            if let platformAmount = model.allOrdersUsePlatformRebateMoney, platformAmount.doubleValue > 0 {
                if (amount.doubleValue - platformAmount.doubleValue) > 0{
                    rebateMoneyItem.data = String(format: "-¥ %.2f", (amount.doubleValue - platformAmount.doubleValue))
                    totalItems.append(rebateMoneyItem)
                }else {
                    
                }
            }else {
                rebateMoneyItem.data = String(format: "-¥ %.2f", amount.doubleValue)
                totalItems.append(rebateMoneyItem)
            }
        }
        //使用平台返利金
        if let amount = model.allOrdersUsePlatformRebateMoney, amount.doubleValue > 0 {
            let rebateMoneyItem = FKYCODetailContainer()
            rebateMoneyItem.sectionType = .sectionTotal
            rebateMoneyItem.cellType = .rebatePlatformMoney
            rebateMoneyItem.data = String(format: "-¥ %.2f", amount.doubleValue)
            totalItems.append(rebateMoneyItem)
        }
        
        //店铺优惠券
        if let amount = model.allOrderCouponMoney, amount.doubleValue > 0 {
            let shopCouponMoneyItem = FKYCODetailContainer()
            shopCouponMoneyItem.sectionType = .sectionTotal
            shopCouponMoneyItem.cellType = .shopCouponMoney
            shopCouponMoneyItem.data = String(format: "-¥ %.2f", amount.doubleValue)
            totalItems.append(shopCouponMoneyItem)
        }
        
        //购物金
        if let amount = model.allUseGwjBalance, amount.doubleValue > 0 {
            let shopCouponMoneyItem = FKYCODetailContainer()
            shopCouponMoneyItem.sectionType = .sectionTotal
            shopCouponMoneyItem.cellType = .allShopBuyMoney
            shopCouponMoneyItem.data = String(format: "-¥ %.2f", amount.doubleValue)
            totalItems.append(shopCouponMoneyItem)
        }
        
        //平台优惠券
        if let amount = model.allPlatformCouponMoney, amount.doubleValue > 0 {
            let platformCouponMoneyItem = FKYCODetailContainer()
            platformCouponMoneyItem.sectionType = .sectionTotal
            platformCouponMoneyItem.cellType = .platformCouponMoney
            platformCouponMoneyItem.data = String(format: "-¥ %.2f", amount.doubleValue)
            totalItems.append(platformCouponMoneyItem)
        }
        
        
        //运费
        let freightItem = FKYCODetailContainer()
        freightItem.sectionType = .sectionTotal
        freightItem.cellType = .freight
        var freightContent = "¥ 0.00" // 默认值
        if let amount = model.freight, amount.doubleValue > 0 {
            freightContent = String(format: "¥ %.2f", amount.doubleValue)
        }
        freightItem.data = freightContent
        totalItems.append(freightItem)
        
        //可获返利金
        if let amount = model.allOrdersGetRebateMoney, amount.doubleValue > 0 {
            let getRebateItem = FKYCODetailContainer()
            getRebateItem.sectionType = .sectionTotal
            getRebateItem.cellType = .getRebate
            getRebateItem.data = String(format: "¥ %.2f", amount.doubleValue)
            totalItems.append(getRebateItem)
        }
        
        //总金额
        let payAmountItem = FKYCODetailContainer()
        payAmountItem.sectionType = .sectionTotal
        payAmountItem.cellType = .payAmount
        var totalContent = "¥ 0.00" // 默认值
        if let amount = model.payAmount, amount.doubleValue > 0 {
            totalContent = String(format: "¥ %.2f", amount.doubleValue)
        }
        var countTip = ""
        if let count  = model.totalProductNumber, count > 0 {
            countTip = "共\(count)件"
        }
        let tip = "应付总额："
        let tips = [
            COPayAmountCell.COPayInfoKey.payAmountKey.rawValue: totalContent,
            COPayAmountCell.COPayInfoKey.countKey.rawValue: countTip,
            COPayAmountCell.COPayInfoKey.tipKey.rawValue: tip
        ]
        payAmountItem.data = tips
        totalItems.append(payAmountItem)
        
        totalSection.sectionType = .sectionTotal
        totalSection.items = totalItems
        sections.append(totalSection)
        
        coSections =  sections
    }
    
    //MARK- 6.3.1 不可用码遍历打标
    func markCouponProducts(_ attachment: [COProductModel]?) {
        guard let attachmentList = attachment, attachmentList.count > 0 else {
            return
        }
        
        guard let model = modelCO else {
            return
        }
        
        guard let shops = model.orderSupplyCartVOs, shops.count > 0 else {
            return
        }
        
        //遍历所有商家的商品
        for shop in shops {
            if let products = shop.products, products.count > 0 {
                for product in products {
                    for attachProduct in attachmentList {
                        if let spuCode1 = product.spuCode, let supplyId1 = product.supplyId, let spuCode2 = attachProduct.spuCode, let supplyId2 = attachProduct.supplyId, spuCode1 == spuCode2, supplyId1 == supplyId2 {
                            //打不可用码标
                            product.isMutexCouponCode = 1
                            break;
                        }
                    }
                }
            }
        }
    }
}
