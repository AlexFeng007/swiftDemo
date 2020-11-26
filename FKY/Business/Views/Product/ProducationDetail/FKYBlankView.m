//
//  FKYBlankView.m
//  FKY
//
//  Created by mahui on 15/10/16.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBlankView.h"
#import <Masonry/Masonry.h>

@interface FKYBlankView ()

@property (nonatomic, strong)  UIImageView *IconView;
@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *subTitleLabel;

@end

@implementation FKYBlankView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.IconView = ({
        UIImageView *view = [UIImageView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(FKYWH(140));
            make.width.height.equalTo(@(FKYWH(80)));
            make.centerX.equalTo(self.mas_centerX);
        }];
        view;
    });
    
    self.titleLabel = ({
        UILabel *label =[UILabel new];
        [self addSubview:label];
        label.font = FKYSystemFont(FKYWH(16));
        label.textColor = UIColorFromRGB(0xCCCCCC);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.IconView.mas_bottom).offset(FKYWH(24));
            make.centerX.equalTo(self.mas_centerX);
            make.left.equalTo(self.mas_left).offset(FKYWH(12));
            make.right.equalTo(self.mas_right).offset(-FKYWH(12));
        }];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    
    self.subTitleLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        label.font = FKYSystemFont(FKYWH(16));
        label.textColor = UIColorFromRGB(0xCCCCCC);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(FKYWH(4));
            make.centerX.equalTo(self.mas_centerX);
            make.left.equalTo(self.mas_left).offset(FKYWH(12));
            make.right.equalTo(self.mas_right).offset(-FKYWH(12));
        }];
        label.numberOfLines = 0;
        
        label;
    });
}

+ (FKYBlankView *)FKYBlankViewInitWithFrame:(CGRect)frame andImage:(UIImage *)image andTitle:(NSString *)title andSubTitle:(NSString *)subTitle{
    FKYBlankView *view = [[FKYBlankView alloc] initWithFrame:frame];
    view.IconView.image = image;
    view.titleLabel.text = title;
    view.subTitleLabel.text = subTitle;
    return view;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subtitle {
    self.subTitleLabel.text = subtitle;
}

@end
