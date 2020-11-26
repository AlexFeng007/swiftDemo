//
//  FKYOrderDetailMoreInfoCell.h
//  FKY
//
//  Created by mahui on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKYOrderModel;


@interface FKYOrderDetailDeliveryCell : UITableViewCell

- (void)configCellWithModel:(FKYOrderModel *)model;
- (void)configGiftCellWithModel:(FKYOrderModel *)model;

- (void)showArraw:(BOOL)showFlag;
- (void)hideAllLabel;
@end
