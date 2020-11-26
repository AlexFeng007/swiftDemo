//
//  FKYOrderProductModel.m
//  FKY
//
//  Created by mahui on 16/9/9.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYOrderProductModel.h"
#import "FKYBatchModel.h"

@implementation FKYOrderProductModel

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"batchList"]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYBatchModel class]];
    }
    
    return nil;
}
////获取库存埋点数据
-(NSString *)getStorageData{
    return @"";
}
//获取促销埋点数据
-(NSString *)getPm_pmtn_type{
    return @"";
}
//获取价格埋点数据
-(NSString *)getPm_price{
    NSMutableArray *priceArray = [NSMutableArray array];
    
    if(self.productPrice.floatValue > 0){
        [priceArray addObject:[NSString stringWithFormat:@"%.2f",self.productPrice.floatValue]];
    }
    if (priceArray.count == 0){
        return @"";
    }else{
        return [priceArray componentsJoinedByString:@"|"];
    }
}
@end
