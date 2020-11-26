//
//  FKYSearchHistoryCell.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYSearchHistoryCell.h"
#import <Masonry/Masonry.h>

@interface FKYSearchHistoryCell ()

@property (nonatomic, strong) UILabel *searchWordLabel;
@property (nonatomic, strong) UIView *line;

/// 折叠图标
@property (nonatomic, strong) UIImageView *flodImg;
@end


@implementation FKYSearchHistoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.searchWordLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(FKYWH(15));
//            make.right.equalTo(self).offset(FKYWH(-10));
            make.left.right.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@(FKYWH(30)));
        }];
        label.font = FKYSystemFont(FKYWH(12));
        label.textColor = UIColorFromRGB(0x333333);
       // label.layer.borderWidth = FKYWH(0.5);
        //label.layer.borderColor = UIColorFromRGB(0xedebec).CGColor;
        //label.layer.cornerRadius = FKYWH(4);
        label.layer.cornerRadius = FKYWH(15);
        label.layer.backgroundColor = UIColorFromRGB(0xF4F4F4).CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    self.line = [[UIView alloc] init];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(FKYWH(15));
        make.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    self.line.backgroundColor = UIColorFromRGB(0xeaecee);
    
    self.flodImg = [[UIImageView alloc]init];
    self.flodImg.image = [UIImage imageNamed:@"search_down_Arrow"];
    self.flodImg.hidden = true;
    [self.contentView addSubview:self.flodImg];
    [self.flodImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(FKYWH(18));
    }];
    
}

- (void)configCell:(NSString *)text
{
    self.searchWordLabel.text = text;
    if (text == nil || text.length < 1){
        self.flodImg.hidden = false;
    }
}

- (void)configCellWithModel:(FKYSearchHistoryModel *)model{
    self.searchWordLabel.text = model.name;
    if ([model.itemType isEqualToString:@"flodItem_up"]){
        self.flodImg.hidden = false;
        self.flodImg.image = [UIImage imageNamed:@"search_down_Arrow"];
    }else if([model.itemType isEqualToString:@"flodItem_down"]){
        self.flodImg.hidden = false;
        self.flodImg.image = [UIImage imageNamed:@"search_up_Arrow"];
    }
    else{
        self.flodImg.hidden = true;
    }
}

- (void)hiddenBottomline:(BOOL)hidden
{
    self.line.hidden = hidden;
}

- (void)layerApper:(BOOL)hidden
{
    if (hidden == NO) {
        _searchWordLabel.layer.borderWidth = 0;
        _searchWordLabel.textAlignment = NSTextAlignmentCenter;
    }
    else {
        _searchWordLabel.layer.borderWidth = FKYWH(0.5);
        _searchWordLabel.textAlignment = NSTextAlignmentCenter;
    }
}

@end
