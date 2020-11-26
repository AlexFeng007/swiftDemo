//
//  FKYOrderDetailFooterView.m
//  FKY
//
//  Created by mahui on 16/9/7.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYOrderDetailFooterView.h"
#import <Masonry/Masonry.h>
#import "FKYOrderModel.h"
#import "FKYOrderProductModel.h"


@interface FKYOrderDetailFooterView ()
@property (nonatomic, strong) UIView *contentBgView;      // 底部分隔线
@property (nonatomic, strong) UIView *topLine;      // 底部分隔线
@property (nonatomic, strong) UILabel *infoLabel;   // 信息
@property (nonatomic, strong) UILabel *titleLabel;  // 数量

@end


@implementation FKYOrderDetailFooterView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupView
{
    _contentBgView = ({
           UIView *view = [[UIView alloc] init];
           [self.contentView addSubview:view];
           [view mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.right.top.equalTo(self.contentView);
               make.bottom.equalTo(self.contentView.mas_bottom);
           }];
         view.backgroundColor = UIColor.whiteColor;
           view;
       });
    // 底部分隔线
    _topLine = ({
        UIView *view = [[UIView alloc] init];
        [_contentBgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView.mas_left).offset(FKYWH(10));
            make.right.equalTo(_contentBgView.mas_right).offset(FKYWH(-10));
            make.bottom.equalTo(_contentBgView.mas_bottom);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    //
    _titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [_contentBgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView.mas_left).offset(FKYWH(10));
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.width.equalTo(@(FKYWH(40)));
        }];
        label.font = FKYSystemFont(13);
        label;
    });
    //
    _infoLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [_contentBgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left).offset(FKYWH(10));
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.right.equalTo(_contentBgView.mas_right).offset(FKYWH(-10));
        }];
        label.font = FKYSystemFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label;
    });
}

- (void)setValueWithDetailModel:(FKYOrderModel *)detailModel
{
    NSInteger integer = 0;
    CGFloat total = 0;
    for (FKYOrderProductModel *model in detailModel.productList) {
        integer += model.quantity.integerValue;
        total += (model.productPrice.doubleValue * model.quantity.doubleValue);
    }
    if ([detailModel.supplyName isKindOfClass:[NSNull class]]) {
        detailModel.supplyName = @"";
    }
    _infoLabel.attributedText = ({
        NSString *message = [NSString stringWithFormat:@"共%ld个品种  %ld件商品  合计: ￥%.2f",(unsigned long)detailModel.productList.count,(long)integer,total];
        NSRange rang = [message rangeOfString:[NSString stringWithFormat:@"￥%.2f",total]];
        NSValue *rangValue = [NSValue valueWithRange:rang];
        NSAttributedString *string = FKYAttributedStringForStringAndRangesOfSubString(message, FKYWH(12), UIColorFromRGB(0x999999), @[rangValue], FKYWH(12), UIColorFromRGB(0xe60012));
        string;
    });
}

- (void)setValueForUnusualWithDetailModel:(FKYOrderModel *)detailModel
{
    NSInteger integer = 0;
    for (FKYOrderProductModel *model in detailModel.productList) {
        integer += model.quantity.integerValue;
    }
    if ([detailModel.supplyName isKindOfClass:[NSNull class]]) {
        detailModel.supplyName = @"";
    }
    
    _infoLabel.text = [NSString stringWithFormat:@"共%ld个品种  %ld件商品",(unsigned long)detailModel.productList.count,(long)integer];
    _infoLabel.textColor = UIColorFromRGB(0x999999);
    
    _titleLabel.text = @"数量:";
    _titleLabel.textColor = UIColorFromRGB(0x666666);
}


@end
