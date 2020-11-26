//
//  MTLJSONAdapter+FKYPictureUrlAppendHost.m
//  FKY
//
//  Created by yangyouyong on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "MTLJSONAdapter+FKYPictureUrlAppendHost.h"
#import "FKYBaseModelPictureUrlAppendHostProtocol.h"
#import "FKYBaseModel.h"
#import "NSString+FKYKit.h"

#import <objc/runtime.h>
#import <objc/objc.h>

@implementation MTLJSONAdapter (FKYPictureUrlAppendHost)

+ (void)load {
    SEL selectors[] = {
        @selector(modelOfClass:fromJSONDictionary:error:),
        @selector(modelsOfClass:fromJSONArray:error:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"fky_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        
        Method originalMethod = class_getClassMethod(self, originalSelector);
        Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (id)fky_modelOfClass:(Class)modelClass fromJSONDictionary:(NSDictionary *)JSONDictionary error:(NSError **)error {
    MTLJSONAdapter *adapter = [[self alloc] initWithJSONDictionary:JSONDictionary modelClass:modelClass error:error];
    [self p_addUrlForModel:adapter.model];
    return adapter.model;
}

+ (NSArray *)fky_modelsOfClass:(Class)modelClass fromJSONArray:(NSArray *)JSONArray error:(NSError **)error {
    
    if (JSONArray == nil || ![JSONArray isKindOfClass:NSArray.class]) {
        if (error != NULL) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Missing JSON array", @""),
                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"%@ could not be created because an invalid JSON array was provided: %@", @""), NSStringFromClass(modelClass), JSONArray.class],
                                       };
            *error = [NSError errorWithDomain:MTLJSONAdapterErrorDomain code:MTLJSONAdapterErrorInvalidJSONDictionary userInfo:userInfo];
        }
        return nil;
    }
    
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:JSONArray.count];
    for (NSDictionary *JSONDictionary in JSONArray){
        MTLModel *model = [self modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:error];
        
        if (model == nil) return nil;
        [self p_addUrlForModel:model];
        [models addObject:model];
    }
    
    return models;
}

+ (void) p_addUrlForModel:(MTLModel *)model {
    NSArray *propertyArray = [((FKYBaseModel<FKYBaseModelPictureUrlAppendHostProtocol> *) model) addHostUrlPropertyNameArray];
    NSString *picHost = [((FKYBaseModel<FKYBaseModelPictureUrlAppendHostProtocol> *) model) picHost];
    if (propertyArray != nil ){
        NSArray *_propertyArray = [propertyArray copy];
        [_propertyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model respondsToSelector:NSSelectorFromString(propertyName)]) {
                NSString *originImageUrl = [model valueForKey:propertyName];
                if (!([originImageUrl hasPrefix:@"http://"] || [originImageUrl hasPrefix:@"https://"])) {
                    NSString *finalImageUrl = [originImageUrl fky_imageUrlAddHost];
                    // p8 图片
                    if (picHost) {
                        if ([originImageUrl hasPrefix:@"/"]) {
                            finalImageUrl = [picHost stringByAppendingString:originImageUrl];
                        }else{
                            finalImageUrl = [NSString stringWithFormat:@"%@/%@",picHost,originImageUrl];
                        }
                    }
                    [model setValue:finalImageUrl forKey:propertyName];
                }
            }else{
                NSLog(@"%@ does not have property named :%@",NSStringFromClass(model.class),propertyName);
                NSAssert(0, @"no target property name");
            }
        }];
    }
    
}

@end
