//
//  ViewControllerBIExtension.swift
//  FKY
//
//  Created by yangyouyong on 2016/12/7.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  pagecode

import UIKit

//MARK: - 支付完成页面
extension FKYOrderPayStatusVC{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PAY_SUCCESS.rawValue
    }
}

//MARK: - 直播页面
extension FKYLiveViewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LIVE_ROOM.rawValue
    }
}
//MARK: - 点播页面
extension FKYVodPlayerViewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LIVE_REPLAY.rawValue
    }
}
extension FKYVideoPlayerDetailVC{
    override func ViewControllerPageCode() -> String? {
        return ""
    }
}

//MARK: - 直播列表
extension LiveContentListViewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LIVE.rawValue
    }
}
extension LivingListViewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LIVE.rawValue
    }
}
extension LiveNoticeViewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LIVE.rawValue
    }
}
//MARK: - 直播结束
extension LiveEndViewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LIVE_END.rawValue
    }
}
//MARK: - 直播间主页
extension LiveRoomInfoVIewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LIVE_HOME.rawValue
    }
}
//MARK: - 直播预告页
extension LiveNticeDetailViewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LIVE_NOTICE.rawValue
    }
}
// MARK: swift view controller BI extension
// MARK:专区 -高毛专区 **
// 高毛专区

extension FKYHeightGrossMarginVC{
    override func ViewControllerPageCode() -> String? {
        if self.typeIndex == 5 {
            return PAGECODE.SAMESPULIST.rawValue
        }else if self.typeIndex == 6{// 降价专区push落地页
            return PAGECODE.CHEAPLIST.rawValue
        }
        else {
            return PAGECODE.LABELPRODUCT.rawValue
        }
    }
}
// MARK:首页 **
extension HomeController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.HOME.rawValue
    }
}
extension HomeMainOftenBuyController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.HOME.rawValue
    }
}

//MARK: - 首页V3
extension FKYHomePageV3VC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.HOME.rawValue
    }
}

extension FKYScanVC{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SCANSEARCH.rawValue
    }
}
extension FKYNewProductRegisterVC{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.NEWPRODUCTREGISTER.rawValue
    }
}
extension FKYStandardProductListVC{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.NEWPRODUCTREGISTER.rawValue
    }
}
//逛一逛，得优惠页面
extension SendCouponDetailInfoController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.ACTIVITYLOADINGPAGE.rawValue
    }
}
// MARK:消息中心 **
extension FKYMessageListViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.messageListActivity.rawValue
    }
}

// MARK:站内信 **
extension FKYStationMsgVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.messageListActivity.rawValue
    }
}

// MARK:资质列表 **
extension ExpiredTipsMessageVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.expiredTipsActivity.rawValue
    }
}
// MARK:物流信息 **
extension OrderLogisticsMsgVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.logisticsMSG.rawValue
    }
}
// MARK:活动特惠**
extension HomePromotionMsgListInfoVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.promotionMSG.rawValue
    }
}
// MARK:降价信息 **
extension PDLowPriceNoticeVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.depreciateNoticeActivity.rawValue
    }
}
// MARK:到货通知 **
extension ArrivalProductNoticeVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.MISS_GOODS.rawValue
    }
}
// MARK:服务通知列表 **
extension PriceChangeNoticeVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.serviceNoticeActivity.rawValue
    }
}

//MARK:店铺馆**
extension FKYShopHomeViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOP_PAVILION_AREA.rawValue
    }
}
//店铺馆（首页）**
extension FKYShopActivityViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOP_PAVILION_AREA.rawValue
    }
}
//店铺馆（关注店铺列表）**
extension FKYShopAttentionViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOP_PAVILION_COLLECTION.rawValue
    }
}
//店铺馆（全部店铺列表）**
extension FKYShopAllListViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.ALL_SHOP_LIST.rawValue
    }
}
//店铺馆（商家热销）**
extension FKYShopPrdPromotionViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOP_PAVILION_BUSINESS_PROMOTIOM.rawValue
    }
}

//品种汇
extension NewShopListItemVC1 {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOPLIST.rawValue
    }
}

//mp精选店
extension FKYShopListViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOPLIST.rawValue
    }
}

//mp中药材
extension FKYMedicineViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOPLIST.rawValue
    }
}

//MARK:购物车...<普通商品和一起购商品的购物车合并> **
extension CartSwitchViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOPPINGCART.rawValue
    }
}
// 一起购 购物车
extension YQGCartViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOPPINGCART.rawValue
    }
}
//购物车...<普通商品>
extension CartViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOPPINGCART.rawValue
    }
}

//MARK:个人中心 **
extension AccountViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.MINE.rawValue
    }
}

/// 购物金
extension FKYshoppingMoneyBalanceVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOPPINGMONEY.rawValue
    }
}

// MARK: 红包结果页<红包领取页> **
extension FKYRedPacketViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.redPacketResultActivity.rawValue
    }
}

//MARK: 新店铺主页<新店铺首页> **
extension FKYNewShopItemViewController {
    override func ViewControllerPageCode() -> String? {
        if self.shopType == "1" {
            return PAGECODE.JBPSHOP.rawValue
        }
        return PAGECODE.SHOPHOME.rawValue
    }
}
//MARK: 优惠券商品列表
extension CouponProductListViewController {
    override func ViewControllerPageCode() -> String? {
        if self.keyword.isEmpty == false{
            // 优惠券可用商品结果：couponProductSearchResult（新增）
            return PAGECODE.COUPONPRODUCTSEARCHRESULT.rawValue
        }
        return PAGECODE.COUPONPRODUCT.rawValue
    }
}
//新店铺全部商品页子控制器
extension ShopAllProductViewController {
    override func ViewControllerPageCode() -> String? {
        if self.shopType == "1" {
            return PAGECODE.JBPSHOP.rawValue
        }
        return PAGECODE.SHOPHOME.rawValue
    }
}
//新店铺主页子控制器
extension FKYShopMainViewController {
    override func ViewControllerPageCode() -> String? {
        if self.shopType == "1" {
            return PAGECODE.JBPSHOP.rawValue
        }
        return PAGECODE.SHOPHOME.rawValue
    }
}
//M
//MARK：企业信息
extension FKYShopEnterpriseInfoViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.ENTERPRISEINFOPAGE.rawValue
    }
}



// MARK: 一起购列表 **
extension FKYTogeterBuyViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.togeterBuyList.rawValue
    }
}

//MARK:一起购搜索结果页 **
extension FKYTogeterSearchResultVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.togeterBuySearchList.rawValue
    }
}

// MARK:一起购商品详情 **
extension FKYTogeterBuyDetailViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.togeterBuyDetail.rawValue
    }
}
// MARK: 秒杀专区页 **
extension FKYSecondKillActivityController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.secondKillActivity.rawValue
    }
}

// MARK: - 搭配套餐聚合页
extension FKYMatchingPackageVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.matchingPackage.rawValue
    }
}

//MARK:店铺内满减满赠特价专区列表页面(特价专区,满减专区,满赠专区,返利专区,满折专区)**
extension ShopItemOldViewController {
    override func ViewControllerPageCode() -> String? {
        // 1-特价活动 2-满减活动 3-满赠活动 4-返利专区 5-满折专区 6- 口令分享
        if self.type == 1 {
            return PAGECODE.shopSpecialOfferActivity.rawValue
        }else if self.type == 2 {
            return PAGECODE.shopReductionActivity.rawValue
        }else if self.type == 3 {
            return PAGECODE.shopGiftActivity.rawValue
        }else if self.type == 4 {
            return PAGECODE.shopRebateActivity.rawValue
        }else if self.type == 6 {
            return PAGECODE.shareIdActivity.rawValue
        }else{
            return PAGECODE.shopDiscountActivity.rawValue
        }
        // return PAGECODE.shopPrefectureList.rawValue
    }
}

// MARK:店铺内套餐 **
extension FKYComboListViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.shopPackageList.rawValue
    }
}

// MARK:搜索页(公共搜索页及一起购搜索页) **
extension FKYSearchViewController {
    override func ViewControllerPageCode() -> String? {
        if (self.searchType == .togeterProduct){
            //一起购搜索页
            return PAGECODE.TOGETER_SEARCH.rawValue
        } else if self.searchType == .order {
            //订单搜索
            return PAGECODE.ORDERSEARCH.rawValue
        }else if self.searchType == .jbpShop {
            //JBP专区搜索
            return PAGECODE.JBPPRODUCTSEARCH.rawValue
        }else if self.searchType == .coupon {
            //优惠券可用商品搜索
            return PAGECODE.COUPONPRODUCTSEARCH.rawValue
        }else if self.searchType == .shop {
            //全站店铺搜索 搜索店铺
            return PAGECODE.SHOPSEARCH.rawValue
        }else if self.searchType == .packageRate{
            //搜索单品包邮商品
            return PAGECODE.SINGLEPACKAGERODUCTSEARCH.rawValue
        } else if self.vcSourceType == .pilot{
           //搜索店铺内搜索商品
            return PAGECODE.SHOPPRODUCTSEARCH.rawValue
        }
        return PAGECODE.SEARCH.rawValue
    }
}

extension FKYSearchProductVC {
    override func ViewControllerPageCode() -> String? {
        if self.searchType == 1{
            // 全栈搜索商品
            return PAGECODE.SEARCH.rawValue
        }else if self.searchType == 3{
            // 店铺内搜索商品
            return PAGECODE.SHOPPRODUCTSEARCH.rawValue
        }
        return ""
    }
}

extension FKYSearchInputKeyWordVC{
    override func ViewControllerPageCode() -> String? {
        if self.searchType == 1{
            // 全栈搜索商品
            return PAGECODE.SEARCH.rawValue
        }else if self.searchType == 2{
            //搜索店铺内搜索商品
            return PAGECODE.SHOPSEARCH.rawValue
        }
        else if self.searchType == 3{
            // 店铺内搜索商品
            return PAGECODE.SHOPPRODUCTSEARCH.rawValue
        }
        return ""
    }
}

extension FKYSearchSellerVC{
    override func ViewControllerPageCode() -> String? {
        if self.searchType == 2{
            return PAGECODE.SHOPSEARCH.rawValue
        }
        return ""
    }
}

// MARK:商品搜索OR店铺搜索 **
extension FKYSearchResultVC {
    override func ViewControllerPageCode() -> String? {
        if (self.searchResultType == "Shop") {
            // 店铺搜索
            return PAGECODE.STORESEARCH.rawValue
        }else if self.shopProductSearch == true{
            //店铺内搜索或者聚宝盆搜索
            if self.jbpShopID != nil && self.jbpShopID!.isEmpty == false{
                //jBP专区搜索结果
                return PAGECODE.JBPPRODUCTSEARCHRESULT.rawValue
            }else if self.sellerCode != nil && String(format:"\(self.sellerCode ?? 0)").isEmpty == false{
                //店铺内搜索结果
                return PAGECODE.SHOPPRODUCTSEARCHRESULT.rawValue
            }
        }
        return PAGECODE.PRODUCTSEARCH.rawValue
    }
}

// MARK:检查订单 **
extension CheckOrderController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.CHECKORDER.rawValue
    }
}

//MARK: 订单列表 **
extension FKYAllOrderViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.ORDERMANAGE.rawValue
    }
}

// MARK: 订单列表-子Controller (订单搜索结果页) **
extension FKYOrderStatusViewController {
    override func ViewControllerPageCode() -> String? {
        if self.isOrderSearch == true {
            //订单搜索结果页
            return PAGECODE.ORDERSEARCHRESULT.rawValue
        }
        return PAGECODE.ORDERMANAGE.rawValue
    }
}

//MARK:登录 **
extension LoginController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LOGIN.rawValue
    }
}
//MARK:找回密码 **
extension FKYFindPasswordViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.FINDPASSWORD.rawValue
    }
}
// MARK:找回密码获取验证码**
extension FKYGetCodeAfterFindPassViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.FINDPASSWORDCAPTCHA.rawValue
    }
}
// MARK:0:找回密码 1:修改密码 **
extension FKYSetPasswordViewController {
    override func ViewControllerPageCode() -> String? {
        if self.type == 0 {
            return PAGECODE.RESERPASSWORD.rawValue
        }
        return PAGECODE.CHANGEPASSWORD.rawValue
    }
}
// MARK:注册 **
extension RegisterController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.REGISTER.rawValue
    }
}

// MARK:资料管理填写基本信息<包括企业信息、收货人信息> **
extension RITextController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.EDITENTERPRISEINFO.rawValue
    }
}
// MARK:(填写基本信息之)企业名称(搜索联想)列表界面 **
extension RIEnterpriseListController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.EDITENTERPRISENAME.rawValue
    }
}
// MARK:(填写基本信息之)企业类型 **
extension CredentialsEnterpriseTypeController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.EDITENTERPRISETYPE.rawValue
    }
}
// MARK: (填写基本信息之)选择经营范围 **
extension CredentialsBusinessScopeForBaseInfoController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.CHOOSESCOPE.rawValue
    }
}
// MARK: 选择经营范围 **
extension CredentialsBusinessScopeController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.CHOOSESCOPE.rawValue
    }
}
// MARK:(填写基本信息之)编辑企业银行信息（批零一体独有） **
extension CredentialsBankInfoController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.EDITENTBANKINFO.rawValue
    }
}
// MARK:资料管理...<上传资质图片> **
extension RIImageController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.UPLOADLICENCE.rawValue
    }
}
// MARK:(填写基本信息之)上传资质成功 **
extension CredentialsCompleteViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.UPLOADLICENSESUCCESS.rawValue
    }
}

// MARK:设置 **
extension FKYSetUpViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.mySetting.rawValue
    }
}
// MARK:我的余额 **
extension RebateInfoController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.MYREBATE.rawValue
    }
}

// MARK:药福利申请 **
extension FKYApplyWalfareTableVC{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.ACTIVITYLANDING.rawValue
    }
}


// MARK:药福利**
extension FKYYflIntroDetailViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.ACTIVITYLANDING.rawValue
    }
}

// MARK:我的余额（累计余额，待到账余额） **
extension RebateDetailController {
    override func ViewControllerPageCode() -> String? {
        if self.rebateRecordType == .FKYRebateRecordTypeTotal{
            //累计余额
            return PAGECODE.MYCUMULATIVEREBATE.rawValue
        }else if self.rebateRecordType == .FKYRebateRecordTypePending {
            //待到账余额
            return PAGECODE.MYEXPECTANTREBATE.rawValue
        }
        return nil
    }
}
// MARK:我的优惠券 **
extension MyCouponController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.myCoupon.rawValue
    }
}
// 我的优惠券-可用、已用、过期
extension MyCouponItemController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.myCoupon.rawValue
    }
}
// MARK:退换货/售后 **
extension FKYRefuseListViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.POSTSALE.rawValue
    }
}
// MARK:我的收藏 **
extension FKYMyFavShopController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.MYFAVORITE.rawValue
    }
}

// 资料管理
//extension CredentialsViewController {
//    override func ViewControllerPageCode() -> String? {
//        return PAGECODE.myResource.rawValue
//    }
//}
// MARK:基本资料管理 **
extension QualificationBaseInfoController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.MYINFORMATION.rawValue
    }
}
// MARK:发票管理 **
extension FKYInvoiceViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.myInvoice.rawValue
    }
}
//// MARK: 发票-维护(增值税普通发票,增值税专用发票) **
//extension InvoiceDetailViewController {
//    override func ViewControllerPageCode() -> String? {
//        if self.viewModel.type == .ordinary {
//            //发票-维护增值税普通发票
//            return PAGECODE.EDITGENERALINVOICE.rawValue
//        }
//        //发票-维护增值税专用发票
//        return PAGECODE.EDITSPECIALINVOICE.rawValue
//    }
//}
// MARK:常购商家**
extension OftenBuySellerListController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.MYPURCHASESHOP.rawValue
    }
}
// MARK:负责业务员 **
extension FKYSalesManViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.MYBD.rawValue
    }
}
// MARK:检查订单-选择优惠券 **
extension UseCouponController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.checkOrdChooseCoupon.rawValue
    }
}
//MARK:检查订单-选择首营资料
extension COFollowQualificaViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.checkOrdChooseFirstDada.rawValue
    }
}
// MARK:检查订单-选择发票类型**
extension SelectInvoiceViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.checkOrderChooseInvoice.rawValue
    }
}
// MARK:选择在线支付方式 **
extension COSelectOnlinePayController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.CHOOSEONLINEPAY.rawValue
    }
}
// MARK: 线下支付详情 & 我的订单-查看规则 & 点的详情点击银行账户
extension COOfflinePayDetailController {
    override func ViewControllerPageCode() -> String? {
        if self.flagFromCO == true {
            //线下支付详情(线下支付成功页)
            return PAGECODE.OFFLINEPAYSUCCESS.rawValue
        }
        return nil
    }
}
// MARK: 第三方物流 **
extension FKYLogisticsDetailViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LOGISTICSDETAIL.rawValue
    }
}

//自有物流
extension FKYLogisticsViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.LOGISTICSDETAIL.rawValue
    }
}

// MARK: 投诉商家 **
extension BuyerComplainInputController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.COMPLAINSHOP.rawValue
    }
}
// MARK: 申请售后服务列表 **
extension AfterSaleListController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.APPLYPOSTSALELIST.rawValue
    }
}
// MARK: 售后服务-选择退换货类型 **
extension RCTypeSelController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.RETURNANDCHANGE.rawValue
    }
}
// MARK: 售后服务-选择随行单据服务/企业首营资质 **
extension ASAttachmentController {
    override func ViewControllerPageCode() -> String? {
        if self.typeId == ASTypeECode.ASType_Bill.rawValue {
            //随行单据服务
            return PAGECODE.PSFOLLOWINGreCEIPT.rawValue
        }else if self.typeId == ASTypeECode.ASType_EnterpriceReport.rawValue {
            //企业首营资质
            return PAGECODE.PSENTERPRISEFIRSTQUALIFICATION.rawValue
        }
        return nil
    }
}
// MARK: 售后服务-选择商品错漏发服务 **
extension ASProductNumWrongController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PSPRODUCTMISTAKE.rawValue
    }
}
// MARK: 售后服务-选择药检报告服务/商品首营资质服务 **
extension ASCredentialsAndReportViewController {
    override func ViewControllerPageCode() -> String? {
        if self.typeId == ASTypeECode.ASType_DrugReport.rawValue {
            //药检报告服务
            return PAGECODE.PSDRUGINSPECTION.rawValue
        }else if self.typeId == ASTypeECode.ASType_ProductReport.rawValue {
            //商品首营资质服务
            return PAGECODE.PSPRODUCTFIRSTQUALIFICATION.rawValue
        }
        return nil
    }
}
// MARK:退换货-填写退货申请原因/填写换货申请原因 **
extension RCSubmitInfoController {
    override func ViewControllerPageCode() -> String? {
        if self.returnFlag == true {
            //退货
            return PAGECODE.EDITRETURNREASON.rawValue
        }else {
            //换货
            return PAGECODE.EDITCHANGEREASON.rawValue
        }
    }
}
// MARK:退货-填写退款信息 **
extension RCSubmitBankViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.EDITRETURNBANKINFORMATION.rawValue
    }
}
//MARK: 确认收货列表**
extension FKYReceiveProductViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.CONFIRMRECEPTION.rawValue
    }
}
//MARK:拒收补货页面(MP部分收货的页面)**
extension FKYJSBHApplyViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.APPLYREFUSEORREPLENISH.rawValue
    }
}
//MARK:h5容器
extension GLWebVC {
    override func ViewControllerPageCode() -> String? {
        //1:maps页面 2:vip页面 3:返利页面
        if self.pageType.count > 0 {
            return self.pageType
        }
        return PAGECODE.GLWebVcActivity.rawValue
    }
}

// 检查订单-找人代付-提交订单
extension FKYFindPeoplePayViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.checkOrdOthpay.rawValue
    }
}
// 分类
extension FKYCategoryWebViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.CATEGORY.rawValue
    }
}
//满减，特价专区
extension FKYAllPrefectureViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.allPrefectureList.rawValue
    }
}
//
extension ShopListCouponCenterViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SHOPCOUPON.rawValue
    }
}
// 商品搜索无结果子控制器保持与父控制器相同的pagecode
extension SearchOftenBuyController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PRODUCTSEARCH.rawValue
    }
}
extension FKYJPPEmptyViewController{
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PRODUCTSEARCH.rawValue
    }
}
// 商品搜索筛选生产厂家和商品规格子控制器保持与父控制器相同的pagecode
extension FKYFactoryFliterForSearchResultVC {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PRODUCTSEARCH.rawValue
    }
}

//商品详情
extension FKYProductionDetailViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PRODUCT.rawValue
    }
}

//商品详情<子控制器>
extension FKYProductionBaseInfoController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PRODUCT.rawValue
    }
}
//商品详情<优惠券弹框>
extension FKYPopComCouponVC {
    override func ViewControllerPageCode() -> String? {
        if self.typeNum == 1 {
            return PAGECODE.PRODUCT.rawValue
        }else {
            return PAGECODE.SHOPPINGCART.rawValue
        }
        
    }
}

// 订单详情
extension FKYOrderDetailViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.ORDERDETAILS.rawValue
    }
}

////查看批次
//extension FKYBatchViewController {
//    override func ViewControllerPageCode() -> String? {
//        return PAGECODE.CHECKLOT.rawValue
//    }
//}

//拒收补货详情
extension FKYJSOrderDetailViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.ORDERREJECTDETAIL.rawValue
    }
}

// 店铺资质列表
//extension ShopMaterialViewController {
//    override func ViewControllerPageCode() -> String? {
//        return PAGECODE.CERTLIST.rawValue
//    }
//}

// 收货地址列表(个人中心)
extension CredentialsAddressManageController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.RECVADDRLIST.rawValue
    }
}

// 支付成功页
//extension FKYPaySuccessViewController {
//    override func ViewControllerPageCode() -> String? {
//        return PAGECODE.PAYSUCC.rawValue
//    }
//}

// 银联支付界面
extension FKYPaymentWebViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.UNIONPAY.rawValue
    }
}

// 区域热搜+本周热销
extension HotSaleController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.TOPSEARCHAPP.rawValue
    }
}

// 推荐药品
extension OftenBuyProductListController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.SUGGESTPILL.rawValue
    }
}
// 查看大图
extension SKPhotoBrowser {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.myResUpCheck.rawValue
    }
}

// 编辑收发货地址
extension CredentialsAddressSendViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.yyResRcv.rawValue
    }
}

// 关于我们
extension FKYAboutUsViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.mySettWe.rawValue
    }
}

//// 我的资产
//extension FKYRebateViewController {
//    override func ViewControllerPageCode() -> String? {
//        return PAGECODE.myRemain.rawValue
//    }
//}
// 返利金明细
//extension FKYRebateDetailViewController {
//    override func ViewControllerPageCode() -> String? {
//        return PAGECODE.myRemDetail.rawValue
//    }
//}
// 销售单示例
extension FKYShowSaleInfoViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.checkOrdPron.rawValue
    }
}
// 登记历史记录列表
extension FKYNewPrdSetHisListViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.NPREGISTERHISTORY.rawValue
    }
}
// 登记历史详情
extension FKYNewPrdSetDeatilViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.NPREGISTERDETAIL.rawValue
    }
}
// 城市热销列表
extension FKYHotSaleRegionViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.HOTSALEREGION.rawValue
    }
}

// 商家特惠
extension FKYPreferentialShopsViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.MPPROMOTION.rawValue
    }
}

// 包邮价
extension FKYPackageRateViewController {
    override func ViewControllerPageCode() -> String? {
        if  self.typeIndex == 0 {
            //列表
            return PAGECODE.PACKAGE_LIST_RATE.rawValue
        }else {
            //搜索结果页
            return PAGECODE.PACKAGE_SEARCH_LIST_RATE.rawValue
        }
    }
}

// 包邮价
extension FKYProductPinkageViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PACKAGE_LIST_RATE.rawValue
    }
}
// 包邮价
extension FKYSelfShopPinkageViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PACKAGE_LIST_RATE.rawValue
    }
}
// 包邮价
extension FKYMpShopPinkageViewController {
    override func ViewControllerPageCode() -> String? {
        return PAGECODE.PACKAGE_LIST_RATE.rawValue
    }
}
