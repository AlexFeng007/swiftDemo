//
//  FKYOrderDetailHeaderView.h
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKYOrderModel;

typedef void(^OrderDetailHeaderViewBlock)(BOOL isTouch);

typedef void(^ContactYYCBlock)(NSString *itemName, NSString *itemPosition);//埋点

@interface FKYOrderDetailHeaderView : UIView

@property (nonatomic, strong)  UIImageView *photoView;
@property (nonatomic, assign)  BOOL isOpened;

@property (nonatomic, copy) OrderDetailHeaderViewBlock touchBlock;
@property (nonatomic, copy) ContactYYCBlock contactBlock;

- (void)setValueWithDetailModel:(FKYOrderModel *)detailModel;
+ (float)configHeightWithDetailModel:(FKYOrderModel *)detailModel;

@end
