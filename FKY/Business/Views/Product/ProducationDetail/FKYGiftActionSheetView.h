//
//  FKYGiftActionSheetView.h
//  FKY
//
//  Created by mahui on 2017/2/14.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartPromotionModel;
@class FKYProductObject;

@interface FKYGiftActionSheetView : UIView

@property (nonatomic, copy) void(^goToActivityController)(CartPromotionModel *model);

- (instancetype)initWithTitle:(NSString *)title andCancleTitle:(NSString *)cancleTitle andProductArray:(FKYProductObject *)object;
- (instancetype)initWithTitle:(NSString *)title andCancleTitle:(NSString *)cancleTitle andDesArray:(NSArray *)contentArray;
- (void)showInView:(UIView *)superView;

@end
