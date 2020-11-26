//
//  FKYURLAction.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYURLAction : NSObject


@property (nonatomic, strong) NSURL *URL;

/**
 *  对于外部URL是否在Safari中打开，默认为YES
 */
@property (nonatomic, assign) BOOL openHTTPURLInSafari;

/**
 *  是否以Modal形式打开URL对应的ViewController，默认为NO
 */
@property (nonatomic, assign) BOOL isModal;

/**
 *  打开URL对应的ViewController时是否有动画，默认为YES
 */
@property (nonatomic, assign) BOOL animated;

/**
 *  是否采用自定义过渡，默认为YES
 *  YES: 采用自定义过渡，即HJNavigationController中自定义的过渡效果
 *  NO: 采用系统的过渡效果
 */
@property (nonatomic, assign) BOOL customTransition;

+ (instancetype)actionWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL;

@end
