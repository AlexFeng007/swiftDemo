//
//  FKYTranslatorHelper.h
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"
#import <CoreData/CoreData.h>

@interface FKYTranslatorHelper : NSObject

/**
 *  将json数据转化为MTLModel子类类名
 *
 *  @param JSON
 *  @param clazz
 *
 *  @return
 */
+ (id)translateModelFromJSON:(NSDictionary *)JSON
                   withClass:(Class)clazz;

/**
 *  将json数据转为多个MTLModel子类类名
 *
 *  @param JSON
 *  @param clazz
 *
 *  @return
 */
+ (NSArray *)translateCollectionFromJSON:(NSArray *)JSON
                               withClass:(Class)clazz;

/**
 *  将Managed Object对象转化为MTLModel子类类名
 *
 *  @param managedObject
 *  @param clazz
 *
 *  @return
 */
+ (id)translateModelfromManagedObject:(NSManagedObject *)managedObject
                            withClass:(Class)clazz;

/**
 *  将MTLModel对象转化为Managed Object子类类名
 *
 *  @param managedObjects
 *  @param clazz
 *
 *  @return
 */
+ (NSArray *)translateCollectionfromManagedObjects:(NSArray *)managedObjects
                                         withClass:(Class)clazz;


@end
