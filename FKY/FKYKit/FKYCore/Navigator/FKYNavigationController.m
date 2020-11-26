//
//  FKYNavigationController.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYNavigationController.h"
#import <UIView_Positioning/UIView+Positioning.h>

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]
#define TOP_VIEW (self.view)

@interface FKYNavigationController () <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *screenShotsList;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign) BOOL isMoving;

@property (nonatomic, strong) UIImageView *borderShadowImageView;

@end

@implementation FKYNavigationController {
    CGPoint _startTouch;
    UIImageView *_lastScreenShotView;
    UIImageView *_lastScreenShotBlurView;
    UIView *_blackMask;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.canDragBack = YES;
        self.screenShotsList = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

- (void)dealloc {
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
    self.borderShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_border_shadow"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)snapshotCurrentViewController {
    UIImage *capturedImage = [self snapshot:TOP_VIEW];
    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
        self.snapshotBeforePush = capturedImage;
    }
}

- (void)removeLastSnapshot {
    [self.screenShotsList removeLastObject];
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
             snapshotFirst:(BOOL)snapshotFirst {
    if (snapshotFirst) {
        [self pushViewController:viewController animated:animated];
    } else {
        [super pushViewController:viewController animated:animated];
    }
}

#pragma mark - Override

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    self.snapshotBeforePresentModel = [self snapshot:TOP_VIEW];
    if (super.presentedViewController == nil) {
        //防止模态窗口错误
        if (@available(iOS 13.0, *)) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.viewControllers count] > 0) {
        [self snapshotCurrentViewController];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.screenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index != NSNotFound) {
        NSUInteger removeImageCount = (self.viewControllers.count - 1) - index;
        for (NSInteger i = 0; i < removeImageCount; i++) {
            if (self.screenShotsList.count > 0) {
                [self.screenShotsList removeLastObject];
            }
        }
    }
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - 手势

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:KEY_WINDOW];
    NSTimeInterval animateDuration = 0.3f;
    @weakify(self);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.dragBackDelegate && [self.dragBackDelegate respondsToSelector:@selector(dragBackDidStartInNavigationController:)]) {
                [self.dragBackDelegate dragBackDidStartInNavigationController:self];
            }
            _isMoving = YES;
            _startTouch = touchPoint;
            
            if (!self.backgroundView) {
                CGRect frame = TOP_VIEW.frame;
                
                self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-100, 0, frame.size.width, frame.size.height)];
                [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
            }
            
            if (_lastScreenShotView) {
                [_lastScreenShotView removeFromSuperview];
            }
            
            UIImage *lastScreenShot = [self.screenShotsList lastObject];
            _lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
            [self.backgroundView addSubview:_lastScreenShotView];
            
            [self.borderShadowImageView removeFromSuperview];
            self.borderShadowImageView.frame = CGRectMake(-6 , 0, 6, [[UIScreen mainScreen] bounds].size.height);
            [self.view addSubview:self.borderShadowImageView];
            
            self.backgroundView.hidden = NO;
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGFloat offsetX = touchPoint.x - _startTouch.x;
            [self moveViewWithX:(offsetX < 0 ? 0:offsetX)];
            CGFloat dx = self.view.frame.size.width - _startTouch.x;
            //防止分母为0奔溃
            if (self.view.frame.size.width - _startTouch.x == 0) {
                dx = 0.01;
            }
            self.backgroundView.x = -100 + (offsetX / dx) * 100;
            if (self.dragBackDelegate && [self.dragBackDelegate respondsToSelector:@selector(navigationController:dragBackDidChangePosition:)]) {
                [self.dragBackDelegate navigationController:self dragBackDidChangePosition:(offsetX >= 0.0 ?: 0.0)];
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            CGFloat spanWidth = -100;
            if (_startTouch.x - touchPoint.x <= spanWidth) {
                [UIView animateWithDuration:animateDuration
                                 animations:^{
                    @strongify(self);
                    [self moveViewWithX:[UIScreen mainScreen].bounds.size.width];
                    self.backgroundView.x = 0;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    [self popViewControllerAnimated:false];
                    CGRect frame = self.view.frame;
                    frame.origin.x = 0;
                    self.view.frame = frame;
                    [self.backgroundView removeFromSuperview];
                    self.backgroundView = nil;
                }];
                if (self.dragBackDelegate && [self.dragBackDelegate respondsToSelector:@selector(draBackEndInNavigationController:)]) {
                    [self.dragBackDelegate draBackEndInNavigationController:self];
                }
            } else {
                [UIView animateWithDuration:animateDuration
                                 animations:^{
                    @strongify(self);
                    [self moveViewWithX:0];
                    self.backgroundView.x = -100;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    self.isMoving = NO;
                    self.backgroundView.hidden = YES;
                    if (self.dragBackDelegate && [self.dragBackDelegate respondsToSelector:@selector(dragBackDidCancelInNavigationController:)]) {
                        [self.dragBackDelegate dragBackDidCancelInNavigationController:self];
                    }
                }];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled: {
            [UIView animateWithDuration:animateDuration animations:^{
                @strongify(self);
                [self moveViewWithX:0];
                self.backgroundView.x = -100;
            } completion:^(BOOL finished) {
                @strongify(self);
                self.isMoving = NO;
                self.backgroundView.hidden = YES;
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)moveViewWithX:(CGFloat)x
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    x = (x > width) ? width:x;
    x = (x < 0) ? 0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 如果viewControllers只有一个vc或禁止了返回手势，直接return
    if ([self.viewControllers count] <= 1
        || [self.screenShotsList count] <= 0 // 至少有1张截图，才能操作划动返回
        || !self.canDragBack) {
        return NO;
    }
    
    // 保证只有在向右滑动的加速度大于上下加速度的时候，才出发滑动手势
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:[[UIApplication sharedApplication] keyWindow]];
    if (velocity.x < 0
        || ABS(velocity.x) < ABS(velocity.y)) {
        return NO;
    }
    
    if (self.dragBackDelegate && [self.dragBackDelegate respondsToSelector:@selector(dragBackShouldStartInNavigationController:)]) {
        return [self.dragBackDelegate dragBackShouldStartInNavigationController:self];
    }
    
    return YES;
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.canDragBack = NO;
    self.view.userInteractionEnabled = NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.canDragBack = YES;
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Private

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end


