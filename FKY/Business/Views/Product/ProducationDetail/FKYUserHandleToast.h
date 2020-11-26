//
//  FKYUserHandleToast.h
//  FKY
//
//  Created by airWen on 2017/8/14.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYUserHandleToast : UIView

- (void)setContentBackgroundColor:(UIColor *_Nullable)bgColor;
+ (void)showInView:(UIView *)superView withShopName:(NSString *)shopName animationCompletion:(void (^ __nullable)(BOOL finished))completion;

@end
