//
//  GLErrorVC.h
//  YYW
//
//  Created by Rabe on 17/04/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "GLHybrid.h"

@protocol GLErrorVCDelegate <NSObject>

@required
- (void)parentVC:(UIViewController *_Nullable)viewController didStartProvisionalNavigation:(WKNavigation *_Nullable)navigation;
- (void)parentVC:(UIViewController *_Nullable)viewController didFinishNavigation:(WKNavigation *_Nullable)navigation;
- (void)parentVC:(UIViewController *_Nullable)viewController didFailProvisionalNavigation:(WKNavigation *_Nullable)navigation withError:(nonnull NSError *)error;

@end

@interface GLErrorVC : GLViewController <GLErrorVCDelegate>

@property (nonatomic, weak) UIViewController * _Nullable parentViewController;

@end
