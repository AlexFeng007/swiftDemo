//
//  FKYOrderDetailFooterView.h
//  FKY
//
//  Created by mahui on 16/9/7.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKYOrderModel;


@interface FKYOrderDetailFooterView : UITableViewCell

- (void)setValueWithDetailModel:(FKYOrderModel *)detailModel;
- (void)setValueForUnusualWithDetailModel:(FKYOrderModel *)detailModel;

@end
