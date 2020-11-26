//
//  FKYAlertView.h
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYPopView.h"

@interface FKYAlertView : FKYPopView

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *inputAddress;

+ (instancetype)showAlertViewWithTitle:(NSString *)title
                               message:(NSString *)message
                               handler:(void (^)(FKYAlertView *alertView, BOOL isRight))handler;

+ (instancetype)showAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                               message:(NSString *)message
                               handler:(void (^)(FKYAlertView *alertView, BOOL isRight))handler;

@end
