//
//  FKYFullGiftActionSheetView.h
//  FKY
//
//  Created by 乔羽 on 2018/6/4.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartPromotionModel;
@class FKYProductObject;

@interface FKYFullGiftActionSheetView : UIView

- (instancetype)initWithContentArray:(NSArray *)contentArray andText:(NSString *)contentStr;
- (void)showInView:(UIView *)superView;

@end
