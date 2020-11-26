//
//  FKYProductGroupItemModel.m
//  FKY
//
//  Created by 夏志勇 on 2017/12/22.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYProductGroupItemModel.h"

@implementation FKYProductGroupItemModel

- (id)copyWithZone:(nullable NSZone *)zone
{
    FKYProductGroupItemModel *obj = [[self.class allocWithZone:zone] init];
    obj.spec = self.spec;
    obj.factoryId = self.factoryId;
    obj.factoryName = self.factoryName;
    obj.minimumPacking = self.minimumPacking;
    obj.filePath = self.filePath;
    obj.productcodeCompany = self.productcodeCompany;
    obj.spuCode = self.spuCode;
    obj.currentBuyNum = self.currentBuyNum;
    obj.supplyId = self.supplyId;
    obj.deadLine = self.deadLine;
    obj.productId = self.productId;
    obj.batchNo = self.batchNo;
    obj.discountMoney = self.discountMoney;
    obj.originalPrice = self.originalPrice;
    obj.unitName = self.unitName;
    obj.doorsill = self.doorsill;
    obj.shortName = self.shortName;
    obj.productName = self.productName;
    obj.weekLimitNum = self.weekLimitNum;
    obj.unselected = self.unselected;
    obj.inputNumber = self.inputNumber;
    return obj;
}


#pragma mark - Public

// 仅针对固定套餐
- (NSInteger)getBaseNumber
{
    // 返回起订量（起售门槛）
    return [self getOrderNumber];
}

- (NSInteger)getProductNumber
{
    if (self.inputNumber > 0) {
        // 非初始化时...<已有值>
    }
    else {
        // 初始化时
        self.inputNumber = [self getOrderNumber];
    }
    
    return self.inputNumber;
}

- (CGFloat)getProductRealPrice
{
    CGFloat realPrice = 0.0;
    if (self.originalPrice) {
        // 有返回原始价格
        if (self.discountMoney) {
            // 有返回优惠价
            realPrice = self.originalPrice.floatValue - self.discountMoney.floatValue;
        }
        else {
            realPrice = self.originalPrice.floatValue;
        }
    }
    
    return realPrice;
}

- (NSString *)getProductFullName
{
    NSString *nameBefore = self.productName;
    NSString *nameAfter = self.shortName;
    if (nameBefore && nameBefore.length > 0) {
        if (nameAfter && nameAfter.length > 0) {
            return [NSString stringWithFormat:@"%@ %@", nameBefore, nameAfter];
        }
        else {
            return nameBefore;
        }
    }
    else {
        if (nameAfter && nameAfter.length > 0) {
            return nameAfter;
        }
        else {
            return @"";
        }
    }
}

//- (NSString *)getDeadLineString
//{
//    if (self.deadLine && self.deadLine.longLongValue > 0) {
//        long long time = self.deadLine.longLongValue;
//        NSTimeInterval interval = time / 1000.0; // iOS生成的时间戳是10位
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        //[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *dateString = [formatter stringFromDate: date];
//        return dateString;
//    }
//    
//    return nil;
//}

- (void)setNumberForAdd:(NSInteger)number
{
    // 最小起批量
    NSInteger unitNumber = [self getUnitNumber];
    // 起订量...<倍数>
    NSInteger orderNumber = [self getOrderNumber];
    // 最大可购买数量...<倍数>
    NSInteger maxNumber = [self getMaxNumber];
    // 之前的购买数量...<倍数>
    NSInteger beforeNumber = [self getProductNumber];
    if (beforeNumber < orderNumber) {
        // 购买数量 >= 起订量
        beforeNumber = orderNumber;
    }
    if (beforeNumber > maxNumber) {
        // 购买数量 <= 最大可购买数量
        beforeNumber = maxNumber;
    }
    
    if (beforeNumber + unitNumber > maxNumber) {
        // 超过最大可购买数量
        self.inputNumber = beforeNumber;
    }
    else {
        // 未超过最大可购买数量
        self.inputNumber = (beforeNumber + unitNumber);
    }
}

- (void)setNumberForMinus:(NSInteger)number
{
    // 最小起批量
    NSInteger unitNumber = [self getUnitNumber];
    // 起订量...<倍数>
    NSInteger orderNumber = [self getOrderNumber];
    // 最大可购买数量...<倍数>
    NSInteger maxNumber = [self getMaxNumber];
    // 之前的购买数量...<倍数>
    NSInteger beforeNumber = [self getProductNumber];
    if (beforeNumber < orderNumber) {
        // 购买数量 >= 起订量
        beforeNumber = orderNumber;
    }
    if (beforeNumber > maxNumber) {
        // 购买数量 <= 最大可购买数量
        beforeNumber = maxNumber;
    }
    
    if (beforeNumber - unitNumber < orderNumber) {
        // 小于起订量
        self.inputNumber = beforeNumber;
    }
    else {
        // 不小于起订量
        self.inputNumber = (beforeNumber - unitNumber);
    }
}

- (void)checkNumberForInput:(NSInteger)number
{
    // 最小起批量
    NSInteger unitNumber = [self getUnitNumber];
    // 起订量...<倍数>
    NSInteger orderNumber = [self getOrderNumber];
    // 最大可购买数量...<倍数>
    NSInteger maxNumber = [self getMaxNumber];
    // 之前的购买数量...<倍数>
    NSInteger beforeNumber = [self getProductNumber];
    if (beforeNumber < orderNumber) {
        // 购买数量 >= 起订量
        beforeNumber = orderNumber;
    }
    if (beforeNumber > maxNumber) {
        // 购买数量 <= 最大可购买数量
        beforeNumber = maxNumber;
    }
    
    if (number <= orderNumber) {
        // 小于等于起订量
        self.inputNumber = orderNumber;
    }
    else if (number >= maxNumber) {
        // 大于等于最大可购买量
        self.inputNumber = maxNumber;
    }
    else {
        // 在区间内
        if (number % unitNumber == 0) {
            // 是最小起批量的倍数
            self.inputNumber = number;
        }
        else {
            // 不是最小起批量的倍数
            NSInteger times = number / unitNumber;
            NSInteger baseNumber = times * unitNumber;
            if (baseNumber + unitNumber > maxNumber) {
                self.inputNumber = baseNumber;
            }
            else {
                self.inputNumber = baseNumber + unitNumber;
            }
        }
    }
}

- (BOOL)checkAddBtnStatus
{
    // 最小起批量
    NSInteger unitNumber = [self getUnitNumber];
    // 最大可购买数量...<倍数>
    NSInteger maxNumber = [self getMaxNumber];
    
    if (self.inputNumber <= maxNumber) {
        if (self.inputNumber + unitNumber <= maxNumber) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        // 不存在当前情况，因为inputNumber一定是合法的
        return NO;
    }
}

- (BOOL)checkMinusBtnStatus
{
    // 最小起批量
    NSInteger unitNumber = [self getUnitNumber];
    // 起订量...<倍数>
    NSInteger orderNumber = [self getOrderNumber];

    if (self.inputNumber >= orderNumber) {
        if (self.inputNumber - unitNumber >= orderNumber) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        // 不存在当前情况，因为inputNumber一定是合法的
        return NO;
    }
}


#pragma mark - Private

// 最小起批量
- (NSInteger)getUnitNumber
{
    // 未返回时默认为1
    NSInteger unitNumber = 1;
    if (self.minimumPacking && self.minimumPacking.integerValue > 0) {
        unitNumber = self.minimumPacking.integerValue;
    }
    return unitNumber;
}

// 起订量
- (NSInteger)getOrderNumber
{
    // 起订量 >= 最小起批量
    NSInteger unitNumber = [self getUnitNumber];
    NSInteger orderNumber = unitNumber;
    if (self.doorsill && self.doorsill.integerValue > 0) {
        orderNumber = self.doorsill.integerValue;
    }
    if (orderNumber < unitNumber) {
        // 若起订量小于最小起批量，则取最小起比量
        orderNumber = unitNumber;
    }
    if (orderNumber % unitNumber != 0) {
        // 起订量不是最小起批量的倍数
        NSInteger times = orderNumber / unitNumber;
        orderNumber = (times + 1) * unitNumber;
        // 起订量不能超过最大可购买数量
        if (self.currentBuyNum && self.currentBuyNum.integerValue > 0) {
            NSInteger maxNumber = self.currentBuyNum.integerValue;
            if (orderNumber > maxNumber) {
                orderNumber -= unitNumber;
            }
            if (orderNumber < unitNumber) {
                // 若起订量小于最小起批量，则取最小起比量
                orderNumber = unitNumber;
            }
        }
    }
    return orderNumber;
}

// 最大可购买数量
- (NSInteger)getMaxNumber
{
    // 最大可购买数量 >= 起订量
    NSInteger unitNumber = [self getUnitNumber];
    NSInteger orderNumber = [self getOrderNumber];
    NSInteger maxNumber = 1000000;
    if (self.currentBuyNum && self.currentBuyNum.integerValue > 0) {
        maxNumber = self.currentBuyNum.integerValue;
    }
   // if (self.isMainProduct && self.isMainProduct.integerValue == 1){
        //主品
        if (self.maxBuyNum && self.maxBuyNum.integerValue > 0){
            if (self.maxBuyNum.integerValue < maxNumber ) {
                maxNumber = self.maxBuyNum.integerValue;
            }
        }
   // }
    // 不单独对限购进行考虑(以currentBuyNum字段为准)~!@
//    if (self.weekLimitNum && self.weekLimitNum.integerValue > 0) {
//        // 有限购
//        maxNumber = MIN(maxNumber, self.weekLimitNum.integerValue);
//    }
    if (maxNumber < orderNumber) {
        // 最大可购买数量小于起订量...<error~!@>
        maxNumber = orderNumber;
    }
    if (maxNumber % unitNumber != 0) {
        // 最大可购买数量不是最小起批量的倍数
        NSInteger times = maxNumber / unitNumber;
        maxNumber = times * unitNumber;
    }
    return maxNumber;
}

@end
