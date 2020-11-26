//
//  FKYAddressAlertView.h
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYPopView.h"

@interface FKYProductAlertView : FKYPopView

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *inputAddress;

+ (instancetype)showAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                               message:(NSString *)message
                               handler:(void (^)(FKYProductAlertView *alertView, BOOL isRight))handler;

+ (instancetype)showNewAlertViewWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle message:(NSString *)message  dismiss:(BOOL)dismiss handler:(void (^)(FKYProductAlertView *, BOOL))handler;
+ (instancetype)showAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                               message:(NSString *)message
                            titleColor:(UIColor *)messageColor
                               handler:(void (^)(FKYProductAlertView *alertView, BOOL isRight))handler;

+ (instancetype)showAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                             leftColor:(UIColor *)leftColor
                            rightTitle:(NSString *)rightTitle
                            rightColor:(UIColor *)rightColor
                      attributeMessage:(NSAttributedString *)attributeMessage
                               handler:(void (^)(FKYProductAlertView *, BOOL))handler;

+ (instancetype)showAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                             leftColor:(UIColor *)leftColor
                            rightTitle:(NSString *)rightTitle
                            rightColor:(UIColor *)rightColor
                               message:(NSString *)message
                            titleColor:(UIColor *)messageColor
                               handler:(void (^)(FKYProductAlertView *, BOOL))handler;

+ (instancetype)showAlertViewWithTitle:(NSString *)title
                             leftTitle:(NSString *)leftTitle
                            rightTitle:(NSString *)rightTitle
                               message:(NSString *)message
                            dismiss:(BOOL )dismiss
                               handler:(void (^)(FKYProductAlertView *alertView, BOOL isRight))handler;
+ (instancetype)showsSeriousAlertViewWithTitle:(NSString *)title
                                     leftTitle:(NSString *)leftTitle
                                    rightTitle:(NSString *)rightTitle
                                       message:(NSString *)message
                                       handler:(void (^)(FKYProductAlertView *alertView, BOOL isRight))handler;
@end
