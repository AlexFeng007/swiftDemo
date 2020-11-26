//
//  FKYLogisticFollowCell.m
//  FKY
//
//  Created by zengyao on 2017/6/7.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYLogisticFollowCell.h"
#import <Masonry/Masonry.h>
@interface FKYLogisticFollowCell ()
@property (nonatomic, strong) UIView*bottomLine;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation FKYLogisticFollowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMainViews];
    }
    return self;
}

- (void)setupMainViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.leading.equalTo(self.contentView).offset(15);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.contentView).offset(0);
        
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.height.equalTo(@1);
    }];
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"物流跟踪";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [UIView new];
        _bottomLine.alpha = 0.5;
        _bottomLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
    }
    return _bottomLine;
    
}

@end
