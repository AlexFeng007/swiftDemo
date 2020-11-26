//
//  FKYNetworkManager_private.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//


#ifndef FKYNetworkManager_private_h
#define FKYNetworkManager_private_h
@interface FKYNetworkManager ()

- (NSString *)adapterUrl:(NSString *)path;

- (NSString *)componentUrl:(NSString *)url parameters:(NSDictionary *)parameters;

@end

#endif