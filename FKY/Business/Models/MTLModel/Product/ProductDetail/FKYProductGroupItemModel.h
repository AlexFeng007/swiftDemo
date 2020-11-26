//
//  FKYProductGroupItemModel.h
//  FKY
//
//  Created by 夏志勇 on 2017/12/22.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详之套餐中单个商品model

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"


@interface FKYProductGroupItemModel : FKYBaseModel <NSCopying>

// 接口返回字段
@property (nonatomic, copy) NSString *spec;                 // 商品规格
@property (nonatomic, copy) NSString *factoryId;            // 生厂厂家id
@property (nonatomic, copy) NSString *factoryName;          // 厂家名称
@property (nonatomic, strong) NSNumber *minimumPacking;     // 最小起批量
@property (nonatomic, copy) NSString *filePath;             // 商品图片路径
@property (nonatomic, copy) NSString *productcodeCompany;   // 本公司编码
@property (nonatomic, copy) NSString *spuCode;              // 商品spucode...<商品id>
@property (nonatomic, strong) NSNumber *currentBuyNum;      // 当前还可购买数量
@property (nonatomic, strong) NSNumber *supplyId;           // 供应商Id
@property (nonatomic, strong) NSString *deadLine;           // 有效期
@property (nonatomic, strong) NSNumber *productId;          // 商品主键id
@property (nonatomic, copy) NSString *batchNo;              // 批号
@property (nonatomic, strong) NSNumber *discountMoney;      // 单位优惠金额
@property (nonatomic, strong) NSNumber *originalPrice;      // 商品原价
@property (nonatomic, copy) NSString *unitName;             // 基本单位名称
@property (nonatomic, strong) NSNumber *doorsill;           // 门槛（起订量）
@property (nonatomic, copy) NSString *shortName;            // 商品通用名
@property (nonatomic, copy) NSString *productName;          // 商品名称
@property (nonatomic, strong) NSNumber *weekLimitNum;       // 每周限购量
@property (nonatomic, copy) NSString *shareStockDesc;       // 共享库存标签
@property (nonatomic, strong) NSNumber *isMainProduct;     // 是否是主品（1是）
@property (nonatomic, strong) NSNumber *maxBuyNum;     // 每日限购数量

// 本地新增业务字段
@property (nonatomic, assign) BOOL unselected;  // NO-已选中 YES-未选中 <默认均为选中状态>
@property (nonatomic, assign) NSInteger inputNumber; // 用户手动输入的购买数量; 若为0,则使用起订量

- (NSInteger)getBaseNumber;
- (NSInteger)getProductNumber;
- (CGFloat)getProductRealPrice;
- (NSString *)getProductFullName;
//- (NSString *)getDeadLineString;
- (void)setNumberForAdd:(NSInteger)number;
- (void)setNumberForMinus:(NSInteger)number;
- (void)checkNumberForInput:(NSInteger)number;
- (BOOL)checkAddBtnStatus;
- (BOOL)checkMinusBtnStatus;
- (NSInteger)getMaxNumber;
@end


/*
"productList": [{
    "spec": "12贴",
    "factoryId": "35950",
    "factoryName": "合肥小林日用品有限公司",
    "minimumPacking": 2,
    "filePath": "//fky/img/01.jpg",
    "productcodeCompany": "app008",
    "spuCode": "0551BBCX370002",
    "currentBuyNum": 338,
    "supplyId": 94654,
    "deadLine": null,
    "productId": 181598,
    "batchNo": "",
    "discountMoney": 5.000,
    "originalPrice": 9.99,
    "unitName": "盒",
    "doorsill": 2,
    "shortName": "小林 退热贴(冰宝贴)儿童装 12贴",
    "productName": "",
    "weekLimitNum": null
}, {
    "spec": "5袋",
    "factoryId": "35949",
    "factoryName": "3M",
    "minimumPacking": 1,
    "filePath": "//fky/img/1.jpg",
    "productcodeCompany": "2345_-1",
    "spuCode": "502BEEX370040",
    "currentBuyNum": 10,
    "supplyId": 94654,
    "deadLine": null,
    "productId": 181597,
    "batchNo": "",
    "discountMoney": 2.000,
    "originalPrice": 9.9,
    "unitName": "袋",
    "doorsill": 1,
    "shortName": "3M 皮肤伤口胶带 R1547 5包/袋",
    "productName": "",
    "weekLimitNum": null
}]
*/
