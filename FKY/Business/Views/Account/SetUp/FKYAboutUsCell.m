//
//  FKYAboutUsCell.m
//  FKY
//
//  Created by yangyouyong on 15/10/10.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYAboutUsCell.h"
#import <Masonry/Masonry.h>

@interface FKYAboutUsCell ()

@property (nonatomic, strong)  UIView *topView;
@property (nonatomic, strong)  UIView *bottomView;

@end


@implementation FKYAboutUsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(15));
            make.top.equalTo(self.contentView.mas_top).offset(FKYWH(10));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(FKYWH(-10));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label;
    });
    
    self.subLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-12));
            make.top.equalTo(self.contentView.mas_top).offset(FKYWH(10));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(FKYWH(-10));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label;
    });
}

@end
