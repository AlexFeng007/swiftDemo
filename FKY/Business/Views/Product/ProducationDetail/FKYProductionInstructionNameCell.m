//
//  FKYProductionInstructionNameCell.m
//  FKY
//
//  Created by mahui on 15/11/20.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYProductionInstructionNameCell.h"
#import <Masonry/Masonry.h>

@interface FKYProductionInstructionNameCell ()

@property (nonatomic, strong)  UIView *leftLine;
@property (nonatomic, strong)  UIView *rightLine;
@property (nonatomic, strong)  UIView *mideLine;

@end


@implementation FKYProductionInstructionNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI
{
    self.topLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xe6e6e6);
        view.hidden = true;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(FKYWH(12));
            make.right.equalTo(self.contentView).offset(-FKYWH(12));
            make.top.equalTo(self.contentView);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view;
    });
    
    self.bottomLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xe6e6e6);
        view.hidden = true;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(FKYWH(12));
            make.right.equalTo(self.contentView).offset(-FKYWH(12));
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view;
    });
    
    self.leftLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xe6e6e6);
        view.hidden = true;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(FKYWH(12));
            make.width.equalTo(@(FKYWH(0.5)));
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        view;
    });
    
    self.rightLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xe6e6e6);
        view.hidden = true;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-FKYWH(12));
            make.top.equalTo(self.contentView);
            make.width.equalTo(@(FKYWH(0.5)));
        }];
        view;
    });
    
    self.bgView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLine.mas_right);
            make.right.equalTo(self.rightLine.mas_left);
            make.top.equalTo(self.topLine.mas_bottom);
            make.bottom.equalTo(self.bottomLine.mas_top);
        }];
        view;
    });
    
    self.mideLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xe6e6e6);
        view.hidden = true;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.leftLine.mas_right).offset(FKYWH(85));
            make.top.equalTo(self.contentView);
            make.width.equalTo(@(FKYWH(0.5)));
        }];
        view;
    });

    self.normalNameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x555555);
        label.font = FKYSystemFont(FKYWH(12));
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLine.mas_right).offset(FKYWH(10));
            make.right.equalTo(self.mideLine.mas_left);
            make.centerY.equalTo(self.bgView);
        }];
        label;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x555555);
        label.font = FKYSystemFont(FKYWH(12));
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mideLine.mas_right).offset(FKYWH(5));
            make.right.equalTo(self.rightLine.mas_left);
            make.centerY.equalTo(self.bgView);
        }];
        label;
    });
}

@end
