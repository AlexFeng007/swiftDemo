//
//  YWSplitDetailHeaderView.h
//  YYW
//
//  Created by Rabe.☀️ on 16/1/11.
//  Copyright © 2016年 YYW. All rights reserved.
//  查看物流顶部自定义视图Header

#import <UIKit/UIKit.h>
#import "FKYDeliveryHeadModel.h"

typedef void(^FKYCopyBlock)(void);

@class FKYSplitDetailHeaderView;


@protocol FKYSplitDetailHeaderViewDelegate <NSObject>

@optional
- (void)FKYSplitDetailHeaderView:(FKYSplitDetailHeaderView *)headerView didTapSplitCarrier:(UILabel *)splitCarrierLabel;

@end


@interface FKYSplitDetailHeaderView : UIView

@property (nonatomic, copy) FKYCopyBlock copyBlock;

@property (nonatomic, weak) id<FKYSplitDetailHeaderViewDelegate> delegate;

- (void)bindModel:(FKYDeliveryHeadModel *)headerModel;

@end
