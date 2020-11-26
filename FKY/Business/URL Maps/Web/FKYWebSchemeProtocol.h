//
//  FKYWebSchemeProtocol
//  FKY
//
//  Created by yangyouyong on 2017/1/11.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FKY_Web <NSObject>

/**
 原生导航栏风格，默认不显示
 */
@property (nonatomic) FKYWebBarStyle barStyle;
@property (nonatomic, readwrite, copy) NSString *urlPath;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, assign) BOOL isShutDown;
@property (nonatomic, assign) BOOL fromFuson;
@property (nonatomic, assign) NSInteger pushType;// 1:从自营店收货跳转 2:已完成订去评价单跳转 3:非自营店收货跳转

@end

