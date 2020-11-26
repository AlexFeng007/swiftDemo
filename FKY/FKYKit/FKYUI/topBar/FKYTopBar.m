//
//  FKYTopBar.m
//  FKY
//
//  Created by yangyouyong on 2016/9/19.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYTopBar.h"
#import <Masonry/Masonry.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FKYTopBar ()

@property (nonatomic, strong)  UIView *topView;
@property (nonatomic, strong)  UIView *bottomView;
@property (nonatomic, strong, readwrite)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIButton *highLightButton;
@property (nonatomic, strong)  UIView *bottomRedView;
@property (nonatomic, strong)  UIView *contentView;

@end


@implementation FKYTopBar

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.topView != nil) {
        return ;
    }
    [self setUI];
    UIButton *button = (UIButton *)[self viewWithTag:101];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)setUI {
    self.topView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    self.bottomView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    
    self.scrollView = ({
        UIScrollView *view = [[UIScrollView alloc] init];
        self.contentView = [UIView new];
        [view addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
            make.height.equalTo(view);
        }];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        view.scrollEnabled = YES;
        
        UIView *midView = view;
        
        for (int i = 1; i <= self.titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.contentView addSubview:button];
            button.tag = 100 + i;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (i == 1) {
                    make.left.equalTo(midView.mas_left);
                }else{
                    make.left.equalTo(midView.mas_right);
                }
                make.top.equalTo(midView.mas_top);
                make.bottom.equalTo(midView.mas_bottom);
                make.width.equalTo(@(SCREEN_WIDTH / self.titleArray.count));
            }];
            
            [button setTitle:self.titleArray[i - 1] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            button.titleLabel.font = FKYSystemFont(FKYWH(14));
            __weak __typeof(self)weakSelf = self;
            [button bk_addEventHandler:^(UIButton *sender) {
                [weakSelf buttonClick:sender];
                safeBlock(weakSelf.buttonClickBlock, sender.tag);
            } forControlEvents:UIControlEventTouchUpInside];
            if (i == self.titleArray.count) {
                [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(button.mas_right);
                }];
            }
            midView = button;
        }
        self.bottomRedView = ({
            UIView *view = [[UIView alloc] init];
            [self.contentView addSubview:view];
            view.frame = CGRectMake(0, 0, self.lineWidth, self.lineHeight);
            view.backgroundColor = self.selectedColor;
            view;
        });
        view;
    });
}

- (void)buttonClick:(UIButton *)button {
    CGFloat centerX = 0;
    NSInteger i = button.tag - 100;
    centerX = (i * 2 - 1) * SCREEN_WIDTH / (self.titleArray.count * 2);
    [self.highLightButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    self.highLightButton = button;
    CGFloat titleW = 0;
    if (self.lineWidth > 0) {
        titleW = self.lineWidth;
    }else{
        if (i-1 < self.titleArray.count){
            NSString *titleStr = self.titleArray[i-1];
            titleW = [titleStr widthWithFont:FKYSystemFont(FKYWH(14)) constrainedToHeight:FKYWH(44)];
        }
    }
    @weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        @strongify(self);
        self.bottomRedView.frame = CGRectMake(0, 0, titleW, self.lineHeight);
        self.bottomRedView.center = CGPointMake(centerX, self.frame.size.height - FKYWH(0.5));
        
    } completion:nil];
    [self.highLightButton setTitleColor:self.selectedColor forState:UIControlStateNormal];
}

- (void)allOrderStatusViewSelectedButtonTag:(NSInteger)tag {
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:tag];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
