//
//  FKYAccountPicCodeModel.h
//  FKY
//
//  Created by Lily on 2018/2/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  图形验证码model

#import <Foundation/Foundation.h>

@interface FKYAccountPicCodeModel : NSObject

/** 图片验证码唯一id */
@property (nonatomic, copy) NSString *identity;
/** 图片验证码base64 */
@property (nonatomic, copy) NSString *imgsrc;
/** ??? */
@property (nonatomic, copy) NSString *open;

/** 图片验证码数据 */
@property (nonatomic, strong) NSData *imageData;

@end
