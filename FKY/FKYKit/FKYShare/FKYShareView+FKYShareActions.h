//
//  FKYShareView+FKYShareActions.h
//  FKY
//
//  Created by yangyouyong on 16/2/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYShareView.h"

@interface FKYShareView (FKYShareActions)

- (void) QQShareComplete:(void(^)(BOOL success))completeBlock;
- (void) WXShareComplete:(void(^)(BOOL success))completeBlock;
- (void) WXFriendShareComplete:(void(^)(BOOL success))completeBlock;

@end
