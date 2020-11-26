//
//  FKYEnterpriseCell.h
//  FKY
//
//  Created by 夏志勇 on 2017/11/30.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYEnterpriseCell : UITableViewCell

- (void)configWithTitle:(NSString *)name currentTitle:(NSString *)current;
- (void)setSelectedStatus:(BOOL)selected;

@end
