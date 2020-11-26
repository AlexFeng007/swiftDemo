//
//  UITableView+HomeFloor.m
//  FKY
//
//  Created by Rabe on 07/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "UITableView+HomeFloor.h"
#import "NSObject+Runtime.h"

@implementation UITableView (HomeFloor)

- (UITableViewCell *)cellForRowWithModelInterface:(id)model actionBlock:(void(^)(id action))operation {
    if ([model conformsToProtocol:@protocol(HomeModelInterface)]) {
        UITableViewCell <HomeCellInterface> * cell = [self dequeueReusableCellWithIdentifier:[model floorIdentifier]];
        [cell bindModel: model];
        [cell bindOperation: operation];
        if ( !cell ) {
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        } else {
            return (UITableViewCell *)cell;
        }
    }
    else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
}

- (CGFloat)heightForRowWithModelInterface:(id)model inTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier cachedBy:(NSIndexPath *)indexPath {
    if ([model conformsToProtocol:@protocol(HomeModelInterface)]) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"FKY.%@", [model floorIdentifier]];
        Class<HomeCellInterface> viewClass = NSClassFromString(cellIdentifier);
        CGFloat height = [viewClass calculateHeightWithModel: model tableView: tableView identifier: identifier indexPath: indexPath];
        return height;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)cellForRowWithShopListModelInterface:(id)model actionBlock:(void(^)(id action))operation {
    if ([model conformsToProtocol:@protocol(ShopListModelInterface)]) {
        UITableViewCell <ShopListCellInterface> * cell = [self dequeueReusableCellWithIdentifier:[model floorCellIdentifier]];
        [cell bindModel: model];
        [cell bindOperation: operation];
        if ( !cell ) {
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        } else {
            return (UITableViewCell *)cell;
        }
    }
    else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
}

- (CGFloat)heightForRowWithShopListModelInterface:(id)model inTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier cachedBy:(NSIndexPath *)indexPath {
    if ([model conformsToProtocol:@protocol(ShopListModelInterface)]) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"FKY.%@", [model floorCellIdentifier]];
        Class<ShopListCellInterface> viewClass = NSClassFromString(cellIdentifier);
        CGFloat height = [viewClass calculateHeightWithModel: model tableView: tableView identifier: identifier indexPath: indexPath];
        return height;
    }
    else {
        return 0;
    }
}

@end
