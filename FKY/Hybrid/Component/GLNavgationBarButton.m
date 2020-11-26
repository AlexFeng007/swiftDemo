//
//  GLNavgationBarButton.m
//  YYW
//
//  Created by airWen on 2017/3/2.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLNavgationBarButton.h"

typedef NS_ENUM(NSUInteger, ButtonContentType) {
    ButtonContentType_None,
    ButtonContentType_OnlyTitle,
    ButtonContentType_OnlyImage,
    ButtonContentType_TitleAndImage
};

#pragma mark - GLNavgationBarButton

#define GLButtonSpace 4

@interface GLNavgationBarButton ()
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIControl *controlMask;
@property (nonatomic, assign) ButtonContentType contentType;
@end

@implementation GLNavgationBarButton

#pragma mark - private

- (BOOL)isEmptyString:(NSString *)string
{
    if ([string isKindOfClass:[NSString class]]) {
        if ((nil == string) || (0 == [string length]) || [string isEqualToString:@""]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return YES;
    }
}

#pragma mark - life cycle

- (instancetype)initWithTitle:(NSString *)title imgUrl:(NSString *)imgUrl
{
    if ([self isEmptyString:title] && [self isEmptyString:imgUrl]) {
        NSLog(@"【GLHybrid Error】数据异常");
        return nil;
    }
    self = [super initWithFrame:CGRectZero];
    if (self) {
        if (![self isEmptyString:title] && [self isEmptyString:imgUrl]) {
            //只有title
            self.contentType = ButtonContentType_OnlyTitle;

            [self addSubview:self.lblTitle];
            [self.lblTitle setText:title];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(space)-[_lblTitle]-(space)-|" options:0 metrics:@{ @"space" : @(GLButtonSpace) } views:NSDictionaryOfVariableBindings(_lblTitle)]];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(space)-[_lblTitle]-(space)-|" options:0 metrics:@{ @"space" : @(GLButtonSpace) } views:NSDictionaryOfVariableBindings(_lblTitle)]];
        }
        else if ([self isEmptyString:title] && ![self isEmptyString:imgUrl]) {
            //只有img
            self.contentType = ButtonContentType_OnlyImage;

            [self addSubview:self.imgView];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

            NSLayoutConstraint *constraintImgH = [NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
            [self addConstraint:constraintImgH]; //25

            NSLayoutConstraint *constraintImgW = [NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
            [self addConstraint:constraintImgW]; //25

            __weak __typeof(self) weakSelf = self;
            __weak __typeof(NSLayoutConstraint *) weakConstraintH = constraintImgH;
            __weak __typeof(NSLayoutConstraint *) weakConstraintW = constraintImgW;
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       NSLog(@"1 imageURL = %@ imagesize:%@ %@:%d", imageURL, NSStringFromCGSize(image.size), [NSThread currentThread], [[NSThread currentThread] isMainThread]);
                                       if (nil != image) {
                                           [weakSelf.imgView setImage:image];
                                           CGFloat height = 30 - GLButtonSpace * 2;
                                           weakConstraintH.constant = height;
                                           weakConstraintW.constant = (image.size.width * height) / image.size.height;
                                       }
                                       else {
                                           NSLog(@"【GLHybrid Error】 button image 获取失败");
                                       }
                                       [weakSelf setNeedsLayout];
                                   }];
        }
        else if (![self isEmptyString:title] && ![self isEmptyString:imgUrl]) {
            //有img 和 title
            self.contentType = ButtonContentType_TitleAndImage;

            [self addSubview:self.lblTitle];
            [self addSubview:self.imgView];

            [self.lblTitle setText:title];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(space)-[_lblTitle]-(space)-|" options:0 metrics:@{ @"space" : @(GLButtonSpace) } views:NSDictionaryOfVariableBindings(_lblTitle)]];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(space)-[_imgView][_lblTitle(<=19)]-(space)-|" options:0 metrics:@{ @"space" : @(GLButtonSpace) } views:NSDictionaryOfVariableBindings(_lblTitle, _imgView)]];

            NSLayoutConstraint *constraintImgH = [NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
            [self addConstraint:constraintImgH]; //25

            NSLayoutConstraint *constraintImgW = [NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
            [self addConstraint:constraintImgW]; //25

            __weak __typeof(self) weakSelf = self;
            __weak __typeof(NSLayoutConstraint *) weakConstraintH = constraintImgH;
            __weak __typeof(NSLayoutConstraint *) weakConstraintW = constraintImgW;
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       if (nil != image) {
                                           [weakSelf.imgView setImage:image];
                                           weakConstraintH.constant = 25;
                                           weakConstraintW.constant = (image.size.width * 25) / image.size.height;
                                       }
                                       else {
                                           weakConstraintH.constant = 0.0f;
                                           weakConstraintW.constant = 0.0f;
                                       }
                                       [weakSelf setNeedsLayout];
                                   }];
        }

        [self addSubview:self.controlMask];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_controlMask]|" options:0 metrics:@{ @"space" : @(GLButtonSpace) } views:NSDictionaryOfVariableBindings(_controlMask)]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_controlMask]|" options:0 metrics:@{ @"space" : @(GLButtonSpace) } views:NSDictionaryOfVariableBindings(_controlMask)]];
    }
    return self;
}

#pragma mark - public

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.controlMask addTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark - override UIView

- (void)setTag:(NSInteger)tag
{
    self.controlMask.tag = tag;
}

- (CGSize)intrinsicContentSize
{
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    switch (_contentType) {
        case ButtonContentType_OnlyTitle: {
            width = _lblTitle.intrinsicContentSize.width;
            if (width > 100) {
                width = 100;
            }
            height = 25;
        } break;
        case ButtonContentType_OnlyImage: {
            CGSize sizeImage = _imgView.intrinsicContentSize;
            height = 25;
            width = (sizeImage.width * (height - GLButtonSpace * 2)) / sizeImage.height + GLButtonSpace * 2;
        } break;
        case ButtonContentType_TitleAndImage: {
            CGSize sizeTitle = _lblTitle.intrinsicContentSize;
            CGSize sizeImage = _imgView.intrinsicContentSize;
            //CGFloat imgheight = (44-GLButtonSpace*2) * 0.618;
            CGFloat imgheight = 25;

            CGFloat imgwidth = (sizeImage.width * imgheight) / sizeImage.height;

            if (imgwidth >= sizeTitle.width) {
                width = imgwidth + GLButtonSpace * 2;
            }
            else {
                width = sizeTitle.width + GLButtonSpace * 2;
            }
            height = 25;

        } break;
        default:
            break;
    }
    NSLog(@"%@", NSStringFromCGSize(CGSizeMake(width, height)));
    return CGSizeMake(width, height);
}

#pragma mark - property getter

- (UILabel *)lblTitle
{
    if (nil == _lblTitle) {
        _lblTitle = [UILabel new];
        [_lblTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_lblTitle setBackgroundColor:[UIColor clearColor]];
        [_lblTitle setTextAlignment:NSTextAlignmentCenter];
        [_lblTitle setTextColor:[UIColor colorWithRed:102 / 255.0f green:102 / 255.0f blue:102 / 255.0f alpha:1.0f]];
        [_lblTitle setFont:[UIFont systemFontOfSize:13]];

        [_lblTitle adjustsFontSizeToFitWidth];
    }
    return _lblTitle;
}

- (UIImageView *)imgView
{
    if (nil == _imgView) {
        _imgView = [UIImageView new];
        [_imgView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_imgView setBackgroundColor:[UIColor clearColor]];
        [_imgView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _imgView;
}

- (UIControl *)controlMask
{
    if (nil == _controlMask) {
        _controlMask = [UIControl new];
        [_controlMask setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_controlMask setBackgroundColor:[UIColor clearColor]];
    }
    return _controlMask;
}

@end

#pragma mark - GLNavgationButton
@implementation GLNavgationButton {
    CGSize _imageSize;
    CGSize _labelSize;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageSize = CGSizeZero;

        _labelSize = CGSizeZero;

        _margin = 8;
    }
    return self;
}

#pragma mark - override UIView

- (CGSize)intrinsicContentSize
{
    CGFloat width = ((_imageSize.width > _labelSize.width) ? _imageSize.width : _labelSize.width) + _margin * 2;
    return CGSizeMake(width, 25);
}

#pragma mark - override UIButton

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    _imageSize = [self.imageView intrinsicContentSize];
    if (_imageSize.width>25) {
        _imageSize = CGSizeMake(25, 25);
    }
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    _labelSize = [self.titleLabel intrinsicContentSize];
    [self setNeedsLayout];
}

//image + title
- (CGRect)contentRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(_margin + _imageSize.width, (CGRectGetHeight(contentRect) - _labelSize.height) / 2, _labelSize.width, _labelSize.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(_margin, (CGRectGetHeight(contentRect) - _imageSize.height) / 2, _imageSize.width, _imageSize.height);
}
@end
