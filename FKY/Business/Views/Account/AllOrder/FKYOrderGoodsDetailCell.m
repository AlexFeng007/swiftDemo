//
//  FKYOrderGoodsDetailCell.m
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderGoodsDetailCell.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"
#import "FKYOrderProductModel.h"
#import "FKYOrderModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FKYBatchModel.h"
#import "UIButton+FKYKit.h"


@interface FKYOrderGoodsDetailCell ()

@property (nonatomic, strong)  UILabel *nameLabel;       // 商品名称
@property (nonatomic, strong)  UILabel *speLabel;        // 规格
@property (nonatomic, strong)  UILabel *unitPriceLabel;  // 单价...<开票金额>
@property (nonatomic, strong)  UILabel *count;           // 数量...<单价 * 数量>
@property (nonatomic, strong)  UILabel *supplyLabel;     // 厂家名称
@property (nonatomic, strong)  UILabel *realNumLabel;    // 实发货数

@property (nonatomic, strong)  UIView *bottomLine;       // 底部分隔线
@property (nonatomic, strong)  UIImageView *iconView;    // 商品图
@property (nonatomic, strong)  UILabel *alertLabel;      // 需调拨发货

@property (nonatomic, strong) UILabel *rebateLabel;      //返利金额
@property (nonatomic, strong) UIButton *rebateBtn;       //协议奖励金按钮

@end


@implementation FKYOrderGoodsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    // 分隔线
    self.bottomLine = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-10));
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    
    // 商品图片
    self.iconView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(10));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(FKYWH(60)));
            make.height.equalTo(@(FKYWH(60)));
        }];
        view;
    });
    
    // 开票金额
    self.unitPriceLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = FKYSystemFont(FKYWH(12));
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(FKYWH(16));
            make.right.equalTo(self.contentView).offset(-FKYWH(10));
            make.height.equalTo(@(FKYWH(20)));
        }];
        label;
    });
    
    // 商品名称
    self.nameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = FKYBoldSystemFont(12);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(FKYWH(10));
            make.top.equalTo(self.contentView).offset(FKYWH(6));
            make.height.equalTo(@(FKYWH(40)));
            make.right.equalTo(self.unitPriceLabel.mas_left).offset(FKYWH(-6));
        }];
        label;
    });
    
    // 规格
    self.speLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = FKYSystemFont(10);
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.right.equalTo(self.nameLabel.mas_right);
            make.height.equalTo(@(FKYWH(18)));
        }];
        label;
    });
    
    // 单价 * 数量
    self.count = ({
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0xe60012);
        label.font = FKYSystemFont(10);
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.right.equalTo(self.unitPriceLabel.mas_right);
            make.height.equalTo(@(FKYWH(18)));
        }];
        label;
    });
    
    // 厂家名称
    self.supplyLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = FKYSystemFont(10);
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.speLabel.mas_bottom);
            make.right.equalTo(self.contentView).offset(FKYWH(-10));;
            make.height.equalTo(@(FKYWH(18)));
        }];
        label;
    });
    
    // 实发货数
    self.realNumLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = FKYSystemFont(10);
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.supplyLabel.mas_bottom).offset(FKYWH(2));
            make.right.equalTo(self.supplyLabel);
            make.height.equalTo(@(FKYWH(16)));
        }];
        label;
    });
    
    // 需调拨发货
    self.alertLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UIColorFromRGB(0xFF2D5C);
        label.font = FKYSystemFont(FKYWH(11));
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = UIColorFromRGB(0xFF2D5C).CGColor;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = FKYWH(2);
        label.layer.masksToBounds = true;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.supplyLabel.mas_bottom).offset(FKYWH(2));
            make.width.equalTo(@(1));
            make.height.equalTo(@(FKYWH(16)));
        }];
        label;
    });
    
    [self.contentView addSubview:self.rebateBtn];
    [self.rebateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.supplyLabel.mas_bottom).offset(FKYWH(2));
        make.size.mas_equalTo(CGSizeMake(FKYWH(66), FKYWH(16)));
    }];
    
    [self.contentView addSubview:self.rebateLabel];
    [self.rebateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.supplyLabel.mas_bottom).offset(FKYWH(2));
    }];
}

- (void)configCellWithModel:(FKYOrderProductModel *)productModel andOrderModel:(FKYOrderModel *)model
{
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[productModel.productPicUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"image_default_img"]];
    _nameLabel.text = productModel.productName;
    _speLabel.text = productModel.spec.fky_safeString;
    CGFloat p = productModel.billMoney.floatValue;
    _unitPriceLabel.text  = [NSString stringWithFormat:@"开票金额￥%.2f",p];
    _supplyLabel.text = productModel.factoryName;
    p = productModel.productPrice.floatValue;
    _count.text = [NSString stringWithFormat:@"￥%.2f x %@",p,productModel.quantity.fky_safeString];
    
    
    //此处动态，先全部隐藏再说
    self.alertLabel.hidden = YES;
    self.realNumLabel.hidden = YES;
    self.rebateBtn.hidden = YES;
    self.rebateLabel.hidden = YES;
    
    if (productModel.inventoryStatus == 0 && productModel.arrivalTips.length > 0) {
        CGFloat maxWidth = SCREEN_WIDTH - 90;
        CGSize size = [productModel.arrivalTips boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:FKYSystemFont(FKYWH(11))}
                                         context:NULL].size;
        CGFloat tipsWidth = (size.width + 6) > maxWidth ? maxWidth : (size.width + 6);
        [self.alertLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(tipsWidth));
        }];
        self.alertLabel.hidden = NO;
        self.alertLabel.text = productModel.arrivalTips;
    }
    
    
    if (model.portionDelivery.integerValue == 1) {
        self.realNumLabel.hidden = NO;
        self.realNumLabel.text = [NSString stringWithFormat:@"实发货数: %@",productModel.realShipment];
        
        [self.realNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.alertLabel.isHidden) {
                make.top.equalTo(self.supplyLabel.mas_bottom).offset(FKYWH(2));
            }else {
                make.top.equalTo(self.supplyLabel.mas_bottom).offset(FKYWH(20));
            }
        }];
    }
    
    CGFloat offset = 2;
    if (!self.alertLabel.isHidden) {
        offset += 18;
    }
    
    if (!self.realNumLabel.isHidden) {
        offset += 18;
    }
    
    if (productModel.agreementRebateDetailUrl.length) {
        self.rebateBtn.hidden = NO;
//        if (productModel.agreementRebateProductTips.length) {
//            [self.rebateBtn setTitle:productModel.agreementRebateProductTips forState:UIControlStateNormal];
//        }else {
//            [self.rebateBtn setTitle:@"协议奖励金" forState:UIControlStateNormal];
//        }
        if ((!self.alertLabel.isHidden && self.realNumLabel.isHidden) || (self.alertLabel.isHidden && !self.realNumLabel.isHidden)) {
            offset += 4;
        }
        [self.rebateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.supplyLabel.mas_bottom).offset(FKYWH(offset));
        }];
        
    }else if (productModel.normalRebateProductTips.length) {
        self.rebateLabel.hidden = NO;
        self.rebateLabel.text = productModel.normalRebateProductTips;
        [self.rebateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.supplyLabel.mas_bottom).offset(FKYWH(offset));
        }];
    }
}

- (void)configcellWithProductModel:(FKYOrderProductModel *)model andBatchModel:(FKYBatchModel *)batch
{
    _count.hidden = YES;
    _realNumLabel.hidden = YES;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[model.productPicUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"image_default_img"]];
    _nameLabel.text = model.productName;
    _speLabel.text = model.spec.fky_safeString;
    CGFloat p = model.productPrice.floatValue;
    _unitPriceLabel.text  = [NSString stringWithFormat:@"￥%.2f",p];
    _supplyLabel.text = model.factoryName;
    _count.text = [NSString stringWithFormat:@"x %@",batch.buyNumber.fky_safeString];
}


- (void)rebateClicked:(id) sender {
    if (self.agreeRebateBlock) {
        self.agreeRebateBlock();
    }
}

- (UIButton *)rebateBtn {
    if (!_rebateBtn) {
        _rebateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rebateBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _rebateBtn.titleLabel.font = FKYSystemFont(10);
        [_rebateBtn setTitleColor:UIColorFromRGB(0xFF2D5C) forState:UIControlStateNormal];
        [_rebateBtn setImage:[UIImage imageNamed:@"protocol_rebate_arrow"] forState:UIControlStateNormal];
        [_rebateBtn setTitle:@"协议奖励金" forState:UIControlStateNormal];
        [_rebateBtn setTitleLeftAndImageRightWithSpace:FKYWH(2)];
        _rebateBtn.layer.cornerRadius = 2;
        _rebateBtn.layer.borderColor =  UIColorFromRGB(0xFF2D5C).CGColor;
        _rebateBtn.layer.borderWidth = 1;
        _rebateBtn.layer.masksToBounds = YES;
        _rebateBtn.hidden = YES;
        [_rebateBtn addTarget:self action:@selector(rebateClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rebateBtn;
}

- (UILabel *)rebateLabel {
    if (!_rebateLabel) {
        _rebateLabel = [[UILabel alloc] init];
        _rebateLabel.textColor = UIColorFromRGB(0xFF2D5C);
        _rebateLabel.adjustsFontSizeToFitWidth = YES;
        _rebateLabel.font = FKYSystemFont(10);
        _rebateLabel.hidden = YES;
    }
    return _rebateLabel;
}

@end
