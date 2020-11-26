//
//  GLNavgationBarButton.h
//  YYW
//
//  Created by airWen on 2017/3/2.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - GLNavgationBarButton
@interface GLNavgationBarButton : UIView

- (nullable instancetype)initWithTitle:(nullable NSString *)title imgUrl:(nullable NSString *)imgUrl;

- (void)addTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

#pragma mark - GLNavgationButton
@interface GLNavgationButton : UIButton
@property (nonatomic, assign) CGFloat margin;
@end
