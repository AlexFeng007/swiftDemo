//
//  FKYProductGroupModel.m
//  FKY
//
//  Created by 夏志勇 on 2017/12/22.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYProductGroupModel.h"

@implementation FKYProductGroupModel

#pragma mark - Copy

- (id)copyWithZone:(nullable NSZone *)zone
{
    FKYProductGroupModel *obj = [[self.class allocWithZone:zone] init];
    obj.useDesc = self.useDesc;
    obj.promotionName = self.promotionName;
    obj.promotionId = self.promotionId;
    obj.endTime = self.endTime;
    obj.promotionRule = self.promotionRule;
    obj.productList = self.productList.mutableCopy;
    obj.groupNumber = self.groupNumber;
    return obj;
}


#pragma mark - Parse

//+ (NSDictionary *)modelContainerPropertyGenericClass
//{
//    return @{ @"productList" : [FKYProductGroupItemModel class] };
//}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    // 解析套餐数据中的单个商品数据...<字典>
    if ([key isEqualToString:NSStringFromSelector(@selector(productList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYProductGroupItemModel class]];
    }
    
    return nil;
}


#pragma mark - Public

- (NSInteger)getGroupNumber
{
    return self.groupNumber > 0 ? self.groupNumber : 1;
}

// number:当前输入框中的数量(未加之前的数量)
- (void)setNumberForAdd:(NSInteger)number
{
    NSInteger max = [self getMaxGroupNumber];
    if (number < 1) {
        number = 1;
    }
    else if (number >= max) {
        number = max;
    }
    else {
        // 1~(max-1)
        number++;
    }
    self.groupNumber = number;
}

- (void)setNumberForMinus:(NSInteger)number
{
    NSInteger max = [self getMaxGroupNumber];
    if (number > max) {
        number = max;
        number--;
    }
    else if (number <= 1) {
        number = 1;
    }
    else {
        // 2~max
        number--;
    }
    self.groupNumber = number;
}

- (void)checkNumberForInput:(NSInteger)number
{
    NSInteger max = [self getMaxGroupNumber];
    if (number > max) {
        number = max;
    }
    else if (number < 1) {
        number = 1;
    }
    else {
        // 1~max
    }
    self.groupNumber = number;
}

- (BOOL)checkAddBtnStatus
{
    NSInteger max = [self getMaxGroupNumber];
    if (self.groupNumber >= max) {
        return NO;
    }
    return YES;
}

- (BOOL)checkMinusBtnStatus
{
    if (self.groupNumber == 1) {
        return NO;
    }
    return YES;
}


#pragma mark - Private

// 获取固定套餐的最大可加车数
- (NSInteger)getMaxGroupNumber
{
    //对比 maxBuyNum和maxBuyNumPerDay中比较小的
    NSInteger maxBuy = 1;
    BOOL hasNum = false;
    if (self.maxBuyNum && self.maxBuyNum.integerValue > 0) {
        maxBuy = self.maxBuyNum.integerValue;
        hasNum = true;
    }
    if (self.maxBuyNumPerDay && self.maxBuyNumPerDay.integerValue > 0) {
        if (hasNum) {
            if (self.maxBuyNumPerDay.integerValue < maxBuy) {
                maxBuy = self.maxBuyNumPerDay.integerValue;
            }
        }else {
            maxBuy = self.maxBuyNumPerDay.integerValue;
        }
    }
    return maxBuy;
}

@end
