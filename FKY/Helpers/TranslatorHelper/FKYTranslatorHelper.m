//
//  FKYTranslatorHelper.m
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYTranslatorHelper.h"
#import <Mantle/Mantle.h>

@implementation FKYTranslatorHelper

+ (id)translateModelFromJSON:(NSDictionary *)JSON
                   withClass:(Class)clazz {
    NSParameterAssert(clazz != nil);
    NSError *error = nil;
    id model = [MTLJSONAdapter modelOfClass:clazz
                         fromJSONDictionary:JSON
                                      error:&error];
    if (!error) {
        return model;
    } else {
        return nil;
    }
}

+ (NSArray *)translateCollectionFromJSON:(NSArray *)JSON
                               withClass:(Class)clazz {
    NSParameterAssert(clazz != nil);
    if ([JSON isKindOfClass:[NSArray class]]) {
        NSError *error = nil;
        NSArray *models = [MTLJSONAdapter modelsOfClass:clazz
                               fromJSONArray:JSON
                                       error:nil];
        if (!error) {
            return models;
        } else {
            return nil;
        }
    }
    return nil;
}

+ (id)translateModelfromManagedObject:(NSManagedObject *)managedObject
                            withClass:(Class)clazz {
    NSParameterAssert(clazz != nil);
    NSError *error = nil;
    id model = [MTLManagedObjectAdapter modelOfClass:clazz
                                   fromManagedObject:managedObject
                                               error:&error];
    if (!error) {
        return model;
    } else {
        return nil;
    }
}

+ (NSArray *)translateCollectionfromManagedObjects:(NSArray *)managedObjects
                                         withClass:(Class)clazz {
    NSParameterAssert(clazz != nil);
    if ([managedObjects isKindOfClass:[NSArray class]]) {
        NSMutableArray *collection = [NSMutableArray array];
        for (NSManagedObject *managedObject in managedObjects) {
            id model = [self translateModelfromManagedObject:managedObject
                                                   withClass:clazz];
            if (model != nil) {
                [collection addObject:model];
            }
        }
        return collection;
    }
    return nil;
}


@end
