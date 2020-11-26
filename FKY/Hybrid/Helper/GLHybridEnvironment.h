//
//  GLHybridEnvironment.h
//  FKY
//
//  Created by Rabe on 23/08/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHybridEnvironment : NSObject

#pragma mark hybrid框架H5加载环境配置
@property (nonatomic, assign) BOOL openLocalWeb;     // 默认yes
@property (nonatomic, assign) BOOL openRemoteDev;    // 默认yes

+ (instancetype)shared;

@end
