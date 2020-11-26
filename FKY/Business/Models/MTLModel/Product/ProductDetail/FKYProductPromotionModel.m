//
//  FKYProductPromotionModel.m
//  FKY
//
//  Created by mahui on 2016/11/17.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYProductPromotionModel.h"

@implementation FKYProductPromotionModel

- (NSInteger)currentStock {
    if (_limitNum.integerValue > _currentInventory.integerValue) {
        return _limitNum.integerValue;
    }else{
        return _currentInventory.integerValue;
    }
}

@end
