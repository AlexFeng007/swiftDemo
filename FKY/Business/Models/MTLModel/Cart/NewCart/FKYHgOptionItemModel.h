//
//  FKYHgOptionItemModel.h
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"

@interface FKYHgOptionItemModel : FKYBaseModel
@property (nonatomic, copy) NSString *factoryName;    //     生产工厂    string    @mock=$order('杭州欧拓普生物技术有限公司','韩国韩林制药株式会社')
@property (nonatomic, copy) NSString *id;    //     主键ID    string    @mock=$order('181722','181663')
@property (nonatomic, copy) NSString *imageUrl;    //     图片地址    string    @mock=$order('//fky/img/0571BEEX370028-01.jpg','//fky/img/133ACAH130004-01.jpg')
@property (nonatomic, strong) NSNumber *isChecked;    //     是否勾选    number    @mock=$order(1,0)
@property (nonatomic, strong) NSNumber *price;    //     换购价格    number    @mock=$order(1,2)
@property (nonatomic, strong) NSNumber *quantity;    //     换购数量    number    @mock=$order(1,2)
@property (nonatomic, copy) NSString *shortName;    //     换购品名称    string    @mock=$order('欧洁 无菌创口贴','达吉 复方消化酶胶囊')
@property (nonatomic, copy) NSString *spec;    //     换购品规格    string    @mock=$order('30片','20粒')
@property (nonatomic, copy) NSString *spuCode;    //     SPU编码    string    @mock=$order('0571BEEX370028','133ACAH130004')
@property (nonatomic,assign)int supplyId;//     供应商ID    string    @mock=$order('94654','94654')
@property (nonatomic, copy) NSString *unit;    //     换购品最小单位    string    @mock=$order('袋','盒')
@end
