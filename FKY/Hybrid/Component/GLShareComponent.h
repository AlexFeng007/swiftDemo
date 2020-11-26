//
//  GLShareComponent.h
//  YYW
//
//  Created by Rabe on 28/02/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GLShareHandler)(NSString *type);

@interface GLShareComponent : UIView

/**
 显示带分享功能的面板

 @param view 展示父视图,默认使用UIWindow
 @param frame 总大小(含遮罩的frame)，默认使用UIScreen mainScreen
 @param titles 分享面板内按钮标题数组
 @param images 分享面板内按钮图片数组
 @param handler 回调block
 */
+ (void)showComponentWithTitles:(NSArray *)titles images:(NSArray *)images handler:(GLShareHandler)handler;
+ (void)showComponentInView:(UIView *)view frame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images handler:(GLShareHandler)handler;
- (instancetype)initWithTitles:(NSArray *)titles images:(NSArray *)images handler:(GLShareHandler)handler;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images handler:(GLShareHandler)handler;

/**
 显示面板
 */
- (void)show;

/**
 隐藏面板
 */
- (void)dismiss;

@end
