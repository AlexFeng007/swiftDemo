//
//  FKYRequestService.h
//  FKY
//
//  Created by 夏志勇 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  接口层

#import "HJLogic.h"
#import "FKYWebService.h"


// 请求数据的结果回调
typedef void (^RequestServiceBlock)(BOOL isSucceed, NSError *error, id response, id model);



@interface FKYRequestService : HJLogic

+ (instancetype)sharedInstance;


#pragma mark - 退换货

// 申请退换货原因
- (void)requestForApplyReasonListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 提交退换货信息...<申请退换货>
- (void)requestForSubmitApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// mp提交退换货信息...<申请退换货>
- (void)requestForMpSubmitApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;


// 快递公司列表
- (void)requestForSendCompanyListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 提交回寄信息
- (void)requestForSubmitSendInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 订阅物流信息
- (void)requestForSubscribeSendInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 查询可退换货数量
- (void)requestForGetCountsInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 查询MP可退换货数量<閤亚峰>
- (void)requestForGetMPCountsInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 根据第三方订单（药城订单）ID查询药网子单
- (void)requestForQueryOrderIdInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取物流日志接口
- (void)requestForqueryLogisticsListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 撤销退换货申请
- (void)requestForCancleOcsRmaApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 撤销退换货申请<閤亚峰>
- (void)requestForMPCancleOcsRmaApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 查看退换货申请
- (void)getOcsRmaApplyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 查询订单的所有退换货记录
- (void)queryUserRmaOrderListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 查询订单的所有退换货  换货返回物流
- (void)queryTmsLogByChildOrderIdWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;


#pragma mark - 售后工单

// 判断是否展示极速理赔
- (void)queryTypeShowCompensationWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取已申请记录列表
- (void)queryASServiceTypeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取可申请售后列表
- (void)queryWorkOrderListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取全部订单的售后列表
- (void)queryAllWorkOrderListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 根据服务类型id和子订单号获取服务类型详情信息
- (void)queryAsWorkServiceTypeDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 提交工单信息
- (void)saveAsWorkOrderForB2BTypeDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取工单基本信息
- (void)getAsWorkOrderBaseInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;


#pragma mark - 检查订单、提交订单相关

// 检查订单
- (void)requestForCheckOrderWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 提交订单...<普通订单>
- (void)requestForSubmitOrderWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 提交订单...<一起购订单>
- (void)requestForSubmitGroupBuyOrderWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 检查用户资质状态...<判断用户是否可以提交订单>
- (void)requestForCheckEnterpriseQualificationWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 在线支付方式列表
- (void)requestForOnlinePayTypeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取上次在线支付方式
- (void)requestForSavedOnlinePayTypeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 快捷支付获取流水号并且自动发送短信
- (void)requestForQuickPayFlowIdWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//快捷支付 支付确认接口
- (void)requestForQuickPayConfirmWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 上海银行支付状态主动获取接口
- (void)requestForQuickPayStatusWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取花呗分期列表数据
- (void)requestForAlipayInstalmentListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 请求收款方账户信息...<商家银行信息>
- (void)requestForEnterpriseBankInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 请求订单分享签名
- (void)requestForOrderShareSignWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取可使用银行列表《黎凯》
- (void)requestForUseBankListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 订单详情相关

- (void)requestForOrderDetaiAboutSendVoiceToMail:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;


#pragma mark - 买家投诉卖家

// mp订单投诉
- (void)sellerComplainActionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;


#pragma mark - 启动

// 获取站点(省份)
- (void)getSiteWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 保存个推(设备)信息
- (void)saveDeviceInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 直播
//直播当前正在讲解的商品
- (void)getLiveCurrecrProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播所有商品列表
- (void)getLiveAllProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播推荐品
- (void)getLiveRecomendProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播间活动详情
- (void)getLiveActivityDetailfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播间优惠券列表
- (void)getLiveActivityCouponsListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播间人数
- (void)getLiveActivityPersonWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播口令分享解密
- (void)getLiveCommendDecryptWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播活动状态
- (void)getLiveStatusWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播间口令红包
- (void)getLiveActivityRedPacketInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//直播间口令红包获取的详情
- (void)getLiveActivityRedPacketGetInfoDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

////直播间领取优惠券<杨崇攀>
- (void)getLiveActivityReceiveCouponInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

////直播列表
- (void)getLiveActivityListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

////直播预告详情
- (void)getLiveActivityNoticeInfoDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

///设置/取消设置提醒
- (void)setLiveActivityNoticeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

///直播间主页
- (void)getLiveActivityAnchorMainInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
///直播类型
- (void)getLiveTypeInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
#pragma mark - 消息中心
/// 获取站内列表
- (void)getMsgListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取未推送过的推送消息
- (void)getNoPushMsgWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 首页

/// 新首页方案选择接口
- (void)getHomeViewOptionInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 新首页混合接口
- (void)getHomeBannerNavInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 新首页获取轮播图与导航icon接口
- (void)getHomeOftenBuyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 检查是否显示红包
- (void)queryRedPacketShowWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 抽取红包
- (void)queryRedPacketDrawWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取消息列表
- (void)queryMessageListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取消息列表
- (void)queryHomeMessageListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 消息分类详情列表
- (void)queryExpiredMessageWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取未读消息列表
- (void)queryReadNotMessageCountWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 首页常购清单第一页
- (void)queryRecommendMixWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 首页常购城市热销
- (void)querCityHotSaleWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 首页常购城常买
- (void)queryFrequentlyBuyWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 新版首页推荐tab接口
- (void)fetchHomeRecommendWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 首页商家特惠列表<王梦萱>
- (void)requestForGetHomePreferetialShopProductListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 首页单品包邮<魏庆冰>
- (void)requestForGetHomeSinglePackageRateShopProductListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//首页为您推荐<魏庆冰>
- (void)fetchHomeRecommendForYouWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//首页是否有惊喜提示view<刘峰>
- (void)fetchHomeSurpriseTipViewYesOrFalseWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//首页推广视图显示与否<李生望>
- (void)fetchHomeSpreadTipViewYesOrFalseWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//首页推广视图点击<李生望>
- (void)fetchHomeSpreadTipViewHideWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//降价专区<魏庆冰>
- (void)fetchCutPriceProductList:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//城市热销<李生望>
- (void)fetchHomeCityHotSalHotSaleProuctListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//即将售罄<李生望>
- (void)fetchHomeWillSaleOutWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//一品多商<魏庆冰>
- (void)fetchHomeSameProductMoreSellersProuctListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//新品上架<魏庆冰>
- (void)fetchHomenewGoodsOnSaleProuctListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//配置楼层接口<李瑞安>
- (void)fetchHomenFloorListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//V3配置楼层接口<李瑞安>
- (void)fetchHomenV3FloorListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 首页获取背景图片<李瑞安>
- (void)getBackGroundImage:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 更新pushid状态<秦涛>
- (void)upLoadPushIdStatus:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 配置楼层接口<魏庆冰>
- (void)getUnreadCount:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取首页切换的tab<李瑞安>
- (void)requestSwitchTab:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取首页单个tag下的信息流<李瑞安>
- (void)requestInfoFollowData:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 首页视频详情<李瑞安>
- (void)requestRecommendVideo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 浏览商详页记录浏览次数达30次送券 活动页信息<卢俊>
- (void)requestProductSendCouponInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 商详<PD>
// 商品详情
- (void)getProductDetailInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 浏览商详页记录浏览次数达30次送券<卢俊>
- (void)requestViewCouponSendWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
 
// 商详之满赠
- (void)getProductDetailFullGiftInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 商详上报后台游览数据《李瑞安》
- (void)upLoadViewDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 商品详情之返利列表
- (void)getProfitListInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 多品返利信息
- (void)getProfitRebateInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 商详之推荐商品列表
- (void)getProductListForRecommendWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 商品详情查看优惠券列表<席天翔>
- (void)getCommonCouponListInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
// 购物车查看优惠券列表<席天翔>
- (void)getCommonCouponListInfoInEnterpriseIdWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
// 领取优惠券接口
- (void)postReceiveCommonCouponInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//商详页立即下单商品校验
- (void)postCheckSimpleItemInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//降价登记
- (void)postLowPriceInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//到货通知商品推荐
- (void)postArrivalRecommendProductInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
#pragma mark - 搜索
// 搜索商品接口
- (void)requestSearchProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
// 搜索发现接口
- (void)sendSearchFoundWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 发送搜索关键词 第一个数据
- (void)sendSearchDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// App搜索无结果或者异常时调用
- (void)sendSearchDataForNoResultWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取商品规格
- (void)getProductRankDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 优惠券可用商品列表
- (void)getProductByCouponWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 搜索用户注册地主仓接口
- (void)queryLocalMainStoreInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
 
//MP钩子商品接口
- (void)queryMPHookGoodWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 三级类目热销榜单对外接口热销榜单钩子
- (void)querySearchHotsellInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取搜店铺时候的发现列表
- (void)requestSearchFoundListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
#pragma mark -店铺馆相关接口
// 店铺馆三个标题
- (void)requestForTabTitleListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
// 商家促销
- (void)requestForProductPromotionListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
// 店铺列表
- (void)requestForMainShopListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
// 全部店铺列表
- (void)requestForAllShopListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
// 店铺馆首页
- (void)requestForMPHomeShopActivityListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//获取旗舰店icon
- (void)requestForFlagShipShopListInShopCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 店铺内
// 全部商品里的商品分类
- (void)requestForProductCategoryInShopWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 全部商品
- (void)requestForAllProducInShopWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 购物车

// 获取购物车中商品数量
- (void)requestForProductNumberInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 修改商品购买数量
- (void)updateProductNumberInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 删除商品
- (void)deleteProductInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 变更商品勾选状态
- (void)updateProductCheckSattusInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取进货单列表
- (void)requestForProductListInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 结算校验
- (void)sumitCheckCheckSattusInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
 

#pragma mark - 优惠券
- (void)requestForThousandCouponsInCartWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;


#pragma mark - 资料管理

// 经营范围
- (void)requestForDrugScopeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 通过企业名称关键词来模糊查询企业名称
- (void)requestForEnterpriseNameFromErpWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 通过企业名称获取企业信息
- (void)requestForEnterpriseInfoFromErpWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 查询资质信息
- (void)requestForEnterpriseDocInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 提交资质信息1...<包括企业信息与收货信息>
- (void)requestForSubmitEnterpriseTextInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 提交资质信息2...<包括所有的资质图片信息>
- (void)requestForSubmitEnterpriseImageInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取企业注册需要的所有资质列表
- (void)requestForGetEnterpriseImageListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// （资质）提交审核
- (void)requestForSubmitQualificationReviewWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;


#pragma mark - 个人中心
///切换账号
- (void)requestChangeUserWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

///获取退换货银行信息
- (void)requestForSaleReturnBankInfoListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

///获取发票银行列表
- (void)requestForBankListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//个人中心获取开票信息
- (void)requestForInvoiceInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//保存发票信息
- (void)requestForSaveInvoiceInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 四个接口聚合URL
- (void)requestForBaseInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 校验注册的时候用户名是否存在
- (void)requestForValidateUserNameWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 注册校验bd号码
- (void)requestForValidateBdMobileWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取图形验证码接口
- (void)requestForGetImageCodeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取短信验证码（注册）
- (void)requestForGetRegisterMessageCodeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 注册
- (void)requestForRegisterWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 登录
- (void)requestForLoginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 短信验证码登录
- (void)requestForLoginBySMSWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 查询是否有注册激活送券活动
- (void)requestForRegisterCouponWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取短信验证码接口（登录）
- (void)requestForGetLoginSMSCodeDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取短信验证码（找回密码处）
- (void)requestForGetSMSCodeDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//  验证短信短信（找回密码处）
- (void)checkSMSCodeDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 重置密码（找回密码处）
- (void)changePasswordDataWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 修改密码（设置处）
- (void)resetPasswordDataInUserSetWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取返利金详情
- (void)requestForGetRebateDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取返利金可用商家列表
- (void)requestForGetRebateDetailListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 根据客户企业id查询待到账返利金列表明细（分页）
- (void)requestRebatePendingDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 获取用户是否是vip
- (void)requestForUserVipDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 根据企业id判断是否显示im入口
- (void)requesImShowWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 修改密码时企业联系词接口<望神>
- (void)requestForCompanyAboutWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 找回密码第一步<输入手机号或者企业和图像验证码><望神>
- (void)requestForFindPasswordOneWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 找回密码第二步<输入手机号验证码><望神>
- (void)requestForFindPasswordTwoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 找回密码第三步<输入手机号或者企业和图像验证码><望神>
- (void)requestForFindPasswordThreeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 找回密码第二步获取业务员信息<望神>
- (void)requestForSalesPersonInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 找回密码获取图形验证码接口<望神>
- (void)requestForGetImageCodeInPasswordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 找回密码获取短信验证码接口<望神>
- (void)requestForGetSMSCodeDataInPasswordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 购物金信验证码接口<望神>
- (void)requestForValidateSMSCodeDataInPasswordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 我的余额
- (void)requestMyRebateWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 返利金记录
- (void)requestRebateRecordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取订单下方推荐品列表
- (void)getRequestRecommendProductList:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取抽奖信息
- (void)getRequestDrawInfo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 开始抽奖
- (void)postRequestStartDraw:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 提交绑定银行卡信息
- (void)postSubmitBankCardInfo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 绑定银行卡界面发送短信验证码
- (void)postSendVerificationCodeInBandingView:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 验证手机验证码
- (void)postCheckVerificationCod:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 修改个人信息
- (void)postUpdataBankCardInfo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 绑定银行卡界面获取银行卡列表
- (void)postRequestBankList:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 提交药店福利申请信息
- (void)postsubmitApplyWalfareTableInfo:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 上传图片相关

// 上传图片...<新接口>...<v5.0.0开始替换成新接口>
- (void)requestForUploadPicWithParam:(NSDictionary *)param image:(UIImage *)image data:(NSData *)imgData completionBlock:(RequestServiceBlock)completion;

// 上传图片...<老接口>...<不再使用>
- (void)uploadIMMessagePicture:(UIImage *)img param:(NSDictionary *)param uploadUrl:(NSString *)url completionBlock:(RequestServiceBlock)completion;

    
#pragma mark - BI埋点
    
// BI埋点
- (void)requestForBIWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;


#pragma mark - 注册地址<三级>

// 获取省份
- (void)requestForGetProvinceWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 根据省份编码获取市
- (void)requestForGetCityWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 根据市编码获取区
- (void)requestForGetDistrictWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

// 根据省市区名称或者编码匹配省市区数据信息
- (void)requestForQueryNameOrCodeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 店铺详情相关
//店铺商家信息(头部信息及开户，发票，入库，公告)<弃用>
- (void)requestForGetShopEnterpriseInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//店铺商家信息(头部信息及优惠券信息)
- (void)requestForGetShopEnterpriseInfoAndCouponInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//店铺商家信息(运营配置楼层-李瑞安)
- (void)requestForGetShopOperateCellProductListInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//店铺商家信息(为你推荐商品)
- (void)requestForGetShopRecommendProductListInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//店铺商家信息(商家促销及优惠券)
- (void)requestForGetShopPromotionBaseInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//店铺的企业资质
- (void)requestForGetShopQualificationInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//店铺是否收藏
- (void)requestForGetShopCollectionInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//店铺收藏与取消
- (void)requestForGetShopAddOrCancellCollectionWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
#pragma mark - 新品登记相关
// 提交新品信息
- (void)requestForSubmitNewProductWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
// 获取标品列表
- (void)requestForGetStandardProductSetListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//新品登记历史列表
- (void)requestForGetNewProductSetListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//新品登记详情
- (void)requestForGetNewProductSetDetailWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;
//城市热销推荐
- (void)requestForGetCityHotRegionProductListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 专区相关

/// 获取搭配套餐列表
- (void)requestForMatchingPackageListWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取高毛专区商品列表
- (void)requestForGetHeightGrossMarginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取满折专区商品列表
- (void)requestForFullDiscountMarginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取特价专区商品列表
- (void)requestForSpecialMarginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//多品返利专区
- (void)requestForRebateMarginWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

//一键入库口令解析
- (void)requestForIpurchaseEntrancePopupWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 药福利相关
//查询药福利开店信息
- (void)requestForGetYflOpenShopInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

#pragma mark - 个人中心相关
/// 查询套餐优惠入口信息
- (void)requestPostForDiscountPackageInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 获取购物金活动列表
- (void)requestPostForRechargeActivityInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 查询购物金余额信息
- (void)requestPostForShoppingMoneyInfoWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 查询购物金流水
- (void)requestPostForShoppingMoneyRecordWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

/// 预充值
- (void)requestPostForShoppingMoneyPrechargeWithParam:(NSDictionary *)param completionBlock:(RequestServiceBlock)completion;

@end
