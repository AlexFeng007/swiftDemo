//
//
//  Created by Rabe.☀️ on 16/1/11.
//  Copyright © 2016年 YYW. All rights reserved.
//  订单模块查看物流页自定义Cell

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "FKYDeliveryItemModel.h"


@interface FKYSplitDetailCell : UITableViewCell

/**
 *  赋值数据源
 *  @param model     数据源
 *  @param indexPath 行
 */
- (void)configureModel:(id)model indexPath:(NSIndexPath *)indexPath;
- (void)configureRcModel:(id)model indexPath:(NSIndexPath *)indexPath;
/**
 *  计算行高
 *  @param model     数据源
 *  @param indexPath 行
 *  @return 相应行高度
 */
- (CGFloat)calulateHeightWithModel:(id)model indexPath:(NSIndexPath *)indexPath;


@end
