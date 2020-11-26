//
//  FKYToast.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYToast.h"


#define HJToastMinContentWidth 60 // 文字最小宽度
#define HJToastMaxContentWidth (CGRectGetWidth([UIScreen mainScreen].bounds) - 40 - 40) // 文字最大宽度
#define HJToastMinHeight 45 // 默认的最小文字高度...<未使用>
#define HJToastMaxHeight 85 // 默认的最大文字高度
#define HJToastSideSpacing 20 // 文字左右两侧间隔
#define HJToastTopSpacing 10  // 文字上下两侧间隔

// 文字font
#define HJToastFontSize [UIFont systemFontOfSize:FKYWH(15.0)]
// 背景色
#define KToastBgColor [[UIColor blackColor] colorWithAlphaComponent:0.92]

// 当前APP支持的最低OS版本就为8
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// toast展示时长
#define kToastShowTime 2.5



static NSMutableArray *toastQueue;
static FKYToast *currentToast;

// UI Style
static UIColor *gBackgroundColor = nil;
static UIColor *gTextColor = nil;
static UIFont *gFont = nil;
static UIEdgeInsets gPaddingEdgeInsets = {0, 0, 0, 0};


@interface FKYToast ()

@property (nonatomic, strong) UIView *containView UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *visualView;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, assign, getter = isVisible) BOOL visible;

+ (NSMutableArray *)sharedQueue;
+ (FKYToast *)currentToast;

@end


@implementation FKYToast

+ (void)configBackgroundColor:(UIColor *)color
{
    gBackgroundColor = color;
}

+ (void)configTextColor:(UIColor *)color
{
    gTextColor = color;
}

+ (void)configTextFont:(UIFont *)font
{
    gFont = font;
}

+ (void)configPaddingEdgeInsets:(UIEdgeInsets)edgeInsets
{
    gPaddingEdgeInsets = edgeInsets;
}

+ (void)showToast:(NSString *)title
{
    [[[FKYToast alloc] initWithTitle:title] show];
}

+ (void)showToast:(NSString *)title withTime:(CGFloat)time
{
    [[[FKYToast alloc] initWithTitle:title] show:time];
}

+ (void)showToast:(NSString *)title delay:(CGFloat)delay numberOfLines:(NSInteger)numberOfLines
{
    [[[FKYToast alloc] initWithTitle:title withNumberOfLines:numberOfLines] showWithDelay:delay];
}

+ (void)showToast:(NSString *)title withImage:(UIImage *)image
{
    [[[FKYToast alloc] initWithTitle:title andImage:image] show];
}


#pragma mark - Init

- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self = [self initWithTitle:title];
        
        gBackgroundColor = KToastBgColor;
        
        _containView.backgroundColor = gBackgroundColor;
        _containView.opaque = YES;
        [self addSubview:_containView];
        
        if (title && title != 0) {
            self.titleLabel.textColor = [UIColor whiteColor];
        }
        
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = image;
        [_containView addSubview:self.iconView];
    }

    return self;
}

- (instancetype)initWithTitle:(NSString *)title withNumberOfLines:(NSInteger)numberOfLines
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initUIStyle];
        
        _containView = [[UIView alloc] initWithFrame:CGRectZero];
        _containView.layer.cornerRadius = 5.0f;
        _containView.layer.masksToBounds = YES;
        _containView.backgroundColor = KToastBgColor;
        _containView.alpha = 0.95;
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        
//        if (IS_IOS8) {
//            _visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//            _visualView.layer.cornerRadius = 5.0f;
//            _visualView.layer.masksToBounds = YES;
//            _visualView.alpha = 0.8;
//            [_containView addSubview:_visualView];
//        }
//        else {
//            _containView.backgroundColor = gBackgroundColor;
//            _containView.alpha = 0.9f;
//        }
        
        if (title && title != 0) {
            // Title信息
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = title;
            _titleLabel.font = gFont;
            _titleLabel.textColor = gTextColor;
            _titleLabel.numberOfLines = numberOfLines;
            _titleLabel.adjustsFontSizeToFitWidth = YES;
            _titleLabel.minimumScaleFactor = 0.8;
            [_containView addSubview:_titleLabel];
        }
        [self addSubview:_containView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title 
{
    return [self initWithTitle:title withNumberOfLines:0];
}

- (void)initUIStyle
{
    if (!gBackgroundColor) {
        gBackgroundColor = KToastBgColor;
    }
    
    if (!gTextColor) {
        gTextColor = [UIColor whiteColor];
    }
    
    if (!gFont) {
        gFont = HJToastFontSize;
    }
    
    if (UIEdgeInsetsEqualToEdgeInsets(gPaddingEdgeInsets, UIEdgeInsetsZero)) {
        gPaddingEdgeInsets = UIEdgeInsetsMake(HJToastTopSpacing, HJToastSideSpacing, HJToastTopSpacing, HJToastSideSpacing);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.iconView.image) {
        // 带图片...<高度固定>
        _containView.frame = CGRectMake(0, 0, FKYWH(200), FKYWH(88));
        _iconView.frame = CGRectMake(0, FKYWH(15), FKYWH(33), FKYWH(33));
        _iconView.center = CGPointMake(CGRectGetWidth(self.containView.frame) / 2.0, FKYWH(28));
        _titleLabel.frame = CGRectMake(0, FKYWH(50), FKYWH(200), FKYWH(30));
        _titleLabel.center = CGPointMake(CGRectGetWidth(self.containView.frame) / 2.0, FKYWH(66));
        _titleLabel.font = gFont;
        self.bounds = _containView.bounds;
        self.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2, CGRectGetHeight([UIScreen mainScreen].bounds) / 2 + FKYWH(80));
        return;
    }
    
    // 文字中是否带换行符
    BOOL multiLines = NO;
    if ([self.titleLabel.text containsString:@"\n"]) {
        multiLines = YES;
    }
    
    // 判断文字有无超过一行...<按只展示一行时的高度来计算宽度>
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, FKYWH(22))
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:HJToastFontSize}
                                              context:NULL].size;
    if (size.width <= HJToastMaxContentWidth && multiLines == NO) {
        // 小于等于最大宽度，即一行可以显示全
        if (size.width < HJToastMinContentWidth) {
            // 最小宽度限制
            size.width = HJToastMinContentWidth;
        }
        self.titleLabel.frame = CGRectMake(0, 0, size.width + 2, FKYWH(22));
    }
    else {
        // 大于最大宽度，即一行显示不全，需要多行
        size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(HJToastMaxContentWidth, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:HJToastFontSize}
                                                  context:NULL].size;
        // 最大高度限制
        CGFloat maxHeight = HJToastMaxHeight;
        if (self.titleLabel.numberOfLines == 0) {
            maxHeight = SCREEN_HEIGHT * 0.75;
        }
        if (size.height >= maxHeight) {
            size.height = maxHeight;
        }
        self.titleLabel.frame = CGRectMake(0, 0, size.width, size.height + 2);
    }
    
    // 容器视图frame
    CGRect frame = self.titleLabel.frame;
    if (self.titleLabel.numberOfLines != 0) {
        if (frame.size.width < HJToastMinContentWidth) {
            frame.size.width = HJToastMinContentWidth;
        }
    }
    frame.size.width += HJToastSideSpacing * 2;
    frame.size.height += HJToastTopSpacing * 2;
    self.containView.frame = frame;
    
    // 标题位置
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.containView.frame) / 2.0, CGRectGetHeight(self.containView.frame) / 2.0);
    
    if (IS_IOS8) {
        self.visualView.frame = self.containView.bounds;
    }
    
    // toast显示位置
    self.bounds = self.containView.bounds;
    self.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2, CGRectGetHeight([UIScreen mainScreen].bounds) / 2 + FKYWH(80));
    //self.frame = CGRectMake((SCREEN_WIDTH-self.containView.frame.size.width) / 2, SCREEN_HEIGHT-self.containView.frame.size.height-FKYWH(80), self.containView.frame.size.width, self.containView.frame.size.height);
    self.frame = CGRectMake((SCREEN_WIDTH-self.containView.frame.size.width) / 2, (SCREEN_HEIGHT-self.containView.frame.size.height) / 2 - FKYWH(90), self.containView.frame.size.width, self.containView.frame.size.height);
}

- (void)showWithDelay:(CGFloat)delay
{
    if (self.isVisible) {
        return;
    }
    
    [[FKYToast sharedQueue] addObject:self];
    
    if ([FKYToast currentToast].isVisible) {
        [[FKYToast currentToast] dismissWithAnimation:NO];
    }
    self.visible = YES;
    
    [FKYToast setCurrentToast:self];
    
    // 布局(提示框会被键盘挡住问题)
    UIWindow *view = [[UIApplication sharedApplication].delegate window];
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    for (id windowView in windows) {
//        NSString *viewName = NSStringFromClass([windowView class]);
//        if ([@"UIRemoteKeyboardWindow" isEqualToString:viewName]) {
//            view = windowView;
//            break;
//        }
//    }
    [view addSubview:self];
    
    self.transform = CGAffineTransformScale(self.transform, 0.98, 0.98);
    @weakify(self);
    [UIView animateKeyframesWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        //
        @strongify(self);
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //
    }];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:(NSTimeInterval)delay];
}

// 默认时长显示
- (void)show
{
    [self showWithDelay:kToastShowTime];
}

// 自定义时长显示
- (void)show:(CGFloat)time
{
    [self showWithDelay:time];
}

- (void)dismiss
{
    [self dismissWithAnimation:YES];
}

- (void)dismissWithAnimation:(BOOL)animation
{
    @weakify(self);
    if (animation) {
        [UIView animateWithDuration:0.3f animations:^{
            @strongify(self);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            @strongify(self);
            [self dismissSelf];
        }];
    }
    else {
        [self dismissSelf];
    }
}

- (void)dismissSelf
{
    self.visible = NO;
    [self removeFromSuperview];
    [[FKYToast sharedQueue] removeObject:self];
    
    if ([FKYToast sharedQueue].count > 0) {
        FKYToast *toast = [[FKYToast sharedQueue] lastObject];
        [toast show];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}


#pragma mark -
#pragma mark Class Method

+ (NSMutableArray*)sharedQueue
{
    if (!toastQueue) {
        toastQueue = [NSMutableArray array];
    }
    return toastQueue;
}

+ (FKYToast *)currentToast
{
    return currentToast;
}

+ (void)setCurrentToast:(FKYToast *)toast
{
    currentToast = toast;
}


@end
