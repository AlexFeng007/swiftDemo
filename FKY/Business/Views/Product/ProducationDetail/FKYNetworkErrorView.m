//
//  FKYNoNetworkView.m
//  FKY
//
//  Created by mahui on 15/10/23.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYNetworkErrorView.h"
#import <Masonry/Masonry.h>

@implementation FKYNetworkErrorView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self setUI];
    };
    return self;
}


- (void)setUI {
//    UIView *containerView = [UIView new];
//    [self addSubview:containerView];
//    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
//    
//    UIView *imageContentView = ({
//        UIView *view = [UIView new];
//        [containerView addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(FKYWH(330)));
//            make.centerX.equalTo(self.mas_centerX);
//            make.height.equalTo(@(FKYWH(60)));
//            make.top.equalTo(containerView.mas_top);
//        }];
//        view;
//    });
    
    UIImageView *errorImage = [UIImageView new];
    errorImage.image = [UIImage imageNamed:@"image_network_error"];
    [self addSubview:errorImage];
    [errorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@(FKYWH(116)));
    }];
    
    UILabel *errorLabel = [UILabel new];
    errorLabel.font = FKYSystemFont(FKYWH(18));
    errorLabel.text = @"网络异常";
    [self addSubview:errorLabel];
    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(errorImage.mas_bottom).offset(FKYWH(15));
        make.centerX.equalTo(errorImage);
    }];
    
    UILabel *subLabel = [UILabel new];
    subLabel.font = FKYSystemFont(FKYWH(14));
    subLabel.text = @"网络不给力，请检查网络";
    [self addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(errorLabel.mas_bottom).offset(FKYWH(10));
        make.centerX.equalTo(errorLabel);
    }];
    
}





@end
