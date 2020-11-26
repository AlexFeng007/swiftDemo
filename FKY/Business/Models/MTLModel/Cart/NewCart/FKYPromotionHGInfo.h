//
//  FKYPromotionHGInfo.h
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"
#import "FKYHgOptionItemModel.h"

@interface FKYPromotionHGInfo : FKYBaseModel
@property (nonatomic, copy) NSString *hgDesc;    //     换购促销描述    string    @mock=每满5盒,可换购商品
@property (nonatomic, strong) NSArray<FKYHgOptionItemModel *> *hgOptionItem;    //     换购促销子品    array<object>
@property (nonatomic, copy) NSString *hgText;    //     换购满足时展示文描    string    @mock=已满5盒,可换购商品
@property (nonatomic, copy) NSString *hyperLink;    //     超链接    string
@property (nonatomic, copy) NSString *iconPath;    //     换购图标地址    string    @mock=icon url
@property (nonatomic, strong) NSNumber *id;    //     换购促销ID    number    @mock=15338
@property (nonatomic, copy) NSString *name;    //     换购促销名称    string    @mock=促销测试-单品换购
@property (nonatomic, copy) NSString *promationDescription;    //      活动描述    string
@property (nonatomic, strong) NSNumber *promotionType;   // 活动类型;1:特价活动;2:单品满减;3:多品满减;5:单品满赠；6:多品满赠送;7:单品满送积分;8:多品满送积分;9:单品换购;11:自定义单品活动; 12:自定义多品活动'
@end
