//
//  FKYHuaBeiInstallmentModel.h
//  FKY
//
//  Created by 乔羽 on 2018/10/23.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYSubInstallmentModel: NSObject

@property (nonatomic, assign) double prinAndFee;         // 每期总费用
@property (nonatomic, assign) double eachPrin;           // 每期本金
@property (nonatomic, assign) double eachFee;            // 每期手续费
@property (nonatomic, assign) double totalEachFee;       // 分期总手续费
@property (nonatomic, assign) double totalPrinAndFee;    // 分期付款总费用
@property (nonatomic, assign) double payAmount;          // 订单金额
@property (nonatomic, copy) NSString *feeRate;           // 费率
@property (nonatomic, copy) NSString *hbFqNum;           // 分期数

@end


@interface FKYHuaBeiInstallmentModel: NSObject

@property (nonatomic, assign) NSInteger position;
@property (nonatomic, copy) NSString *orderMoney;
@property (nonatomic, strong) NSArray *hbInstalmentInfoDtoList; // 花呗分期费率列表

@end
