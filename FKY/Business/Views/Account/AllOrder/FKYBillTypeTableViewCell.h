//
//  FKYBillTypeTableViewCell.h
//  FKY
//
//  Created by Andy on 2018/10/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYBillTypeTableViewCell : UITableViewCell

@property (nonatomic, strong)NSArray *eleArr;

- (void)configCellWithModel:(FKYOrderModel *)model;

@property (nonatomic, strong)void(^clickSendMail)(void);
@property (nonatomic, strong)void(^clickLookBillMail)(void);

@end
