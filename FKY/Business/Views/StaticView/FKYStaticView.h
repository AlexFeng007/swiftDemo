//
//  FKYStaticView.h
//  FKY
//
//  Created by yangyouyong on 2016/9/21.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYStaticView : UIView

@property (nonatomic, copy) void(^actionBlock)(void);

- (void)configView:(NSString *)iconName
             title:(NSString *)title
          btnTitle:(NSString *)btnTitle;

@end
