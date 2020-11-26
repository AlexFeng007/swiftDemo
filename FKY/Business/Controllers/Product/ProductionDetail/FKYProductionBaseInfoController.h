//
//  FKYProductionBaseInfoController.h
//  FKY
//
//  Created by mahui on 15/11/13.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  商详之基本信息

#import <UIKit/UIKit.h>
#import "FKYHomeSchemeProtocol.h"

@class FKYProductObject;


@interface FKYProductionBaseInfoController : UIViewController

// 商详主界面VC传递过来的商品详情数据model
@property (nonatomic, strong) FKYProductObject *productModel;

// 显示套餐视图block
@property (nonatomic, copy) void(^showGroupViewBlock)(NSString *promationName);

// 显示同品推荐列表
@property (nonatomic, copy) void(^showSameProductRecommendViewBlock)(void);
@property (nonatomic, copy) void(^loginActionBlock)(void);

// 刷新
- (void)showContent;
- (void)refreshContentForList;
- (void)updateContentHeight:(BOOL)showFlag;
- (void)setContentHeight:(CGFloat)height;
- (void)resetProductTableOffset;
/// 商详上报后台游览数据《李瑞安》
-(void)upLoadViewData;
@end
