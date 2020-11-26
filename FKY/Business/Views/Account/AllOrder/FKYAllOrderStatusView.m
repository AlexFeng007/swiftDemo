//
//  FKYAllOrderStatusView.m
//  FKY
//
//  Created by mahui on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYAllOrderStatusView.h"

#import <Masonry/Masonry.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface FKYAllOrderStatusView ()

@property (nonatomic, strong)  UIView *topView;
@property (nonatomic, strong)  UIView *bottomView;
@property (nonatomic, strong, readwrite)  NSMutableArray *titleArray;
@property (nonatomic, strong)  UIButton *highLightButton;
@property (nonatomic, strong)  UIView *bottomRedView;
@property (nonatomic, assign)  NSInteger selectedIndex;
@property (nonatomic, strong) UIView *contentView;

@end


@implementation FKYAllOrderStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        UIButton *button = (UIButton *)[self viewWithTag:101];
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setUI
{
    self.titleArray = [NSMutableArray arrayWithObjects:@"全部", @"待付款", @"待发货", @"待收货", @"已完成", nil];
    
    self.topView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xcccccc);
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
        view.backgroundColor = UIColorFromRGB(0xcccccc);
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
                make.width.equalTo(@(SCREEN_WIDTH / 5));
            }];
            
            [button setTitle:self.titleArray[i - 1] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            button.titleLabel.font = FKYSystemFont(FKYWH(14));
            __weak __typeof(self)weakSelf = self;
            //__weak __typeof(self)weakView = view;
            @weakify(view);
            [button bk_addEventHandler:^(UIButton *sender) {
                @strongify(view);
                weakSelf.selectedIndex = sender.tag - 101;
                if (weakSelf.titleArray.count > 5) {
                    if (view.contentOffset.x == 0) {
                        if (weakSelf.selectedIndex >= 2) {
                            [UIView animateWithDuration:0.2 animations:^{
                                view.contentOffset = CGPointMake(SCREEN_WIDTH / 5, 0);
                            }];
                        }
                    }
                    if (view.contentOffset.x != 0) {
                        if (weakSelf.selectedIndex <= 2) {
                            [UIView animateWithDuration:0.2 animations:^{
                                view.contentOffset = CGPointZero;
                            }];
                        }
                    }
                }
                
                [weakSelf buttonClick:sender];
                safeBlock(weakSelf.buttonClickBlock, weakSelf.selectedIndex);
                
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
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(SCREEN_WIDTH/5);
                make.height.mas_equalTo(0.5);
                make.bottom.equalTo(self.contentView);
                make.left.equalTo(self.contentView);
            }];
            view.backgroundColor = UIColorFromRGB(0xdf4138);
            view;
        });
        view;
    });
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger i = button.tag - 100;
    [self.highLightButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    self.highLightButton = button;
    [self.bottomRedView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset((i - 1) * (SCREEN_WIDTH/5));
    }];
    @weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        @strongify(self);
        [self.bottomRedView layoutIfNeeded];
    } completion:nil];
    [self.highLightButton setTitleColor:UIColorFromRGB(0xdf4138) forState:UIControlStateNormal];
}

- (void)allOrderStatusViewSelectedButtonTag:(NSInteger)tag
{
   UIButton *button = (UIButton *)[self.scrollView viewWithTag:tag + 101];
    self.selectedIndex = tag;
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
