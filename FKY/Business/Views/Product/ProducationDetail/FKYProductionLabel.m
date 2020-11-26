//
//  FKYProductionLabel.m
//  FKY
//
//  Created by mahui on 15/9/18.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYProductionLabel.h"

@implementation FKYProductionLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = FKYSystemFont(FKYWH(12));
        self.textColor = UIColorFromRGB(0x3f4257);
    }
    return self;
}

@end
