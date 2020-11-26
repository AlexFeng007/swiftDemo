//
//  NSManagedObject+FKYKit.h
//  FKY
//
//  Created by yangyouyong on 15/9/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <CoreData/CoreData.h>

@class FKYBaseModel;

@interface NSManagedObject (FKYKit)

- (void)copyPropertiesFromBaseModel:(FKYBaseModel *)baseModel;

@end
