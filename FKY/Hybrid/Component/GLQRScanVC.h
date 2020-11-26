//
//  GLQRScanVC.h
//  YYW
//
//  Created by Rabe on 20/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLQRScanVC.h"

typedef void (^GLQRCompletionBlock)(NSString *);

@interface GLQRScanVC : UIViewController
/**
 初始化方法

 @param completionHandler 回调，返回扫描的结果字符串
 @return 实例
 */
- (instancetype)initWithCompletionHandler:(GLQRCompletionBlock)completionHandler;

@end
