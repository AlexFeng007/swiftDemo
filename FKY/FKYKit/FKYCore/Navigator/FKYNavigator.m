//
//  FKYNavigator.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYNavigator.h"

static NSString *gScheme = nil;
static NSString *gHost = nil;


@interface FKYNavigator ()

@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end


@implementation FKYNavigator

#pragma mark - 创建 && 配置

- (instancetype)init
{
    self = [super init];
    if (self) {
        _URLMaps = [NSMutableSet set];
    }
    return self;
}

+ (FKYNavigator *)sharedNavigator
{
    static FKYNavigator *navigator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navigator = [[FKYNavigator alloc] init];
    });
    return navigator;
}

+ (void)configGlobalScheme:(NSString *)scheme
{
    gScheme = scheme;
}

+ (void)configGlobalHost:(NSString *)host
{
    gHost = host;
}

#pragma mark - Setter & Getter

- (void)setRootViewController:(UIViewController *)rootViewController
{
    _rootViewController = rootViewController;
    
    FKYNavigationController *navigationController = [[FKYNavigationController alloc] initWithRootViewController:rootViewController];
    navigationController.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication].delegate window].rootViewController = navigationController;
    
    [self.navigationControllers removeAllObjects];
    [self.navigationControllers addObject:navigationController];
}

- (NSMutableArray *)navigationControllers
{
    if (!_navigationControllers) {
        _navigationControllers = [@[] mutableCopy];
    }
    return _navigationControllers;
}

- (FKYNavigationController *)topNavigationController
{
    if ([self.navigationControllers count] > 0) {
        return [self.navigationControllers lastObject];
    }
    return nil;
}

- (FKYNavigationController *)previousNavigationController
{
    if ([self.navigationControllers count] >= 2) {
        return self.navigationControllers[[self.navigationControllers count] - 2];
    }
    return nil;
}

- (UIViewController *)visibleViewController
{
    // 返回最高级别的NavigationController的ViewController栈中的最后一个ViewController
    return [self.topNavigationController.viewControllers lastObject];
}

- (NSArray *)getAllNavControllers
{
    return self.navigationControllers;
}

#pragma mark - URL Map

- (void)addURLMap:(FKYURLMap *)URLMap
{
    [self.URLMaps addObject:URLMap];
}

#pragma mark - Get View Controller

/**
 *  从所有的URLMap中查找URL对应的viewController
 *
 *  @param URL <#URL description#>
 *
 *  @return <#return value description#>
 */
- (UIViewController *)viewControllerForURL:(NSURL *)URL
{
    __block UIViewController *viewController = nil;
    [self.URLMaps enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        viewController = [obj viewControllerForURL:URL];
        if (viewController) {
            *stop = YES;
        }
    }];
    return viewController;
}

/**
 *  从所有的URLMap中查找protocol对应的viewController
 *
 *  @param protocol <#protocol description#>
 *
 *  @return <#return value description#>
 */
- (UIViewController *)viewControllerForProtocol:(Protocol *)protocol
{
    __block UIViewController *viewController = nil;
    [self.URLMaps enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        viewController = [obj viewControllerForProtocol:protocol];
        if (viewController) {
            *stop = YES;
        }
    }];
    return viewController;
}

- (Class)viewControllerClassForURL:(NSURL *)URL
{
    __block Class class = nil;
    [self.URLMaps enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        class = [obj viewControllerClassForURL:URL];
        if (class) {
            *stop = YES;
        }
    }];
    return class;
}

- (Class)viewControllerClassForProtocol:(Protocol *)protocol
{
    __block Class class = nil;
    [self.URLMaps enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        class = [obj viewControllerClassForProtocol:protocol];
        if (class) {
            *stop = YES;
        }
    }];
    return class;
}

#pragma mark - Open URL

- (void)openURL:(NSURL *)URL
{
    [self openURLAction:[FKYURLAction actionWithURL:URL]];
}

- (void)openURLString:(NSString *)URLString
{
    [self openURLAction:[FKYURLAction actionWithURL:[NSURL URLWithString:URLString]]];
}

- (void)openURLAction:(FKYURLAction *)URLAction
{
    NSURL *URL = URLAction.URL;
    if (URLAction.openHTTPURLInSafari && [URL.absoluteString hasPrefix:@"http"]) {
        [self openHttpURLAction:URLAction];
        return;
    }
    
    if (![[URLAction.URL scheme] isEqualToString:gScheme]) {
        NSLog(@"错误的URL scheme");
        showErrorAlert(@"错误的URL scheme");
        return;
    }
    
    if (![[URLAction.URL host] isEqualToString:gHost]) {
        NSLog(@"错误的URL host");
        showErrorAlert(@"错误的URL host");
        return;
    }
    
    Class class = [self viewControllerClassForURL:URLAction.URL];
    if (!class && URLAction.URL.path.length > 1) {
        showErrorAlert(@"错误的URL");
        return;
    }
    
    UIViewController *viewController = nil;
    if ([self isSingleton:class]) {
        viewController = [self findSingletonViewControllerWithClass:class];
    } else {
        viewController = [[class alloc] init];
    }
    
    [self openViewController:viewController isModal:URLAction.isModal animated:URLAction.animated];
    
    NSDictionary *parameters = [self parseQueryString:[URLAction.URL query]];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *parametersKeyMap = [viewController.class propertyURLSchemeParametersKeyMap];
        NSString *realKey = nil;
        if (parametersKeyMap) {
            realKey = parametersKeyMap[key];
        }
        if (realKey == nil) {
            realKey = key;
        }
        if ([viewController respondsToSelector:NSSelectorFromString(realKey)]) {
            [viewController setValue:obj forKey:realKey];
        }
    }];
}

- (void)openHttpURLAction:(FKYURLAction *)aUrlAction
{
    // 在Safari中打开页面
    [[UIApplication sharedApplication] openURL:aUrlAction.URL];
}

#pragma mark - Open Scheme

- (void)openScheme:(Protocol *)scheme
{
    [self openScheme:scheme setProperty:nil];
}

- (void)openScheme:(Protocol *)scheme setProperty:(FKYNavigatorSetPropertyBlock)block
{
    [self openScheme:scheme setProperty:block isModal:NO];
}

- (void)openScheme:(Protocol *)scheme setProperty:(FKYNavigatorSetPropertyBlock)block isModal:(BOOL)isModal
{
    [self openScheme:scheme setProperty:block isModal:isModal animated:YES];
}

- (void)openScheme:(Protocol *)scheme setProperty:(FKYNavigatorSetPropertyBlock)block isModal:(BOOL)isModal animated:(BOOL)animated
{
    UIViewController *viewController = nil;
    
    Class class = [self viewControllerClassForProtocol:scheme];
    if ([self isSingleton:class]) {
        viewController = [self findSingletonViewControllerWithClass:class];
    } else {
        viewController = [[class alloc] init];
    }
    
    [self openViewController:viewController isModal:isModal animated:animated];

    if (block) {
        block(viewController);
    }
}

#pragma mark - Handle Open

- (void)openViewController:(UIViewController *)viewController isModal:(BOOL)isModal animated:(BOOL)animated
{
    if (!viewController) {
        return;
    }
    
    // 如果要打开的是个Singleton View Controller，则把已经存在的这个View Controller，和从这个View Controller上延展出来的View Controller全部销毁
    UIViewController *singletonViewController = [self findSingletonViewControllerWithClass:[viewController class]];
    if ([self isSingleton:viewController.class] && singletonViewController) {
        BOOL finished = NO;
        NSUInteger dismissLevel = 0;
        NSUInteger index = NSNotFound;
        
        for (NSInteger i = [self.navigationControllers count] - 1; (i >= 0 && !finished); --i) {
            index = [[self.navigationControllers[i] viewControllers] indexOfObject:singletonViewController];
            if (index != NSNotFound) { // 在当前层级中找到
                finished = YES;
                break;
            } else { // 当前层级中未找到
                // 继续下一次循环，在下个层级中寻找，下降层级数＋1
                dismissLevel++;
            }
        }
        
        if (finished) { // 已找到
            // 先下降对应的层级数
            for (NSUInteger i = 0; i < dismissLevel; ++i) {
                [self dismissWithoutAnimated];
            }
            
            if (index > 0) {
                // 然后pop到找到的那个ViewController的前一个
                UIViewController *previousViewController = [self.topNavigationController viewControllers][index - 1];
                [self.topNavigationController popToViewController:previousViewController animated:NO];
            } else { // index == 0
                [self.topNavigationController popToRootViewControllerAnimated:animated];
                return;
            }
        }
    }
    
    if ([[viewController class] isAlreadyInStackForPop] && [self isPreviousIsAClass:[viewController class]]) {
        [self.topNavigationController popViewControllerAnimated:YES];
        return;
    }
    
    // Modal和Push两种不同的方式打开新ViewController
    if (isModal) {
        // Present
        [self openModelViewController:viewController];
    } else {
        // Push方式
        [self openPushViewController:viewController animated:animated];
    }
    
    if (kNavLog) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"当前Modal层级为：%@（初始层级为1）", @([self.navigationControllers count]));
            NSLog(@"当前层级的ViewController有：%@", self.topNavigationController.viewControllers);
        });
    }
}

// present
- (void)openModelViewController:(UIViewController *)viewController {
    NSLog(@"navigationControllers:%@", self.navigationControllers);
    
    FKYNavigationController *navigationController = [[FKYNavigationController alloc] initWithRootViewController:viewController];
    if (@available(iOS 13.0, *)) {
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (self.topNavigationController.presentedViewController == nil) {
        //防止模态窗口错误
        [self.topNavigationController presentViewController:navigationController animated:YES completion:^{
            [self.navigationControllers addObject:navigationController];
        }];
    }
}

// push
- (void)openPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.topNavigationController pushViewController:viewController animated:animated];
    
    UIImage *image = [[UIImage imageNamed:@"icon-navi-back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:self
                                                                                      action:@selector(pop)];
}

#pragma mark - Back

- (void)pop
{
    if (self.delegate
        && [self.delegate isEqual:self.visibleViewController]
        && [self.delegate respondsToSelector:@selector(shouldPopInNavigator:)]) {
        if (![self.delegate shouldPopInNavigator:self]) {
            return;
        }
    }

    [self.topNavigationController popViewControllerAnimated:YES];
}

- (void)popWithoutAnimation {
    [self.topNavigationController popViewControllerAnimated:NO];
}

- (void)popToRoot
{
    [self.topNavigationController popToRootViewControllerAnimated:YES];
}

- (void)popToRootWithoutAnimation
{
    [self.topNavigationController popToRootViewControllerAnimated:NO];
}

- (void)popToURL:(NSURL *)URL
{
    [self popToURLAction:[FKYURLAction actionWithURL:URL]];
}

- (void)popToScheme:(Protocol *)scheme
{
    [self popToScheme:scheme setProperty:nil];
}

- (void)popToScheme:(Protocol *)scheme setProperty:(FKYNavigatorSetPropertyBlock)block {
    __block UIViewController *destinationViewController = nil;
    NSUInteger dismissLevel = 0;
    
    UIViewController *viewController = [self viewControllerForProtocol:scheme];
    if (!viewController) {
        showErrorAlert(@"错误的Protocol");
        return;
    }
    
    for (NSInteger i = [self.navigationControllers count] - 1; i >= 0; --i) {
        NSArray *viewControllers = [self.navigationControllers[i] viewControllers];
        [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[viewController class]]) {
                destinationViewController = obj;
                *stop = YES;
            }
        }];
        
        if (destinationViewController) {
            break;
        } else {
            dismissLevel++;
        }
    }
    
    if (destinationViewController) {
        // 先下降对应的层级数
        for (NSUInteger i = 0; i < dismissLevel; ++i) {
            [self dismissWithoutAnimated];
        }
        // 然后pop到找到的那个ViewController的前一个
        if (block) {
            block(destinationViewController);
        }
        [self.topNavigationController popToViewController:destinationViewController animated:YES];
    }
}

- (void)dismiss
{
    [self dismiss:nil];
}

- (void)dismiss:(void (^)(void))completion
{
    [[self.navigationControllers lastObject] dismissViewControllerAnimated:YES completion:^{
        [self.navigationControllers removeLastObject];
        if (completion) {
            completion();
        }
//        NSLog(@"abc = %@", self.topNavigationController.view.subviews);
    }];
}

- (void)dismissWithoutAnimated
{
    [[self.navigationControllers lastObject] dismissViewControllerAnimated:NO completion:^{
        [self.navigationControllers removeLastObject];
    }];
}

- (BOOL)popToURLAction:(FKYURLAction *)urlAction
{
    if (!urlAction) {
        return NO;
    }
    
    UIViewController *popToViewcontroller = nil;
    UIViewController *viewController = [self viewControllerForURL:urlAction.URL];
    for (NSInteger i = [[self.topNavigationController viewControllers] count] - 2; i >= 0; --i) {
        UIViewController *vc = [self.topNavigationController viewControllers][i];
        if ([vc isKindOfClass:[viewController class]]) {
            popToViewcontroller = vc;
        }
    }
    if (popToViewcontroller) {
        [self.topNavigationController popToViewController:popToViewcontroller animated:YES];
        return YES;
    } else {
        NSLog(@"在当前层级中未找到对应的ViewController");
        return NO;
    }
}


#pragma mark - Other
- (void)removeViewControllerFromNvc:(id)vc{
    NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:self.topNavigationController.viewControllers];
    [naviVCsArr removeObject:vc];
    self.topNavigationController.viewControllers = naviVCsArr;
}
- (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        dictionary[key] = value;
    }
    return dictionary;
}

- (UIViewController *)findSingletonViewControllerWithClass:(Class)class
{
    __block UIViewController *result = nil;
    [self.navigationControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FKYNavigationController *navigationController = obj;
        [navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *viewController = obj;
            if ([viewController isKindOfClass:class]) {
                result = viewController;
            }
        }];
    }];
    return result;
}

- (BOOL)isPreviousIsAClass:(Class)class
{
    NSInteger vcCount = self.topNavigationController.viewControllers.count;
    if (vcCount>2) {
        if ([self.topNavigationController.viewControllers[vcCount-2] isKindOfClass:class]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSingleton:(Class)class
{
    if ([class isSubclassOfClass:[FKYTabBarController class]] || [NSStringFromClass(class) isEqualToString:@"FKYTabBarController"]) {
        return YES;
    }
    return NO;
}

#pragma mark - 快捷方法

void FKYOpenURL(NSString *URLString)
{
    [[FKYNavigator sharedNavigator] openURLString:URLString];
}

void FKYPopToURL(NSString *URLString)
{
    [[FKYNavigator sharedNavigator] popToURL:[NSURL URLWithString:URLString]];
}

void showErrorAlert(NSString *message)
{
    if (kNavDebug) {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.title = message;
        [alertView addButtonWithTitle:@"确定"];
        [alertView show];
    }
}
@end
