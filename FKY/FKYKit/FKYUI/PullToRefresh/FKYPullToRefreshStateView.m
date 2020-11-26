//
//  FKYPullToRefreshStateView.m
//  FKY
//
//  Created by yangyouyong on 15/10/23.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYPullToRefreshStateView.h"
#import <Masonry/Masonry.h>
#import "FKYCategories.h"

@interface FKYPullToRefreshStateView ()

@property (nonatomic, strong) UIActivityIndicatorView *indecatorView;
@property (nonatomic, strong) UIImageView *indecator;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *viewContainer;

@end


@implementation FKYPullToRefreshStateView

+ (instancetype)fky_headerViewWithState:(SVPullToRefreshState)state {
    FKYPullToRefreshStateView *view = [FKYPullToRefreshStateView new];
    view.frame = CGRectMake(0, 0, FKYWH(120), FKYWH(40));
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    return [view initilizeHeaderViewWithState:state];
}

+ (instancetype)fky_footerViewWithState:(SVPullToRefreshState)state {
    FKYPullToRefreshStateView *view = [FKYPullToRefreshStateView new];
    view.frame = CGRectMake(0, 0, FKYWH(120), FKYWH(40));
    return [view initilizeFooterViewWithState:state];
}

- (void)setupView {
    if (_viewContainer != nil) {
        return;
    }
    
    self.indecatorView = ({
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:view];
        view.center = CGPointMake(0, FKYWH(20));
        view.hidden = YES;
        view;
    });
    
    self.indecator = ({
        UIImageView *imageV = [UIImageView new];
        imageV.frame = CGRectMake(0, 0, FKYWH(15), FKYWH(40));
        [self addSubview:imageV];
        imageV;
    });
    
    self.titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(FKYWH(30), FKYWH(20) - label.font.lineHeight / 2.0, FKYWH(160), FKYWH(20));
        [self addSubview:label];
        label;
    });
}

- (instancetype)initilizeHeaderViewWithState:(SVPullToRefreshState)state {
    [self setupView];
    
    if (state == SVPullToRefreshStateStopped) {
        self.indecator.image = [UIImage imageNamed:@"icon_pulltorefresh"];
        self.titleLabel.text = @"下拉刷新...";
    }
    if (state == SVPullToRefreshStateTriggered) {
//        self.indecator.image = [UIImage FKY_image:[UIImage imageNamed:@"icon_pulltorefresh"] rotation:UIImageOrientationDown];
        self.indecator.image = [UIImage imageNamed:@"icon_pulltorefresh_up"];
        self.titleLabel.text = @"松手加载...";
    }
    if (state == SVPullToRefreshStateLoading) {
        self.indecator.hidden = YES;
        self.titleLabel.text = @"加载中...";
        self.indecatorView.hidden = NO;
    }
    
    return self;
}

- (instancetype)initilizeFooterViewWithState:(SVPullToRefreshState)state {
    [self setupView];
    
    if (state == SVPullToRefreshStateStopped) {
//        self.indecator.image = [UIImage FKY_image:[UIImage imageNamed:@"icon_pulltorefresh"] rotation:UIImageOrientationDown];
        self.indecator.image = [UIImage imageNamed:@"icon_pulltorefresh_up"];
        self.titleLabel.text = @"上拉加载更多...";
    }
    if (state == SVPullToRefreshStateTriggered) {
        self.indecator.image = [UIImage imageNamed:@"icon_pulltorefresh"];
        self.titleLabel.text = @"松手加载...";
    }
    if (state == SVPullToRefreshStateLoading) {
        self.indecator.hidden = YES;
        self.titleLabel.text = @"加载中...";
        self.indecatorView.hidden = NO;
    }
    
    return self;
}

@end
