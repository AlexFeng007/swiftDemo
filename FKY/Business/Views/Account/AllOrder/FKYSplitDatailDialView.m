//
//  FKYSplitDatailDialView.m
//  FKY
//
//  Created by zengyao on 2017/6/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYSplitDatailDialView.h"
#import <Masonry/Masonry.h>

const NSInteger kDialPickerHeight = 160;

typedef void (^DialDiliveryman)(void);

@interface FKYSplitDatailDialView ()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) DialDiliveryman callback;
@end

@implementation FKYSplitDatailDialView

+ (void)showDialViewWithPhoneNumber:(NSString *)phoneNumber andCallback:(void (^)(void))callback
{
    if (phoneNumber.length != 11) { return; }
    
    FKYSplitDatailDialView *dialView = [[FKYSplitDatailDialView alloc] init];
    dialView.phoneNumber = phoneNumber;
    dialView.callback = callback;
    [dialView setupSubViews];
    [dialView show];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setupSubViews
{
    UIButton *buttonDial = [[UIButton alloc] init];
    buttonDial.backgroundColor = UIColorFromRGB(0xFE403B);
    buttonDial.layer.cornerRadius = 3;
    buttonDial.layer.masksToBounds = YES;
    [buttonDial addTarget:self action:@selector(handleDial) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonDial];
    
    UILabel *labelPhone = [[UILabel alloc] init];
    labelPhone.font = [UIFont systemFontOfSize:18];
    labelPhone.textColor = [UIColor whiteColor];
    NSMutableString *phonestring = [NSMutableString stringWithString:self.phoneNumber];
    [phonestring insertString:@" " atIndex:3];
    [phonestring insertString:@" " atIndex:phonestring.length - 4];
    labelPhone.text = phonestring;
    [buttonDial addSubview:labelPhone];
    
    UIImageView *imagephone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"consultation_phone_icon"]];
    [buttonDial addSubview:imagephone];
    
    UIButton *buttonCancel = [[UIButton alloc] init];
    buttonCancel.backgroundColor = UIColorFromRGB(0x535353);
    buttonCancel.layer.cornerRadius = 3;
    buttonCancel.layer.masksToBounds = YES;
    [buttonCancel setTitle:@"取 消" forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = [UIFont systemFontOfSize:18];
    [buttonCancel addTarget:self action:@selector(handleDisappear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonCancel];
    
    [buttonDial mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(24);
        make.height.equalTo(@(53));
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    [labelPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonDial).offset(10);
        make.centerY.equalTo(buttonDial);
    }];
    
    [imagephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(29, 24));
        make.centerY.equalTo(buttonDial);
        make.right.mas_equalTo(labelPhone.mas_left).offset(-10);
    }];
    
    [buttonCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.height.equalTo(@(53));
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    _maskView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizerTap setNumberOfTapsRequired:1];
    recognizerTap.cancelsTouchesInView = NO;
    [_maskView addGestureRecognizer:recognizerTap];
    [window addSubview:_maskView];
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kDialPickerHeight);
    [_maskView addSubview:self];
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.frame = CGRectMake(0, SCREEN_HEIGHT - kDialPickerHeight, SCREEN_WIDTH, kDialPickerHeight);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIEvent

- (void)handleTapBehind:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil];
        if (![self pointInside:[self convertPoint:location fromView:_maskView] withEvent:nil]) {
            [_maskView removeGestureRecognizer:sender];
            [self handleDisappear];
        }
    }
}

- (void)handleDial
{
    [self handleDisappear];
    if (_callback) {
        _callback();
    }
}

- (void)handleDisappear
{
    @weakify(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        @strongify(self);
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kDialPickerHeight);
        self->_maskView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        @strongify(self);
        [self removeFromSuperview];
        [self->_maskView removeFromSuperview];
    }];
}

@end
