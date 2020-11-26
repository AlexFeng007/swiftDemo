//
//  GLBridge+NavigationBar.h
//  YYW
//
//  Created by airWen on 2017/3/2.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "GLBridge.h"
#import "GLNavigationBarComponent.h"

@interface GLBridge (NavigationBar) <GLNavigationBarComponentEventDelegate>

@property (nonatomic, strong) GLJsRequest *request;
@property (nonatomic, strong) NSMutableDictionary *navigationDict;

@end
