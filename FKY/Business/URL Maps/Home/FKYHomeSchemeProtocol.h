//
//  FKYHomeSchemeProtocol.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#ifndef FKY_FKYHomeSchemeProtocol_h
#define FKY_FKYHomeSchemeProtocol_h


//
@protocol FKY_Home <NSObject>

@property (nonatomic, strong) NSString *url; // 跳转URL

@end


@protocol FKY_HotSale <NSObject>

@property (nonatomic, assign) BOOL isWeekRankMode; // true-本周热销 false-区域热搜

@end


//
@protocol FKY_HomeCategory <NSObject>

@end


//
@protocol FKY_Search <NSObject>

@end

/// 搜索关键词vc
@protocol FKY_NewSearch <NSObject>

@end


//
@protocol FKY_SearchResult <NSObject>

@property (nonatomic, strong) NSString *keyword; // 搜索关键字
@property (nonatomic, strong) NSString *factoryNameKeyword ; //厂商联想
@property (nonatomic, strong) NSString *selectedAssortId; // 搜索分类

@property (nonatomic, copy) NSString *couponTemplateId; // 搜索优惠券可用商品入参
@property (nonatomic, copy) NSString *sellerCode; // 搜索优惠券可用商品入参

@end


//
@protocol FKY_SearchProvider <NSObject>

@property (nonatomic, copy) void(^providerCallBackBlock)(NSString *provider, NSArray* custIdArray); // 搜索关键字
@property (nonatomic, strong) NSString *keyword; // 搜索关键字
@property (nonatomic, strong) NSString *assortId;
@property (nonatomic, strong) NSArray *custIdArray;

@end


//
@protocol FKY_ProdutionDetail <NSObject>

@property (nonatomic, strong) NSString *productionId;   // 商品ID
@property (nonatomic, strong) NSString *vendorId;       // enterpriseId 供应商id
@property (nonatomic, strong) NSString *pushType;       //降价通知类型

@property (nonatomic, strong) NSString *schemeString;
 
@property (nonatomic, copy) void(^updateCarNum)(NSNumber *carId,NSNumber *num);//更新列表中cell

@end


//
@protocol FKY_ProductionBaseInfo <NSObject>

@end


/**
 *  购物车
 */
@protocol FKY_ShopCart <NSObject>

// 是否可返回...<默认不可返回>
@property (nonatomic, assign) BOOL canBack;
// 默认选中的type索引...<默认为0>
@property (nonatomic, assign) NSInteger typeIndex;

@end


/**
 *  促销详情页面 
 */
@protocol FKY_PromoteDetail <NSObject>

@property (nonatomic, strong) NSString *schemeString;
@property (nonatomic, assign) NSInteger promoteId;

@end


/**
 *  专题H5
 */
@protocol FKY_PromoteWeb <NSObject>

@property (nonatomic, strong) NSString *webUrl;

@end


//
@protocol FKY_Station <NSObject>

@property (nonatomic, copy) void(^stationCallBack)(NSString *stationName);

@end


/**
 秒杀详情页面
 */
@protocol FKY_SecondKillActivityDetail <NSObject>
@property (nonatomic, copy) NSString *sellerCode; // 商家ID
@end


//一起购列表页面
@protocol FKY_TogeterBuy <NSObject>
@property (nonatomic, copy) NSString *sellerCode; // 商家ID
@end


//一起购详情页面
@protocol FKY_Togeter_Detail_Buy <NSObject>

@end


//一起购搜索结果页面
@protocol FKY_Togeter_Search_Buy <NSObject>

@end


//红包结果页
@protocol FKY_RedPacket <NSObject>

@end


//消息列表
@protocol FKY_Message_List <NSObject>

@end

//逛一逛送券活动
@protocol FKY_Send_Coupon_Info <NSObject>

@end

//新品登记列表
@protocol FKY_New_Product_Set_List <NSObject>

@end

//新品登记详情
@protocol FKY_New_Product_Set_Detail <NSObject>

@end

//城市热销列表
@protocol FKY_Hot_Sale_Region <NSObject>

@end

//商家特惠
@protocol FKY_Preferential_Shop <NSObject>

@end

//包邮价
@protocol FKY_Package_Rate <NSObject>

@end
@protocol FKY_Product_Pinkage <NSObject>

@end

#endif
