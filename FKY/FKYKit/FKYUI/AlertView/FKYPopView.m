//
//  FKYPopView.m
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYPopView.h"
#import <Masonry/Masonry.h>

CGFloat FKYPopViewEdgesTop = 28;
CGFloat FKYPopViewEdgesLeft = 20;
CGFloat FKYPopViewEdgesRight = 20;
CGFloat FKYPopViewCornerRadius = 5;
//static CGFloat kTitleFontSize = 21;

@interface FKYPopView ()

@property (nonatomic, getter=isVisible) BOOL visible; // 当前是否已经显示了

#pragma mark Layout
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *forgroundView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic) BOOL hasBuildLayout;
@end

@implementation FKYPopView

@synthesize forgroundView = _forgroundView, titleLabel = _titleLabel;

- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    _titleLabel.text = title;
}

- (void)show {
    if (self.isVisible) {
        return;
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self fky_layoutSubviews];
    
    self.visible = YES;
    [self p_transformShow];
}

- (void)dismiss {
    @weakify(self);
    [UIView animateWithDuration:.25 delay:0 options:kNilOptions animations:^{
        @strongify(self);
        self.backgroundView.alpha = .0;
        self.forgroundView.alpha = .0;
        self.forgroundView.transform = CGAffineTransformMakeScale(.9, .9);
    } completion:^(BOOL finished) {
        @strongify(self);
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Private

- (void)p_transformShow {
    self.backgroundView.alpha = .0;
    self.forgroundView.alpha = .0;
    self.forgroundView.transform = CGAffineTransformMakeScale(.9, .9);
    @weakify(self);
    [UIView animateWithDuration:.25 delay:0 options:kNilOptions animations:^{
        @strongify(self);
        self.backgroundView.alpha = .5;
        self.forgroundView.alpha = 1;
    } completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:.35 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:5 options:kNilOptions animations:^{
        @strongify(self);
        self.forgroundView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished){
        
    }];
}

- (void)fky_layoutSubviews {
    if (self.hasBuildLayout) {
        return;
    }
    
    _backgroundView = ({
        UIView *v = UIView.new;
        v.backgroundColor = UIColorFromRGB(0x0);
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        v;
    });
    
    _forgroundView = ({
        UIView *v = UIView.new;
        v.layer.masksToBounds = YES;
        v.layer.cornerRadius = FKYWH(FKYPopViewCornerRadius);
        v.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@(FKYWH(240)));
        }];
        v;
    });
    
    if (_title) {
        _titleLabel = ({
            UILabel *l = UILabel.new;
            l.backgroundColor = UIColor.clearColor;
            l.textColor = UIColorFromRGB(0x666666);
            l.numberOfLines = 1;
            l.textAlignment = NSTextAlignmentCenter;
            [_forgroundView addSubview:l];
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self->_forgroundView).offset(FKYWH(FKYPopViewEdgesTop));
                make.left.equalTo(self->_forgroundView).offset(FKYWH(FKYPopViewEdgesLeft));
                make.right.equalTo(self->_forgroundView).offset(FKYWH(-FKYPopViewEdgesRight));
            }];
            l;
        });
        _titleLabel.text = _title;
    }
    
    self.hasBuildLayout = YES;
}

@end
