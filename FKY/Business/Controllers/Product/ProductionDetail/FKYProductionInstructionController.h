//
//  FKYProductionInstructionController.h
//  FKY
//
//  Created by mahui on 15/11/13.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  商详之说明书

#import <UIKit/UIKit.h>
#import "FKYProductObject.h"

@interface FKYProductionInstructionController : UIViewController

// 商详主界面VC传递过来的商品详情数据model
@property (nonatomic, strong) FKYProductObject *productModel;

- (void)showContent;
- (void)updateContentHeight:(BOOL)showFlag;
- (void)setContentHeight:(CGFloat)height;

@end
