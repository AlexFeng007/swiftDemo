//
//  WUTimerAlertView.h
//  YYW
//
//  Created by Lily on 2017/9/8.
//  Copyright © 2017年 YYW. All rights reserved.
//  带倒计时功能的弹窗

#import "WUPopView.h"

@interface WUTimerAlertView : WUPopView

/**
 @param title 标题
 @param message 信息
 @param buttonTitle 按钮标题
 @param interval 倒计时总时间
 @param block 隐藏弹框时回调方法 
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle timeInterval:(NSInteger)interval hideCompletion:(WUPopCompletion)block;

@end
