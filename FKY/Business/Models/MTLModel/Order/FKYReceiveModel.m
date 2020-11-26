//
//  FKYReceiveModel.m
//  FKY
//
//  Created by mahui on 16/9/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYReceiveModel.h"
#import "FKYReceiveProductModel.h"


@implementation FKYReceiveModel

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"productList"]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYReceiveProductModel class]];
    }

    return nil;
}

@end
