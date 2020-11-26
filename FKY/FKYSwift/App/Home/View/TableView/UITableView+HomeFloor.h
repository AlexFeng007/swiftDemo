//
//  FKYHomeRuntime.h
//  FKY
//
//  Created by Rabe on 07/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (HomeFloor)

- (UITableViewCell *)cellForRowWithModelInterface:(id)model actionBlock:(void(^)(id action))operation;

- (CGFloat)heightForRowWithModelInterface:(id)model inTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier cachedBy:(NSIndexPath *)indexPath;

- (UITableViewCell *)cellForRowWithShopListModelInterface:(id)model actionBlock:(void(^)(id action))operation;

- (CGFloat)heightForRowWithShopListModelInterface:(id)model inTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier cachedBy:(NSIndexPath *)indexPath;

@end
