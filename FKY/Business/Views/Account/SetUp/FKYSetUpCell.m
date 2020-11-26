//
//  FKYSetUpCell.m
//  FKY
//
//  Created by mahui on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYSetUpCell.h"
#import <Masonry/Masonry.h>

@interface FKYSetUpCell ()

@property (nonatomic, strong)  UIView *topView;
@property (nonatomic, strong)  UIView *bottomView;

@end

@implementation FKYSetUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{

    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(12));
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
            make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-6));
            make.top.equalTo(self.contentView.mas_top).offset(FKYWH(10));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(FKYWH(-10));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label;
    });
    self.dotView = ({
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"icon_reddot"];
        
        [self.contentView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top).offset(FKYWH(10));
            make.width.height.equalTo(@(FKYWH(5)));
        }];
        
        iv;
    });
}

@end
