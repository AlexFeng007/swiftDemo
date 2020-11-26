//
//  FKYProductInstructionCell.m
//  FKY
//
//  Created by mahui on 15/11/19.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYProductInstructionCell.h"
#import <Masonry/Masonry.h>


@interface FKYProductInstructionCell ()

@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;

@end


@implementation FKYProductInstructionCell

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
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(FKYWH(12));
            make.right.equalTo(self.contentView).offset(-FKYWH(12));
            make.top.equalTo(self.contentView);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.hidden = true;
        view;
    });
    
    self.bottomLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xe6e6e6);
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
        view.backgroundColor = UIColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLine.mas_right);
            make.right.equalTo(self.rightLine.mas_left);
            make.top.equalTo(self.topLine.mas_bottom);
            make.bottom.equalTo(self.bottomLine.mas_top);
        }];
        view;
    });
         
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.9;
        label.textColor = UIColorFromRGB(0x555555);
        [self.bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.bgView.mas_right).offset(-FKYWH(10));
            make.top.equalTo(self.bgView.mas_top).offset(FKYWH(10));
            //make.bottom.equalTo(self.bgView.mas_bottom).offset(FKYWH(-10));
        }];
        label;
    });
}
         
@end
