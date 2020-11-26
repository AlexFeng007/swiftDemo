//
//  FKYOrderModel.m
//  FKY
//
//  Created by mahui on 15/12/1.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderModel.h"
#import "FKYOrderProductModel.h"
#import "FKYPersonModel.h"

@implementation FKYOrderModel

- (BOOL)isHuanGouSonOrder
{
    if (1 == [self.isPromotionChange integerValue]) {
        if (nil != self.parentOrderId) {
            if ([self.parentOrderId integerValue] > 0) {
                return YES;
            }else{
                return NO;
            }
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

- (BOOL)isZhongjin
{
    return NO;
    // 中金代码临时注释
    //    if (self.zhongJinPayFlag.length == 0) {
    //        return NO;
    //    }
    //    return [self.zhongJinPayFlag isEqualToString:@"Y"];
}

//0:全部订单, 1:待付款,2:待发货,3:待收货,4:已完成,5:拒收,6补货
- (NSString *)getOrderStatus
{
    if (_orderStatusName.length) { // 接口返回了状态文描则优先使用接口文描
        return _orderStatusName;
    }
    NSInteger integer = _orderStatus.integerValue;
    switch (integer) {
        case 0:
            return orderStatus_all;
            break;
        case 1:
            return orderStatus_unpay;
            break;
        case 2:
        case 902:
            return orderStatus_ship;
            break;
        case 3:
        case 903:
            return orderStatus_receive;
            break;
        case 7:
        case 905:
        case 804:
            return orderStatus_compelited;
            break;
        case 904:
        case 803:
            return orderStatus_closed;
            break;
        case 800:
            return orderStatus_rejected;
            break;
        case 801:
        case 901:
            return orderStatus_unconfirm;
            break;
        case 802:
            return orderStatus_refund;
            break;
        case 900:
            return orderStatus_replenishment;
            break;
        case 850:
            return orderStatus_JSBU;
        default:
            return orderStatus_cancle;
            break;
    }
}

- (NSString *)getPayType
{
    if(_payType.integerValue == 3){
        // 线下支付
        return payType_xxzz;
    }else{
        if (_payTypeId) {
            if(_payTypeId.integerValue == 8 || _payTypeId.integerValue == 7){
                // 支付宝支付
                return payType_zfb;
            }else if(_payTypeId.integerValue == 9){
                // 银联支付
                return payType_upay;
            }else if(_payTypeId.integerValue == 14 || _payTypeId.integerValue == 13 || _payTypeId.integerValue == 12){
                // 微信支付
                return payType_wx;
            }else if(_payTypeId.integerValue == 17){
                // 1药贷
                return payType_yiloan;
            }else{
                // PC线上支付
                return payType_pc_xszf;
            }
        }else{
            // 线上支付
            return payType_xszf;
        }
    }
}

- (NSString *)getBillType
{
    if (_billType.integerValue == 2) {
        return @"纸质普通发票";
    }
    if (_billType.integerValue == 1) {
        return  @"专用发票";
    }
    if (_billType.integerValue == 3) {
        return  @"电子普通发票";
    }
    return @"专用发票";
}

- (NSString *)getDeliveryMethod
{
    if (_deliveryMethod.integerValue == 1) {
        return deliveryMethod_own;
    }
    if (_deliveryMethod.integerValue == 2) {
        return  deliveryMethod_third;
    }
    return nil;
}

// 判断商品底部的操作栏是否显示
- (BOOL)getHandleBarShowStatus
{
    // 订单状态
    NSInteger status = self.orderStatus.integerValue;
    
    // 与Android保持同步...<只要是已完成，则必须显示，不再区分自营、非自营>
    if (status == 7) {
        // 已完成
        return YES;
    }
    
    // 已取消订单底部新增“再次购买”按钮
    if (status == 10) {
        // 已取消
        return YES;
    }
    if ([self.complaintFlag isEqualToString:@"0"] || [self.complaintFlag isEqualToString:@"1"]){
        return YES;
    }
    
    // 订单状态
    NSString *str = [NSString stringWithFormat:@"%@", self.orderStatus];
    // 一起拼代发货
    BOOL isYiQiPinDaiFaHuo = (self.orderType.integerValue == 3) && status == 2;
    // 一起购代发货
    BOOL isYiQiGouDaiFaHuo = (self.orderType.integerValue == 1) && status == 2;
    //
    if (isYiQiGouDaiFaHuo || isYiQiPinDaiFaHuo || status == 10 || status == 850 || ([str containsString:@"90"] && self.exceptionOrderId == nil)) {
        // 上述情况均不显示
        return NO;
    }
    
    // 待发货 or 已完成《自营和mp都展示申请售后按钮》
    if (status == 2 || status == 7 ) {
        return YES;
//        if (self.isZiYingFlag == 1) {
//            // 自营
//            return YES;
//        }
//        else {
//            // 非自营
//            return NO;
//        }
    }
    
    return YES;
}


#pragma mark -

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"productList"]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYOrderProductModel class]];
    }
    if ([key isEqualToString:@"invoiceDtoList"]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYBillInfoModel class]];
    }
    if ([key isEqualToString:@"childOrderBeans"]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FKYOrderModel class]];
    }
    if ([key isEqualToString:@"address"]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FKYPersonModel class]];
    }
    return nil;
}


@end
