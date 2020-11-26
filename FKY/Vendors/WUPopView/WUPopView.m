//
//  WUPopView.m
//  
//
//  Created by Rabe on 10/11/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "WUPopView.h"
#import <Masonry/Masonry.h>

#define WUWeakify(o)        __weak   typeof(self) weakself = o;
#define WUStrongify(o)      __strong typeof(self) o = weakself;

@interface WUPopView ()

@property (nonatomic, copy  ) WUPopBlock showAnimation;
@property (nonatomic, copy  ) WUPopBlock hideAnimation;

@property (nonatomic, strong) UIWindow *attachedWindow;

@end

@implementation WUPopView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self ) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.type = WUPopTypeAlert;
    self.animationDuration = 0.3f;
    self.userInteractionEnabled = YES;
}

#pragma mark - public

- (void)show
{
    [self showWithBlock:nil];
}

- (void)showWithBlock:(WUPopCompletion)block
{
    if ( block ) {
        self.showCompletion = block;
    }
    
    if ( !self.attachedWindow ) {
        self.attachedWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    if ( [self.attachedWindow wu_dimBackgroundAnimating] == NO ) {
        [self.attachedWindow wu_showDimBackground];
        
        if (self.tapDismissEnabled) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDismiss:)];
            tap.numberOfTapsRequired = 1;
            tap.cancelsTouchesInView = NO;
            [self.attachedWindow addGestureRecognizer:tap];
        }
        
        WUPopBlock showAnimation = self.showAnimation;
        NSAssert(showAnimation, @"未配置展示动画!");
        showAnimation(self);
    }
}

- (void)hide
{
    [self hideWithBlock:nil];
}

- (void)hideWithBlock:(WUPopCompletion)block
{
    if ( block ) {
        self.hideCompletion = block;
    }
    
    if ( !self.attachedWindow ) {
        self.attachedWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    if ([self.attachedWindow wu_dimBackgroundAnimating] == NO) {
        [self.attachedWindow wu_hideDimBackground];
        WUPopBlock hideAnimation = self.hideAnimation;
        NSAssert(hideAnimation, @"未配置隐藏动画!");
        hideAnimation(self);
    }
}

#pragma mark - action

- (void)onTapDismiss:(UITapGestureRecognizer *)reg
{
    if (self.tapDismissEnabled == NO) {
        return;
    }
    // 点击除self外的蒙版区域，执行隐藏动画
    if ( reg.state == UIGestureRecognizerStateEnded ) {
        CGPoint location = [reg locationInView:nil];
        CGPoint locationInWindow = [self convertPoint:location fromView:self.attachedWindow];
        if ( ![self pointInside:locationInWindow withEvent:nil] ) {
            [self.attachedWindow removeGestureRecognizer:reg];
            [self hide];
        }
    }
}

#pragma mark - private

- (WUPopBlock)alertShowAnimation
{
    WUWeakify(self);
    WUPopBlock block = ^(WUPopView *popupView){
        WUStrongify(self);
        
        if ( !self.superview ) {
            [self.attachedWindow.wu_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedWindow).centerOffset(CGPointMake(0, 0));
            }];
            [self layoutIfNeeded];
        }
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        @weakify(self);
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             @strongify(self);
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         } completion:^(BOOL finished) {
                             @strongify(self);
                             if ( self.showCompletion ) {
                                 self.showCompletion(self, finished);
                             }
                         }];
    };
    
    return block;
}

- (WUPopBlock)alertHideAnimation
{
    WUWeakify(self);
    WUPopBlock block = ^(WUPopView *popupView){
        WUStrongify(self);
        @weakify(self);
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             @strongify(self);
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             @strongify(self);
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletion ) {
                                 self.hideCompletion(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (WUPopBlock)sheetShowAnimation
{
    WUWeakify(self);
    WUPopBlock block = ^(WUPopView *popupView){
        WUStrongify(self);
        
        [self.attachedWindow.wu_dimBackgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        if ( !self.superview )
            {
            [self.attachedWindow.wu_dimBackgroundView addSubview:self];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.attachedWindow);
                make.bottom.equalTo(self.attachedWindow.mas_bottom).offset(self.attachedWindow.frame.size.height);
            }];

            [self.superview layoutIfNeeded];
        }
        @weakify(self);
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             @strongify(self);
                             if ( self.superview ) {
                                 [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.bottom.equalTo(self.attachedWindow.mas_bottom).offset(0);
                                 }];
                                 
                                 [self.superview layoutIfNeeded];
                             }
                             
                         }
                         completion:^(BOOL finished) {
                             @strongify(self);
                             if ( self.showCompletion ) {
                                 self.showCompletion(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (WUPopBlock)sheetHideAnimation
{
    WUWeakify(self);
    WUPopBlock block = ^(WUPopView *popupView){
        WUStrongify(self);
        @weakify(self);
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             @strongify(self);
                             if ( self.superview ) {
                                 [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.bottom.equalTo(self.attachedWindow.mas_bottom).offset(self.attachedWindow.frame.size.height);
                                 }];
                                 
                                 [self.superview layoutIfNeeded];
                             }
                             
                         }
                         completion:^(BOOL finished) {
                             @strongify(self);
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletion ) {
                                 self.hideCompletion(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (WUPopBlock)customShowAnimation
{
    WUWeakify(self);
    WUPopBlock block = ^(WUPopView *popupView){
        WUStrongify(self);
        
        if ( !self.superview ) {
            [self.attachedWindow.wu_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedWindow).centerOffset(CGPointMake(0, -self.attachedWindow.bounds.size.height));
            }];
            [self.superview layoutIfNeeded];
        }
        @weakify(self);
        [UIView animateWithDuration:self.animationDuration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1.5
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             @strongify(self);
                             if ( self.superview ) {
                                 [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.center.equalTo(self.attachedWindow).centerOffset(CGPointMake(0, 0));
                                 }];
                                 
                                 [self.superview layoutIfNeeded];
                             }
                             
                         } completion:^(BOOL finished) {
                             @strongify(self);
                             if ( self.showCompletion ) {
                                 self.showCompletion(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (WUPopBlock)customHideAnimation
{
    WUWeakify(self);
    WUPopBlock block = ^(WUPopView *popupView){
        WUStrongify(self);
        @weakify(self);
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             @strongify(self);
                             if ( self.superview ) {
                                 [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.center.equalTo(self.attachedWindow).centerOffset(CGPointMake(0, self.attachedWindow.bounds.size.height));
                                 }];
                                 
                                 [self.superview layoutIfNeeded];
                             }
                             
                         } completion:^(BOOL finished) {
                             @strongify(self);
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletion ) {
                                 self.hideCompletion(self, finished);
                             }
                         }];
    };
    
    return block;
}

#pragma mark - property

- (void)setType:(WUPopType)type
{
    _type = type;
    
    switch (type) {
        case WUPopTypeAlert: {
            self.showAnimation = [self alertShowAnimation];
            self.hideAnimation = [self alertHideAnimation];
            break;
        }
        case WUPopTypeSheet: {
            self.showAnimation = [self sheetShowAnimation];
            self.hideAnimation = [self sheetHideAnimation];
            break;
        }
        case WUPopTypeCustom: {
            self.showAnimation = [self customShowAnimation];
            self.hideAnimation = [self customHideAnimation];
            break;
        }
        
        default:
        break;
    }
}

@end





@implementation WUPopItem

@end
