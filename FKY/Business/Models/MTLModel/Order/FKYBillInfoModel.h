//
//  FKYBillInfoModel.h
//  FKY
//
//  Created by hui on 2019/7/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYBillInfoModel : FKYBaseModel
@property (nonatomic, strong) NSString *invoiceName;        // 电子发票名称
@property (nonatomic, strong) NSString *filePath;          // 电子发票地址
@end

