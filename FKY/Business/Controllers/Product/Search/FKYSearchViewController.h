//
//  FKYSearchViewController.h
//  FKY
//
//  Created by yangyouyong on 15/9/9.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//  搜索

#import <UIKit/UIKit.h>
#import "FKYHomeSchemeProtocol.h"

//搜索来源
typedef NS_ENUM(NSInteger, SearchResultContentType) {
    SearchResultContentTypeFromCommon = 0, // 通用的商品搜索?
    SearchResultContentTypeFromShop = 1,   // 店铺内的商品搜索?!
};

// 搜索栏样式
typedef NS_ENUM(NSUInteger, SourceType) {
    SourceTypeCommon = 1, // 通用...<商品/店铺>...<可切换>
    SourceTypePilot,      // 店铺内的商品搜索???
    SourceTypeOrder,      // 订单搜索???
    SourceTypeCoupon,      // 优惠券可用商品搜索???
};

//搜索的类型>
typedef NS_ENUM(NSUInteger, SearchType) {
    SearchTypeProdcut = 1,      // 搜索商品
    SearchTypeShop,             // 搜索店铺
    SearchTypeTogeterProduct,   // 搜索一起购活动
    SearchTypeOrder,      // 订单搜索???
    SearchTypeJBPShop,             //专区
    SearchTypeYFLShop,             //药福利
    SearchTypeCoupon,             //优惠券可用商品
    SearchTypePackageRate,             //包邮商品
    //此处增加类型，需要在存储本地历史记录地方增加类型
};


@interface FKYSearchViewController : UIViewController <FKY_Search>

// 搜索样式
@property (nonatomic, assign) SourceType vcSourceType;
// 优惠券ID
@property (nonatomic, copy) NSString *couponID;
/// 优惠券模板编号
@property (nonatomic, copy) NSString *couponCode;
// 优惠券名称
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *sourceType; //来源

// 店铺ID...<若不为空，则一定是店铺内的商品搜索>
@property (nonatomic, copy) NSString *shopID;
// 专区ID
@property (nonatomic, copy) NSString *jbpShopID;
// 药福利ID
@property (nonatomic, copy) NSString *yflShopID;
// 搜索类型
@property (nonatomic, assign) SearchType searchType;
// 进入搜索来源
@property (nonatomic, assign) SearchResultContentType searchFromType;

/// 从哪个界面进来的 1 首页进搜索 2分类页进搜索 3店铺馆首页进搜索 其余的用原来老的样式
@property (nonatomic,assign)NSInteger fromePage;
//单品包邮是不是自营
@property (nonatomic, assign) BOOL isSelfTag;
//记录已经选择的筛选条件
@property (nonatomic,strong)NSString *priceSeqType;
@property (nonatomic,strong)NSString *sortColumnType;
@property (nonatomic,strong)NSString *shopSortType;
@property (nonatomic,strong)NSString *stockSeqType;

@end
