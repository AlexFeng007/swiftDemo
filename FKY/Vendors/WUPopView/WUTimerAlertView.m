//
//  WUTimerAlertView.m
//  YYW
//
//  Created by Lily on 2017/9/8.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "WUTimerAlertView.h"
#import "WUPopHeader.h"
#import <Masonry/Masonry.h>

@interface WUTimerAlertView ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *messageLabel;
@property (nonatomic, strong) UIButton    *confirmButton;
@property (nonatomic, strong) NSTimer     *timer;
@property (nonatomic, assign) NSInteger    totalTimeInterval;

@end

@implementation WUTimerAlertView

#pragma mark - life cycle

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle timeInterval:(NSInteger)interval hideCompletion:(WUPopCompletion)block
{
    self = [super init];
    
    if ( self )
        {
        self.type = WUPopTypeAlert;
        self.hideCompletion = block;
        
        WUAlertViewConfig *config = [WUAlertViewConfig shared];
        
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(311);
        }];
        
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 ) {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
            }];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:config.titleFontSize];
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.mas_bottom;
        }
        
        if ( message.length > 0 ) {
            self.messageLabel = [UILabel new];
            [self addSubview:self.messageLabel];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(title.length ? 10 : config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
            }];
            self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.messageLabel.text = message;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.textColor = [UIColor wu_colorWithHex:0x333333FF];
            self.messageLabel.font = [UIFont systemFontOfSize:config.messageFontSize];
            
            lastAttribute = self.messageLabel.mas_bottom;
        }
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        NSString *btnTitle = [NSString stringWithFormat:@"%@(%zds)", buttonTitle.length ? buttonTitle : @"确定", interval];
        [_confirmButton setTitle:btnTitle forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor wu_colorWithHex:0xFFFFFFFF] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor wu_colorWithHex:0xFF6666FF];
        [_confirmButton addTarget:self action:@selector(actionHide) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_confirmButton];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(25);
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@46);
        }];
        
        _totalTimeInterval = interval;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fireTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

#pragma mark - action

- (void)fireTimer
{
    self.totalTimeInterval--;
    if ( self.totalTimeInterval > 0 ) {
        [self.confirmButton setTitle:[NSString stringWithFormat:@"确定(%zds)",self.totalTimeInterval] forState:UIControlStateNormal];
    }
    else {
        [self actionHide];
    }
}

- (void)actionHide
{
    [_timer invalidate];
    _timer = nil;
    [self hideWithBlock:self.hideCompletion];
}

@end

