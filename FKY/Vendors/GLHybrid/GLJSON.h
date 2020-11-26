//
//  GLJSON.h
//  YYW
//
//  Created by Rabe on 2017/2/23.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GLJSONSerializing)
- (NSString *)gl_JSONString;
@end

@interface NSDictionary (GLJSONSerializing)
- (NSString *)gl_JSONString;
@end

@interface NSString (GLJSONSerializing)
- (id)gl_JSONObject;
@end
