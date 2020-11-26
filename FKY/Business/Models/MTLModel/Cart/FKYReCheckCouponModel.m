//
//  FKYReCheckCouponModel.m
//  FKY
//
//  Created by zengyao on 2018/1/18.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYReCheckCouponModel.h"
#import "FKY-Swift.h"

@implementation FKYReCheckCouponModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{ @"couponDtoShopList" : [UseShopModel class] };
}
-(NSString *)getCouponFullName{
    return [NSString stringWithFormat:@"满%d减%d",self.limitprice,self.denomination];
}
//var couponFullName: String?{ //优惠券名称
//    get {
//        return "满" + "\(limitprice ?? 0)" + "减" + "\(denomination ?? 0)"
//    }
//}
//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
//
//    if ([key isEqualToString:NSStringFromSelector(@selector(couponDtoShopList))]) {
//        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UseShopModel class]];
//    }
//
//    //    if ([key isEqualToString:NSStringFromSelector(@selector(activityModel))]) {
//    //        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYCartProductPromoteModel class]];
//    //    }
//
//    return nil;
//}

//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
//    if ([key isEqualToString:@"couponDtoShopList"]) {
//        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UseShopModel class]];
//    }
//
//    return nil;
//}

@end
