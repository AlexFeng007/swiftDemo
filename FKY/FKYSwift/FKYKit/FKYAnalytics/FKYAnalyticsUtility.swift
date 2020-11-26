//
//  FKYAnalysisUtility.swift
//  FKYNetwork
//
//  Created by mahui on 16/8/16.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony
import AdSupport

@objc
class FKYAnalyticsUtility: NSObject {
    
    /**
     *  是否可以发送行为统计到服务器(2G和无网络不发送，只缓存)
     *
     *  @return 是否可以发送行为统计到服务器
     */
    class func isShouldSendMessageToService() -> Bool {
        return true
    }
    
    /**
     *  是否第一次加载新版本客户端
     *
     *  @return 是否第一次加载新版本客户端
     */
    class func isAppFirstDownloadByDevice() -> Bool {
        let firstTime  = UserDefaults.standard.bool(forKey: "YWBehaviorStatistics_isAppFirstDownloadByDevice")
        if firstTime == false {
            UserDefaults.standard.set(false, forKey: "YWBehaviorStatistics_isAppFirstDownloadByDevice")
            UserDefaults.standard.synchronize()
            return false
        }else{
            return firstTime
        }
    }
    
    /**
     *  获取APP版本
     *
     *
     */
    class func appVersion() -> String? {
        if let info = Bundle.main.infoDictionary {
            let bundleVersion = info["CFBundleShortVersionString"]!
            return "\(bundleVersion)"
        }
        return String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)
    }
    
    /**
     *
     *
     *	获取设备型号
     *
     */
    @objc
    class func getDevicePlatform() -> String? {
        let name = UnsafeMutablePointer<utsname>.allocate(capacity: 1)
        uname(name)
        let machine = withUnsafePointer(to: &name.pointee.machine, { (ptr) -> String? in
            let int8Ptr = unsafeBitCast(ptr, to: UnsafePointer<CChar>.self)
            return String(cString: int8Ptr)
        })
        name.deallocate(capacity: 1)
        if let deviceString = machine {
            switch deviceString {
            case"iPhone1,1" :   return "iPhone 2G"
            case"iPhone1,2" :   return "iPhone 3G"
            case"iPhone2,1" :   return "iPhone 3GS"
            case"iPhone3,1" :   return "iPhone 4"
            case"iPhone3,2" :   return "iPhone 4"
            case"iPhone3,3" :   return "iPhone 4 (CDMA)"
            case"iPhone4,1" :   return "iPhone 4S"
            case"iPhone5,1" :   return "iPhone 5"
            case"iPhone5,2" :   return "iPhone 5 (GSM+CDMA)"
            case"iPhone5,3" :   return "iPhone 5c (GSM+CDMA)"
            case"iPhone5,4" :   return "iPhone 5c (UK+Europe+Asis+China)"
            case"iPhone6,1" :   return "iPhone 5s (GSM+CDMA)"
            case"iPhone6,2" :   return "iPhone 5s (UK+Europe+Asis+China)"
            case"iPhone7,1" :   return "iPhone 6 Plus"
            case"iPhone7,2" :   return "iPhone 6"
            case"iPhone8,1" :   return"iPhone 6s"
            case"iPhone8,2" :   return "iPhone 6s Plus"
            case"iPhone8,4" :   return "iPhone SE"
            case"iPhone9,1" :   return "iPhone 7"
            case"iPhone9,3" :   return "iPhone 7"
            case"iPhone9,2" :   return "iPhone 7 Plus"
            case"iPhone9,4" :   return "iPhone 7 Plus"
            case"iPhone10,1" :  return "iPhone 8"
            case"iPhone10,4" :  return "iPhone 8"
            case"iPhone10,2" :  return "iPhone 8 Plus"
            case"iPhone10,5" :  return "iPhone 8 Plus"
            case"iPhone10,3" :  return "iPhone X"
            case"iPhone10,6" :  return "iPhone X"
            case"iPhone11,2" :  return "iPhone XS"
            case"iPhone11,4" :  return "iPhone XS Max China"
            case"iPhone11,6" :  return "iPhone XS Max"
            case"iPhone11,8" :  return "iPhone XR"
            case"iPhone12,1" :  return "iPhone 11"
            case"iPhone12,3" :  return "iPhone 11 Pro"
            case"iPhone12,5" :  return "iPhone 11 Pro Max"
            case"iPhone12,8" :  return "iPhone SE (2nd generation)"
                
            case"iPod1,1"   :   return "iPod Touch (1 Gen)"
            case"iPod2,1"   :   return "iPod Touch (2 Gen)"
            case"iPod3,1"   :   return "iPod Touch (3 Gen)"
            case"iPod4,1"   :   return "iPod Touch (4 Gen)"
            case"iPod5,1"   :   return "iPod Touch (5 Gen)"
            case"iPod7,1"   :    return "iPod touch 6"
            case"iPod9,1"   :    return "iPod touch 7"
                
            case"iPad1,1"   :   return "iPad"
            case"iPad1,2"   :   return "iPad 3G"
            case"iPad2,1"   :   return "iPad 2 (WiFi)"
            case"iPad2,2"   :   return "iPad 2"
            case"iPad2,3"   :   return "iPad 2 (CDMA)"
            case"iPad2,4"   :   return "iPad 2"
            case"iPad2,5"   :   return "iPad Mini (WiFi)"
            case"iPad2,6"   :   return "iPad Mini"
            case"iPad2,7"   :   return "iPad Mini (GSM+CDMA)"
            case"iPad3,1"   :   return "iPad 3 (WiFi)"
            case"iPad3,2"   :   return "iPad 3 (GSM+CDMA)"
            case"iPad3,3"   :   return "iPad 3"
            case"iPad3,4"   :   return "iPad 4 (WiFi)"
            case"iPad3,5"   :   return "iPad 4"
            case"iPad3,6"   :   return "iPad 4 (GSM+CDMA)"
            case"iPad4,1"   :   return "iPad Air (WiFi)"
            case"iPad4,2"   :   return "iPad Air (GSM+CDMA)"
            case"iPad4,4"   :   return "iPad Mini Retina (WiFi)"
            case"iPad4,5"   :   return "iPad Mini Retina (GSM+CDMA)"
            case"iPad4,6" :    return "iPad mini 2 (CDMA EV-DO)"
            case"iPad4,7" :    return "iPad mini 3 (WiFi)"
            case"iPad4,8" :    return "iPad mini 3 (4G)"
            case"iPad4,9" :    return "iPad mini 3 (4G)"
            case"iPad5,1" :    return "iPad mini 4 (WiFi)"
            case"iPad5,2" :    return "iPad mini 4 (4G)"
            case"iPad5,3" :    return "iPad Air 2 (WiFi)"
            case"iPad5,4" :    return "iPad Air 2 (4G)"
            case"iPad6,3" :    return "iPad Pro (9.7-inch-WiFi)"
            case"iPad6,4" :    return "iPad Pro (9.7-inch-4G)"
            case"iPad6,7" :    return "iPad Pro (12.9-inch-WiFi)"
            case"iPad6,8" :    return "iPad Pro (12.9-inch-4G)"
            case"iPad6,11" :    return "iPad 5 (WiFi)"
            case"iPad6,12" :    return "iPad 5 (4G)"
            case"iPad7,1" :    return "iPad Pro 2 (12.9-inch-WiFi)"
            case"iPad7,2" :    return "iPad Pro 2 (12.9-inch-4G)"
            case"iPad7,3" :    return "iPad Pro (10.5-inch-WiFi)"
            case"iPad7,4" :    return "iPad Pro (10.5-inch-4G)"
            case"iPad7,5" :    return "iPad 6 (WiFi)"
            case"iPad7,6" :    return "iPad 6 (4G)"
            case"iPad8,1" :    return "iPad Pro 3rd Gen (11 inch, WiFi)"
            case"iPad8,2" :    return "iPad Pro 3rd Gen (11 inch, 1TB, WiFi)"
            case"iPad8,3" :    return "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)"
            case"iPad8,4" :    return "iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)"
            case"iPad8,5" :    return "iPad Pro 3rd Gen (12.9 inch, WiFi)"
            case"iPad8,6" :    return "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)"
            case"iPad8,7" :    return "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)"
            case"iPad8,8" :    return "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case"iPad11,1" :    return "iPad mini 5th Gen (WiFi)"
            case"iPad11,2" :    return "iPad mini 5th Gen"
            case"iPad11,3" :    return "iPad Air 3rd Gen (WiFi)"
            case"iPad11,4" :    return "iPad Air 3rd Gen"
            case"iPad11,5" :    return "iPad Air 3rd Gen"
            case"i386"      :   return "Simulator"
            case"x86_64"    :   return "Simulator"
                
            default:
                return deviceString
            }
        } else {
            return "Unknown Machine"
        }
    }
    
    /**
     *  获取运营商
     *
     *  @return 运营商
     */
    @objc
    class func getDeviceOperator() -> String {
        let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider
        if carrier != nil {
            let code = carrier!.mobileNetworkCode
            if code != nil {
                if code == "00" || code == "02" || code == "07"{
                    return "China Mobile"
                }
                if code == "01" || code == "06"{
                    return "China Unicom"
                }
                if code == "03" || code == "05"{
                    return "China Telecom"
                }
                if code == "20"{
                    return "China Tietong"
                }
                return "Unknown Network"
            }
        }
        
        return "Unknown Network"
    }
    
    /**
     *
     *	获取设备系统类型
     *
     *	@return	获取设备系统类型
     */
    @objc
    class func getDeviceSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /**
     *
     *	获取设备UUID
     *
     *	@return	获取设备系统类型
     */
    @objc class func getDeviceUUID() -> String? {
        return UIDevice.readIdfvForDeviceId()
    }
    //暂时不用啦 如果后期要用记得判断iOS14 下面的权限申请
    class func getIDFA() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    /**
     *
     *	获取时间轴
     *
     */
    class func generateTimeIntervalWithTimeZone() -> Double{
        let date = Date()
        let time = date.timeIntervalSince1970 * 1000
        let str = String(format: "%.f",time)
        return (str as NSString).doubleValue
    }
    
    fileprivate static let YWBSVisitIDKey = "YWBehaviorStatisticsVisitIDKey"
    
    class func getVisitID() -> String {
        let time = FKYAnalyticsUtility.generateTimeIntervalWithTimeZone()
        let preTimeIntervalStr = UserDefaults.standard.double(forKey: YWBSVisitIDKey)
        if preTimeIntervalStr > 0 {
            let interval = time - preTimeIntervalStr
            let halfHourInterval = 60*30*1000
            if interval >= Double(halfHourInterval) {
                return FKYAnalyticsUtility.generateVisitID()
            }else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HHmm"
                let date = Date.init(timeIntervalSince1970: preTimeIntervalStr)
                return dateFormatter.string(from: date)
            }
        }else{
            return FKYAnalyticsUtility.generateVisitID()
        }
    }
    
    class func generateVisitID() -> String {
        let time = FKYAnalyticsUtility.generateTimeIntervalWithTimeZone()
        UserDefaults.standard.set(time, forKey: YWBSVisitIDKey)
        UserDefaults.standard.synchronize()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        let date = Date.init(timeIntervalSince1970: time / 1000)
        return dateFormatter.string(from: date)
    }
}

// 添加BI打点的controller 和对应的链接
let BIViewControllerMap:[String: String] = [
    "HomeController": "https://mall.yaoex.com/", //  首页
    "LoginController": "https://passport.yaoex.com/", //  登录
    "RegisterController": "https://passport.yaoex.com/jsp/login/", //  注册
    "FKYCategoryWebViewController": "https://mall.yaoex.com/",  //  分类
    "CartSwitchViewController": "https://oms.yaoex.com/shoppingCart/index/", // 购物车
    "AccountViewController": "https://passport.yaoex.com/passport/menu/menu/",   // 个人中心
    "FKYSearchResultVC_Product": "https://mall.yaoex.com/product/toSearchPage/",   // 商品搜索
    "FKYSearchResultVC_Shop": "http://mall.yaoex.com/store/search/", // 店铺搜索
    "FKYProductionDetailViewController": "https://mall.yaoex.com/product/productDetail/", //  商品详情
    "FKYShopListViewController": "https://mall.yaoex.com/shop/goShopList/",   // 店铺馆
    "ShopItemViewController": "https://mall.yaoex.com/shop/goShopHome/",   // 店铺主页
    "FKYAllOrderViewController": "https://oms.yaoex.com/order/buyerOrderManage/", // 订单列表
    "FKYOrderDetailViewController": "https://oms.yaoex.com/order/getBuyOrderDetails/",   //  订单详情
    //"FKYBatchViewController": "https://oms.yaoex.com/order/getBuyOrderDetails/",   //    查看批次
    "FKYLogisticsViewController": "https://oms.yaoex.com/order/getBuyOrderDetails/", // 取消原因, 查看更多详情
    "FKYLogisticsDetailViewController": "https://oms.yaoex.com/order/getBuyOrderDetails/", // 物流信息
    "FKYReceiveProductViewController": "https://oms.yaoex.com/order/getBuyOrderDetails/", // 确认收货列表
    "FKYJSBHApplyViewController": "https://oms.yaoex.com/order/getBuyOrderDetails/" ,    // 拒收补货页面
    "CheckOrderController": "https://oms.yaoex.com/order/checkOrderPage/",             // 检查订单
    "COSelectOnlinePayController": "https://oms.yaoex.com/order/createOrderSuccess/",  // 选择在线支付方式
    "RegisterSuccessViewController": "https://passport.yaoex.com/jsp/login/",             // 注册成功
    "FKYRefuseListViewController": "https://oms.yaoex.com/orderException/buyerRejectOrderManage/",   // 拒收补货列表
    "FKYJSOrderDetailViewController": "https://oms.yaoex.com/orderException/getDetails-1/",          // 拒收补货详情
    "CredentialsAddressManageController": "https://usermanage.yaoex.com/enterpriseInfo/enterpriseDoor/", // 个人中心之收货地址列表
    "FKYPaySuccessViewController": "https://oms.yaoex.com/order/buyerOrderManage/",     // 支付成功页
    "FKYPaymentWebViewController": "https://oms.yaoex.com/order/createOrderSuccess/",   // 银联支付页面
    "HotSaleController": "https://mall.yaoex.com/topsearchapp/", // 本周热搜、区域热销排行榜列表页
    "RITextController":"https://usermanage.yaoex.com/company/", //企业基本信息
    "OftenBuyProductListController":"http://usermanage.yaoex.com/suggestPill/", // 推荐药品
    "FKYSearchViewController":"http://mall.yaoex.com/search/" // 搜索页
]

// 页面
enum PAGECODE: String {
    case HOME = "home" // 首页
    case CATEGORY = "category" // 分类
    case SHOPPINGCART = "shoppingCart" // 购物车/购物车<购物车合并后的总的购物车>
    case NORMALSHOPPINGCART = "normalShoppingCart" // (普通商品)购物车/购物车
    case MINE = "mine" // 我的/个人中心
    //case ENTERPRISEINFO = "enterpriseInfo" // 地址选择(检查订单)
    case PRODUCTSEARCH = "productSearch" // 商品搜索
    case SCANSEARCH = "scanSearch" // 扫描搜索
    case NEWPRODUCTREGISTER = "newProductRegister" // 新品登记
    case ACTIVITYLOADINGPAGE = "Activitylanding" // 逛一逛的优惠界面
    case STORESEARCH = "shopSearchResult" // 店铺搜索
    case SHOPPRODUCTSEARCHRESULT = "shopProductSearchResult" // 店铺内搜索结果：shopProductSearchResult（新增）
    case JBPPRODUCTSEARCHRESULT = "JBPProductSearchResult" // JBP专区搜索结果：JBPProductSearchResult（新增）
    case COUPONPRODUCTSEARCHRESULT = "couponProductSearchResult" // 优惠券可用商品结果：couponProductSearchResult（新增）
    case PRODUCT = "product" // 商品详情
    case SHOPLIST = "shopList" // 店铺馆
    case ALL_SHOP_LIST = "allShopList" // 全部店铺列表
    case SHOP_PAVILION_AREA = "shopArea" //店铺馆首页
    case SHOP_PAVILION_COLLECTION = "shopCollection" //店铺馆关注店铺
    case SHOP_PAVILION_BUSINESS_PROMOTIOM = "businessPromotion" //店铺馆-上海热销
    case SHOPCOUPON = "coupon"
    case SHOPHOME = "shopHome" // 店铺主页
    case JBPSHOP = "JBPshop" // 店铺专区
    case COUPONPRODUCT = "couponProduct" // 优惠券商品列表
    case ENTERPRISEINFOPAGE = "enterpriseInfo" // 企业信息
    case LOGIN = "login" // 登录
    case FINDPASSWORD = "findPassword" // 找回密码
    case FINDPASSWORDCAPTCHA = "findPasswordCaptcha" // 找回密码获取验证码
    case RESERPASSWORD = "resetPassword" // 重置(找回)密码
    case CHANGEPASSWORD = "changePassword" // 修改密码
    case REGISTER = "register" // 注册
    case ORDERMANAGE = "orderManage" // 订单列表
    case ORDERSEARCHRESULT = "orderSearchResult" // 订单搜索结果页
    case ORDERDETAILS = "orderDetail" // 订单详情
    case CHECKLOT = "checkLot" // 查看批次
    case LOGISTICSDETAIL = "logisticsDetail" // 自有物流/第三方物流
    case COMPLAINSHOP = "complainShop" // 投诉商家
    case CONFIRMRECEPTION = "confirmReception" // 确认收货列表
    case APPLYREFUSEORREPLENISH = "applyRefuseOrReplenish" // 拒收补货页面(MP部分收货的页面)
    case CHECKORDER = "checkOrder" // 检查订单
    case CHOOSEONLINEPAY = "chooseOnlinePay" // 选择(在线)支付方式
    case REGISTERSUCC = "registerSucc" // 注册成功
    case LOCATIONCHOOSE = "locateChoose" // 分站选择
    case POSTSALE = "postSale" // 退换货/售后
    case MYFAVORITE = "myFavorite" // 我的收藏
    case ORDERREJECTDETAIL = "orderExceptiongetDetails-1" // 订单拒收/补货详情
    case CERTLIST = "certList" // 企业资质
    case RECVADDRLIST = "recvAddrList" // 收货地址列表(个人中心)
    case PAYSUCC = "paySucc" // 支付成功
    case UNIONPAY = "unionPay" // 银联支付
    case SALESCONSULT = "SalesConsult" // 销售顾问
    case TOPSEARCHAPP = "topsearchapp" // 区域热搜+本周热销
    case SUGGESTPILL = "suggestPill" // 推荐药品
    case SEARCH = "search" // 搜索页
    case ORDERSEARCH = "orderSearch" // 订单搜索页
    case TOGETER_SEARCH = "1GroupBuySearch" // 一起购搜索页
    case SHOPSEARCH = "shopSearch" // 全站店铺搜索：shopSearch（新增）
    case SHOPPRODUCTSEARCH = "shopProductSearch" // 店铺内搜索：shopProductSearch（新增）
    case JBPPRODUCTSEARCH = "JBPProductSearch" // JBP专区搜索：JBPProductSearch（新增）
    case COUPONPRODUCTSEARCH = "couponProductSearch" // 优惠券可用商品搜索：couponProductSearch（新增）
    case SINGLEPACKAGERODUCTSEARCH = "1PackageFreeShippingSearch" // 单品包邮商品搜索：1PackageFreeShippingSearch（新增）
    case myResource = "myResource" // 资料管理
    case MYINFORMATION = "myInformation" // 基本资料管理
    case CHOOSESCOPE = "chooseScope" // 选择经营范围
    case EDITENTERPRISENAME = "editEnterpriseName" // 企业名称
    case EDITENTBANKINFO = "editBankInfo" // 编辑企业银行信息（批零一体独有）
    case UPLOADLICENCE = "uploadLicence" //上传资质
    case myResUpCheck = "myResUpCheck" // 查看大图
    case yyResRcv = "yyResRcv" // 编辑收发货地址
    case EDITENTERPRISEINFO = "editEnterpriseInfo" // 添加企业基本信息
    case EDITENTERPRISETYPE = "chooseEnterpriseType" // 企业类型
    case UPLOADLICENSESUCCESS = "uploadLicenseSuccess" // 提交审核成功
    case myInvoice = "myInvoice" // 发票管理
    case EDITGENERALINVOICE = "editGeneralInvoice" // 发票-维护增值税普通发票
    case EDITSPECIALINVOICE = "editSpecialInvoice" // 发票-维护增值税专用发票
    case MYPURCHASESHOP = "myPurchaseShop" // 常购商家
    //case myContact = "myContact" // 联系客服
    case mySetting = "mySetting" // 设置
    case MYREBATE = "myRebate" // 我的余额
    case ACTIVITYLANDING = "activityLanding" // 药福利
    
    case MYCUMULATIVEREBATE = "myCumulativeRebate" // 我的余额(累计余额)
    case MYEXPECTANTREBATE = "myExpectantRebate" // 我的余额(待到账余额)
    
    case mySettWe = "mySettWe" // 关于我们
    case MYBD = "myBD" // 负责业务员
    case myRemain = "myRemain" // 我的资产
    case myRemDetail = "myRemDetail" // 返利金明细
    case myCoupon = "myCoupon" // 我的优惠券
    case checkOrdPron = "checkOrdPron" // 销售单示例
    case checkOrdChooseCoupon = "checkOrderChooseCoupon" // 检查订单-选择优惠券
    case checkOrdChooseFirstDada = "firstDada" // 检查订单-选择首营资质
    case checkOrdCoupon = "checkOrdCoupon" // 检查订单-优惠券码
    case checkOrderChooseInvoice = "checkOrderChooseInvoice" // 检查订单-选择发票类型
    case checkOrdOthpay = "findPeoplePay" // 检查订单-找人代付-提交订单
    case OFFLINEPAYSUCCESS = "offlinePaySuccess" // 线下支付详情
    case groupBuyShoppingCar = "1GroupBuyShoppingCart" // 一起购购物车
    case togeterBuyList = "1GroupBuy" //一起购列表页面
    case togeterBuySearchList = "1GroupBuyProductSearch" //一起购搜索结果页面
    case togeterBuyDetail = "1GroupBuyProduct" //一起购商品详情页
    case allPrefectureList = "promotion" //满减，特价专区
    case shopPrefectureList = "shopPromotion" //店铺内满减，特价专区（已废弃）
    case shopSpecialOfferActivity = "shopSpecialOffer" //特价列表
    case shopReductionActivity = "shopReduction" //满减列表
    case shopGiftActivity = "shopGift" //满赠列表
    case shopRebateActivity = "shopRebate" //返利列表
    case shopDiscountActivity = "shopDiscount" //满折列表
    case shopPackageList = "shopPackage" //店铺内专区套餐列表
    case secondKillActivity = "secKill" //秒杀详情
    case matchingPackage = "freePackage" //搭配套餐聚合页
    case redPacketResultActivity = "redPacket" //秒杀详情
    case GLWebVcActivity = "webview" //h5容器的pagecode
    case GLWebMapsVcActivity = "maps" //h5容器中的maps页面
    case GLWebVipSectionVcActivity = "vipSection" //h5容器中的vip
    case GLWebRebateVcActivity = "rebate" //h5容器中的返利
    
    case messageListActivity = "message" //消息中心
    case expiredTipsActivity = "messageLicense" //消息中心
    case depreciateNoticeActivity = "depreciateNotice" //降价通知
    case logisticsMSG = "transaction" //物流信息
    case promotionMSG = "sales" //活动特惠
    case serviceNoticeActivity = "serviceNotice" //服务通知
    case shareIdActivity = "salesLead"//口令分享
    
    case APPLYPOSTSALELIST = "applyPostSaleList" // 申请售后服务列表
    case PSFOLLOWINGreCEIPT = "psFollowingReceipt" // 售后服务-选择随行单据服务
    case PSPRODUCTMISTAKE = "psProductMistake" // 售后服务-选择商品错漏发服务
    case PSDRUGINSPECTION = "psDrugInspection" // 售后服务-选择药检报告服务
    case PSPRODUCTFIRSTQUALIFICATION = "psProductFirstQualification" //  售后服务-选择商品首营资质服务
    case PSENTERPRISEFIRSTQUALIFICATION = "psEnterpriseFirstQualification" // 售后服务-选择企业首营服务
    case RETURNANDCHANGE = "returnAndChange" // 售后服务-选择退换货类型
    case EDITRETURNREASON = "editReturnReason" // 退换货-填写退货申请原因
    case EDITCHANGEREASON = "editChangeReason" // 退换货-填写换货申请原因
    case EDITRETURNBANKINFORMATION = "editReturnBankInformation" // 退货-填写退款信息
    case NPREGISTERHISTORY = "NPRegisterHistory" // 登记历史记录列表
    case NPREGISTERDETAIL = "NPRegisterDetail" // 登记历史详情
    case HOTSALEREGION = "hotList" //城市热销列表
    case LABELPRODUCT = "labelProduct" //高毛专区 专区
    case SAMESPULIST = "sameSPUList" //同品多商家
    case CHEAPLIST = "cheaplist" //降价专区push落地页
    case MPPROMOTION = "MPPromotion" //商家特惠
    /// 支付完成页/抽奖
    case PAY_SUCCESS = "paySuccess"
    case SHOPPINGMONEY = "shoppinggold" // 购物金
    case PACKAGE_LIST_RATE = "1PackageFreeShipping" //包邮价
    case PACKAGE_SEARCH_LIST_RATE = "1PackageFreeShippingProductSearch" //包邮价所以结果页
    case PACKAGE_RATE = "packageRate" //包邮价
    case MISS_GOODS = "missGoods" //到货通知
    
    /// 直播
    case LIVE = "live" //直播列表
    case LIVE_ROOM = "liveRoom" // 直播间
    case LIVE_REPLAY = "liveReplay" //直播回放
    case LIVE_NOTICE = "liveNotice" //直播预告页
    case LIVE_HOME = "liveHome" //直播间主页
    case LIVE_END = "liveOver" //直播结束
}

// 楼层
enum FLOORCODE: String {
    case UNDEFINED = "0" // 未定义
    case HOME_YC_PAGEHEADER = "homeycpageheader" // 首页-页头
    case HOME_YC_CLASSIFY = "homeycclassify" // 首页-热销类目
    case HOME_YC_SHUFFL = "homeycshuffl" // 首页-轮播图
    case HOME_YC_GOODS = "homeycgoods" // 首页-首推特价（药城精选）
    case HOME_YC_TOPSELLSEARCH = "homeyctopsellsearch" // 首页-排行榜（本周热销、区域热搜榜）
    case HOME_YC_CATEGORY = "homeyccategory" // 首页-类目热销（商品分类列表）
    case HOME_YC_NEWPRIVILEGE = "homeycnewexclusive" // 首页-新人专享
    case HOME_YC_ADAVTIVITY = "homeycactivities" // 首页-大型活动
    case HOME_YC_YIQI = "homeyc1series" // 首页一起系列
    case HOME_YC_HEXIE = "homeyctopsearch" // 首页 - 区域热搜（消费者最爱）
    case HOME_YC_SUPPLY_SELECT = "homeycsuppliers" // 首页 - 供应商甄选
    case HOME_YC_RECENT_PURCHASE = "homeycregularlylist" // 首页 - 最近采购
    case PRODUCTRESULT_YC_JOINCART = "productresult_yc" //加入购物车(兼容旧的埋点,不是新规则)
}
//楼层名称（新的埋点）
//enum FLOORNAME : String {
//    case AD_PIC_FLOOR_NAME = "开屏广告"
//    case AD_TIP_FLOOR_NAME = "跳过按钮"
//    case HOME_SPEC_PRD_FLOOR_NAME = "特价抢购样式楼层"
//    case HOME_AD_L_FLOOR_NAME = "单张广告样式楼层"
//    case HOME_YIG_FLOOR_NAME = "1起购样式楼层"
//}

//enum ITEMNAME : String {
//    case AD_PIC_ITEM_NAME = "开屏广告图"
//    case AD_TIP_ITEM_NAME = "跳过按钮"
//    case HOME_SEARCH_NAME = "首页搜索框"
//    case HOME_BANNER_NAME = "轮播图"
//    case HOME_NOTICE_NAME = "药城公告"
//    case HOME_NAVIGATION_NAME = "导航按钮"
//    case HOME_MORE_NAME = "更多"
//    case HOME_SPEC_PRD_NAME = "商品"
//    case HOME_AD_L_NAME = "单张广告图"
//
//}
//
//enum SECTIONNAME : String {
//    case HOME_CHANGE_SECTION_NAME = "可配楼层"
//}
enum FLOORID: String {
    case HOME_COMMON_PRODUCT_FLOOR = "F1001"
    case HOME_PROMATION_PRODUCT_FLOOR = "F1002"
    case HOME_RECOMMEND_PRODUCT_FLOOR = "F1011"
    case SHOP_DETAIL_RECOMMEND_PRODUCT_FLOOR = "F6441"
}
// 栏位
enum SECTIONCODE: String {
    case UNDEFINED = "0" // 未定义
    case TOP_SEARCH_APP_Category = "category" // 类目热销 & 区域热搜和本周热销(非首页)
    case TOP_YIQI_SHAN = "homeyc1series1qishan" // 一起闪
    case TOP_YIQI_GOU = "homeyc1series1qigou"   // 一起购
    case TOP_YIQI_PIN = "homeyc1series1qipin"   // 一起拼
    
    //(新的埋点）sectionId
    case HOME_CHANGE_SECTION_CODE = "S1000"
    case SHOPLIST_CHANGE_SECTION_CODE = "S4000"
    case HOME_SUGGESTPILL_SECTION_CODE = "S7000"
    case SHOPLIST_COUPON_SECTION_CODE = "S7300"
    
    
    // 检查订单相关
    case CHECKORDER_ACTION_LIST = "S9103"
    
    //新首页
    case HOME_ACTION_OFTEN_BUY = "S1001"  //常买
    case HOME_ACTION_OFTEN_LOOK = "S1002"  //常看
    case HOME_ACTION_OFTEN_HOTSALES = "S1003" //热销
    case HOME_RECOMMEND_SECTION_CODE = "S1011" // 首页推荐
    
    case TOGETER_BUY_SECTION_CODE = "S7202" //一起购列表
    case SHOP_DETAIL_PROMOTION_SECTION_CODE = "S6405" //店铺详情促销楼层
    case SHOP_DETAIL_COUPON_LIST_CODE = "S6440" //店铺详情优惠券
    case SHOP_DETAIL_AD_LIST_CODE = "S6441" //店铺详情中通广告
    case SHOP_DETAIL_SINGLE_PRD_LIST_CODE = "S6442" //店铺详情秒杀单品
    case SHOP_DETAIL_MANEY_PRD_LIST_CODE = "S6443" //店铺详情秒杀多品
    case SHOP_DETAIL_PRD_LIST_CODE = "S6444" //店铺详情普通商品楼层
    case SHOP_DETAIL_RECOMMEND_PRD_LIST_CODE = "S6445" //店铺详情推荐商品
}

// 坑位
enum ITEMCODE: String {
    case UNDEFINED = "0" // 未定义
    case HOME_YC_PAGEHEADER_Advertising = "advertising" // 首页-页头-站点
    case HOME_YC_PAGEHEADER_Search = "search" // 首页-页头-搜索框
    case HOME_YC_PAGEHEADER_Notice = "notice" // 首页-页头-消息盒子
    case HOME_YC_CLASSIFY_Classify = "classify" // 首页-热销类目-品类分类跳转
    case HOME_YC_CLASSIFY_Classifymore = "classifymore" // 首页-热销类目-更多
    case HOME_YC_SHUFFL_Detail = "shuffl" // 首页-轮播图（跳转）
    case HOME_YC_GOODS_Detail = "goods" // 首页-首推特价（药城精选）（跳转商详）
    case HOME_YC_TOPSELLSEARCH_Sell = "homeyctopsell" // 首页-排行榜之本周热销
    case HOME_YC_TOPSELLSEARCH_Search = "homeyctopsearch2" // 首页-排行榜之区域热搜
    case HOME_YC_CATEGORUY_More = "categoryfieldmore" // 首页-类目热销之查看更多
    case HOME_YC_CATEGORY_Detail = "categoryfield" // 首页-类目热销之类目商品（跳转商详）
    case HOME_YC_CLASSIFY_NewPrivilege = "newexclusive" // 首页-新人专享
    case HOME_YC_AD_Activity = "activities" // 首页-大型活动
    case HOME_YC_AD_Hexie = "topsearchmore" // 首页-区域热搜（消费者最爱）
    case HOME_YC_AD_MasterShop = "suppliersstore" // 首页-供应商甄选 - 店铺主页
    case HOME_YC_AD_MoreShop = "suppliersmore" // 首页-供应商甄选 - 查看更多店铺
    case HOME_YC_AD_RecentPurchase = "regularlylist" // 首页-最近采购
    
    case TOP_SEARCH_APP_Topsearchfield = "topsearchfield" // 区域热搜排行榜列表页
    case TOP_SEARCH_APP_Topsellfield = "topsellfield" // 本周热销排行榜列表页
    
    //(新的埋点）itemId
    case AD_PIC_ITEM_CODE = "I0000"
    case AD_TIP_ITEM_CODE = "I0001"
    case HOME_SEARCH_CLICK_CODE = "I1000"
    case HOME_SCAN_CLICK_CODE = "I1030"
    case HOME_HOT_SEARCH_WORD_CODE = "I1032"
    case HOME_MESSAGE_CLICK_CODE = "I1010"
    case HOME_BANNER_CLICK_CODE = "I1001"
    case HOME_NOTICE_CLICK_CODE = "I1002"
    case HOME_NAVIGATION_CLICK_CODE = "I1003"
    case HOME_SPEC_PRD_CLICK_CODE = "I1004"
    case HOME_AD_L_CLICK_CODE = "I1005"
    case HOME_YIG_CLICK_CODE = "I1006"
    case SHOPLIST_SEGMENT_CLICK_CODE = "I4001"
    case SHOPLIST_BANNER_CLICK_CODE = "I4002"
    case SHOPLIST_FUNCTBN_CLICK_CODE = "I4003"
    case SHOPLIST_SECONDKILL_CLICK_CODE = "I4004"
    case SHOPLIST_HIGHQUALITYSHOPS_CLICK_CODE = "I4005"
    case SHOPLIST_MAJORACTIVITY_CLICK_CODE = "I4006"
    case SHOPLIST_ACTIVITYZONE_CLICK_CODE = "I4007"
    case SHOPLIST_RECOMMENT_CLICK_CODE = "I4008"
    case HOME_SUGGESTPILL_HOT_CLICK_CODE = "I7000"
    case HOME_SUGGESTPILL_OFTENLOOK_CLICK_CODE = "I7001"
    case HOME_SUGGESTPILL_OFTENBUY_CLICK_CODE = "I7002"
    case SHOPLIST_COUPON_CLICK_CODE = "I7300"
    case SEARCH_BAR_CLICK_CODE = "I8000"
    case SEARCH_VOICE_CLICK_CODE = "I8001"
    case SEARCHRESULT_BAR_CLICK_CODE = "I9000"
    case SEARCHRESULT_FILTRATE_CLICK_CODE = "I9001"
    case SEARCHRESULT_FILTRATE_FACTORY_CODE = "I9003" //筛选点击生产厂家
    case SEARCHRESULT_FILTRATE_SPECS_CODE = "I9004" //筛选点击规格
    case SEARCHRESULT_FILTRATE_FUCTION_CODE = "I9005"//筛选厂家点击重置，确定，关闭
    case SEARCHRESULT_NO_RESULT_CODE = "I9006"//搜索无结果推荐词
    
    
    /* 检查订单相关埋点<begin> */
    // 查看销售单示例
    //    case CHECKORDER_SHOW_SALE_ADDRESS = "I9101"
    //    // 选择支付方式相关...[选择支付方式、关闭弹窗、确定]
    //    case CHECKORDER_PAY_TYPE_SELECT = "I9102"
    // [展开全部商品、留言]
    case CHECKORDER_ORDER_PRODUCT_ALL = "I9103"
    // 优惠券相关...[勾选、提示、击开]
    case CHECKORDER_OREDR_PRODUCT_COUPON = "I9104"
    // 优惠码相关...[激活输入框、关闭弹窗、确定]
    case CHECKORDER_ORDER_COUPON_CODE = "I9105"
    // 输入返利金
    case CHECKORDER_ORDER_REBATE_INPUT = "I9106"
    //共享返利金
    case CHECKORDER_SHARE_ORDER_REBATE_INPUT = "I9112"
    //共享平台券
    case CHECKORDER_SHARE_ORDER_PLARFORM_COUPON_INPUT = "I9113"
    //销售合同是否随货
    case CHECKORDER_SALE_INFO = "I9114"
    //更新过期证照
    case CHECKORDER_UPDATE_CERTIFICATION_INFO = "I9111"
    // 发票信息
    case CHECKORDER_ORDER_INVOICE = "I9107"
    // 运费提示
    case CHECKORDER_FRIGHT_TIP = "I9108"
    // 提交订单
    case CHECKORDER_SUBMIT_ORDER = "I9109"
    //选择 支付方式
    case CHECKORDER_SELECT_PAY_TYPE = "I9110"
    /* 检查订单相关埋点<end> */
    
    //新首页
    case HOME_ACTION_COMMON_ITEMDETAIL = "I1011"  //普品查看商详
    case HOME_ACTION_COMMON_ADDCAR = "I9999"  //活动普品加车
    case HOME_ACTION_COMMON_CLICK_PRDDETAIL = "I9998"  //普品查看商详
    
    case HOME_ACTION_PROMATION_MORE = "I1012"  //点击更多
    case HOME_ACTION_PROMATION_ITEMDETAIL = "I1013"  //活动查看商详
    
    case HOME_ACTION_AD_CONTENT = "I1021"  //中通广告
    case HOME_ACTION_SINGLE_ITEMDETAIL = "I1022"  //单品秒杀 查看商详 更多 1
    case HOME_ACTION_SEGMENT_SWITCH = "I1020"  //上部的segment 切换
    case HOME_ACTION_PROTIOM_MORE_ADD = "I1023"  //秒杀-多品/一起系列
    case HOME_ACTION_BRAND_MORE_ADD = "I1024"  //推荐品牌
    case HOME_ACTION_PRODUCTION_MORE_ADD = "I1025"  //药城精选(3*2)
    case HOME_ACTION_SUPRISE_EIXT = "I1031"  //逛一逛入口
    case HOME_ACTION_SUPRISE_CLOSE = "I10207"  //引导图关闭
    case HOME_ACTION_SUPRISE_APPLY = "I10208"  //引导图入口
    
    
    //新埋点
    case TOGETER_BUY_HEADER_ITEM_CODE = "I7110" //一起购头部<返回，搜索，购物车>
    case TOGETER_BUY_TAB_ITEM_CODE = "I7111" //一起购tab
    case TOGETER_BUY_DETAIL_ITEM_CODE = "I7112" //一起购点击cell
    case TOGETER_BUY_SEARCH_LIST_ITEM_CODE = "I7130" //一起购搜索结果头部<返回，搜索，购物车>
    case TOGETER_BUY_SEARCH_DETAIL_ITEM_CODE = "I7131" //一起购搜索结果点击cell
    
    //秒杀专区
    case SECKILL_ACTIVITY_HEAD_CODE = "I7210" //返回购物车
    case SECKILL_ACTIVITY_TAB_CODE = "I7211" //切换tab
    case SECKILL_ACTIVITY_PRODUCT_DETAIL_CODE = "I7212"//进商详
    
    case TOGETER_BUY_HEADER_DETAIL_ITEM_CODE = "I7140" //一起购详情头部<返回，购物车>
    case TOGETER_BUY_PIC_DETAIL_ITEM_CODE = "I7141" //一起购详情查看大图
    case TOGETER_BUY_SHOP_DETAIL_ITEM_CODE = "I7142" //一起购详情进入店铺
    
    //新店铺详情
    case SHOP_DETAIL_BACK_CART_CODE = "I6401" // 返回or购物车
    case SHOP_DETAIL_ENTER_COLLECT_INFO_CODE = "I6402" // 企业资质or收藏按钮
    case SHOP_DETAIL_COUPONS_CATCH_CODE = "I6440" // 显示全部优惠券/查看可用商家/立即领取/查看可用商品
    case SHOP_DETAIL_SHOP_BANNER_LIST_CODE = "I6441" // 店铺内轮播图
    case SHOP_DETAIL_SHOP_NAVAGATION_LIST_CODE = "I6442" // 店铺导航icon
    case SHOP_DETAIL_SHOP_AD_LIST_CODE = "I6443" //
    case SHOP_DETAIL_SHOP_SIGLE_PRD_MORE_CODE = "I6444" //
    case SHOP_DETAIL_SHOP_MANY_PRD_MORE_CODE = "I6445" //
    case SHOP_DETAIL_SHOP_PRD_MORE_CODE = "I6446" //
    case SHOP_DETAIL_PROMOTION_CATERY_CODE = "I6404" // 促销分类
    case SHOP_DETAIL_PROMOTION_MORE_DETAIL_CODE = "I6405" // 促销商品详情和更多按钮
    case SHOP_DETAIL_CONTACT_CUSTOMER_CODE = "I6410" // 联系客服
    case SHOP_JBP_BANNER_PIC_CLICK_CODE = "I6412" // JBP专区内轮播图
    case SHOP_DETAIL_ETERPRISE_INFOMATION_CODE = "I6411" // 企业信息-查看大图
    case SHOP_DETAIL_TAB_CODE = "I6420" // 底部导航栏
    
    //登记新品
    case NEW_PRODUCT_REGISTER_LIST_BACK_CODE = "I9510"//新品登记列表返回
    case NEW_PRODUCT_REGISTER_LIST_CLICK_CODE = "I9511" //新品登记列表点击cell
    case NEW_PRODUCT_REGISTER_DETAIL_BACK_CODE = "I9520"//新品登记详情返回
    case NEW_PRODUCT_REGISTER_DETAIL_LOOK_PIC_CODE = "I9521" //查看图片
}

enum ACTIONITEM: String {
    case HOME_YC_SHUFFL = "home_yc_shuffl"
    case HOME_YC_CLASSIFY = "home_yc_classify"
    case HOME_YC_USERCENTER = "home_yc_usercenter"
    case HOME_YC_SHOPCART = "home_yc_shopcart"
    case HOME_YC_AREA = "home_yc_area"
    case HOME_YC_CATEGORY = "home_yc_category"
    case HOME_YC_BRAND = "home_yc_brand"
    case HOME_YC_STORE_ID = "home_yc_store_id"
    case HOME_YC_PRODUCT_ID = "home_yc_product_id"
    case CLASSIFY_YC_MEDICINE = "classify_yc_medicine"
    case CLASSIFY_YC_INSTRUMENT = "classify_yc_instrument"
    case CLASSIFY_YC_MATERIALS = "classify_yc_materials"
    case CLASSIFY_YC_NUTRITION = "classify_yc_nutrition"
    case CLASSIFY_YC_NURSING = "classify_yc_nursing"
    case CLASSIFY_YC_DEPARTMENT = "classify_yc_department"
    case PRODUCTSEARCH_YC_SEARCH = "productsearch_yc_search"
    case PRODUCTSEARCH_YC_CANCEL = "productsearch_yc_cancel"
    case STORESEARCH_YC_SEARCH = "storesearch_yc_search"
    case STORESEARCH_YC_CANCEL = "storesearch_yc_cancel"
    case PRODUCTRESULT_YC_PRICE = "productresult_yc_price"
    case PRODUCTRESULT_YC_CLICKCART = "productresult_yc_clickcart"
    case PRODUCTRESULT_YC_JOINCHANNEL = "productresult_yc_joinchannel"
    case PRODUCTRESULT_YC_JOINCART = "productresult_yc_joincart"
    case PRODUCTRESULT_YC_RETURN = "productresult_yc_return"
    case STORERESULT_YC_STORETYPE = "storeresult_yc_storetype"
    case STORERESULT_YC_JOINCART = "storeresult_yc_joincart"
    case PRODUCT_YC_SHARE_MOMENTS = "product_yc_share_moments"
    case PRODUCT_YC_SHARE_WECHAT = "product_yc_share_wechat"
    case PRODUCT_YC_QQ = "product_yc_qq"
    case PRODUCT_YC_QZONE = "product_yc_qzone"
    case PRODUCT_YC_WEIBO = "product_yc_weibo"
    case PRODUCT_YC_JOINCART = "product_yc_joincart"
    case PRODUCT_YC_ENTERSTORE = "product_yc_enterstore"
    case PRODUCT_YC_CLICKINSTRUCTIONS = "product_yc_clickinstructions"
    case PRODUCT_YC_CLICKCART = "product_yc_clickcart"
    case PRODUCT_YC_RETURN = "product_yc_return"
    case STORPAVILION_YC_JOINCART = "storpavilion_yc_joincart"
    case STORPAVILION_YC_RETURN = "storpavilion_yc_return"
    case MAINSTORE_YC_SHARE_MOMENTS = "mainstore_yc_share_moments"
    case MAINSTORE_YC_SHARE_WECHAT = "mainstore_yc_share_wechat"
    case MAINSTORE_YC_SHARE_QQ = "mainstore_yc_share_qq"
    case MAINSTORE_YC_SHARE_QZONE = "mainstore_yc_share_qzone"
    case MAINSTORE_YC_SHARE_WEIBO = "mainstore_yc_share_weibo"
    case MAINSTORE_YC_RETURN = "mainstore_yc_return"
    case MAINSTORE_YC_CLICKCART = "mainstore_yc_clickcart"
    case SHOPCART_YC_SETTLE = "shopcart_yc_settle"
    case USERCENTER_YC_ORDERVIEW_ALLORDER = "usercenter_yc_orderview_allorder"
    case USERCENTER_YC_ORDERVIEW_PAYWAIT = "usercenter_yc_orderview_paywait"
    case USERCENTER_YC_ORDERVIEW_DELIVERYWAIT = "usercenter_yc_orderview_deliverywait"
    case USERCENTER_YC_ORDERVIEW_GETWAIT = "usercenter_yc_orderview_getwait"
    case USERCENTER_YC_ORDERVIEW_ABNORMAL = "usercenter_yc_orderview_abnormal"
    case USERCENTER_YC_CALLSERVICE = "usercenter_yc_callservice"
    case USERCENTER_YC_SET = "usercenter_yc_set"
    case USERCENTER_YC_LOGIN_REGISTER = "usercenter_yc_login_register"
    case SETTLEMENT_YC_SUBMIT = "settlement_yc_submit"
    case SETTLEMENT_YC_RETURN = "settlement_yc_return"
    case SETTLEMENT_YC_PAYTYPE = "settlement_yc_paytype"
    case PAY_YC_SUBMIT = "pay_yc_submit"
    case PAY_YC_RETURN = "pay_yc_return"
    case ORDERLIST_YC_WAITPAY_CANCEL = "orderlist_yc_waitpay_cancel"
    case ORDERLIST_YC_WAITPAY_PAY = "orderlist_yc_waitpay_pay"
}

// 生成打点信息
extension ACTIONITEM {
    func dictValue() ->[String: AnyObject] {
        switch self {
        case .HOME_YC_SHUFFL:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_shuffl" as AnyObject ,
                    "sectionId": "home_yc_shuffl" as AnyObject ,
                    "itemId": "home_yc_shuffl" as AnyObject ,
            ]
        case .HOME_YC_CLASSIFY:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_classify" as AnyObject ,
                    "sectionId": "home_yc_classify" as AnyObject ,
                    "itemId": "home_yc_classify" as AnyObject ,
            ]
        case .HOME_YC_USERCENTER:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_usercenter" as AnyObject ,
                    "sectionId": "home_yc_usercenter" as AnyObject ,
                    "itemId": "home_yc_usercenter" as AnyObject ,
            ]
        case .HOME_YC_SHOPCART:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_shopcart" as AnyObject ,
                    "sectionId": "home_yc_shopcart" as AnyObject ,
                    "itemId": "home_yc_shopcart" as AnyObject ,
            ]
        case .HOME_YC_AREA:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_area" as AnyObject ,
                    "sectionId": "home_yc_area" as AnyObject ,
                    "itemId": "home_yc_area" as AnyObject ,
            ]
        case .HOME_YC_CATEGORY:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_category" as AnyObject ,
                    "sectionId": "home_yc_category" as AnyObject ,
                    "itemId": "home_yc_category" as AnyObject ,
            ]
        case .HOME_YC_BRAND:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_brand" as AnyObject ,
                    "sectionId": "home_yc_brand" as AnyObject ,
                    "itemId": "home_yc_brand" as AnyObject ,
            ]
        case .HOME_YC_STORE_ID:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_store" as AnyObject ,
                    "sectionId": "home_yc_store" as AnyObject ,
                    "itemId": "home_yc_store_id" as AnyObject ,
            ]
        case .HOME_YC_PRODUCT_ID:
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_product" as AnyObject ,
                    "sectionId": "home_yc_product" as AnyObject ,
                    "itemId": "home_yc_product_id" as AnyObject ,
            ]
        case .CLASSIFY_YC_MEDICINE:
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_medicine" as AnyObject ,
                    "sectionId": "classify_yc_medicine" as AnyObject ,
                    "itemId": "classify_yc_medicine" as AnyObject ,
            ]
        case .CLASSIFY_YC_INSTRUMENT:
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_instrument" as AnyObject ,
                    "sectionId": "classify_yc_instrument" as AnyObject ,
                    "itemId": "classify_yc_instrument" as AnyObject ,
            ]
        case .CLASSIFY_YC_MATERIALS:
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_materials" as AnyObject ,
                    "sectionId": "classify_yc_materials" as AnyObject ,
                    "itemId": "classify_yc_materials" as AnyObject ,
            ]
        case .CLASSIFY_YC_NUTRITION:
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_nutrition" as AnyObject ,
                    "sectionId": "classify_yc_nutrition" as AnyObject ,
                    "itemId": "classify_yc_nutrition" as AnyObject ,
            ]
        case .CLASSIFY_YC_NURSING:
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_nursing" as AnyObject ,
                    "sectionId": "classify_yc_nursing" as AnyObject ,
                    "itemId": "classify_yc_nursing" as AnyObject ,
            ]
        case .CLASSIFY_YC_DEPARTMENT:
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_department" as AnyObject ,
                    "sectionId": "classify_yc_department" as AnyObject ,
                    "itemId": "classify_yc_department" as AnyObject ,
            ]
        case .PRODUCTSEARCH_YC_SEARCH:
            return ["page_type": "productsearch_yc" as AnyObject ,
                    "floorId": "productsearch_yc" as AnyObject ,
                    "sectionId": "productsearch_yc" as AnyObject ,
                    "itemId": "productsearch_yc_search" as AnyObject ,
            ]
        case .PRODUCTSEARCH_YC_CANCEL:
            return ["page_type": "productsearch_yc" as AnyObject ,
                    "floorId": "productsearch_yc" as AnyObject ,
                    "sectionId": "productsearch_yc" as AnyObject ,
                    "itemId": "productsearch_yc_cancel" as AnyObject ,
            ]
        case .STORESEARCH_YC_SEARCH:
            return ["page_type": "storesearch_yc" as AnyObject ,
                    "floorId": "storesearch_yc" as AnyObject ,
                    "sectionId": "storesearch_yc" as AnyObject ,
                    "itemId": "storesearch_yc_search" as AnyObject ,
            ]
        case .STORESEARCH_YC_CANCEL:
            return ["page_type": "storesearch_yc" as AnyObject ,
                    "floorId": "storesearch_yc" as AnyObject ,
                    "sectionId": "storesearch_yc" as AnyObject ,
                    "itemId": "storesearch_yc_cancel" as AnyObject ,
            ]
        case .PRODUCTRESULT_YC_PRICE:
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_price" as AnyObject ,
            ]
        case .PRODUCTRESULT_YC_CLICKCART:
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_clickcart" as AnyObject ,
            ]
        case .PRODUCTRESULT_YC_JOINCHANNEL:
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_joinchannel" as AnyObject ,
            ]
        case .PRODUCTRESULT_YC_JOINCART:
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_joincart" as AnyObject ,
            ]
        case .PRODUCTRESULT_YC_RETURN:
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_return" as AnyObject ,
            ]
        case .STORERESULT_YC_STORETYPE:
            return ["page_type": "storeresult_yc" as AnyObject ,
                    "floorId": "storeresult_yc" as AnyObject ,
                    "sectionId": "storeresult_yc" as AnyObject ,
                    "itemId": "storeresult_yc_storetype" as AnyObject ,
            ]
        case .STORERESULT_YC_JOINCART:
            return ["page_type": "storeresult_yc" as AnyObject ,
                    "floorId": "storeresult_yc" as AnyObject ,
                    "sectionId": "storeresult_yc" as AnyObject ,
                    "itemId": "storeresult_yc_joincart" as AnyObject ,
            ]
        case .PRODUCT_YC_SHARE_MOMENTS:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_share_moments" as AnyObject ,
            ]
        case .PRODUCT_YC_SHARE_WECHAT:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_share_wechat" as AnyObject ,
            ]
        case .PRODUCT_YC_QQ:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_qq" as AnyObject ,
            ]
        case .PRODUCT_YC_QZONE:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_qzone" as AnyObject ,
            ]
        case .PRODUCT_YC_WEIBO:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_weibo" as AnyObject ,
            ]
        case .PRODUCT_YC_JOINCART:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_joincart" as AnyObject ,
            ]
        case .PRODUCT_YC_ENTERSTORE:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_enterstore" as AnyObject ,
            ]
        case .PRODUCT_YC_CLICKINSTRUCTIONS:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_clickinstructions" as AnyObject ,
            ]
        case .PRODUCT_YC_CLICKCART:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_clickcart" as AnyObject ,
            ]
        case .PRODUCT_YC_RETURN:
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_return" as AnyObject ,
            ]
        case .STORPAVILION_YC_JOINCART:
            return ["page_type": "storpavilion_yc" as AnyObject ,
                    "floorId": "storpavilion_yc" as AnyObject ,
                    "sectionId": "storpavilion_yc" as AnyObject ,
                    "itemId": "storpavilion_yc_joincart" as AnyObject ,
            ]
        case .STORPAVILION_YC_RETURN:
            return ["page_type": "storpavilion_yc" as AnyObject ,
                    "floorId": "storpavilion_yc" as AnyObject ,
                    "sectionId": "storpavilion_yc" as AnyObject ,
                    "itemId": "storpavilion_yc_return" as AnyObject ,
            ]
        case .MAINSTORE_YC_SHARE_MOMENTS:
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_moments" as AnyObject ,
            ]
        case .MAINSTORE_YC_SHARE_WECHAT:
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_wechat" as AnyObject ,
            ]
        case .MAINSTORE_YC_SHARE_QQ:
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_qq" as AnyObject ,
            ]
        case .MAINSTORE_YC_SHARE_QZONE:
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_qzone" as AnyObject ,
            ]
        case .MAINSTORE_YC_SHARE_WEIBO: 
            return ["page_type": "mainstore_yc" as AnyObject , 
                    "floorId": "mainstore_yc_share" as AnyObject , 
                    "sectionId": "mainstore_yc_share" as AnyObject , 
                    "itemId": "mainstore_yc_share_weibo" as AnyObject , 
            ]
        case .MAINSTORE_YC_RETURN: 
            return ["page_type": "mainstore_yc" as AnyObject , 
                    "floorId": "mainstore_yc" as AnyObject , 
                    "sectionId": "mainstore_yc" as AnyObject , 
                    "itemId": "mainstore_yc_return" as AnyObject , 
            ]
        case .MAINSTORE_YC_CLICKCART: 
            return ["page_type": "mainstore_yc" as AnyObject , 
                    "floorId": "mainstore_yc" as AnyObject , 
                    "sectionId": "mainstore_yc" as AnyObject , 
                    "itemId": "mainstore_yc_clickcart" as AnyObject , 
            ]
        case .SHOPCART_YC_SETTLE: 
            return ["page_type": "shopcart_yc" as AnyObject , 
                    "floorId": "shopcart_yc" as AnyObject , 
                    "sectionId": "shopcart_yc" as AnyObject , 
                    "itemId": "shopcart_yc_settle" as AnyObject , 
            ]
        case .USERCENTER_YC_ORDERVIEW_ALLORDER: 
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_allorder" as AnyObject , 
            ]
        case .USERCENTER_YC_ORDERVIEW_PAYWAIT: 
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_paywait" as AnyObject , 
            ]
        case .USERCENTER_YC_ORDERVIEW_DELIVERYWAIT:
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_deliverywait" as AnyObject ,
            ]
        case .USERCENTER_YC_ORDERVIEW_GETWAIT:
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_getwait" as AnyObject ,
            ]
        case .USERCENTER_YC_ORDERVIEW_ABNORMAL:
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_abnormal" as AnyObject ,
            ]
        case .USERCENTER_YC_CALLSERVICE:
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_callservice" as AnyObject ,
                    "sectionId": "usercenter_yc_callservice" as AnyObject ,
                    "itemId": "usercenter_yc_callservice" as AnyObject ,
            ]
        case .USERCENTER_YC_SET:
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_set" as AnyObject ,
                    "sectionId": "usercenter_yc_set" as AnyObject ,
                    "itemId": "usercenter_yc_set" as AnyObject ,
            ]
        case .USERCENTER_YC_LOGIN_REGISTER:
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_login&register" as AnyObject ,
                    "sectionId": "usercenter_yc_login&register" as AnyObject ,
                    "itemId": "usercenter_yc_login&register" as AnyObject ,
            ]
        case .SETTLEMENT_YC_SUBMIT: 
            return ["page_type": "settlement_yc" as AnyObject , 
                    "floorId": "settlement_yc" as AnyObject , 
                    "sectionId": "settlement_yc" as AnyObject , 
                    "itemId": "settlement_yc_submit" as AnyObject , 
            ]
        case .SETTLEMENT_YC_RETURN: 
            return ["page_type": "settlement_yc" as AnyObject , 
                    "floorId": "settlement_yc" as AnyObject , 
                    "sectionId": "settlement_yc" as AnyObject , 
                    "itemId": "settlement_yc_return" as AnyObject , 
            ]
        case .SETTLEMENT_YC_PAYTYPE: 
            return ["page_type": "settlement_yc" as AnyObject , 
                    "floorId": "settlement_yc" as AnyObject , 
                    "sectionId": "settlement_yc" as AnyObject , 
                    "itemId": "settlement_yc_paytype" as AnyObject , 
            ]
        case .PAY_YC_SUBMIT: 
            return ["page_type": "pay_yc" as AnyObject , 
                    "floorId": "pay_yc" as AnyObject , 
                    "sectionId": "pay_yc" as AnyObject , 
                    "itemId": "pay_yc_submit" as AnyObject , 
            ]
        case .PAY_YC_RETURN: 
            return ["page_type": "pay_yc" as AnyObject , 
                    "floorId": "pay_yc" as AnyObject , 
                    "sectionId": "pay_yc" as AnyObject , 
                    "itemId": "pay_yc_return" as AnyObject , 
            ]
        case .ORDERLIST_YC_WAITPAY_CANCEL: 
            return ["page_type": "orderlist_yc" as AnyObject , 
                    "floorId": "orderlist_yc_waitpay" as AnyObject , 
                    "sectionId": "orderlist_yc_waitpay" as AnyObject , 
                    "itemId": "orderlist_yc_waitpay_cancel" as AnyObject , 
            ]
        case .ORDERLIST_YC_WAITPAY_PAY: 
            return ["page_type": "orderlist_yc" as AnyObject , 
                    "floorId": "orderlist_yc_waitpay" as AnyObject , 
                    "sectionId": "orderlist_yc_waitpay" as AnyObject , 
                    "itemId": "orderlist_yc_waitpay_pay" as AnyObject , 
            ]
        }
    }
}

// 生成打点信息
extension String {
    func BI_dictValue() ->[String: AnyObject] {
        if (self == ACTIONITEM.HOME_YC_SHUFFL.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_shuffl" as AnyObject ,
                    "sectionId": "home_yc_shuffl" as AnyObject ,
                    "itemId": "home_yc_shuffl" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.HOME_YC_CLASSIFY.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_classify" as AnyObject ,
                    "sectionId": "home_yc_classify" as AnyObject ,
                    "itemId": "home_yc_classify" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.HOME_YC_USERCENTER.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_usercenter" as AnyObject ,
                    "sectionId": "home_yc_usercenter" as AnyObject ,
                    "itemId": "home_yc_usercenter" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.HOME_YC_SHOPCART.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_shopcart" as AnyObject ,
                    "sectionId": "home_yc_shopcart" as AnyObject ,
                    "itemId": "home_yc_shopcart" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.HOME_YC_AREA.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_area" as AnyObject ,
                    "sectionId": "home_yc_area" as AnyObject ,
                    "itemId": "home_yc_area" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.HOME_YC_CATEGORY.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_category" as AnyObject ,
                    "sectionId": "home_yc_category" as AnyObject ,
                    "itemId": "home_yc_category" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.HOME_YC_BRAND.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_brand" as AnyObject ,
                    "sectionId": "home_yc_brand" as AnyObject ,
                    "itemId": "home_yc_brand" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.HOME_YC_STORE_ID.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_store" as AnyObject ,
                    "sectionId": "home_yc_store" as AnyObject ,
                    "itemId": "home_yc_store_id" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.HOME_YC_PRODUCT_ID.rawValue) {
            return ["page_type": "home_yc" as AnyObject ,
                    "floorId": "home_yc_product" as AnyObject ,
                    "sectionId": "home_yc_product" as AnyObject ,
                    "itemId": "home_yc_product_id" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.CLASSIFY_YC_MEDICINE.rawValue) {
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_medicine" as AnyObject ,
                    "sectionId": "classify_yc_medicine" as AnyObject ,
                    "itemId": "classify_yc_medicine" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.CLASSIFY_YC_INSTRUMENT.rawValue) {
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_instrument" as AnyObject ,
                    "sectionId": "classify_yc_instrument" as AnyObject ,
                    "itemId": "classify_yc_instrument" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.CLASSIFY_YC_MATERIALS.rawValue) {
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_materials" as AnyObject ,
                    "sectionId": "classify_yc_materials" as AnyObject ,
                    "itemId": "classify_yc_materials" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.CLASSIFY_YC_NUTRITION.rawValue) {
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_nutrition" as AnyObject ,
                    "sectionId": "classify_yc_nutrition" as AnyObject ,
                    "itemId": "classify_yc_nutrition" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.CLASSIFY_YC_NURSING.rawValue) {
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_nursing" as AnyObject ,
                    "sectionId": "classify_yc_nursing" as AnyObject ,
                    "itemId": "classify_yc_nursing" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.CLASSIFY_YC_DEPARTMENT.rawValue) {
            return ["page_type": "classify_yc" as AnyObject ,
                    "floorId": "classify_yc_department" as AnyObject ,
                    "sectionId": "classify_yc_department" as AnyObject ,
                    "itemId": "classify_yc_department" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCTSEARCH_YC_SEARCH.rawValue) {
            return ["page_type": "productsearch_yc" as AnyObject ,
                    "floorId": "productsearch_yc" as AnyObject ,
                    "sectionId": "productsearch_yc" as AnyObject ,
                    "itemId": "productsearch_yc_search" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCTSEARCH_YC_CANCEL.rawValue) {
            return ["page_type": "productsearch_yc" as AnyObject ,
                    "floorId": "productsearch_yc" as AnyObject ,
                    "sectionId": "productsearch_yc" as AnyObject ,
                    "itemId": "productsearch_yc_cancel" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.STORESEARCH_YC_SEARCH.rawValue) {
            return ["page_type": "storesearch_yc" as AnyObject ,
                    "floorId": "storesearch_yc" as AnyObject ,
                    "sectionId": "storesearch_yc" as AnyObject ,
                    "itemId": "storesearch_yc_search" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.STORESEARCH_YC_CANCEL.rawValue) {
            return ["page_type": "storesearch_yc" as AnyObject ,
                    "floorId": "storesearch_yc" as AnyObject ,
                    "sectionId": "storesearch_yc" as AnyObject ,
                    "itemId": "storesearch_yc_cancel" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCTRESULT_YC_PRICE.rawValue) {
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_price" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCTRESULT_YC_CLICKCART.rawValue) {
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_clickcart" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCTRESULT_YC_JOINCHANNEL.rawValue) {
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_joinchannel" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCTRESULT_YC_JOINCART.rawValue) {
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_joincart" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCTRESULT_YC_RETURN.rawValue) {
            return ["page_type": "productresult_yc" as AnyObject ,
                    "floorId": "productresult_yc" as AnyObject ,
                    "sectionId": "productresult_yc" as AnyObject ,
                    "itemId": "productresult_yc_return" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.STORERESULT_YC_STORETYPE.rawValue) {
            return ["page_type": "storeresult_yc" as AnyObject ,
                    "floorId": "storeresult_yc" as AnyObject ,
                    "sectionId": "storeresult_yc" as AnyObject ,
                    "itemId": "storeresult_yc_storetype" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.STORERESULT_YC_JOINCART.rawValue) {
            return ["page_type": "storeresult_yc" as AnyObject ,
                    "floorId": "storeresult_yc" as AnyObject ,
                    "sectionId": "storeresult_yc" as AnyObject ,
                    "itemId": "storeresult_yc_joincart" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_SHARE_MOMENTS.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_share_moments" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_SHARE_WECHAT.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_share_wechat" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_QQ.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_qq" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_QZONE.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_qzone" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_WEIBO.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc_share" as AnyObject ,
                    "sectionId": "product_yc_share" as AnyObject ,
                    "itemId": "product_yc_weibo" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_JOINCART.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_joincart" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_ENTERSTORE.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_enterstore" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_CLICKINSTRUCTIONS.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_clickinstructions" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_CLICKCART.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_clickcart" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.PRODUCT_YC_RETURN.rawValue) {
            return ["page_type": "product_yc" as AnyObject ,
                    "floorId": "product_yc" as AnyObject ,
                    "sectionId": "product_yc" as AnyObject ,
                    "itemId": "product_yc_return" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.STORPAVILION_YC_JOINCART.rawValue) {
            return ["page_type": "storpavilion_yc" as AnyObject ,
                    "floorId": "storpavilion_yc" as AnyObject ,
                    "sectionId": "storpavilion_yc" as AnyObject ,
                    "itemId": "storpavilion_yc_joincart" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.STORPAVILION_YC_RETURN.rawValue) {
            return ["page_type": "storpavilion_yc" as AnyObject ,
                    "floorId": "storpavilion_yc" as AnyObject ,
                    "sectionId": "storpavilion_yc" as AnyObject ,
                    "itemId": "storpavilion_yc_return" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.MAINSTORE_YC_SHARE_MOMENTS.rawValue) {
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_moments" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.MAINSTORE_YC_SHARE_WECHAT.rawValue) {
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_wechat" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.MAINSTORE_YC_SHARE_QQ.rawValue) {
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_qq" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.MAINSTORE_YC_SHARE_QZONE.rawValue) {
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_qzone" as AnyObject ,
            ]
        }
        if (self == ACTIONITEM.MAINSTORE_YC_SHARE_WEIBO.rawValue) {
            return ["page_type": "mainstore_yc" as AnyObject ,
                    "floorId": "mainstore_yc_share" as AnyObject ,
                    "sectionId": "mainstore_yc_share" as AnyObject ,
                    "itemId": "mainstore_yc_share_weibo" as AnyObject ,
            ]
        } 
        if (self == ACTIONITEM.MAINSTORE_YC_RETURN.rawValue) { 
            return ["page_type": "mainstore_yc" as AnyObject , 
                    "floorId": "mainstore_yc" as AnyObject , 
                    "sectionId": "mainstore_yc" as AnyObject , 
                    "itemId": "mainstore_yc_return" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.MAINSTORE_YC_CLICKCART.rawValue) { 
            return ["page_type": "mainstore_yc" as AnyObject , 
                    "floorId": "mainstore_yc" as AnyObject , 
                    "sectionId": "mainstore_yc" as AnyObject , 
                    "itemId": "mainstore_yc_clickcart" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.SHOPCART_YC_SETTLE.rawValue) { 
            return ["page_type": "shopcart_yc" as AnyObject , 
                    "floorId": "shopcart_yc" as AnyObject , 
                    "sectionId": "shopcart_yc" as AnyObject , 
                    "itemId": "shopcart_yc_settle" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.USERCENTER_YC_ORDERVIEW_ALLORDER.rawValue) { 
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_allorder" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.USERCENTER_YC_ORDERVIEW_PAYWAIT.rawValue) { 
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_paywait" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.USERCENTER_YC_ORDERVIEW_DELIVERYWAIT.rawValue) {
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_deliverywait" as AnyObject ,
            ] 
        } 
        if (self == ACTIONITEM.USERCENTER_YC_ORDERVIEW_GETWAIT.rawValue) {
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_getwait" as AnyObject ,
            ] 
        } 
        if (self == ACTIONITEM.USERCENTER_YC_ORDERVIEW_ABNORMAL.rawValue) {
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_orderview" as AnyObject , 
                    "sectionId": "usercenter_yc_orderview" as AnyObject , 
                    "itemId": "usercenter_yc_orderview_abnormal" as AnyObject ,
            ] 
        } 
        if (self == ACTIONITEM.USERCENTER_YC_CALLSERVICE.rawValue) {
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_callservice" as AnyObject ,
                    "sectionId": "usercenter_yc_callservice" as AnyObject ,
                    "itemId": "usercenter_yc_callservice" as AnyObject ,
            ] 
        } 
        if (self == ACTIONITEM.USERCENTER_YC_SET.rawValue) {
            return ["page_type": "usercenter_yc" as AnyObject , 
                    "floorId": "usercenter_yc_set" as AnyObject ,
                    "sectionId": "usercenter_yc_set" as AnyObject ,
                    "itemId": "usercenter_yc_set" as AnyObject ,
            ] 
        } 
        if (self == ACTIONITEM.USERCENTER_YC_LOGIN_REGISTER.rawValue) {
            return ["page_type": "usercenter_yc" as AnyObject ,
                    "floorId": "usercenter_yc_ login&register" as AnyObject , 
                    "sectionId": "usercenter_yc_login&register" as AnyObject ,
                    "itemId": "usercenter_yc_login&register" as AnyObject ,
            ] 
        } 
        if (self == ACTIONITEM.SETTLEMENT_YC_SUBMIT.rawValue) { 
            return ["page_type": "settlement_yc" as AnyObject , 
                    "floorId": "settlement_yc" as AnyObject , 
                    "sectionId": "settlement_yc" as AnyObject , 
                    "itemId": "settlement_yc_submit" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.SETTLEMENT_YC_RETURN.rawValue) { 
            return ["page_type": "settlement_yc" as AnyObject , 
                    "floorId": "settlement_yc" as AnyObject , 
                    "sectionId": "settlement_yc" as AnyObject , 
                    "itemId": "settlement_yc_return" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.SETTLEMENT_YC_PAYTYPE.rawValue) { 
            return ["page_type": "settlement_yc" as AnyObject , 
                    "floorId": "settlement_yc" as AnyObject , 
                    "sectionId": "settlement_yc" as AnyObject , 
                    "itemId": "settlement_yc_paytype" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.PAY_YC_SUBMIT.rawValue) { 
            return ["page_type": "pay_yc" as AnyObject , 
                    "floorId": "pay_yc" as AnyObject , 
                    "sectionId": "pay_yc" as AnyObject , 
                    "itemId": "pay_yc_submit" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.PAY_YC_RETURN.rawValue) { 
            return ["page_type": "pay_yc" as AnyObject , 
                    "floorId": "pay_yc" as AnyObject , 
                    "sectionId": "pay_yc" as AnyObject , 
                    "itemId": "pay_yc_return" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.ORDERLIST_YC_WAITPAY_CANCEL.rawValue) { 
            return ["page_type": "orderlist_yc" as AnyObject , 
                    "floorId": "orderlist_yc_waitpay" as AnyObject , 
                    "sectionId": "orderlist_yc_waitpay" as AnyObject , 
                    "itemId": "orderlist_yc_waitpay_cancel" as AnyObject , 
            ] 
        } 
        if (self == ACTIONITEM.ORDERLIST_YC_WAITPAY_PAY.rawValue) { 
            return ["page_type": "orderlist_yc" as AnyObject , 
                    "floorId": "orderlist_yc_waitpay" as AnyObject , 
                    "sectionId": "orderlist_yc_waitpay" as AnyObject , 
                    "itemId": "orderlist_yc_waitpay_pay" as AnyObject , 
            ] 
        } 
        
        return ["page_type": "" as AnyObject ,
                "floorId": "" as AnyObject ,
                "sectionId": "" as AnyObject ,
                "itemId": "" as AnyObject ,
        ]
    }
}


