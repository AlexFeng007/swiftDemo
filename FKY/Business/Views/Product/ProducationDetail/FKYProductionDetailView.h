//
//  FKYProducationDetailView.h
//  FKY
//
//  Created by mahui on 15/9/16.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "JSBadgeView.h"

typedef void(^JionBlock)(void);
typedef void(^ProductionDetailViewCartBlock)(void);

@interface FKYProductionDetailView : UIView

@property (nonatomic, strong)  UIButton *jionButton;
@property (nonatomic, strong)  UIView *bottomWhiteView;
@property (nonatomic, strong)  UIButton *bottomRedView;
@property (nonatomic, copy)  JionBlock jionBlock;
@property (nonatomic, copy)  ProductionDetailViewCartBlock cartBlock;
@property (nonatomic, strong)  JSBadgeView *badgeView;
@property (nonatomic, copy) void (^showLoginBlock)(void);

@end
