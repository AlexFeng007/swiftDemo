//
//  FKYCartTypeView.h
//  FKY
//
//  Created by 夏志勇 on 2019/3/26.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  购物车之类型选择视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FKYCartTypeView : UIView

@property (nonatomic, copy) void(^selectBlock)(NSInteger index);

- (void)setSelectedIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
