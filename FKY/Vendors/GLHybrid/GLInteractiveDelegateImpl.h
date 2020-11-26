//
//  GLInteractiveDelegateImpl.h
//  YYW
//
//  Created by Rabe on 2017/2/21.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLInteractiveDelegate.h"

@class GLViewController;

@interface GLInteractiveDelegateImpl : NSObject <GLInteractiveDelegate>

/**
 返回一个实现交互协议的内核对象

 @param viewController 所在视图控制器
 @return 一个实现交互协议<GLInteractiveDelegate>的内核对象
 */
- (instancetype)initWithViewController:(GLViewController *)viewController;

@end
