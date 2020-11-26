//
//  FKYEnterpriseCell.m
//  FKY
//
//  Created by 夏志勇 on 2017/11/30.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYEnterpriseCell.h"


@interface FKYEnterpriseCell ()

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIImageView *imgviewSelect;

@end


@implementation FKYEnterpriseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.imgviewSelect];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    [self.imgviewSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(FKYWH(-12));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(FKYWH(10));
        make.right.equalTo(self.imgviewSelect.mas_left).offset(FKYWH(-12));
        make.height.mas_equalTo(FKYWH(40));
    }];
    [super updateConstraints];
}


#pragma mark - public

// 设置当前cell中的名称
- (void)configWithTitle:(NSString *)name currentTitle:(NSString *)current
{
    self.lblTitle.text = name;
//    if (name && current && [name isEqualToString:current]) {
//        // 当前为选中项
//        self.imgviewSelect.image = [UIImage imageNamed:@"icon_cart_selected"];
//    }
//    else {
//        // 当前为非选中项
//        self.imgviewSelect.image = [UIImage imageNamed:@"icon_cart_promote_unselected"];
//    }
}

// 设置当前cell的选中状态
- (void)setSelectedStatus:(BOOL)selected
{
    if (selected) {
        // 当前为选中项
        self.imgviewSelect.image = [UIImage imageNamed:@"icon_cart_selected"];
    }
    else {
        // 当前为非选中项
        self.imgviewSelect.image = [UIImage imageNamed:@"icon_cart_promote_unselected"];
    }
}


#pragma mark - property

- (UILabel *)lblTitle
{
    if (!_lblTitle) {
        _lblTitle = [UILabel new];
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.font = [UIFont boldSystemFontOfSize:FKYWH(14)];
        _lblTitle.textColor = [UIColor darkGrayColor];
        _lblTitle.textAlignment = NSTextAlignmentLeft;
        _lblTitle.numberOfLines = 2;
        _lblTitle.minimumScaleFactor = 0.8;
        _lblTitle.adjustsFontSizeToFitWidth = YES;
    }
    return _lblTitle;
}

- (UIImageView *)imgviewSelect
{
    if (!_imgviewSelect) {
        _imgviewSelect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cart_promote_unselected"]];
    }
    return _imgviewSelect;
}


@end
