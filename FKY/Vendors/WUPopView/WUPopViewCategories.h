//
//  WUPopViewCategories.h
//  
//
//  Created by Rabe on 10/11/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WU_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)

@interface UIColor (WUPop)

+ (UIColor *) wu_colorWithHex:(NSUInteger)hex;

@end


@interface UIImage (WUPop)

+ (UIImage *) wu_imageWithColor:(UIColor *)color;

+ (UIImage *) wu_imageWithColor:(UIColor *)color Size:(CGSize)size;

- (UIImage *) wu_stretched;

@end


@interface UIButton (WUPop)

+ (id) wu_buttonWithTarget:(id)target action:(SEL)sel;

@end


@interface NSString (WUPop)

- (NSString *)wu_truncateByCharLength:(NSUInteger)charLength;

@end


@interface UIWindow (WUPop)

@property (nonatomic, strong, readonly) UIView *wu_dimBackgroundView;
@property (nonatomic, assign) BOOL wu_dimBackgroundAnimating;
@property (nonatomic, assign) NSTimeInterval wu_dimAnimationDuration;

- (void) wu_showDimBackground;
- (void) wu_hideDimBackground;

@end
