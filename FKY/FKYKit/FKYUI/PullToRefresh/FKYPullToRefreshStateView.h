//
//  FKYPullToRefreshStateView.h
//  FKY
//
//  Created by yangyouyong on 15/10/23.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//  自定义的下拉刷新、上拉加载更多视图

#import <UIKit/UIKit.h>
#import <SVPullToRefresh/SVPullToRefresh.h>


@interface FKYPullToRefreshStateView : UIView

+ (instancetype)fky_headerViewWithState:(SVPullToRefreshState)state;
+ (instancetype)fky_footerViewWithState:(SVPullToRefreshState)state;

@end
