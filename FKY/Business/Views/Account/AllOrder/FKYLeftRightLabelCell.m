//
//  FKYLeftRightLabelCell.m
//  FKY
//
//  Created by mahui on 15/11/23.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYLeftRightLabelCell.h"
#import <Masonry/Masonry.h>
#import "FKYOrderModel.h"
#import "NSString+AttributedString.h"

@interface FKYLeftRightLabelCell ()

@property (nonatomic, strong)  UIView *bottomView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *infoLabel;
@property (nonatomic, strong)  UIImageView *iv;
@end


@implementation FKYLeftRightLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    _bottomView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-10));
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@(FKYWH(.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    _nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.lessThanOrEqualTo(@(FKYWH(180)));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textColor = UIColorFromRGB(0x333333);
        label;
    });
    _infoLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-FKYWH(10));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textAlignment = NSTextAlignmentRight;
        label;
    });
    
    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"cart_rebeat_icon"];
    iv.userInteractionEnabled = YES;
    [self.contentView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.equalTo(@20);
    }];
    @weakify(self);
    [iv bk_whenTouches:1 tapped:1 handler:^{
        @strongify(self);
        safeBlock(self.showRebateDescBlock);
    }];
    self.iv = iv;
}

- (void)configCellWithModel:(FKYOrderModel *)model andType:(FKYLeftRightLabelCellType)cellType
{
    _nameLabel.text = nil;
    _infoLabel.text = nil;
    _nameLabel.hidden = NO;
    _infoLabel.hidden = NO;
    _iv.hidden = YES;
    if (cellType == PayType || cellType == BillTagType || cellType == saleContract) {
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.nameLabel.mas_right).offset(FKYWH(13));
        }];
    }else{
        [_infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-FKYWH(10));
        }];
    }
    
    switch (cellType) {
        case PayType:
            _nameLabel.text = @"支付方式";
            _infoLabel.text = model.payName;
            _infoLabel.textColor = UIColorFromRGB(0x666666);
            break;
        case saleContract:
            if (model.viewPrintContract !=nil && model.viewPrintContract.intValue == 1){
                _nameLabel.hidden = NO;
                _infoLabel.hidden = NO;
            }else{
                _nameLabel.hidden = YES;
                _infoLabel.hidden = YES;
            }
            _nameLabel.text = @"销售合同（纸质版)";
            if (model.isPrintContract !=nil && model.isPrintContract.intValue == 1){
                _infoLabel.text = @"随货寄出";
            }else{
                _infoLabel.text = @"不随货寄出";
            }
            _infoLabel.textColor = UIColorFromRGB(0x666666);
            break;
        case BillTagType:
            _nameLabel.text = @"发票类型";
            _infoLabel.text = [model getBillType];
            _infoLabel.textColor = UIColorFromRGB(0x666666);
            break;
        case DeliveryType:
            _nameLabel.text = @"配送方式";
            _infoLabel.text = [model getDeliveryMethod];
            _infoLabel.textColor = UIColorFromRGB(0x333333);
            break;
        case ProductsMoneyType:
            _nameLabel.text = @"商品金额";
            _infoLabel.text = [NSString stringWithFormat:@"¥ %.2f",model.orderTotal.doubleValue];
            _infoLabel.textColor = UIColorFromRGB(0x333333);
            break;
        case CouponMoneyType:
            _nameLabel.text = @"优惠券";
            _infoLabel.text = [NSString stringWithFormat:@"-¥ %.2f",model.couponMoney.doubleValue];
            _infoLabel.textColor = UIColorFromRGB(0xe60012);
            break;
        case PayMoneyType:
            _nameLabel.text = @"实付金额";
            _infoLabel.text = [NSString stringWithFormat:@"¥ %.2f",model.finalPay.doubleValue];
            _infoLabel.textColor = UIColorFromRGB(0xe60012);
            break;
        case FreightMoneyTypes: {
            NSString *str = @"运费";
            _nameLabel.text = str;
            if (model.isZiYingFlag == 1){
                _nameLabel.attributedText = [str fky_rightQuestionAttributed];
            }
            _infoLabel.text = [NSString stringWithFormat:@"¥ %.2f",model.freight.doubleValue];
            _infoLabel.textColor = UIColorFromRGB(0xe60012);
        }
            break;
        case PromotionMoneyType:
            if (model.orderFullReductionMoney.floatValue > 0) {
                _nameLabel.text = @"立减";
                _infoLabel.text = [NSString stringWithFormat:@"-¥ %.2f",(model.orderFullReductionMoney.doubleValue)];
                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            }
            break;
        case ReduceMoneyType:
            if (model.orderFullReductionMoney.floatValue > 0) {
                _nameLabel.text = @"优惠抵扣";
                _infoLabel.text = [NSString stringWithFormat:@"-¥ %.2f",(model.orderFullReductionMoney.doubleValue)];
                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            }
            break;
        case ScoreType:
            if (model.orderFullReductionIntegration.floatValue > 0) {
                _nameLabel.text = @"赠商家积分";
                _infoLabel.text = [NSString stringWithFormat:@"%g",model.orderFullReductionIntegration.doubleValue];
                _infoLabel.textColor = UIColorFromRGB(0x333333);
            }
            break;
        case CouponShopType:
            if (model.orderCouponMoney && model.orderCouponMoney.floatValue > 0) {
                _nameLabel.text = @"店铺优惠券";
                _infoLabel.text = [NSString stringWithFormat:@"-¥ %.2f",model.orderCouponMoney.doubleValue];
                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            }
            //            else {
            //                _nameLabel.text = @"店铺优惠券";
            //                _infoLabel.text = @"-¥ 0.00";
            //                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            //            }
            break;
        case BuyMoneyType:
            if (model.shopRechargeMoney && model.shopRechargeMoney.floatValue > 0) {
                _nameLabel.text = @"购物金";
                _infoLabel.text = [NSString stringWithFormat:@"-¥ %.2f",model.shopRechargeMoney.doubleValue];
                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            }
            break;
        case CouponPlatformType:
            if (model.orderPlatformCouponMoney && model.orderPlatformCouponMoney.floatValue > 0) {
                _nameLabel.text = @"平台优惠券";
                _infoLabel.text = [NSString stringWithFormat:@"-¥ %.2f",model.orderPlatformCouponMoney.doubleValue];
                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            }
            //            else {
            //                _nameLabel.text = @"平台优惠券";
            //                _infoLabel.text = @"-¥ 0.00";
            //                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            //            }
            break;
            case RebateShopDeductibleType:
            if (model.useEnterpriseRebateMoney.floatValue>0) {
                _nameLabel.text = @"店铺返利金抵扣";
                _infoLabel.text = [NSString stringWithFormat:@"-¥ %.2f",model.useEnterpriseRebateMoney.doubleValue];
                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            }
            break;
        case RebatePlatformDeductibleType:
            if (model.usePlatformRebateMoney.floatValue>0) {
                _nameLabel.text = @"平台返利金抵扣";
                _infoLabel.text = [NSString stringWithFormat:@"-¥ %.2f",model.usePlatformRebateMoney.doubleValue];
                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            }
            break;
        case RebateObtainType:
            if (model.orderRebateObtainMoney.floatValue>0) {
                _nameLabel.text = @"订单完成后可获返利金";
                _iv.hidden = NO;
                _infoLabel.text = [NSString stringWithFormat:@"+¥ %@",model.orderRebateObtainMoney];
                _infoLabel.textColor = UIColorFromRGB(0xe60012);
            }
            break;
        default:
            break;
    }
}


@end
