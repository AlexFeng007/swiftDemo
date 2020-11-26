//
//  FKYRefuseListViewController.h
//  FKY
//
//  Created by yangyouyong on 2016/9/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  拒收补货列表

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FKYRefuseListType) {
    JS,
    BH,
    DEFAULT
};

@interface FKYRefuseListViewController : UIViewController

@property (nonatomic, assign) FKYRefuseListType listType;

@end
