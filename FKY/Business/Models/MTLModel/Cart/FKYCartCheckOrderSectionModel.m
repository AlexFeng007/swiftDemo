//
//  FKYCartCheckOrderSectionModel.m
//  FKY
//
//  Created by airWen on 2017/6/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYCartCheckOrderSectionModel.h"
#import "FKYCartCheckOrderProductModel.h"

@implementation FKYCartCheckOrderSectionModel

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(products))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYCartCheckOrderProductModel class]];
    }
    return nil;
}

- (void)setPayTypeDesc:(NSString *)payTypeDesc
{
    _payTypeDesc = payTypeDesc;
    if ([_payTypeDesc containsString:@"线下"]) {
        self.payType = @"3";
    }else{
        self.payType = @"1";
    }
    if ([_payTypeDesc containsString:@"花呗"]) {
        self.payTypeId = @"20";
        self.isSelectHuaBei = true;
    } else {
        self.payTypeId = @"";
        self.isSelectHuaBei = false;
    }
}

// 不明白为何要手动修改接口返回的运费数据~?!...<会引起bug: 运费变动导致无法提交订单>
// 如：24.65 修改成 24.6
//- (void)setFreight:(NSString *)freight
//{
//    NSString *tempFreight = StringValue(freight);
//    if (tempFreight.length > 4) {
//        _freight = [tempFreight substringWithRange:NSMakeRange(0, 4)];
//    }else {
//        _freight = tempFreight;
//    }
//}

- (void)setOrderFreight:(NSString *)orderFreight
{
    _orderFreight = StringValue(orderFreight);
}

@end
