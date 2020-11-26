//
//  FKYApiList.h
//  FKY
//
//  Created by 夏志勇 on 2018/12/18.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  所有接口列表

#ifndef FKYApiList_h
#define FKYApiList_h


#pragma mark - 退换货<RC>

// 申请退换货原因
static NSString *const API_RC_APPLY_REASON_LIST = @"aftersales/ocs/queryApplySelectList";

// 提交退换货信息(申请退换货)
static NSString *const API_RC_APPLY_RETURN_CHANGE = @"aftersales/ocs/saveOcsRmaApply";

// mp提交退换货信息(申请退换货)
static NSString *const API_RC_MP_APPLY_RETURN_CHANGE = @"api/order/confirmSaleReturn";

// 快递公司列表
static NSString *const API_RC_SEND_COMPANY_LIST = @"erp/courier/courierList";

// 提交回寄信息
static NSString *const API_RC_SUBMIT_RETURN_INFO = @"aftersales/ocs/submitUserExpress";

// 订阅物流日志
static NSString *const API_RC_SUBSCRIBE_SEND_INFO = @"erp/logistics/subscribe";

// 获取物流日志
static NSString *const API_RC_QUERY_LOGISTICES_LIST_INFO = @"erp/logistics/queryLogisticsList";

// 根据第三方订单（药城订单）ID查询药网子单
static NSString *const API_RC_QUERY_ORDERID_INFO = @"erp/ycSalesOrder/queryChildOrderByOutOrderId";

// 查询可退换货数量
static NSString *const API_RC_GET_COUNTS_INFO = @"erp/ycSalesOrder/getRmaCountsByOrderId";

// 查询MP可退换货数量<閤亚峰>
static NSString *const API_RC_MP_GET_COUNTS_INFO = @"api/order/listPaginationReturn";

// 撤销退换货申请
static NSString *const API_RC_CANCEL_RMA_APPLY = @"aftersales/ocs/cancleOcsRmaApply";

// mp订单撤销退换货申请
static NSString *const API_RC_MP_CANCEL_RMA_APPLY = @"api/order/buyerCancelRefundOrder";

// 查看退换货申请...<退换货详情>
static NSString *const API_RC_GET_APPLY_INFO = @"aftersales/ocs/getOcsRmaApplyInfo";

// 查询订单的所有退换货记录...<退换货列表>
static NSString *const API_RC_QUERY_RMA_ORDER_LIST = @"aftersales/ocs/queryUserRmaOrderList";

// 换货返回物流...<卖家寄回信息>
static NSString *const API_RC_QUERY_TMS_LOG_CHILDORDERID = @"erp/order/queryTmsLogByChildOrderId";


#pragma mark - 售后工单<AS>

// 判断是否展示极速理赔《夏沼润》
static NSString *const API_AS_APPLY_SERVICE_TYPE_SHOW_COMP = @"aftersales/ocs/isExistRapidClaim";

// 获取已申请记录列表《李生望》
static NSString *const API_AS_APPLY_SERVICE_TYPE = @"ycapp/ass/workServiceType";

// 获取可申请售后列表《李生望》
static NSString *const API_AS_APPLY_ORDER_LIST = @"ycapp/ass/workOrderList";

// 获取全部订单的售后列表(王戈强)
static NSString *const API_All_AS_APPLY_ORDER_LIST = @"aftersales/asAndWorkOrder/queryAsAndWorkOrderList";

// 根据服务类型id和子订单号获取服务类型详情信息
static NSString *const API_AS_APPLY_DETAIL_INFO = @"aftersales/workorder/queryAssWorkServiceTypeDetail";

// 提交工单信息
static NSString *const API_AS_APPLY_SAVE_INFO = @"aftersales/workorder/saveAssWorkOrderForB2B";

// 获取工单基本信息
static NSString *const API_AS_APPLY_BASE_INFO = @"ycapp/ass/applyWorkOrder";


#pragma mark - 检查订单、提交订单<CO>

// 检查订单
static NSString *const API_CO_CHECK_ORDER = @"api/cart/checkOrder";

// 提交订单...<普通订单-邹超>
//static NSString *const API_CO_SUBMIT_ORDER_NORMAL = @"api/cart/submitOrdinaryOrder";
//static NSString *const API_CO_SUBMIT_ORDER_NORMAL = @"api/order/submitShopCart";
static NSString *const API_CO_SUBMIT_ORDER_NORMAL = @"api/cart/submitOrdinaryOrder";

// 提交订单...<一起购订单-邹超>
//static NSString *const API_CO_SUBMIT_ORDER_GROUP_BUY = @"api/cart/submitGroupBuyOrder";
//static NSString *const API_CO_SUBMIT_ORDER_GROUP_BUY = @"api/groupBuy/createGroupBuyOrder";
static NSString *const API_CO_SUBMIT_ORDER_GROUP_BUY = @"api/cart/submitGroupBuyOrder";

// 查看用户资质状态...<判断用户是否可以提交订单>
static NSString *const API_CO_CHECK_QUALIFICATION_STATUS = @"api/order/checkEnterpriseQualification";

// 在线支付方式列表 /orderPay/V2/getAppPayTypeList
static NSString *const API_CO_GET_ONLINE_PAY_TYPE = @"orderPay/V3/getAppPayTypeList";

// 获取上次在线支付方式...<商家维度>
static NSString *const API_CO_GET_ONLINE_PAY_TYPE_SAVED = @"api/order/getOrderTypeRecently";

// 快捷支付获取流水号并且自动发送短信
static NSString *const API_CO_GET_ONLINE_QUICKPAY_TYPE_BANK = @"shBank/pay";

// 快捷支付 支付确认接口
static NSString *const API_CO_GET_ONLINE_QUICKPAY_TYPE_CONFIRM = @"shBank/directRechargeConfirm";

// 上海银行支付状态主动获取接口
static NSString *const API_GET_QUICKPAY_STATUS = @"shBank/getPayStatus";


// 获取花呗分期列表数据
static NSString *const API_CO_GET_ALIPAY_INSTALMENT_LIST = @"aliappPay/getAliHbPayInstalmentAmount";

// 请求收款方账户信息...<商家银行信息>
static NSString *const API_CO_GET_ENTERPRISE_BANK_INFO = @"orderPay/enterprise/bankInfo";

// 请求订单分享签名
static NSString *const API_CO_GET_ORDER_SHARE_SIGN = @"pay/another/sign";

// 获取支持的银行列表《黎凯》
static NSString *const API_CO_GET_BANK_LIST = @"shBank/getBankList";

#pragma mark - 订单详情相关

// 电子发票发送到邮箱
static NSString *const API_SEND_INVOICE_TO_MAIL = @"ycapp/invoice/sendEmail";


#pragma mark - 买家投诉卖家

// mp订单投诉
static NSString *const API_ORDER_COMPLAINT = @"api/order/complaint";


#pragma mark - 启动<Launch>

// 获取站点
static NSString *const API_LAUNCH_GET_SITE = @"ycapp/getCurrentProvince";

// 保存个推信息
static NSString *const API_LAUNCH_SAVE_DEVICE = @"ycapp/mobile/saveDevice";


#pragma mark - 直播
//直播当前正在讲解的商品
static NSString *const API_LIVE_CURRECT_PRODUCT = @"ycapp/live/current/product";
//直播所有商品列表
static NSString *const API_LIVE_ALL_PRODUCT = @"ycapp/live/all/product";
//直播推荐品
static NSString *const API_LIVE_RECOMMEND_PRODUCT = @"ycapp/live/recommend/product";
//直播间活动详情
static NSString *const API_LIVE_ACTIVITY_DETAIL = @"ycapp/live/activity/detail";
//直播间优惠券
static NSString *const API_LIVE_ACTIVITY_COUPON_LIST = @"ycapp/live/coupon";
//直播间人数
static NSString *const API_LIVE_ACTIVITY_PERSON = @"ycapp/live/activity/person";
//直播口令分享解密
static NSString *const API_LIVE_ACTIVITY_DECRYPT_COMMEND = @"ycapp/live/decryptCommend";
//直播活动状态
static NSString *const API_LIVE_ACTIVITY_STATUS = @"ycapp/live/activity/status";
//直播间口令红包
static NSString *const API_LIVE_ACTIVITY_RAD_PACKET = @"ycapp/live/redPacket";
//直播间口令红包获取详情<杨崇攀>
static NSString *const API_LIVE_ACTIVITY_RAD_PACKET_GET_INFO_DETAIL = @"promotion/draw/pwdRedPacket";
////直播间领取优惠券<杨崇攀>
static NSString *const API_LIVE_ACTIVITY_RECEIVE_COUPON = @"promotion/coupon/liveStreamingCouponReceiveByTemplateCode";
////直播列表
static NSString *const API_LIVE_ACTIVITY_LIST = @"ycapp/live/activity/list";
////直播预告详情
static NSString *const API_LIVE_ACTIVITY_NOTICE_INFO_DRETAIL = @"ycapp/live/preview/detail";
///设置/取消设置提醒
static NSString *const API_LIVE_ACTIVITY_SET_NOTICE = @"ycapp/live/addAndCancelNotice";
///直播间主页
static NSString *const API_LIVE_ACTIVITY_ANCHOR_INFO = @"ycapp/live/roomMain";
///直播间显示页面
static NSString *const API_LIVE_TYPE_INFO = @"ycapp/live/getLiveListType";
#pragma mark - 首页

// 新首页方案选择接口
static NSString *const API_HOME_OPTION = @"mobile/home/option";

// 新首页混合接口
static NSString *const API_HOME_MIX = @"mobile/home/mix";

// 新首页获取轮播图与导航icon接口
static NSString *const API_HOME_BANNER = @"mobile/home/bannerNavigation";

// 检查是否显示红包
static NSString *const API_RED_PACKET_SHOW = @"promotion/redpacket/show";

// 抽取红包
static NSString *const API_RED_PACKET_DRAW = @"promotion/redpacket/draw";

// 获取消息列表
static NSString *const API_MESSAGE_LIST = @"im/notice/allList";

/// 获取站内信列表
static NSString *const API_GET_STATION_MSG_LIST = @"ycapp/message/home/new";

/// 获取未推送过的推送消息
static NSString *const API_GET_NO_PUSH_MSG = @"ycapp/message/unread/list";

// 消息分类详情列表
static NSString *const API_EXPIRED_MESSAGE = @"ycapp/message/detail/list";

// 获取消息列表
static NSString *const API_HOME_MESSAGE = @"ycapp/message/home";

// 获取未读消息数量
static NSString *const API_NO_READ_COUNT = @"im/notice/unreadCount";

// 首页常购清单第一页
static NSString *const API_HOME_RECOMMEND_MIX = @"mobile/home/mixRecommend";
// 首页常购城市热销
static NSString *const API_HOME_RECOMMEND_CITYHOTSALE = @"home/recommend/cityHotSale";
// 首页常购城常买
static NSString *const API_HOME_RECOMMEND_FREQUENTLYBUY = @"home/recommend/frequentlyBuy";

// 新版首页推荐tab接口
static NSString *const API_HOME_RECOMMEND = @"mobile/home/homeRecommend";

// 首页商家特惠列表
static NSString *const API_HOME_PREFERETIAL_LIST = @"promotion/sellerTehuiList.json";

// 首页单品包邮<魏庆冰>
static NSString *const API_HOME_SINGLE_PACKAGE_LIST = @"ycapp/singlePackageList";

// 首页为您推荐列表
static NSString *const API_HOME_RECOMMEND_YOU_LIST = @"home/recommendForYou";

// 首页是否有惊喜提示view<刘峰>
static NSString *const API_HOME_TIP_SURPRISE_VIEW = @"promotion/viewProductSendCouponSwitch";

// 首页欢迎视图显示与否<李生望>
static NSString *const API_HOME_TIP_SPREAD_VIEW = @"ycapp/ipurchase/homeTips";

// 首页欢迎视图点击<李生望>
static NSString *const API_HOME_TIP_SPREAD_HIDE_VIEW = @"ycapp/ipurchase/closeTips";

// 城市热销
static NSString *const API_HOME_CITY_HOT_SALLE_LIST = @"home/recommend/loadCityHotSale";

// 首页为您推荐列表
static NSString *const API_HOME_SELLE_OUT_LIST = @"home/recommend/loadSoldOut";

//降价专区<魏庆冰>
static NSString *const API_HOME_CUT_PRICE_PRODUCT_LIST = @"ycapp/zone";

//一品多商<魏庆冰>
static NSString *const API_HOME_SAME_PRD_MORE_SELLERS_LIST = @"home/sameProductMoreSellers";

//新品上架<魏庆冰>
static NSString *const API_HOME_NEW_GOODS_ON_SALE_LIST = @"home/newGoodsOnSale";

//配置楼层接口<李瑞安>
static NSString *const API_HOME_FLOOR = @"home/homeFloor";

//V3配置楼层接口<李瑞安>
static NSString *const API_HOME_V3_FLOOR = @"home/homeFirstPart";

/// 首页获取背景图片<李瑞安>
static NSString *const API_HOME_BACK_IMAGE = @"mobile/home/bgImg";

/// 更新pushid状态<秦涛>
static NSString *const API_HOME_ADS_PUSHIDSTATUS = @"ads/updatePushIdStatus";

/// 首页未读消息数量<李瑞安>
static NSString *const API_UNREAD_MSG_COUNT = @"ycapp/message/unread/count";

/// 获取首页切换的tab<李瑞安>
static NSString *const API_SWITCH_TAB = @"home/flowTabs";

/// 获取首页单个tag下的信息流<李瑞安> 
static NSString *const API_INFO_FOLLOW_DATA = @"home/flowInfo";

/// 首页视频详情<李瑞安>
static NSString *const API_RECOMMEND_VIDEO = @"home/recommendVideo";

// 浏览商详页记录浏览次数达30次送券 活动页信息<卢俊>
static NSString *const API_PD_PROMOTION_VIEWCOUPONSEND_INFO = @"promotion/viewProductSendCouponInfo";

#pragma mark - 商详<PD>

// 商品详情
static NSString *const API_PRODUCT_DETAIL_INFO = @"product/detail";

// 浏览商详页记录浏览次数达30次送券<卢俊>
static NSString *const API_PD_PROMOTION_VIEWCOUPONSEND = @"promotion/viewCouponSend";

/// 商详上报后台游览数据《李瑞安》
static NSString *const API_PD_UPLOAD_VIEWDATA = @"home/viewBuyTrack";

// 商详之满赠
static NSString *const API_PD_FULL_GIFT = @"ycapp/getMzInfomation";

// 商品详情之返利列表
static NSString *const API_PD_PROFIT_LIST_INFO = @"ycapp/rebateDistrictInfo";

// 多品返利信息
static NSString *const API_PD_PROFIT_REBATE_INFO = @"api/cart/queryMultiRebateInfo";

// 商详之推荐商品
static NSString *const API_PD_RECOMMEND_PRODUCT_LIST = @"ycapp/sameRecommend";

//商品详情查看优惠券列表<席天翔>
static NSString *const API_PD_COMMON_COUPON_LIST = @"promotion/coupon/getMultiplyCouponBySpuCode";
//购物车查看优惠券列表<席天翔>
static NSString *const API_PD_COMMON_COUPON_LIST_ENTERPRISEID = @"promotion/coupon/getMultiplyCouponByEnterpriseId";
//领取优惠券接口
static NSString *const API_PD_COMMON_COUPON_RECEIVE_INFO = @"promotion/coupon/couponReceiveByTemplateCode";
//商详页立即下单商品校验
static NSString *const API_PD_CHECK_SOMPLE_ITEM = @"api/cart/checkSimpleItem";
//降价登记
static NSString *const API_LOW_PRICE_NOTICE = @"ycapp/notice/reducePriceNotice";
//到货通知商品推荐
static NSString *const API_ARRIVAL_RECOMMOD_NOTICE = @"ycapp/outOfStore/recommend/product";
#pragma mark - 搜索

// 搜索发现接口
static NSString *const API_HOME_SEARCH_FOUND = @"mobile/home/searchFound";

// 搜索商品接口
static NSString *const API_HOME_SEARCH_PRODUCT = @"api/search/searchProductList";

// 发送搜索关键词 第一个数据
static NSString *const API_SEND_SEARCH_DATA = @"crm/sendSearchData";

// App搜索无结果或者异常时调用
static NSString *const API_SEARCH_SEND_DATA_FOR_NO_RESULT = @"ycapp/searchExceptionLog";

// 获取商品筛选规格
static NSString *const API_GET_PRODUCT_RANK_DATA = @"api/search/specs";

// 优惠券可用商品列表
static NSString *const API_GET_PRODUCT_WITH_COUPON = @"ycapp/search/coupon/product";

// 搜索用户注册地主仓接口
static NSString *const API_GET_SEARCH_SHOP_INFO = @"ycapp/search/queryLocalMainStoreInfo";

//MP钩子商品接口
static NSString *const API_GET_SEARCH_MP_INFO = @"promotion/mpHookGood";

// 三级类目热销榜单对外接口热销榜单钩子
static NSString *const API_GET_SEARCH_HOTSELL_INFO = @"druggmp/index/seacrhHotSalePro";

/// 获取搜店铺时候的发现列表
static NSString *const API_GET_SEARCH_FOUND_LIST = @"api/order/queryOftenBuyEnterprise";

#pragma mark -店铺馆相关接口
//店铺馆三个标题
static NSString *const API_SHOP_COLLECT_TAB_TITLE_LIST = @"ycapp/shop/homeTabNameList";
//商家促销商品
static NSString *const API_SHOP_COLLECT_PRODUCT_PROMOTION_LIST = @"home/mpHome/ChineseMedicine";
//店铺列表
static NSString *const API_SHOP_COLLECT_SHOP_LIST = @"druggmp/shop/myFollowShop";
//全部店铺列表
static NSString *const API_SHOP_ALL_SHOP_LIST = @"druggmp/shop/allShopList";
// 店铺馆首页
static NSString *const API_SHOP_COLLECT_SHOP_ACTIVITY_LIST = @"home/mpHome/activities";
//旗舰店铺icon
static NSString *const API_SHOP_FLAG_SHIP_LIST = @"druggmp/shop/ultimateShop";

#pragma mark - 店铺内
// 全部商品里的商品分类
static NSString *const API_SHOP_PRODUCT_CATEGORY = @"ycapp/shop/productCategory";

// 全部商品
static NSString *const API_SHOP_ALL_PRODUCT = @"ycapp/shop/allProduct";

#pragma mark - 购物车

// 获取购物车中商品数量
static NSString *const API_CART_PRODUCT_NUMBER = @"api/cart/productsCount";

// 修改商品购买数量
static NSString *const API_CART_PRODUCT_UPDATE_NUMBER = @"api/cart/updateNum";

// 删除商品
static NSString *const API_CART_PRODUCT_DELETE = @"api/cart/delete";

// 变更商品勾选状态
static NSString *const API_CART_PRODUCT_CHECK_STATUS = @"api/cart/updateCheckStatus";

// 结算校验
static NSString *const API_CART_PRODUCT_SUBMIT = @"api/cart/submitCheck";

// 获取进货单列表
static NSString *const API_CART_PRODUCT_LIST = @"api/cart/list";

#pragma mark - 优惠券
static NSString *const API_PROMTION_COUPON_SEND = @"promotion/condCoupon/send";


#pragma mark - 资料管理

// 经营范围
static NSString *const API_USER_GET_DRUG_SCOPE = @"usermanage/enterpriseInfo/getDrugScope.json";

// 通过企业名称关键词来模糊查询企业名称
static NSString *const API_USER_GET_ENTERPRISE_NAME_ERP = @"usermanage/enterpriseInfo/queryEnterpriseNameLike.json";

// 通过企业名称获取企业信息
static NSString *const API_USER_GET_ENTERPRISE_INFO_ERP = @"usermanage/enterpriseInfo/getEnterpriseInfo.json";

// 查询资质信息
static NSString *const API_USER_GET_ENTERPRISE_DOC_INFO = @"usermanage/enterpriseInfo/queryEnterpriseById.json";

// 提交资质信息1...<包括企业信息与收货信息>
static NSString *const API_USER_SUBMIT_ENTERPRISE_TEXT_INFO = @"usermanage/enterpriseInfo/saveEnterpriseInfoNew.json";

// 提交资质信息2...<包括所有的资质图片信息>
static NSString *const API_USER_SUBMIT_ENTERPRISE_IMAGE_INFO = @"usermanage/enterpriseInfo/saveQcDftList.json";

// 获取企业注册需要的所有资质列表
static NSString *const API_USER_GET_ENTERPRISE_IMAGE_UPLOAD_LIST = @"usermanage/enterpriseInfo/getRegisterQualification.json";

// （资质）提交审核
static NSString *const API_USER_SUMBIT_QUALIFICATION_REVIEW = @"usermanage/enterpriseInfo/submitAuditDft.json";



#pragma mark - 个人中心
//切换账号
static NSString *const API_USER_CHANGE_USER = @"ypassport/change_user";

//获取退换货银行信息
static NSString *const API_USER_GET_SALE_RETURN_BANK_INFO = @"aftersales/ocs/queryOcsBankInfo";

//获取发票银行列表
static NSString *const API_USER_GET_INVOICE_BANK_LIST = @"invoiceUserInfo/getBankTypes";

//获取个人中心开票信息
static NSString *const API_USER_GET_INVOICE_INFO = @"invoiceUserInfo/getInvoiceUserInfo";

//保存发票信息
static NSString *const API_USER_SAVE_INVOICE_INFO = @"invoiceUserInfo/saveInvoiceUserInfo";

// 四个接口聚合URL
static NSString *const API_USER_GET_BASE_INFO = @"ycapp/userCenter";

//校验注册的时候用户名是否存在<开发_熊文友> ValidateUserName
static NSString *const API_USER_POST_VALIDATE_USER = @"ypassport/yc_check_username";

// 获取图片验证码接口
static NSString *const API_USER_GET_IMAGE_CODE = @"ypassport/getPicCode";

// 获取短信验证码接口（注册）
static NSString *const API_USER_REGISTER_GET_SMS_CODE = @"ypassport/sendSms";

// 注册
static NSString *const API_USER_REGISTER_ACTION = @"ypassport/regist";

// 登录
static NSString *const API_USER_LOGIN_ACTION = @"ypassport/login";

//短信验证码登录
static NSString *const API_USER_LOGIN_SMS_ACTION = @"ypassport/ycSmsCodeLogin";

// 查询是否有注册激活送券活动
static NSString *const API_USER_REGISTER_COUPON = @"promotion/coupon/hasRegisterActivity";

// 获取短信验证码接口（登录）
static NSString *const API_USER_GET_LOGIN_SMS_CODE = @"ypassport/yc_login_sms";

// 获取短信验证码接口（找回密码处）
static NSString *const API_USER_GET_SMS_CODE = @"ypassport/bd/sendsmscode";

// 验证短信短信接口（找回密码处）
static NSString *const API_USER_CHECK_SMS_CODE = @"ypassport/bd/checksmscode";

// 注册校验bd号码
static NSString *const API_USER_REGISTRE_BDMOBILE = @"mobile/dcso/bdMobile";

// 重置密码接口（找回密码处）
static NSString *const API_USER_CHANGE_PASSWORD = @"ypassport/reset_pwd_mobile";

//修改密码接口（设置处）
static NSString *const API_USER_RESET_PASSWORD = @"ypassport/user/reset_user_pwd";

// 获取返利金详情
static NSString *const API_USER_GET_REBATE_AMOUNT = @"promotion/coupon/getRebateAmount";
/// 获取返利金可用商家列表
static NSString *const API_USER_GET_REBATE_DETAIL = @"manage/rebate/couldUseRebateDetail";

// 根据客户企业id查询待到账返利金列表明细（分页）
static NSString *const API_USER_GET_DELAY_REBATE_AMOUNT = @"manage/rebate/rebatePendingDetail";

// 查询用户是否是vip（返回vip信息及用户类型）
static NSString *const API_USER_GET_VIP_DETAIL = @"mobile/vip/getVipInfo";

// 修改密码时联想企业<望神>
static NSString *const API_USER_GET_COMPANY_ABOUT = @"ycapp/enterprise/suggestEnterprise";
// 修改密码时第一步<望神>
static NSString *const API_USER_POST_PWD_ONE = @"ycapp/passport/retrievePasswordStepOne";
// 修改密码时第二步<望神>
static NSString *const API_USER_POST_PWD_TWO = @"ycapp/passport/retrievePasswordStepTwo";
// 修改密码时第三步<望神>
static NSString *const API_USER_POST_PWD_THREE = @"ycapp/passport/retrievePasswordStepThree";
// 修改密码时第二步获取业务员信息<望神>
static NSString *const API_USER_POST_SALES_PERSON_INFO = @"ycapp/enterprise/getSalesperson";
// 修改密码时获取图像验证码<望神>
static NSString *const API_USER_GET_PICTURE_CODE = @"ycapp/code/getPictureCode";
// 修改密码时获取图像验证码<望神>
static NSString *const API_USER_GET_SMS_PAS_CODE = @"ycapp/code/sendSmsCode";
// 购物金验证短信验证码<望神>
static NSString *const API_USER_VALIDATE_SMS_PAS_CODE = @"ycapp/code/validateSmsCode";
/// 查询套餐优惠入口信息
static NSString *const API_DISCOUNT_PACKAGE_ENTRY_INFO = @"home/adPromotion";

/// 获取购物金活动列表
static NSString *const API_RECHARGE_ACTIVITY_INFO = @"promotion/getRechargeActivity";

/// 查询购物金余额信息
static NSString *const API_SHOPPING_MONEY_INFO = @"gwjapi/account";

/// 查询购物金流水
static NSString *const API_SHOPPING_MONEY_RECORD = @"gwjapi/dealLog";

/// 预充值
static NSString *const API_SHOPPING_MONEY_PRECHARGE = @"gwjapi/preCharge";

// 会员规则介绍页
#if FKY_ENVIRONMENT_MODE == 1   // 线上环境
static NSString *const API_VIP_INTRODUCTION_H5 = @"https://m.yaoex.com/web/h5/maps/index.html?pageId=100586&type=release";
#elif FKY_ENVIRONMENT_MODE == 2 // 开发环境
static NSString *const API_VIP_INTRODUCTION_H5 = @"https://m.yaoex.com/web/h5/maps/index.html?pageId=100311&type=release";
#elif FKY_ENVIRONMENT_MODE == 3 // 测试环境
static NSString *const API_VIP_INTRODUCTION_H5 = @"https://m.yaoex.com/web/h5/maps/index.html?pageId=100311&type=release";
#endif

// 隐私政策
static NSString *const API_PRIVATE_CONTENT_H5 = @"http://mall.yaoex.com/cmsPage/2020dfe570a10608111609/index.html";
// 服务条款
static NSString *const API_SEVERVE_CONTENT_H5 = @"http://mall.yaoex.com/cmsPage/2020c4f4ea7f0608140810/index.html";

// 会员商品专区
static NSString *const API_VIP_PRODUCT_LIST_H5 = @"https://m.yaoex.com/h5/vipArea/index.html#/";

// IM即时通讯h5的url
static NSString *const API_IM_H5_URL = @"https://m.yaoex.com/h5/im/index.html";

// IM入口是否显示
static NSString *const API_IM_SHOW_URL = @"im/switchShow/switchType";

// 我的余额
static NSString *const API_MY_REBATE = @"manage/rebate/myRebate";

//返利金记录
static NSString *const API_REBATE_RECORD = @"manage/rebate/rebateRecord";

// 获取订单列表下方推荐品列表
static NSString *const API_RECOMMEND_LIST = @"ycapp/product/newOnSale";

/// 获取抽奖信息
static NSString *const API_DRAW_INFO = @"promotion/orderDraw/priseInfo";

/// 开始抽奖
static NSString *const API_START_DRAW = @"promotion/orderDraw/main";

/// 提交绑定银行卡信息
static NSString *const API_SUBMIT_BANDING_INFO = @"shBank/personRegister";

/// 绑定银行卡界面发送短信验证码
static NSString *const API_SEND_VERIFICATIONCODE_BANDING = @"shBank/sendRegisterSms";

/// 验证手机验证码
static NSString *const API_CHECK_VERIFICATIONCODE = @"shBank/validRegisterSms";

/// 修改个人信息
static NSString *const API_UPDATA_BANK_CARD_INFO = @"shBank/updatePersonInfo";

/// 绑定银行卡界面获取银行卡列表
static NSString *const API_REQUEST_BANK_LIST = @"ycapp/eshopStore/listBankCode";

/// 提交药店福利申请信息
static NSString *const API_SUBMIT_APPLY_WALFARE_TABLE_INFO = @"ycapp/eshopStore/createDraftStore";
#pragma mark - 注册地址<三级>

// 获取省份
static NSString *const API_REGISTER_ADDRESS_GET_PROVINCE = @"ycapp/provinces";

// 根据省份编码获取市
static NSString *const API_REGISTER_ADDRESS_GET_CITY = @"ycapp/citys";

// 根据市编码获取区
static NSString *const API_REGISTER_ADDRESS_GET_DISTRICT = @"ycapp/countrys";

// 根据省市区名称或者编码匹配省市区数据信息
static NSString *const API_REGISTER_ADDRESS_QUERY_NAME_CODE = @"ycapp/addressCodeOrName";

#pragma mark - 店铺详情相关
// 店铺商家信息(头部信息及开户，发票，入库，公告)
static NSString *const API_SHOP_DETAIL_ENTERPRISE_INFO = @"ycapp/shop/enterpriseInfo";
//店铺商家信息(头部信息及优惠券列表-李瑞安)
static NSString *const API_SHOP_DETAIL_ENTERPRISE_AND_COUPON_LIST_INFO = @"shop/home/baseInfo";
//店铺商家信息(为你推荐商品-李瑞安)
static NSString *const API_SHOP_RECOMMEND_PRODUCT_LIST_INFO = @"shop/home/recommend";
//店铺商家信息(运营配置楼层-李瑞安)
static NSString *const API_SHOP_OPERATE_CELL_LIST_INFO = @"shop/home/floor";
// 店铺商家信息(商家促销及优惠券)
static NSString *const API_SHOP_DETAIL_PROMOTION_BASE_INFO = @"ycapp/shop/promotion";
// 店铺的企业资质
static NSString *const API_SHOP_DETAIL_QUALIFICATION_INFO = @"ycapp/shop/enterpriseQualification";
// 店铺是否收藏
static NSString *const API_SHOP_DETAIL_COLLECTION_INFO = @"druggmp/index/shopIsCollect";
// 店铺收藏与取消
static NSString *const API_SHOP_DETAIL_ADD_CANCELL_COLLECTION_INFO = @"druggmp/index/shopCollectAddCancel";

#pragma mark - 新品登记相关
// 提交新品登记
static NSString *const API_STANDARD_SUBMIT_NEW = @"ycapp/product/register/submit";
// 获取标品列表
static NSString *const API_STANDARD_PRODUCT_LIST = @"ycapp/search/barcode";
static NSString *const API_NEW_PRODUCT_LIST = @"ycapp/product/register/list";
static NSString *const API_NEW_PRODUCT_DETAIL = @"ycapp/product/register/detail";
//热销商品列表
static NSString *const API_HOT_REGION_LIST = @"druggmp/index/seacrhHotSaleRankPageList";
#pragma mark - 专区相关

/// 获取搭配套餐列表
static NSString *const API_MATCHING_PACKAGE_LIST = @"ycapp/promotion/collectionDinner";

/// 高毛专区
static NSString *const API_HEIGHT_GROSS_MARGIN = @"ycapp/product/labelList";

//满折专区
static NSString *const API_FULLDISCOUNT_PRODUCT_MARGIN = @"ycapp/promotion/fullDiscount/product";
//特价专区
static NSString *const API_SPECIAL_PRODUCT_MARGIN = @"ycapp/promotion/special/product";

//多品返利专区
static NSString *const API_REBATE_PRODUCT_MARGIN = @"/ycapp/rebate/product";

//一键入库口令解析
static NSString *const API_ENTRANCE_POPUP = @"/ycapp/ipurchase/entrancePopup";
#pragma mark - 药福利相关
//查询药福利开店信息
static NSString *const API_YFL_OPEN_SHOP_INFO = @"ycapp/eshopStore/selectBdEshopStore";


#pragma mark - 上传图片...<集团接口>...<New>

// 图片上传...<测试环境请配置host: upload.111.com.cn 10.6.80.229>
static NSString *const API_YC_UPLOAD_IMAGE = @"https://upload.111.com.cn/uploadfile";


#pragma mark - 上传图片...<非Adapter接口>...<Old>

#if FKY_ENVIRONMENT_MODE == 1 // 线上环境(正式版)
    //#if FKY_BUGLY_MODE == 1 // 提审版
    static NSString *const API_YC_UPLOAD_PIC = @"https://usermanage.yaoex.com/api/enterpriseInfo/uploadPic";
    //#endif
#else // 非线上环境
    static NSString *const API_YC_UPLOAD_PIC = @"http://usermanage.yaoex.com/api/enterpriseInfo/uploadPic";
#endif


#pragma mark - BI埋点...<New>

// BI埋点
static NSString *const API_YC_BI_RECORD = @"http://nest.111.com.cn";


#endif /* FKYApiList_h */
