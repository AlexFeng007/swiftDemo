//
//  FKYShareAPI.h
//  FKY
//
//  Created by yangyouyong on 16/2/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FKYShareView;


@interface FKYShareAPI : NSObject

+ (FKYShareView *)showShareViewWithURL:(NSURL *)url
                       title:(NSString *)title
                 description:(NSString *)description
            previewImageData:(NSData *)imageData
               completeBlock:(void(^)(BOOL success))combleteBlock;

@end
