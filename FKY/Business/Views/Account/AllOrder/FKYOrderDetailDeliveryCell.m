//
//  FKYOrderDetailMoreInfoCell.m
//  FKY
//
//  Created by mahui on 15/11/21.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderDetailDeliveryCell.h"
#import <Masonry/Masonry.h>
#import "FKYOrderModel.h"


@interface FKYOrderDetailDeliveryCell ()

@property (nonatomic, strong)  UIView *bottomView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *infoLabel;
@property (nonatomic, strong)  UIImageView *rightIcon;


@end

@implementation FKYOrderDetailDeliveryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_setupUI];
    }
    return  self;
}

- (void)p_setupUI{
    
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
            make.width.lessThanOrEqualTo(@(FKYWH(100)));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textColor = UIColorFromRGB(0x333333);
        label;
    });
    _rightIcon = ({
        UIImageView *icon = [[UIImageView alloc] init];
        [self.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-10));
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@(FKYWH(16)));
        }];
        icon.image = [UIImage imageNamed:@"icon_account_black_arrow"];
        icon;
    });
    
    _infoLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(FKYWH(100)));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.rightIcon.mas_left).offset(-FKYWH(5));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textAlignment = NSTextAlignmentRight;
        label;
    });
}


- (void)configCellWithModel:(FKYOrderModel *)model{
    _nameLabel.hidden = NO;
    _infoLabel.hidden = NO;
    _nameLabel.text = @"物流方式";
    _infoLabel.text = [model getDeliveryMethod];
    _infoLabel.textAlignment = NSTextAlignmentLeft;
    _infoLabel.textColor = UIColorFromRGB(0x666666);
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(FKYWH(13));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(FKYWH(100)));
    }];
}

- (void)configGiftCellWithModel:(FKYOrderModel *)model{
    _nameLabel.hidden = NO;
    _infoLabel.hidden = NO;
    _nameLabel.text = @"赠品";
    _infoLabel.text = model.orderPromotionGift;
    if ([model.orderPromotionGift isEqual:[NSNull null]] || model.orderPromotionGift.length <= 0) {
        _nameLabel.text = @"";
    }
    _infoLabel.textAlignment = NSTextAlignmentRight;
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(FKYWH(100)));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.rightIcon.mas_left).offset(-FKYWH(5));
    }];
}
//防止重用
- (void)hideAllLabel{
    _nameLabel.hidden = YES;
    _infoLabel.hidden = YES;
}
- (void)showArraw:(BOOL)showFlag
{
    self.rightIcon.hidden = !showFlag;
}

@end
