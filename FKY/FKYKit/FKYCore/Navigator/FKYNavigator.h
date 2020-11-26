//
//  FKYNavigator.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYURLAction.h"
#import "FKYURLMap.h"
#import "NSObject+FKYSingleton.h"
#import "FKYNavigationController.h"
#import "UIViewController+FKYURLParameterMap.h"


#define kNavDebug YES // 若为YES，则当遇到不合法的URL或者Scheme时，会弹出错误Alert
#define kNavLog NO // 是否打印层级信息Log


typedef void (^FKYNavigatorSetPropertyBlock)(id destinationViewController);



@class FKYNavigator;

@protocol FKYNavigatorDelegate <NSObject>
@optional
- (BOOL)shouldPopInNavigator:(FKYNavigator *)navigator;
@end



@interface FKYNavigator : NSObject

/**
 *  URL映射表集合
 */
@property (nonatomic, strong, readonly) NSMutableSet *URLMaps;

/**
 *  最初的NavigationController下的rootViewController
 *  对此属性进行赋值会销毁所有ViewController，回到新的初始ViewController
 */
@property (nonatomic, strong) UIViewController *rootViewController;

/**
 *  顶层NavigationController
 */
@property (nonatomic, strong, readonly) FKYNavigationController *topNavigationController;

/**
 *  顶层的下一层NavigationController
 */
@property (nonatomic, strong, readonly) FKYNavigationController *previousNavigationController;

/**
 *  当前显示的ViewController
 */
@property (nonatomic, strong, readonly) UIViewController *visibleViewController;

@property (nonatomic, weak) id<FKYNavigatorDelegate> delegate;

/**
 *  单例FKYNavigator
 *
 *  @return FKYNavigator唯一实例
 */
+ (FKYNavigator *)sharedNavigator;

/**
 *  配置全局Scheme
 *
 *  @param scheme
 */
+ (void)configGlobalScheme:(NSString *)scheme;

/**
 *  配置全局Host
 *
 *  @param host
 */
+ (void)configGlobalHost:(NSString *)host;

/**
 *  添加一个模块的映射表
 *
 *  @param URLMap 模块映射表
 */
- (void)addURLMap:(FKYURLMap *)URLMap;

/**
 *  在当前的NVNavigator栈中打开新的URL
 *  [[FKYNavigator sharedNavigator] openURL:@"yiyaowang://search?keyword=药品"]
 *
 *  @param URL 要打开的URL
 */
- (void)openURL:(NSURL *)URL;
- (void)openURLString:(NSString *)URLString;
- (void)openURLAction:(FKYURLAction *)URLAction;

- (void)openScheme:(Protocol *)scheme;
- (void)openScheme:(Protocol *)scheme setProperty:(FKYNavigatorSetPropertyBlock)block;
- (void)openScheme:(Protocol *)scheme setProperty:(FKYNavigatorSetPropertyBlock)block isModal:(BOOL)isModal;
- (void)openScheme:(Protocol *)scheme setProperty:(FKYNavigatorSetPropertyBlock)block isModal:(BOOL)isModal animated:(BOOL)animated;

- (void)pop;
- (void)popWithoutAnimation;
- (void)popToRoot;
- (void)popToRootWithoutAnimation;
- (void)popToURL:(NSURL *)URL;
- (void)popToScheme:(Protocol *)scheme;
- (void)popToScheme:(Protocol *)scheme setProperty:(FKYNavigatorSetPropertyBlock)block;
- (void)openPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)openViewController:(UIViewController *)viewController isModal:(BOOL)isModal animated:(BOOL)animated;
- (void)dismiss;
- (void)dismiss:(void (^)(void))completion;
- (void)removeViewControllerFromNvc:(id)vc;
// 快捷方法
void FKYOpenURL(NSString *URLString);
void FKYPopToURL(NSString *URLString);

void showErrorAlert(NSString *message);

- (NSArray *)getAllNavControllers;

@end
