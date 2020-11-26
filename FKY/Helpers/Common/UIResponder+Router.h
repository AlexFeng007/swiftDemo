//
//  UIResponder+Router.h
//  
//
//  Created by Rabe on 27/07/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

//static NSString *FKYUserParameterKey = @"userParameter";
#define FKYUserParameterKey @"userParameter"
@interface UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
- (NSInvocation *)createInvocationWithSelector:(SEL)selector;

@end
