//
//  FKYSplitDatailDialView.h
//  FKY
//
//  Created by zengyao on 2017/6/12.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYSplitDatailDialView : UIView

+ (void)showDialViewWithPhoneNumber:(NSString *)phoneNumber andCallback:(void (^)(void))callback;

@end
