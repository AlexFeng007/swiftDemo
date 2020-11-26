//
//  WUPopViewCategories.m
//  
//
//  Created by Rabe on 10/11/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "WUPopViewCategories.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@implementation UIColor (WUPop)

+ (UIColor *) wu_colorWithHex:(NSUInteger)hex {
    
    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

@end

@implementation UIImage (WUPop)

+ (UIImage *) wu_imageWithColor:(UIColor *)color {
    return [UIImage wu_imageWithColor:color Size:CGSizeMake(4.0f, 4.0f)];
}

+ (UIImage *) wu_imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image wu_stretched];
}

- (UIImage *) wu_stretched
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    
    return [self resizableImageWithCapInsets:insets];
}

@end

@implementation UIButton (WUPop)

+ (id) wu_buttonWithTarget:(id)target action:(SEL)sel
{
    id btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    return btn;
}

@end

@implementation NSString (WUPop)

- (NSString *)wu_truncateByCharLength:(NSUInteger)charLength
{
    __block NSUInteger length = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              
                              if ( length+substringRange.length > charLength ) {
                                  *stop = YES;
                                  return;
                              }
                              
                              length+=substringRange.length;
                          }];
    
    return [self substringToIndex:length];
}

@end

static const void *wu_dimBackgroundViewKey            = &wu_dimBackgroundViewKey;
static const void *wu_dimAnimationDurationKey         = &wu_dimAnimationDurationKey;
static const void *wu_dimBackgroundAnimatingKey       = &wu_dimBackgroundAnimatingKey;

@implementation UIWindow (WUPop)

@dynamic wu_dimBackgroundView;
@dynamic wu_dimAnimationDuration;
@dynamic wu_dimBackgroundAnimating;

//wu_dimBackgroundView
- (UIView *)wu_dimBackgroundView
{
    UIView *dimView = objc_getAssociatedObject(self, wu_dimBackgroundViewKey);
    
    if ( !dimView )
        {
        dimView = [UIView new];
        [self addSubview:dimView];
        [dimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        dimView.alpha = 0.0f;
        dimView.backgroundColor = [UIColor wu_colorWithHex:0x0000007F];
        dimView.layer.zPosition = FLT_MAX;
        
        self.wu_dimAnimationDuration = 0.3f;
        
        objc_setAssociatedObject(self, wu_dimBackgroundViewKey, dimView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    
    return dimView;
}

//wu_dimBackgroundAnimating
- (BOOL)wu_dimBackgroundAnimating
{
    return [objc_getAssociatedObject(self, wu_dimBackgroundAnimatingKey) boolValue];
}

- (void)setWu_dimBackgroundAnimating:(BOOL)wu_dimBackgroundAnimating
{
    objc_setAssociatedObject(self, wu_dimBackgroundAnimatingKey, @(wu_dimBackgroundAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//wu_dimAnimationDuration
- (NSTimeInterval)wu_dimAnimationDuration
{
    return [objc_getAssociatedObject(self, wu_dimAnimationDurationKey) doubleValue];
}

- (void)setWu_dimAnimationDuration:(NSTimeInterval)wu_dimAnimationDuration
{
    objc_setAssociatedObject(self, wu_dimAnimationDurationKey, @(wu_dimAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wu_showDimBackground
{
    self.wu_dimBackgroundView.hidden = NO;
    self.wu_dimBackgroundAnimating = YES;
    @weakify(self);
    [UIView animateWithDuration:self.wu_dimAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         @strongify(self);
                         self.wu_dimBackgroundView.alpha = 1.0f;
                         
                     } completion:^(BOOL finished) {
                         @strongify(self);
                         if ( finished ) {
                             self.wu_dimBackgroundAnimating = NO;
                         }
                     }];
}

- (void)wu_hideDimBackground
{
    self.wu_dimBackgroundAnimating = YES;
    @weakify(self);
    [UIView animateWithDuration:self.wu_dimAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         @strongify(self);
                         self.wu_dimBackgroundView.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         @strongify(self);
                         if ( finished ) {
                             self.wu_dimBackgroundAnimating = NO;
                         }
                     }];
}

@end
