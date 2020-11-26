//
//  GLNavigationBarComponent.m
//  YYW
//
//  Created by airWen on 2017/3/2.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLNavigationBarComponent.h"
#import "GLNavgationBarButton.h"
#import "UIColor+HEX.h"

@interface GLNavigationBarComponent ()
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) NSLayoutConstraint *constraintnavTitleLabelWidth;
@property (nonatomic, assign) CGFloat totalButtonWidth;
@property (nonatomic, weak) GLNavgationBarButton *rightLastAddButton;  //只是一个auto标志，其他无任何作用
@property (nonatomic, weak) GLNavgationButton *leftrightLastAddButton; //只是一个auto标志，其他无任何作用
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation GLNavigationBarComponent

#pragma mark - life cycle

- (nonnull instancetype)init
{
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat statuBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    self = [super initWithFrame:CGRectMake(0, -statuBarHeight, screenWidth, [self fky_NavigationBarHeight])];
    if (self) {

        [self setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.backgroundColor = UIColorFromRGB(0xf54b41);

        [self addSubview:self.navTitleLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        
        CGFloat offset = 10.0;
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.bottom > 0) {
                offset = 20;
            }
        }
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:offset]];

        self.totalButtonWidth = 16.0f;

        self.constraintnavTitleLabelWidth = [NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-_totalButtonWidth];

        [self addConstraint:self.constraintnavTitleLabelWidth];

        [self addSubview:self.bottomLine];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (CGFloat)fky_NavigationBarHeight
{
    if (@available(iOS 11, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (insets.bottom > 0) {
            return insets.top + 44;
        }
    }
    return FKYWH(64);
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), [self fky_NavigationBarHeight]);
}

#pragma mark - User Action

- (void)onLeftNavBarReturnButton:(id)sender
{
    if ((nil != _eventDelegate) && ([_eventDelegate respondsToSelector:@selector(touchLeftReturnNavigationBarButton)])) {
        [_eventDelegate touchLeftReturnNavigationBarButton];
    }
}

- (void)onLeftNavBarCloseButton:(id)sender
{
    if ((nil != _eventDelegate) && ([_eventDelegate respondsToSelector:@selector(touchLeftCloseNavigationBarButton)])) {
        [_eventDelegate touchLeftCloseNavigationBarButton];
    }
}

- (void)onRightNavBarButton:(id)sender
{
    if ((nil != _eventDelegate) && ([_eventDelegate respondsToSelector:@selector(touchRightNavigationBarButton:)])) {
        NSInteger tag = 0;
        if ([sender isKindOfClass:[UIView class]]) {
            tag = [(UIView *) sender tag];
        }
        [_eventDelegate touchRightNavigationBarButton:tag];
    }
}

#pragma mark -Public

- (void)setTitle:(nullable NSString *)title
{
    [self.navTitleLabel setText:title];
}

- (void)setTitleColor:(UIColor *)color
{
    self.navTitleLabel.textColor = color;
}

- (void)setBottomLineVisible:(BOOL)visible
{
    self.bottomLine.hidden = !visible;
}

- (void)setBottomLineColor:(UIColor *)color
{
    self.bottomLine.backgroundColor = color;
}

- (void)configNavLeftButton:(nullable NSString *)imageflag
{
    GLNavgationButton *returnButton = [GLNavgationButton buttonWithType:UIButtonTypeCustom];
    returnButton.margin = 10;
    [returnButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (imageflag.length>0 && ![imageflag isEqualToString:@"red"] && ![imageflag isEqualToString:@"white"]) {
        [returnButton sd_setImageWithURL:[NSURL URLWithString:[imageflag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal];
         [returnButton sd_setImageWithURL:[NSURL URLWithString:[imageflag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateHighlighted];
    }else{
        if (![imageflag isEqualToString:@"red"]) {
            [returnButton setImage:[UIImage imageNamed:@"icon_back_white_normal"] forState:UIControlStateNormal];
            [returnButton setImage:[UIImage imageNamed:@"icon_back_white_normal"] forState:UIControlStateHighlighted];
        } else if (![imageflag isEqualToString:@"white"]) {
            [returnButton setImage:[UIImage imageNamed:@"icon_back_new_red_normal"] forState:UIControlStateNormal];
            [returnButton setImage:[UIImage imageNamed:@"icon_back_new_red_normal"] forState:UIControlStateHighlighted];
        } else {
            [returnButton setImage:[UIImage imageNamed:@"icon_back_white_normal"] forState:UIControlStateNormal];
            [returnButton setImage:[UIImage imageNamed:@"icon_back_white_normal"] forState:UIControlStateHighlighted];
        }
    }
    [returnButton setExclusiveTouch:YES];
    [returnButton addTarget:self action:@selector(onLeftNavBarReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:returnButton];

    if (nil == _leftrightLastAddButton) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:returnButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:8.0f]];
    }
    else {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:returnButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_leftrightLastAddButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:1.0f]];
    }
    _leftrightLastAddButton = returnButton;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:returnButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navTitleLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];

    _totalButtonWidth += (returnButton.intrinsicContentSize.width + 8.0f);
    self.constraintnavTitleLabelWidth.constant = -_totalButtonWidth;
}

- (void)configNavCloseButtonWithTextColor:(UIColor *)textColor
{
    GLNavgationButton *closeBtn = [GLNavgationButton buttonWithType:UIButtonTypeCustom];
    closeBtn.margin = 8;
    [closeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [closeBtn setExclusiveTouch:YES];
    [closeBtn setTintColor:[UIColor colorWithRed:102 / 255.0f green:102 / 255.0f blue:102 / 255.0f alpha:1.0f]];
    [closeBtn setTitleColor:[UIColor colorWithRed:102 / 255.0f green:102 / 255.0f blue:102 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    closeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    if (textColor) {
        [closeBtn setTitleColor:textColor forState:UIControlStateNormal];
    }
    [closeBtn addTarget:self action:@selector(onLeftNavBarCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];

    if (nil == _leftrightLastAddButton) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:8.0f]];
    }
    else {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_leftrightLastAddButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:1.0f]];
    }
    _leftrightLastAddButton = closeBtn;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navTitleLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];

    _totalButtonWidth += (closeBtn.intrinsicContentSize.width + 8.0f);
    self.constraintnavTitleLabelWidth.constant = -_totalButtonWidth;
}

- (void)configNavRightButtonWithIndex:(NSInteger)index imgUrl:(NSString *)imgUrl title:(NSString *)title
{
    GLNavgationBarButton *rightButton = [[GLNavgationBarButton alloc] initWithTitle:title imgUrl:imgUrl];
    if (nil != rightButton) {
        rightButton.tag = index;
        [rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [rightButton addTarget:self action:@selector(onRightNavBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navTitleLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
        if (nil == _rightLastAddButton) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-8.0f]];

            _rightLastAddButton = rightButton;
        }
        else {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_rightLastAddButton attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-1.0f]];

            _rightLastAddButton = rightButton;
        }
        _totalButtonWidth += (rightButton.intrinsicContentSize.width + 8.0f);
    }
}

#pragma mark - property getter

- (UILabel *)navTitleLabel
{
    if (nil == _navTitleLabel) {
        _navTitleLabel = [UILabel new];
        [_navTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_navTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_navTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_navTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_navTitleLabel setTextColor:UIColorFromRGB(0xffffff)];
    }
    return _navTitleLabel;
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [UIView new];
        _bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomLine.backgroundColor = [UIColorFromRGB(0x979797) colorWithAlphaComponent:0.3];
    }
    return _bottomLine;
}

@end
