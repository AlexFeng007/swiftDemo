//
//  FKYSearchRemindCell.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYSearchRemindCell.h"

@interface FKYSearchRemindCell ()

@property (nonatomic, strong) UILabel *productNameLabel;    // 商品名称
@property (nonatomic, strong) UILabel *productVenderLabel;  // 供应商名称

@end


@implementation FKYSearchRemindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    UILabel *label = [UILabel new];
    label.font = FKYSystemFont(FKYWH(13));
    label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(FKYWH(15)));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH/2));
        make.width.greaterThanOrEqualTo(@(80));
    }];
    self.productNameLabel = label;
    
    label = [UILabel new];
    label.font = FKYSystemFont(FKYWH(12));
    label.textColor = UIColorFromRGB(0x999999);
    label.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_right).offset(FKYWH(15));
        make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-15));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    self.productVenderLabel = label;
    
    UIView *bottomLine = [UIView new];
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    
    // 当冲突时，productNameLabel不被压缩，productVenderLabel可以被压缩
    // 当前lbl抗压缩（不想变小）约束的优先级高
    [self.productNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    // 当前lbl抗压缩（不想变小）约束的优先级低
    [self.productVenderLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    // 当冲突时，productPriceLabel不被拉伸，productVenderLabel可以被拉伸
    // 当前lbl抗拉伸（不想变大）约束的优先级高
    [self.productNameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    // 当前lbl抗拉伸（不想变大）约束的优先级低
    [self.productVenderLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)configCell:(FKYSearchRemindModel *)model
{
    self.productNameLabel.text = model.drugName;
    self.productVenderLabel.text = model.factoryName;
}

@end
