//
//  FKYProductGroupListInfoModel.h
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//
#import "FKYBaseModel.h"
#import <Foundation/Foundation.h>
#import "FKYCartGroupInfoModel.h"

@protocol FKYBaseCellProtocol;

@interface FKYProductGroupListInfoModel : FKYBaseModel

@property (nonatomic, copy) NSString *groupId;    //    商品组ID    string    @mock=$order('','15254','15335')
@property (nonatomic, strong) NSArray<FKYCartGroupInfoModel *> * groupItemList;    //    商品列表    array<object>
@property (nonatomic, copy) NSString *groupName;    //    商品组名称    string    @mock=$order('','搭配套餐测试请勿删','固定套餐购物车测试')
@property (nonatomic, assign) NSInteger groupType;    //    商品组类型（0：普通商品组；1：搭配套餐；2：固定套餐 3：多品返利组）

@property (nonatomic, assign) NSInteger comboAmount;    //    固定套餐有值，当前固定套餐的合计金额    number    2989.5
@property (nonatomic, assign) NSInteger comboMaxNum;    //    固定套餐有值，当前固定套餐的最大可购买套数    number    6
@property (nonatomic, assign) NSInteger comboNum;    //    固定套餐有值，当前固定套餐购买套数    number    5
@property (nonatomic, assign) BOOL checkedAll;    //    套餐有值，套餐是否全选    boolean    true
@property (nonatomic, assign) BOOL valid;    //    套餐有值，套餐是否有效 boolean    true
@property (nonatomic, assign)int supplyId;
@property (nonatomic, assign) NSInteger editStatus; // 0:(默认)未编辑状态, 1:编辑未选中, 2: 编辑已选中
@property (nonatomic, copy) NSString *outMaxReason;//超出最大可售数量，最多只能购买9999
@property (nonatomic, copy) NSString *lessMinReson;//该普通商品最小起批量为1
@property (nonatomic, copy) NSString *multiRebateTip;//多品返利文描

- (NSArray *)getSectionDeatilInfo;
- (BOOL)isSelectedAllForEditStatus;

@end
