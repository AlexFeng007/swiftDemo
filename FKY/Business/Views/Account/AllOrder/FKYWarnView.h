//
//  FKYTimeView.h
//  FKY
//
//  Created by mahui on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  申请拒收/补货之顶部提示视图

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FKYWarnViewType) {
    FKYWarnViewTypeNomal,
    FKYWarnViewTypeJSBU,
};


@interface FKYWarnView : UIView

- (void)configViewWithType:(FKYWarnViewType)type;

@end
