//
//  FKYFullGiftActionSheetModel.h
//  FKY
//
//  Created by 乔羽 on 2018/6/5.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FKYFullGiftImg : NSObject

@property (nonatomic, copy) NSString *giftImgUrl;

@end


@interface FKYFullGiftActionSheetModel : NSObject

@property (nonatomic, copy) NSString *promotionRuleMsg;
@property (nonatomic, strong) NSArray<FKYFullGiftImg *> *giftInfoList;

@end
