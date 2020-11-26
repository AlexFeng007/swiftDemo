//
//  FKYNavigationController.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FKYNavigationControllerDragBackDelegate;



@interface FKYNavigationController : UINavigationController

@property (nonatomic) BOOL canDragBack;

@property (nonatomic, strong) UIImage *snapshotBeforePresentModel;
@property (nonatomic, strong) UIImage *snapshotBeforePush;

@property (nonatomic, weak) id<FKYNavigationControllerDragBackDelegate> dragBackDelegate;

/**
 *  截取push之前的屏幕快照，放入截图栈
 */
- (void)snapshotCurrentViewController;

/**
 *  截图栈最后一个元素出栈
 */
- (void)removeLastSnapshot;

/**
 *  push一个ViewController，可设置push之前是否截图
 *
 *  @param viewController 被push的ViewController
 *  @param animated       是否动画
 *  @param snapshotFirst  在push之前是否要截图
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
             snapshotFirst:(BOOL)snapshotFirst;

@end



@protocol FKYNavigationControllerDragBackDelegate <NSObject>

@optional
// 在滑动返回的手势开始前调用，返回NO则阻止手势发生
- (BOOL)dragBackShouldStartInNavigationController:(FKYNavigationController *)navigationController;
// 在滑动返回的手势开始后调用一次
- (void)dragBackDidStartInNavigationController:(FKYNavigationController *)navigationController;
// 在滑动返回的手势过程中多次调用
- (void)navigationController:(FKYNavigationController *)navigationController dragBackDidChangePosition:(CGFloat)offsetX;
//当滑动返回取消时调用
- (void)dragBackDidCancelInNavigationController:(FKYNavigationController *)navigationController;
//滑动完成
- (void)draBackEndInNavigationController:(FKYNavigationController *)navigationController;
@end


