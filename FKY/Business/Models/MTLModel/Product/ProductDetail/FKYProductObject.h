//
//  FKYProductObjec.h
//  FKY
//
//  Created by mahui on 16/8/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  商详接口返回的商详基本信息model

#import "FKYBaseModel.h"
#import "CartPromotionModel.h"
#import "FKYProductGroupModel.h"
#import "FKYVipPromotionModel.h"
#import "FKYDiscountPriceInfoModel.h"
#import "FKYProductRecommendListModel.h"
#import "FKYProtocolRebateModel.h"

@class FKYExtModel;
@class FKYProductPromotionModel;
@class CouponTempModel;
@class CommonCouponNewModel;
@class FKYProductDinnerInfoObject;
@class FKYProductpriceInfoObject;
@class FKYProductLimitInfoObject;
@class FKYProductRebateInfoObject;
@class ProductPromotionInfo;
@class FKYProductEntranceInfoObject;
/*
 statusDesc
 （0:正常显示价格,
 -1:登录后可见,
 -2:加入渠道后可见,
 -3:资质认证后可见,
 -4:渠道待审核,
 -5:缺货,
 -6:不显示,
 -7:已下架,
 -9:无采购权限
 -10:采购权限待审核
 -11:采购权限不通过
 -12:采购权限已禁用）
 */


@interface FKYProductObject : FKYBaseModel

//接口新字段
/*
 批准号
 */
@property (nonatomic, copy) NSString *approvalNum;
/*
 0：待审核，1：审核通过，2：审核不通过，3：ERP对码完成 ,4:上架，5:下架 ,6:逻辑删除
 */
@property (nonatomic, copy) NSString *auditStatus;
/*
 批号
 */
@property (nonatomic, copy) NSString *batchNo;
/*
 大包装 Integer
 */
@property (nonatomic, copy) NSString *bigPacking;
/*
 是否显示奖励金 YES-可购买 NO-不可购买
 */
@property (nonatomic, assign) BOOL bonusTag;
/*
 奖励金文描
 */
@property (nonatomic, copy) NSString * bonusText;
@property (nonatomic, copy) NSString * brandId;
/*
 商标
 */
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString * buyerCode;
/*
 化妆品类商品说明
 */
@property (nonatomic, copy) NSString *cosmeticsInfo;
/*
 有效期至
 */
@property (nonatomic, copy) NSString *deadline;
/*
 药品一级类别
 */
@property (nonatomic, copy) NSString *drugFirstCategory;
/*
 药品一级类别名称
 */
@property (nonatomic, copy) NSString *drugFirstCategoryName;
/*
 剂型
 */
@property (nonatomic, copy) NSString *drugFormType;
/*
 药品二级类别
 */
@property (nonatomic, copy) NSString *drugSecondCategory;
/*
 药品二级类别名称
 */
@property (nonatomic, copy) NSString *drugSecondCategoryName;
/*
 生产厂商ID
 */
@property (nonatomic, strong) NSNumber *factoryId;
/*
 生产厂商
 */
@property (nonatomic, copy) NSString *factoryName;
/*
 一级类目
 */
@property (nonatomic, copy) NSString *firstCategory;
/*
 一级类目名称
 */
@property (nonatomic, copy) NSString *firstCategoryName;
/*
 真实供应商id
 */
@property (nonatomic, copy) NSString *frontSellerCode;
/*
 真实供应商名称
 */
@property (nonatomic, copy) NSString *frontSellerName;
/*
 促销语<跳转文案>
 */
@property (nonatomic, strong) NSString *giftLinkTxt;
/*
 无线促销语跳转连接
 */
@property (nonatomic, strong) NSString *h5GiftLink;

/*
 是否有套餐
 */
@property (nonatomic, assign) BOOL haveDinner;
/*
 是否保价
 */
@property (nonatomic, assign) BOOL holdPrice;
/*
 保价标签名称
 */
@property (nonatomic, copy) NSString *holdPriceTag;
/*
 保价文描
 */
@property (nonatomic, copy) NSString *holdPriceText;
/*
 保价跳转地址
 */
@property (nonatomic, copy) NSString *holdPriceUrl;
/*
 JBP寄售, 一品多商, 同品排序
 */
@property (nonatomic, copy) NSString *jbpSort;
/*
 主图
 */
@property (nonatomic, copy) NSString *mainImg;
/*
 最小起批量
 */
@property (nonatomic, strong) NSNumber *minBatch;
/*
 最小拆零包装
 */
@property (nonatomic, strong) NSNumber *minPackage;
/*
 图片列表
 */
@property (nonatomic, strong) NSArray *picsInfo;
/*
 降价通知
 */
@property (nonatomic, copy) NSString *priceNoticeMsg;
/*
 生产日期
 */
@property (nonatomic, copy) NSString *producedTime;
/*
 本公司产品编码
 */
@property (nonatomic, copy) NSString *productCodeCompany;
/*
 商品id
 */
@property (nonatomic, copy) NSString *productId;
/*
 通用名称
 */
@property (nonatomic, copy) NSString *productName;
/*
 二级类目<推荐商品需求新增字段>
 */
@property (nonatomic, copy) NSString *secondCategory;
/*
 二级类目名称eg:中药材
 */
@property (nonatomic, copy) NSString *secondCategoryName;
/*
 供应商id
 */
@property (nonatomic, copy) NSString *sellerCode;
/*
 供应商名称
 */
@property (nonatomic, copy) NSString *sellerName;
/*
 保质期
 */
@property (nonatomic, copy) NSString *shelfLife;
/*
 商品+通用名称
 */
@property (nonatomic, copy) NSString *shortName;
/*
 是否展示立即购买(1：展示，0：不展示)
 */
@property (nonatomic, copy) NSString *showBuyNow;
/*
 商品规格
 */
@property (nonatomic, copy) NSString *spec;
/*
 商品编码
 */
@property (nonatomic, copy) NSString *spuCode;
/*
 库存
 */
@property (nonatomic, strong) NSNumber *stockCount;
/*
 库存文描
 */
@property (nonatomic, copy) NSString *stockDesc;
/*
 是否是本地库存
 */
@property (nonatomic, assign) BOOL stockIsLocal;

//MARK:慢必赔
/*
 是否慢必赔
 */
@property (nonatomic, assign) BOOL slowPay;
/*
 慢必赔名称
 */
@property (nonatomic, copy) NSString *slowPayTag;
/*
 慢必赔文描
 */
@property (nonatomic, copy) NSString *slowPayText;
/*
 慢必赔跳转地址
 */
@property (nonatomic, copy) NSString *slowPayUrl;
/*
 三级类目
 */
@property (nonatomic, copy) NSString *thirdCategory;
/*
 三级类目名称
 */
@property (nonatomic, copy) NSString *thirdCategoryName;
/*
 标题
 */
@property (nonatomic, copy) NSString *title;
/*
 单位
 */
@property (nonatomic, copy) NSString *unit;
/*
 判断是否自营 1-自营
 */
@property (nonatomic, assign) NSInteger isZiYingFlag;
/*
 自营仓名字
 */
@property (nonatomic, copy) NSString *ziyingWarehouseName;
/*
 店铺扩展标签（商家，xx仓，旗舰店，加盟店）
 */
@property (nonatomic, copy) NSString *shopExtendTag;
/*
 店铺扩展类型（0普通店铺，1旗舰店 2加盟店 3自营店）
 */
@property (nonatomic, assign) NSInteger shopExtendType;

/*
 共享库存文描
 */
@property (nonatomic, copy) NSString *shareStockDesc;
/*
 近效期（1：显示 0不显示）
 */
@property (nonatomic, assign) NSInteger nearExpiration;
/*
 未知字段
 */
@property (nonatomic, copy) NSString *groupParam;
/*
 套餐数据
 */
@property (nonatomic, strong) FKYProductDinnerInfoObject *dinnerInfo;
/*
 折后价相关
 */
@property (nonatomic, strong) FKYDiscountPriceInfoModel *discountInfo;
/*
 价格信息
 */
@property (nonatomic, strong) FKYProductpriceInfoObject *priceInfo;
/*
 周限购信息
 */
@property (nonatomic, strong) FKYProductLimitInfoObject *productLimitInfo;
/*
 促销满减信息...<ProductPromotionInfo*>
 */
@property (nonatomic, strong) NSArray<ProductPromotionInfo*> *promotionList;

/*
 促销信息入口...<FKYProductEntranceInfoObject*>
 */
@property (nonatomic, strong) NSArray<FKYProductEntranceInfoObject*> *entranceInfos;
/*
 返利信息
 */
@property (nonatomic, strong) FKYProductRebateInfoObject *rebateInfo;
/*
 vip模型
 */
@property (nonatomic, strong) FKYVipDetailModel *vipModel;
/*
 vip的价格模型
 */
@property (nonatomic, strong) FKYVipPromotionModel *vipPromotionInfo;
/*
 说明书
 */
@property (nonatomic, strong) FKYExtModel *ext;
/*
 特价信息
 */
@property (nonatomic, strong) FKYProductPromotionModel *productPromotion;
/*
 协议返利金
 */
@property (nonatomic, strong) FKYProtocolRebateModel *rebateProtocol;

/*+++++++++++++++++自定义字段+++++++++++++++++*/
//购物车中数量（自定义字段，需匹配购物车接口中商品id获取）
@property (nonatomic, strong) NSNumber *carOfCount;
@property (nonatomic, strong) NSNumber *carId;

// //MARK:本地处理字段 非接口返回字段...<本地新增业务字段>
/*
 推荐商品接口返回model
 */
@property (nonatomic, strong) FKYProductRecommendListModel *recommendModel;
/*
 优惠券数组
 */
@property (nonatomic, strong) NSArray<CommonCouponNewModel *> *couponList;
// 同品推荐数组
@property (nonatomic, strong) NSArray *MPProducts;
@property (nonatomic, strong) NSArray<ProductPromotionInfo *> *promotionListForProductShow; // 商详页的促销满减信息 view Data
@property (nonatomic, strong) NSArray<ProductPromotionInfo *> *fullGiftListForProductShow; // 商详页的促销满赠信息 view Data
@property (nonatomic, strong) NSArray<ProductPromotionInfo *> *fullDiscountListForProductShow; // 商详页的促销满折信息 view Data



//@property (nonatomic, strong) NSNumber *exceedLimitNum;    // 设置限购时，当周剩余可购买数量
//@property (nonatomic, copy) NSNumber *weekLimitNum;        // 每周限购上限


// 大包装
- (NSString *)bigPackageText;  

- (NSInteger)promotionCount;
- (NSInteger)fullDiscountCount;
- (NSInteger)fullGiftCount;
- (ProductPromotionInfo *)promotionModelForIndex:(NSIndexPath *)indexPath;
- (ProductPromotionInfo *)fullDiscountModelForIndex:(NSIndexPath *)indexPath;
- (ProductPromotionInfo *)fullGiftModelForIndex:(NSIndexPath*)indexPath;
- (FKYProductEntranceInfoObject *)getEntranceInfoObject:(NSNumber *)entranceType;
- (NSArray *)detailViewAppearPromotions:(NSArray *)promptions;
- (NSArray *)detailViewAppearFullGiftPromotions:(NSArray *)promptions;

//- (NSArray *)giftActivity:(NSArray *)promotions;
//- (NSArray *)scoreActivity:(NSArray *)promotions;
//是否有底价活动
- (BOOL)hasBasePriceActivity;
////获取库存埋点数据
-(NSString *)getStorageData;
//获取促销埋点数据
-(NSString *)getPm_pmtn_type;
//获取价格埋点数据
-(NSString *)getPm_price;

//MARK:是否能点击加车
//- (BOOL)getCanAddCarBtn;
//MARK:未登录
//- (BOOL)getNoLoginStatus;
//MARK:判断单品是否可购买(false:单品不可购买)
- (BOOL)getSigleCanBuy;
@end


//MARK:套餐模型
@interface FKYProductDinnerInfoObject : FKYBaseModel

@property (nonatomic, strong) NSArray<FKYProductGroupModel *> *dinnerList;

@end

//MARK:价格状态相关
@interface FKYProductpriceInfoObject : FKYBaseModel
/*
 按钮文案
 */
@property (nonatomic, copy) NSString *buttonText;
/*
 按钮true是能点   false是不能点
 */
@property (nonatomic, assign) BOOL appButtonCanClick;
/*
 毛利率
 */
@property (nonatomic, copy) NSString *grossProfitRate;
/*
 原价
 */
@property (nonatomic, copy) NSString *price;
/*
 未知字段
 */
@property (nonatomic, copy) NSString *priceStatusEnums;
/*
 不显示销售价格时，文案
 */
@property (nonatomic, copy) NSString *priceText;
/*
 是否可以购买
 */
@property (nonatomic, assign) BOOL productStatus;
/*
 建议零售价
 */
@property (nonatomic, copy) NSString *recommendPrice;
/*
 是否显示销售价
 */
@property (nonatomic, assign) BOOL showPrice;
/*
 价格状态
 */
@property (nonatomic, copy) NSString *status;
/*
 不能加车提示
 */
@property (nonatomic, copy) NSString *tips;

@end

//MARK:周限购信息
@interface FKYProductLimitInfoObject : FKYBaseModel
/*
 已买数量
 */
@property (nonatomic, copy) NSNumber *limitBuyNum;
/*
 限购文描
 */
@property (nonatomic, copy) NSString *limitInfo;
/*
 剩余限购数量
 */
@property (nonatomic, assign) NSInteger surplusBuyNum;
/*
 周限购数
 */
@property (nonatomic, assign) NSInteger weekLimitNum;

@end

//MARK:返利信息
@interface FKYProductRebateInfoObject : FKYBaseModel

/*
 是否返利商品 0:无返利  1:有返利
 */
@property (nonatomic, copy) NSNumber *isRebate;
/*
 是否是平台返利。0：商家返利活动 1：平台返利活动
 */
@property (nonatomic, copy) NSNumber *platformPart;
/*
 返利文描
 */
@property (nonatomic, copy) NSString *rebateDesc;
/*
 返利id
 */
@property (nonatomic, copy) NSNumber *rebateId;
/*
 规则。1：单品，2：多品
 */
@property (nonatomic, copy) NSNumber *ruleType;

@end


//MARK:入口列表信息
@interface FKYProductEntranceInfoObject : FKYBaseModel
/*
 入口描述    string    单品包邮活动入口
 */
@property (nonatomic, copy) NSString *entranceDesc;
/*
 入口类型1（单品包邮）    number
 */
@property (nonatomic, strong) NSNumber *entranceType;
/**
 * 入口名称
 */
@property (nonatomic, copy) NSString * entranceName;

/**
 * 跳转url
 */
@property (nonatomic, copy) NSString * jumpUrl;

@end
