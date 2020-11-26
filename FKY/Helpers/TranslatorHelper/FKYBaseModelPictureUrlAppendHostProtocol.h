//
//  FKYBaseModelPictureUrlAppendHostProtocol.h
//  FKY
//
//  Created by yangyouyong on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FKYBaseModelPictureUrlAppendHostProtocol <NSObject>

@optional
/**
 *  需要添加host 的property name array
 *
 *  @return property name array;
 */
- (NSArray *)addHostUrlPropertyNameArray;

- (NSString *)picHost;

@end
