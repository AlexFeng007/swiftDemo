//
//  FKYCartCheckModel.m
//  FKY
//
//  Created by zhangxuewen on 2018/3/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYCartCheckModel.h"
#import "NSDictionary+SafeAccess.h"
@implementation FKYCartCheckModel
-(void)initWithDict:(NSDictionary *)dict{
    self.productName = [dict stringForKey:@"productName"];
    self.message = [dict stringForKey:@"message"];
    self.shoppingCartId = [dict integerForKey:@"shoppingCartId"];
    self.specification = [dict stringForKey:@"specification"];
    self.spuCode = [dict stringForKey:@"spuCode"];
    self.statusCode = [dict integerForKey:@"statusCode"];
    self.supplyId = [dict integerForKey:@"supplyId"];
}
@end
