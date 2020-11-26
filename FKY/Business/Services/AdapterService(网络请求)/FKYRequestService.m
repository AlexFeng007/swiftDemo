//
//  FKYRequestService.m
//  FKY
//
//  Created by 夏志勇 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "FKYRequestService.h"
// AFN
#import "AFHTTPRequestOperationManager.h"
// Model
#import "FKYAccountPicCodeModel.h"
#import "FKYBankInfoModel.h"
#import "FKYProductRecommendListModel.h"


// 集团下载图片url主域名...<集团上传图片接口请求成功后，返回的url路径仅包含主域名后的路径，完整路径需要应用自己拼接>
// http://wiki.yiyaowang.com/pages/viewpage.action?pageId=9112982
// 说明：p3-p8都ok
// http://p5.maiyaole.com/img/yc/e601f571c70b4ec78bba749135ba8e06
#define kImageDownloadHost @"https://p8.maiyaole.com"



@implementation FKYRequestService

static FKYRequestService *requestService = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //requestService = [[FKYRequestService alloc] init];
        //requestService = [FKYRequestService logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
        requestService = [FKYRequestService logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:kAppDelegate]];
    });
    return requestService;
}


#pragma mark - Private

// 注：如果不传returnClass，则取数据时直接使用原始的字典response；若有传returnClass，解析成功时取model对象，解析失败仍可以取原始的字典response；使用时开发自已根据实际情况来处理。

// post
- (void)startPostRequest:(NSString *)action param:(NSDictionary *)param returnClass:(Class)returnClass completionBlock:(RequestServiceBlock)completion
{
    HJOperationParam *operationParam = [FKYWebService postRequest:action param:param returnClass:returnClass success:^(id response, id model) {
        // 成功
        completion(YES, nil, response, model);
    } failure:^(id response, NSError *error) {
        // 失败
        completion(NO, error, nil, nil);
    }];
    [self.operationManger requestWithParam:operationParam];
}

// get
- (void)startGetRequest:(NSString *)action param:(NSDictionary *)param returnClass:(Class)returnClass completionBlock:(RequestServiceBlock)completion
{
    HJOperationParam *operationParam = [FKYWebService getRequest:action param:param returnClass:returnClass success:^(id response, id model) {
        // 成功
        completion(YES, nil, response, model);
    } failure:^(id response, NSError *error) {
        // 失败
        completion(NO, error, nil, nil);
    }];
    [self.operationManger requestWithParam:operationParam];
}


#pragma mark - 退换货

// 申请退换货原因
- (void)requestForApplyReasonListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_RC_APPLY_REASON_LIST param:param returnClass:[RCApplyReasonModel class] completionBlock:completion];
}

// 提交退换货信息...<申请退换货>
- (void)requestForSubmitApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_APPLY_RETURN_CHANGE param:param returnClass:nil completionBlock:completion];
}

// mp提交退换货信息...<申请退换货-閤亚峰>
- (void)requestForMpSubmitApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
    [self startPostRequest:API_RC_MP_APPLY_RETURN_CHANGE param:param returnClass:nil completionBlock:completion];
}

// 快递公司列表
- (void)requestForSendCompanyListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_SEND_COMPANY_LIST param:param returnClass:[RCSendCompanyModel class] completionBlock:completion];
}

// 提交回寄信息
- (void)requestForSubmitSendInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_SUBMIT_RETURN_INFO param:param returnClass:nil completionBlock:completion];
}

// 订阅物流信息
- (void)requestForSubscribeSendInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_SUBSCRIBE_SEND_INFO param:param returnClass:nil completionBlock:completion];
}

// 查询可退换货数量
- (void)requestForGetCountsInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_GET_COUNTS_INFO param:param returnClass:nil completionBlock:completion];
}

// 查询MP可退换货数量<閤亚峰>
- (void)requestForGetMPCountsInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_RC_MP_GET_COUNTS_INFO param:param returnClass:nil completionBlock:completion];
}

// 根据第三方订单（药城订单）ID查询药网子单
- (void)requestForQueryOrderIdInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_QUERY_ORDERID_INFO param:param returnClass:nil completionBlock:completion];
}

// 获取物流日志接口
- (void)requestForqueryLogisticsListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_QUERY_LOGISTICES_LIST_INFO param:param returnClass:nil completionBlock:completion];
}

// 撤销退换货申请
- (void)requestForCancleOcsRmaApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_CANCEL_RMA_APPLY  param:param returnClass:nil completionBlock:completion];
}
// 撤销退换货申请<閤亚峰>
- (void)requestForMPCancleOcsRmaApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_MP_CANCEL_RMA_APPLY  param:param returnClass:nil completionBlock:completion];
}

// 查看退换货申请
- (void)getOcsRmaApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_GET_APPLY_INFO param:param returnClass:nil completionBlock:completion];
}

// 查询订单的所有退换货记录
- (void)queryUserRmaOrderListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_QUERY_RMA_ORDER_LIST param:param returnClass:nil completionBlock:completion];
}

// 查询订单的所有退换货  换货返回物流
- (void)queryTmsLogByChildOrderIdWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RC_QUERY_TMS_LOG_CHILDORDERID param:param returnClass:nil completionBlock:completion];
}


#pragma mark - 售后工单

// 判断是否展示极速理赔
- (void)queryTypeShowCompensationWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_AS_APPLY_SERVICE_TYPE_SHOW_COMP param:param returnClass:nil completionBlock:completion];
}

// 获取已申请记录列表
- (void)queryASServiceTypeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_AS_APPLY_SERVICE_TYPE param:param returnClass:nil completionBlock:completion];
}

// 获取可申请售后列表
- (void)queryWorkOrderListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_AS_APPLY_ORDER_LIST param:param returnClass:nil completionBlock:completion];
}

// 获取全部订单的售后列表
- (void)queryAllWorkOrderListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_All_AS_APPLY_ORDER_LIST param:param returnClass:nil completionBlock:completion];
}

// 根据服务类型id和子订单号获取服务类型详情信息
- (void)queryAsWorkServiceTypeDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_AS_APPLY_DETAIL_INFO param:param returnClass:nil completionBlock:completion];
}

// 提交工单信息
- (void)saveAsWorkOrderForB2BTypeDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_AS_APPLY_SAVE_INFO param:param returnClass:nil completionBlock:completion];
}

// 获取工单基本信息
- (void)getAsWorkOrderBaseInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_AS_APPLY_BASE_INFO param:param returnClass:nil completionBlock:completion];
}


#pragma mark - 检查订单、提交订单

// 检查订单
- (void)requestForCheckOrderWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_CHECK_ORDER param:param returnClass:nil completionBlock:completion];
}

// 提交订单...<普通订单>
- (void)requestForSubmitOrderWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_SUBMIT_ORDER_NORMAL param:param returnClass:[COSubmitOrderModel class] completionBlock:completion];
}

// 提交订单...<一起购订单>
- (void)requestForSubmitGroupBuyOrderWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_SUBMIT_ORDER_GROUP_BUY param:param returnClass:[COSubmitOrderModel class] completionBlock:completion];
}

// 检查用户资质状态...<判断用户是否可以提交订单>
- (void)requestForCheckEnterpriseQualificationWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_CHECK_QUALIFICATION_STATUS param:param returnClass:nil completionBlock:completion];
}

// 在线支付方式列表
- (void)requestForOnlinePayTypeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_GET_ONLINE_PAY_TYPE param:param returnClass:[PayTypeItemModel class] completionBlock:completion];
}

// 上海银行支付状态主动获取接口
- (void)requestForQuickPayStatusWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_GET_QUICKPAY_STATUS param:param returnClass:nil completionBlock:completion];
}

// 获取上次在线支付方式
- (void)requestForSavedOnlinePayTypeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_GET_ONLINE_PAY_TYPE_SAVED param:param returnClass:nil completionBlock:completion];
}
// 快捷支付获取流水号并且自动发送短信
- (void)requestForQuickPayFlowIdWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CO_GET_ONLINE_QUICKPAY_TYPE_BANK param:param returnClass:nil completionBlock:completion];
}
 
//
//快捷支付 支付确认接口
- (void)requestForQuickPayConfirmWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CO_GET_ONLINE_QUICKPAY_TYPE_CONFIRM param:param returnClass:nil completionBlock:completion];
}

// 获取花呗分期列表数据
- (void)requestForAlipayInstalmentListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_GET_ALIPAY_INSTALMENT_LIST param:param returnClass:[COAlipayInstallmentModel class] completionBlock:completion];
}

// 请求收款方账户信息...<商家银行信息>
- (void)requestForEnterpriseBankInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_GET_ENTERPRISE_BANK_INFO param:param returnClass:[FKYBankInfoModel class] completionBlock:completion];
}

// 请求订单分享签名
- (void)requestForOrderShareSignWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CO_GET_ORDER_SHARE_SIGN param:param returnClass:nil completionBlock:completion];
}

// 获取支持的银行列表《黎凯》
- (void)requestForUseBankListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CO_GET_BANK_LIST param:param returnClass:nil completionBlock:completion];
}

#pragma mark - 订单详情相关

- (void)requestForOrderDetaiAboutSendVoiceToMail:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_SEND_INVOICE_TO_MAIL param:param returnClass:nil completionBlock:completion];
}


#pragma mark - 买家投诉卖家

// mp订单投诉
- (void)sellerComplainActionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_ORDER_COMPLAINT param:param returnClass:nil completionBlock:completion];
}


#pragma mark - 启动

// 获取站点(省份)
- (void)getSiteWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_LAUNCH_GET_SITE param:param returnClass:nil completionBlock:completion];
}

// 保存个推(设备)信息
- (void)saveDeviceInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_LAUNCH_SAVE_DEVICE param:param returnClass:nil completionBlock:completion];
}

#pragma mark - 直播
//直播当前正在讲解的商品
- (void)getLiveCurrecrProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_LIVE_CURRECT_PRODUCT param:param returnClass:nil completionBlock:completion];
}
//直播所有商品列表
- (void)getLiveAllProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_LIVE_ALL_PRODUCT param:param returnClass:nil completionBlock:completion];
}
//直播推荐品
- (void)getLiveRecomendProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_LIVE_RECOMMEND_PRODUCT param:param returnClass:nil completionBlock:completion];
}
//直播间活动详情
- (void)getLiveActivityDetailfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_DETAIL param:param returnClass:nil completionBlock:completion];
}
//直播间优惠券列表
- (void)getLiveActivityCouponsListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_COUPON_LIST param:param returnClass:nil completionBlock:completion];
}
//直播间人数
- (void)getLiveActivityPersonWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_PERSON param:param returnClass:nil completionBlock:completion];
}

//直播口令分享解密
- (void)getLiveCommendDecryptWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_DECRYPT_COMMEND param:param returnClass:nil completionBlock:completion];
}

//直播活动状态
- (void)getLiveStatusWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_STATUS param:param returnClass:nil completionBlock:completion];
}
//直播间口令红包
- (void)getLiveActivityRedPacketInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_RAD_PACKET param:param returnClass:[LiveRoomRedPacketInfo class] completionBlock:completion];
}
//直播间口令红包获取的详情<杨崇攀>
- (void)getLiveActivityRedPacketGetInfoDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_RAD_PACKET_GET_INFO_DETAIL param:param returnClass:[LiveRedPacketResultModel class] completionBlock:completion];
}

//直播间领取优惠券<杨崇攀>
- (void)getLiveActivityReceiveCouponInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_RECEIVE_COUPON param:param returnClass:[CommonCouponNewModel class] completionBlock:completion];
}

////直播列表
- (void)getLiveActivityListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_LIST param:param returnClass:nil completionBlock:completion];
}

////直播预告详情
- (void)getLiveActivityNoticeInfoDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
     [self startPostRequest:API_LIVE_ACTIVITY_NOTICE_INFO_DRETAIL param:param returnClass:[LiveRedPacketResultModel class] completionBlock:completion];
}

///设置/取消设置提醒
- (void)setLiveActivityNoticeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_SET_NOTICE param:param returnClass:nil completionBlock:completion];
}

///直播间主页
- (void)getLiveActivityAnchorMainInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_ACTIVITY_ANCHOR_INFO param:param returnClass:nil completionBlock:completion];
}
///直播的类型
- (void)getLiveTypeInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LIVE_TYPE_INFO param:param returnClass:nil completionBlock:completion];
}

#pragma mark - 消息中心
/// 获取站内信列表
- (void)getMsgListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_GET_STATION_MSG_LIST param:param returnClass:nil completionBlock:completion];
}

/// 获取未推送过的推送消息
- (void)getNoPushMsgWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_GET_NO_PUSH_MSG param:param returnClass:nil completionBlock:completion];
}

#pragma mark - 首页

// 四个接口聚合URL
- (void)requestForBaseInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_BASE_INFO param:param returnClass:nil completionBlock:completion];
}

// 新首页方案选择接口
- (void)getHomeViewOptionInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_HOME_OPTION param:param returnClass:nil completionBlock:completion];
}

// 新首页混合接口
- (void)getHomeBannerNavInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_HOME_BANNER param:param returnClass:nil completionBlock:completion];
}

// 新首页获取轮播图与导航icon接口
- (void)getHomeOftenBuyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_HOME_MIX param:param returnClass:nil completionBlock:completion];
}

// 检查是否显示红包
- (void)queryRedPacketShowWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RED_PACKET_SHOW param:param returnClass:nil completionBlock:completion];
}

// 抽取红包
- (void)queryRedPacketDrawWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_RED_PACKET_DRAW param:param returnClass:nil completionBlock:completion];
}

// 获取消息列表
- (void)queryMessageListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_MESSAGE_LIST param:param returnClass:nil completionBlock:completion];
}
// 获取消息列表
- (void)queryHomeMessageListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_HOME_MESSAGE param:param returnClass:nil completionBlock:completion];
}
// 消息分类详情列表
- (void)queryExpiredMessageWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{    
    [self startPostRequest:API_EXPIRED_MESSAGE param:param returnClass:nil completionBlock:completion];
}

// 获取未读消息列表
- (void)queryReadNotMessageCountWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_NO_READ_COUNT param:param returnClass:nil completionBlock:completion];
}

// 首页常购清单第一页
- (void)queryRecommendMixWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_HOME_RECOMMEND_MIX param:param returnClass:nil completionBlock:completion];
}

// 首页常购城市热销
- (void)querCityHotSaleWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_HOME_RECOMMEND_CITYHOTSALE param:param returnClass:nil completionBlock:completion];
}

// 新版首页推荐tab接口
- (void)fetchHomeRecommendWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_HOME_RECOMMEND param:param returnClass:nil completionBlock:completion];
}

// 首页常购城常买
- (void)queryFrequentlyBuyWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_HOME_RECOMMEND_FREQUENTLYBUY param:param returnClass:nil completionBlock:completion];
}

// 首页商家特惠列表<王梦萱>
- (void)requestForGetHomePreferetialShopProductListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_PREFERETIAL_LIST param:param returnClass:nil completionBlock:completion];
}

// 首页单品包邮<魏庆冰>
- (void)requestForGetHomeSinglePackageRateShopProductListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_SINGLE_PACKAGE_LIST param:param returnClass:nil completionBlock:completion];
}

//首页为您推荐<魏庆冰>
- (void)fetchHomeRecommendForYouWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
    [self startPostRequest:API_HOME_RECOMMEND_YOU_LIST param:param returnClass:nil completionBlock:completion];
}

//首页是否有惊喜提示view<刘峰>
- (void)fetchHomeSurpriseTipViewYesOrFalseWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_HOME_TIP_SURPRISE_VIEW param:param returnClass:nil completionBlock:completion];
}

//首页推广视图显示与否<李生望>
- (void)fetchHomeSpreadTipViewYesOrFalseWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_TIP_SPREAD_VIEW param:param returnClass:nil completionBlock:completion];
}

//首页推广视图点击<李生望>
- (void)fetchHomeSpreadTipViewHideWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_TIP_SPREAD_HIDE_VIEW param:param returnClass:nil completionBlock:completion];
}

//降价专区<魏庆冰>
- (void)fetchCutPriceProductList:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_HOME_CUT_PRICE_PRODUCT_LIST param:param returnClass:nil completionBlock:completion];
}

//城市热销<李生望>
- (void)fetchHomeCityHotSalHotSaleProuctListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
     [self startPostRequest:API_HOME_CITY_HOT_SALLE_LIST param:param returnClass:nil completionBlock:completion];
}

//即将售罄<李生望>
- (void)fetchHomeWillSaleOutWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
     [self startPostRequest:API_HOME_SELLE_OUT_LIST param:param returnClass:nil completionBlock:completion];
}

//一品多商<魏庆冰>
- (void)fetchHomeSameProductMoreSellersProuctListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_SAME_PRD_MORE_SELLERS_LIST param:param returnClass:nil completionBlock:completion];
}

//新品上架<魏庆冰>
- (void)fetchHomenewGoodsOnSaleProuctListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_NEW_GOODS_ON_SALE_LIST param:param returnClass:nil completionBlock:completion];
}
//配置楼层接口<李瑞安>
- (void)fetchHomenFloorListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_FLOOR param:param returnClass:nil completionBlock:completion];
}

//V3配置楼层接口<李瑞安>
- (void)fetchHomenV3FloorListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_V3_FLOOR param:param returnClass:nil completionBlock:completion];
}

/// 首页获取背景图片<李瑞安>
- (void)getBackGroundImage:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_BACK_IMAGE param:param returnClass:nil completionBlock:completion];
}

/// 更新pushid状态<秦涛>
- (void)upLoadPushIdStatus:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_ADS_PUSHIDSTATUS param:param returnClass:nil completionBlock:completion];
}

/// 配置楼层接口<魏庆冰>
- (void)getUnreadCount:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_UNREAD_MSG_COUNT param:param returnClass:nil completionBlock:completion];
}

/// 首页视频详情<李瑞安>
- (void)requestRecommendVideo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_RECOMMEND_VIDEO param:param returnClass:nil completionBlock:completion];
}

/// 获取首页切换的tab<李瑞安>
- (void)requestSwitchTab:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_SWITCH_TAB param:param returnClass:nil completionBlock:completion];
}

/// 获取首页单个tag下的信息流<李瑞安> InfoFollowData
- (void)requestInfoFollowData:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_INFO_FOLLOW_DATA param:param returnClass:nil completionBlock:completion];
}

// 浏览商详页记录浏览次数达30次送券 活动页信息<卢俊>
- (void)requestProductSendCouponInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_PD_PROMOTION_VIEWCOUPONSEND_INFO param:param returnClass:nil completionBlock:completion];
}
#pragma mark - 商详<PD>
// 商品详情
- (void)getProductDetailInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_PRODUCT_DETAIL_INFO param:param returnClass:nil completionBlock:completion];
}

// 浏览商详页记录浏览次数达30次送券<卢俊>
- (void)requestViewCouponSendWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_PD_PROMOTION_VIEWCOUPONSEND param:param returnClass:nil completionBlock:completion];
}
// 商详之满赠
- (void)getProductDetailFullGiftInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_PD_FULL_GIFT param:param returnClass:nil completionBlock:completion];
}

/// 商详上报后台游览数据《李瑞安》
- (void)upLoadViewDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_PD_UPLOAD_VIEWDATA param:param returnClass:nil completionBlock:completion];
}

// 商品详情之返利列表
- (void)getProfitListInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_PD_PROFIT_LIST_INFO param:param returnClass:nil completionBlock:completion];
}

// 多品返利信息
- (void)getProfitRebateInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_PD_PROFIT_REBATE_INFO param:param returnClass:nil completionBlock:completion];
}

// 商详之推荐商品列表
- (void)getProductListForRecommendWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_PD_RECOMMEND_PRODUCT_LIST param:param returnClass:[FKYProductRecommendListModel class] completionBlock:completion];
}

// 商品详情查看优惠券列表<席天翔>
- (void)getCommonCouponListInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_PD_COMMON_COUPON_LIST param:param returnClass:[CommonCouponNewModel class] completionBlock:completion];
}
// 购物车查看优惠券列表<席天翔>
- (void)getCommonCouponListInfoInEnterpriseIdWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_PD_COMMON_COUPON_LIST_ENTERPRISEID param:param returnClass:[CommonCouponNewModel class] completionBlock:completion];
}

// 领取优惠券接口
- (void)postReceiveCommonCouponInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_PD_COMMON_COUPON_RECEIVE_INFO param:param returnClass:[CouponModel class] completionBlock:completion];
}

//商详页立即下单商品校验
- (void)postCheckSimpleItemInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_PD_CHECK_SOMPLE_ITEM param:param returnClass:[PDOrderChangeInfoModel class] completionBlock:completion];
}

//降价登记
- (void)postLowPriceInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_LOW_PRICE_NOTICE param:param returnClass:[PDOrderChangeInfoModel class] completionBlock:completion];
}
//到货通知商品推荐
- (void)postArrivalRecommendProductInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_ARRIVAL_RECOMMOD_NOTICE param:param returnClass:nil completionBlock:completion];
}
#pragma mark - 搜索
// 搜索商品接口
- (void)requestSearchProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOME_SEARCH_PRODUCT param:param returnClass:nil completionBlock:completion];
}
// 搜索发现接口
- (void)sendSearchFoundWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_HOME_SEARCH_FOUND param:param returnClass:nil completionBlock:completion];
}

// 发送搜索关键词 第一个数据
- (void)sendSearchDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_SEND_SEARCH_DATA param:param returnClass:nil completionBlock:completion];
}

// App搜索无结果或者异常时调用
- (void)sendSearchDataForNoResultWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_SEARCH_SEND_DATA_FOR_NO_RESULT param:param returnClass:nil completionBlock:completion];
}

// 获取商品规格
- (void)getProductRankDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_GET_PRODUCT_RANK_DATA param:param returnClass:nil completionBlock:completion];
}

// 优惠券可用商品列表
- (void)getProductByCouponWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_GET_PRODUCT_WITH_COUPON param:param returnClass:nil completionBlock:completion];
}
// 搜索用户注册地主仓接口
- (void)queryLocalMainStoreInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_GET_SEARCH_SHOP_INFO param:param returnClass:nil completionBlock:completion];
}
 
////MP钩子商品接口
- (void)queryMPHookGoodWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_GET_SEARCH_MP_INFO param:param returnClass:nil completionBlock:completion];
}

// 三级类目热销榜单对外接口热销榜单钩子
- (void)querySearchHotsellInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_GET_SEARCH_HOTSELL_INFO param:param returnClass:nil completionBlock:completion];
}

/// 获取搜店铺时候的发现列表
- (void)requestSearchFoundListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_GET_SEARCH_FOUND_LIST param:param returnClass:nil completionBlock:completion];
}
#pragma mark -店铺馆相关接口
// 店铺馆三个标题
- (void)requestForTabTitleListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_COLLECT_TAB_TITLE_LIST param:param returnClass:nil completionBlock:completion];
}
// 商家促销
- (void)requestForProductPromotionListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_COLLECT_PRODUCT_PROMOTION_LIST param:param returnClass:nil completionBlock:completion];
}
// 店铺列表
- (void)requestForMainShopListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
    [self startPostRequest:API_SHOP_COLLECT_SHOP_LIST param:param returnClass:nil completionBlock:completion];
}
// 全部店铺列表
- (void)requestForAllShopListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_ALL_SHOP_LIST param:param returnClass:nil completionBlock:completion];
}
// 店铺馆首页
- (void)requestForMPHomeShopActivityListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_COLLECT_SHOP_ACTIVITY_LIST param:param returnClass:nil completionBlock:completion];
}
//获取旗舰店icon
- (void)requestForFlagShipShopListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_FLAG_SHIP_LIST param:param returnClass:nil completionBlock:completion];
}
#pragma mark - 店铺内
// 全部商品里的商品分类
- (void)requestForProductCategoryInShopWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_PRODUCT_CATEGORY param:param returnClass:nil completionBlock:completion];
}

// 全部商品
- (void)requestForAllProducInShopWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_ALL_PRODUCT param:param returnClass:nil completionBlock:completion];
}

#pragma mark - 购物车

// 获取购物车中商品数量
- (void)requestForProductNumberInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_CART_PRODUCT_NUMBER param:param returnClass:nil completionBlock:completion];
}

// 修改商品购买数量
- (void)updateProductNumberInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CART_PRODUCT_UPDATE_NUMBER param:param returnClass:nil completionBlock:completion];
}

// 删除商品
- (void)deleteProductInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CART_PRODUCT_DELETE param:param returnClass:nil completionBlock:completion];
}

// 变更商品勾选状态
- (void)updateProductCheckSattusInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CART_PRODUCT_CHECK_STATUS param:param returnClass:nil completionBlock:completion];
}

// 获取进货单列表
- (void)requestForProductListInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CART_PRODUCT_LIST param:param returnClass:nil completionBlock:completion];
}

// 结算校验
- (void)sumitCheckCheckSattusInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CART_PRODUCT_SUBMIT param:param returnClass:nil completionBlock:completion];
}

#pragma mark - 优惠券
- (void)requestForThousandCouponsInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_PROMTION_COUPON_SEND param:param returnClass:[FKYThousandCouponDetailModel class] completionBlock:completion];
}


#pragma mark - 资料管理

// 经营范围
- (void)requestForDrugScopeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_DRUG_SCOPE param:param returnClass:[DrugScopeModel class] completionBlock:completion];
}

// 通过企业名称关键词来模糊查询企业名称
- (void)requestForEnterpriseNameFromErpWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_ENTERPRISE_NAME_ERP param:param returnClass:nil completionBlock:completion];
}

// 通过企业名称获取企业信息
- (void)requestForEnterpriseInfoFromErpWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_ENTERPRISE_INFO_ERP param:param returnClass:[ZZEnterpriseInfo class] completionBlock:completion];
}

// 查询资质信息
- (void)requestForEnterpriseDocInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_ENTERPRISE_DOC_INFO param:param returnClass:[ZZModel class] completionBlock:completion];
}

// 提交资质信息1...<包括企业信息与收货信息>
- (void)requestForSubmitEnterpriseTextInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_SUBMIT_ENTERPRISE_TEXT_INFO param:param returnClass:nil completionBlock:completion];
}

// 提交资质信息2...<包括所有的资质图片信息>
- (void)requestForSubmitEnterpriseImageInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_SUBMIT_ENTERPRISE_IMAGE_INFO param:param returnClass:nil completionBlock:completion];
}

// 获取企业注册需要的所有资质列表
- (void)requestForGetEnterpriseImageListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_ENTERPRISE_IMAGE_UPLOAD_LIST param:param returnClass:[RIQualificationModel class] completionBlock:completion];
}

// （资质）提交审核
- (void)requestForSubmitQualificationReviewWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_SUMBIT_QUALIFICATION_REVIEW param:param returnClass:nil completionBlock:completion];
}


#pragma mark - 个人中心
///切换账号
- (void)requestChangeUserWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_USER_CHANGE_USER param:param returnClass:nil completionBlock:completion];
}
 
///获取退换货银行信息
- (void)requestForSaleReturnBankInfoListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_USER_GET_SALE_RETURN_BANK_INFO param:param returnClass:[FKYInvoiceModel class] completionBlock:completion];
//    [self startPostRequest:API_USER_GET_SALE_RETURN_BANK_INFO param:param returnClass:[FKYInvoiceModel class] completionBlock:completion];
}

///获取发票银行列表
- (void)requestForBankListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_USER_GET_INVOICE_BANK_LIST param:param returnClass:[FKYInvoiceModel class] completionBlock:completion];
}

//获取个人中心开票信息
- (void)requestForInvoiceInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_USER_GET_INVOICE_INFO param:param returnClass:[FKYInvoiceModel class] completionBlock:completion];
}

//保存发票信息
- (void)requestForSaveInvoiceInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_USER_SAVE_INVOICE_INFO param:param returnClass:nil completionBlock:completion];
}

// 校验注册的时候用户名是否存在<开发_熊文友>
- (void)requestForValidateUserNameWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_POST_VALIDATE_USER param:param returnClass:nil completionBlock:completion];
}

// 注册校验bd号码
- (void)requestForValidateBdMobileWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_USER_REGISTRE_BDMOBILE param:param returnClass:nil completionBlock:completion];
}

// 获取图形验证码接口
- (void)requestForGetImageCodeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    //[self startPostRequest:API_USER_GET_IMAGE_CODE param:param returnClass:nil completionBlock:completion];
    
    // 解析完数据后带个性化处理~!@
    HJOperationParam *operationParam = [FKYWebService postRequest:API_USER_GET_IMAGE_CODE param:param returnClass:[FKYAccountPicCodeModel class] success:^(id response, id model) {
        // 成功
        if (model && [model isKindOfClass:[FKYAccountPicCodeModel class]]) {
            ((FKYAccountPicCodeModel *)model).imageData = [[NSData alloc] initWithBase64EncodedString:((FKYAccountPicCodeModel *)model).imgsrc options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }
        completion(YES, nil, response, model);
    } failure:^(id response, NSError *error) {
        // 失败
        completion(NO, error, nil, nil);
    }];
    [self.operationManger requestWithParam:operationParam];
}

// 获取短信验证码（注册）
- (void)requestForGetRegisterMessageCodeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_REGISTER_GET_SMS_CODE param:param returnClass:nil completionBlock:completion];
}

// 注册
- (void)requestForRegisterWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_REGISTER_ACTION param:param returnClass:nil completionBlock:completion];
}

// 登录
- (void)requestForLoginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_LOGIN_ACTION param:param returnClass:nil completionBlock:completion];
}

//短信验证码登录
- (void)requestForLoginBySMSWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_LOGIN_SMS_ACTION param:param returnClass:nil completionBlock:completion];
}

// 查询是否有注册激活送券活动
- (void)requestForRegisterCouponWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_REGISTER_COUPON param:param returnClass:nil completionBlock:completion];
}

// 获取短信验证码（找回密码处）
- (void)requestForGetSMSCodeDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_SMS_CODE param:param returnClass:nil completionBlock:completion];
}

// 获取短信验证码接口（登录）
- (void)requestForGetLoginSMSCodeDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_LOGIN_SMS_CODE param:param returnClass:nil completionBlock:completion];
}

//  验证短信短信（找回密码处）
- (void)checkSMSCodeDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_CHECK_SMS_CODE param:param returnClass:nil completionBlock:completion];
}

//  重置密码（找回密码处）
- (void)changePasswordDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_CHANGE_PASSWORD param:param returnClass:nil completionBlock:completion];
}

//修改密码（设置处）
- (void)resetPasswordDataInUserSetWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_RESET_PASSWORD param:param returnClass:nil completionBlock:completion];
}

// 获取返利金详情
- (void)requestForGetRebateDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_REBATE_AMOUNT param:param returnClass:nil completionBlock:completion];
}

// 获取返利金可用商家列表
- (void)requestForGetRebateDetailListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_REBATE_DETAIL param:param returnClass:nil completionBlock:completion];
}

// 根据客户企业id查询待到账返利金列表明细（分页）
- (void)requestRebatePendingDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_DELAY_REBATE_AMOUNT param:param returnClass:nil completionBlock:completion];
}

// 获取用户是否是vip
- (void)requestForUserVipDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_VIP_DETAIL param:nil returnClass:[FKYVipDetailModel class] completionBlock:completion];
}

// 根据企业id判断是否显示im入口
- (void)requesImShowWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_IM_SHOW_URL param:param returnClass:nil completionBlock:completion];
}

// 修改密码时企业联系词接口<望神>
- (void)requestForCompanyAboutWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_GET_COMPANY_ABOUT param:param returnClass:[FKYAssCompanyModel class] completionBlock:completion];
}

// 找回密码第一步<输入手机号或者企业和图像验证码><望神>
- (void)requestForFindPasswordOneWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_POST_PWD_ONE param:param returnClass:[FKYRetrieveOneModel class] completionBlock:completion];
}

// 找回密码第二步<输入手机号验证码><望神>
- (void)requestForFindPasswordTwoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_POST_PWD_TWO param:param returnClass:nil completionBlock:completion];
}

// 找回密码第三步<输入手机号或者企业和图像验证码><望神>
- (void)requestForFindPasswordThreeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_POST_PWD_THREE param:param returnClass:nil completionBlock:completion];
}

// 找回密码第二步获取业务员信息<望神>
- (void)requestForSalesPersonInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_USER_POST_SALES_PERSON_INFO param:param returnClass:[FKYSalesPersonInfoModel class] completionBlock:completion];
}

// 找回密码获取图形验证码接口<望神>
- (void)requestForGetImageCodeInPasswordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    // 解析完数据后带个性化处理~!@
    HJOperationParam *operationParam = [FKYWebService postRequest:API_USER_GET_PICTURE_CODE param:param returnClass:[FKYAccountPicCodeModel class] success:^(id response, id model) {
        // 成功
        if (model && [model isKindOfClass:[FKYAccountPicCodeModel class]]) {
            ((FKYAccountPicCodeModel *)model).imageData = [[NSData alloc] initWithBase64EncodedString:((FKYAccountPicCodeModel *)model).imgsrc options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }
        completion(YES, nil, response, model);
    } failure:^(id response, NSError *error) {
        // 失败
        completion(NO, error, nil, nil);
    }];
    [self.operationManger requestWithParam:operationParam];
}

// 找回密码获取短信验证码接口<望神>
- (void)requestForGetSMSCodeDataInPasswordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startGetRequest:API_USER_GET_SMS_PAS_CODE param:param returnClass:nil completionBlock:completion];
}

// 购物金短信验证码接口<望神>
- (void)requestForValidateSMSCodeDataInPasswordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
    [self startGetRequest:API_USER_VALIDATE_SMS_PAS_CODE param:param returnClass:nil completionBlock:completion];
}

// 我的余额
- (void)requestMyRebateWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_MY_REBATE param:param returnClass:[FKYMyRebateModel class] completionBlock:completion];
}

// 返利金记录
- (void)requestRebateRecordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_REBATE_RECORD param:param returnClass:[FKYRebateRecordModel class] completionBlock:completion];
}

/// 获取订单下方推荐品列表
- (void)getRequestRecommendProductList:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_RECOMMEND_LIST param:param returnClass:nil completionBlock:completion];
}

/// 获取抽奖信息
- (void)getRequestDrawInfo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_DRAW_INFO param:param returnClass:nil completionBlock:completion];
}

/// 开始抽奖
- (void)postRequestStartDraw:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_START_DRAW param:param returnClass:nil completionBlock:completion];
}

/// 提交绑定银行卡信息
- (void)postSubmitBankCardInfo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SUBMIT_BANDING_INFO param:param returnClass:nil completionBlock:completion];
}

/// 绑定银行卡界面发送短信验证码
- (void)postSendVerificationCodeInBandingView:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SEND_VERIFICATIONCODE_BANDING param:param returnClass:nil completionBlock:completion];
}

/// 验证手机验证码
- (void)postCheckVerificationCod:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_CHECK_VERIFICATIONCODE param:param returnClass:nil completionBlock:completion];
}

/// 修改个人信息
- (void)postUpdataBankCardInfo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_UPDATA_BANK_CARD_INFO param:param returnClass:nil completionBlock:completion];
}

/// 绑定银行卡界面获取银行卡列表
- (void)postRequestBankList:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_REQUEST_BANK_LIST param:param returnClass:nil completionBlock:completion];
}

/// 提交药店福利申请信息
- (void)postsubmitApplyWalfareTableInfo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SUBMIT_APPLY_WALFARE_TABLE_INFO param:param returnClass:nil completionBlock:completion];
}

#pragma mark - 上传图片相关

// 上传图片...<新接口>
- (void)requestForUploadPicWithParam:(NSDictionary *)param image:(UIImage *)image data:(NSData *)imgData completionBlock:(RequestServiceBlock)completion
{
    // 上传manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 上传
    [manager POST:API_YC_UPLOAD_IMAGE parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传的图片数据...<文件流方式>
        if (imgData) {
            [formData appendPartWithFileData:imgData name:@"file" fileName:@"ycpic.jpg" mimeType: @"image/jpeg"];
            return;
        }
        if (image) {
            // 若图片数据未包在param中，则需要在当前block中加入
            NSData *dataImg = UIImageJPEGRepresentation(image, 0.9);
            [formData appendPartWithFileData:dataImg name:@"file" fileName:@"ycpic.jpg" mimeType: @"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 请求成功
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] == YES) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSNumber *result = dic[@"result"]; // 上传成功/失败
            NSString *url = dic[@"url"]; // url路径仅包含主域名后的路径，完整路径需要应用自己拼接。
            NSString *msg = dic[@"msg"]; // 上传失败，返回失败信息
            if (result && result.boolValue == YES) {
                // 上传成功
                if (url && url.length > 0) {
                    // 有返回url...<真正的成功>
                    // url: img/yc/e601f571c70b4ec78bba749135ba8e06
                    // final url: http://m.111.com.cn/img/yc/e601f571c70b4ec78bba749135ba8e06
                    completion(YES, nil, dic, [NSString stringWithFormat:@"%@/%@", kImageDownloadHost, url]);
                }
                else {
                    // 未返回url
                    completion(NO, nil, nil, msg);
                }
                return;
            }
            else {
                // 上传失败
                completion(NO, nil, nil, msg);
                return;
            }
        }
        // 上传失败...<无返回值>
        completion(NO, nil, nil, @"上传失败");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 请求失败
        completion(NO, error, nil, @"上传失败");
    }];
}

// 上传图片...<老接口>
- (void)uploadIMMessagePicture:(UIImage *)img param:(NSDictionary *)param uploadUrl:(NSString *)uploadUrl completionBlock:(RequestServiceBlock)completion
{
    // 1. 压缩图片
    NSData *cData = UIImageJPEGRepresentation(img, 1.0);
    float zipScale = 1.0;
    // 对于大于2M的图片先压缩比例大一点
    while (cData.length > 1024 * 1024 * 2) {
        zipScale = zipScale * 0.5;
        UIImage *desImg = [img imageScaleDown:zipScale];
        cData = UIImageJPEGRepresentation(desImg, 1.0);
    }
    // 压缩图片（小于1.2M）
    while (cData.length > 1024 * 1024 * 1.2) {
        zipScale = zipScale * 0.85;
        UIImage *desImg = [img imageScaleDown:zipScale];
        cData = UIImageJPEGRepresentation(desImg, 1.0);
    }
    if (cData == nil) {
        NSError *error = [NSError errorWithDomain:@"pic" code:-4 userInfo:@{NSLocalizedDescriptionKey:@"图片压缩失败"}];
        completion(NO, error, nil, nil);
        return;
    }
    
    // 上传图片
    NSString *url = uploadUrl.length > 0 ? uploadUrl : API_YC_UPLOAD_PIC;
    [FKYWebService uploadImage:url data:cData param:param returnClass:nil success:^(id response, id model) {
        completion(YES, nil, response, model);
    } failure:^(id response, NSError *error) {
        completion(NO, error, nil, nil);
    }];
}


#pragma mark - BI埋点

// BI埋点
- (void)requestForBIWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    HJOperationParam *operationParam = [FKYWebService getBiRequest:API_YC_BI_RECORD param:param returnClass:nil success:^(id response, id model) {
        // 成功
        completion(YES, nil, response, model);
    } failure:^(id response, NSError *error) {
        // 失败
        completion(NO, error, nil, nil);
    }];
    [self.operationManger requestWithParam:operationParam];
}


#pragma mark - 注册地址<三级>

// 获取省份
- (void)requestForGetProvinceWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_REGISTER_ADDRESS_GET_PROVINCE param:param returnClass:[RegisterAddressModel class] completionBlock:completion];
}

// 根据省份编码获取市
- (void)requestForGetCityWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_REGISTER_ADDRESS_GET_CITY param:param returnClass:[RegisterAddressModel class] completionBlock:completion];
}

// 根据市编码获取区
- (void)requestForGetDistrictWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_REGISTER_ADDRESS_GET_DISTRICT param:param returnClass:[RegisterAddressModel class] completionBlock:completion];
}

// 根据省市区名称或者编码匹配省市区数据信息
- (void)requestForQueryNameOrCodeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion
{
    [self startPostRequest:API_REGISTER_ADDRESS_QUERY_NAME_CODE param:param returnClass:[RegisterAddressQueryModel class] completionBlock:completion];
}

#pragma mark - 店铺详情相关
//店铺商家信息(头部信息及开户，发票，入库，公告)<废用>
- (void)requestForGetShopEnterpriseInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
    [self startPostRequest:API_SHOP_DETAIL_ENTERPRISE_INFO param:param returnClass:[FKYShopEnterInfoModel class] completionBlock:completion];
}
//店铺商家信息(头部信息及优惠券信息-李瑞安)
- (void)requestForGetShopEnterpriseInfoAndCouponInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
    [self startPostRequest:API_SHOP_DETAIL_ENTERPRISE_AND_COUPON_LIST_INFO param:param returnClass:[FKYShopEnterAndCouponInfoModel class] completionBlock:completion];
}
//店铺商家信息(为你推荐商品-李瑞安)
- (void)requestForGetShopRecommendProductListInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_RECOMMEND_PRODUCT_LIST_INFO param:param returnClass:[FKYShopRecommendInfoModel class] completionBlock:completion];
}
//店铺商家信息(运营配置楼层-李瑞安)
- (void)requestForGetShopOperateCellProductListInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_OPERATE_CELL_LIST_INFO param:param returnClass:[FKYShopOperateCellModel class] completionBlock:completion];
}
//店铺商家信息(商家促销及优惠券)
- (void)requestForGetShopPromotionBaseInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion {
    [self startPostRequest:API_SHOP_DETAIL_PROMOTION_BASE_INFO param:param returnClass:[FKYShopPromotionInfoModel class] completionBlock:completion];
}
//店铺的企业资质
- (void)requestForGetShopQualificationInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_DETAIL_QUALIFICATION_INFO param:param returnClass:[FKYEnterQualificationModel class] completionBlock:completion];
}
//店铺是否收藏
- (void)requestForGetShopCollectionInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_DETAIL_COLLECTION_INFO param:param returnClass:nil completionBlock:completion];
}
//店铺收藏与取消
- (void)requestForGetShopAddOrCancellCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOP_DETAIL_ADD_CANCELL_COLLECTION_INFO param:param returnClass:nil completionBlock:completion];
}
#pragma mark - 新品登记相关

// 提交新品信息
- (void)requestForSubmitNewProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_STANDARD_SUBMIT_NEW param:param returnClass:[FKYNewPrdSetModel class] completionBlock:completion];
}
// 获取标品列表
- (void)requestForGetStandardProductSetListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
//    [self startPostRequest:API_STANDARD_PRODUCT_LIST param:param returnClass:[FKYNewPrdSetModel class] completionBlock:completion];
    [self startGetRequest:API_STANDARD_PRODUCT_LIST param:param returnClass:nil completionBlock:completion];
}
//新品登记历史列表
- (void)requestForGetNewProductSetListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_NEW_PRODUCT_LIST param:param returnClass:[FKYNewPrdSetModel class] completionBlock:completion];
}
//新品登记详情
- (void)requestForGetNewProductSetDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_NEW_PRODUCT_DETAIL param:param returnClass:[FKYNewPrdSetItemModel class] completionBlock:completion];
}
//城市热销推荐
- (void)requestForGetCityHotRegionProductListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_HOT_REGION_LIST param:param returnClass:[FKYHotSaleModel class] completionBlock:completion];
}
#pragma mark - 专区相关

/// 获取搭配套餐列表
- (void)requestForMatchingPackageListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_MATCHING_PACKAGE_LIST param:param returnClass:nil completionBlock:completion];
}

/// 获取高毛专区商品列表
- (void)requestForGetHeightGrossMarginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_HEIGHT_GROSS_MARGIN param:param returnClass:nil completionBlock:completion];
}
/// 获取满折专区商品列表
- (void)requestForFullDiscountMarginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_FULLDISCOUNT_PRODUCT_MARGIN param:param returnClass:nil completionBlock:completion];
}
// 获取特价专区商品列表
- (void)requestForSpecialMarginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
     [self startPostRequest:API_SPECIAL_PRODUCT_MARGIN param:param returnClass:nil completionBlock:completion];
}
//多品返利专区
- (void)requestForRebateMarginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_REBATE_PRODUCT_MARGIN param:param returnClass:nil completionBlock:completion];
}
//一键入库口令解析
- (void)requestForIpurchaseEntrancePopupWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_ENTRANCE_POPUP param:param returnClass:nil completionBlock:completion];
}
#pragma mark - 药福利相关
//查询药福利开店信息
- (void)requestForGetYflOpenShopInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startGetRequest:API_YFL_OPEN_SHOP_INFO param:param returnClass:[FKYYflInfoModel class] completionBlock:completion];
}

#pragma mark - 个人中心相关
/// 查询套餐优惠入口信息
- (void)requestPostForDiscountPackageInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_DISCOUNT_PACKAGE_ENTRY_INFO param:param returnClass:[FKYHotSaleModel class] completionBlock:completion];
}

/// 获取购物金活动列表
- (void)requestPostForRechargeActivityInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_RECHARGE_ACTIVITY_INFO param:param returnClass:[FKYHotSaleModel class] completionBlock:completion];
}

/// 查询购物金余额信息
- (void)requestPostForShoppingMoneyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOPPING_MONEY_INFO param:param returnClass:[FKYHotSaleModel class] completionBlock:completion];
}

/// 查询购物金流水
- (void)requestPostForShoppingMoneyRecordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOPPING_MONEY_RECORD param:param returnClass:[FKYHotSaleModel class] completionBlock:completion];
}

/// 预充值
- (void)requestPostForShoppingMoneyPrechargeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion{
    [self startPostRequest:API_SHOPPING_MONEY_PRECHARGE param:param returnClass:[FKYHotSaleModel class] completionBlock:completion];
}

@end
