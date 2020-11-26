//
//  FKYCartInfoModel.m
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYCartInfoModel.h"
#import "NSDictionary+SafeAccess.h"

@implementation FKYCartInfoModel

// 数据解析
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(supplyCartList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYCartMerchantInfoModel class]];
    }
    return nil;
}

- (void) initWithDict:(NSDictionary *)dict
{
    self.checkedProducts = [dict numberForKey:@"checkedProducts"];
    self.discountAmount = [dict numberForKey:@"discountAmount"];
    self.freight = [dict numberForKey:@"freight"];
    self.checkedAll = [dict boolForKey:@"checkedAll"];
    self.rebateAmount = [dict numberForKey:@"rebateAmount"];
    self.appShowMoney = [dict numberForKey:@"appShowMoney"];
    self.payAmount = [dict numberForKey:@"payAmount"];
    self.totalAmount= [dict numberForKey:@"totalAmount"];
    self.checkedRebateProducts= [dict numberForKey:@"checkedRebateProducts"];
    self.supplyCartList =  [FKYTranslatorHelper translateCollectionFromJSON:[dict arrayForKey: @"supplyCartList"] withClass:[FKYCartMerchantInfoModel class]];
}

@end
