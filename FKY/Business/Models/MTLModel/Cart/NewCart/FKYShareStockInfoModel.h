//
//  FKYShareStockInfoModel.h
//  FKY
//
//  Created by 寒山 on 2019/5/30.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYShareStockInfoModel : FKYBaseModel
@property (nonatomic, copy) NSString *desc;//    发货文描：【该商品需从XX进行调拔，预计可发货时间：2000-01-01】    string
@property (nonatomic, assign) BOOL needAlert ;//   是否需要弹窗    boolean
@property (nonatomic, strong) NSNumber *stockToFromWarhouseId ;//   库存调拨仓ID
@end
