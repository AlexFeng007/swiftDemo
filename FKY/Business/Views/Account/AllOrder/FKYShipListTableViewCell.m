//
//  FKYShipListTableViewCell.m
//  FKY
//
//  Created by hui on 2019/7/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

#import "FKYShipListTableViewCell.h"

@interface FKYShipListTableViewCell()
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UIButton *shopListBtn;
@end
@implementation FKYShipListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI
{
    _nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"电子随货同行单";
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(10));
            make.top.equalTo(self.contentView).offset(FKYWH(12));
            make.height.equalTo(@(FKYWH(20)));
            make.width.lessThanOrEqualTo(@(FKYWH(100)));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textColor = UIColorFromRGB(0x333333);
        label;
    });
    
    _shopListBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"查看详情" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        btn.titleLabel.font = FKYSystemFont(FKYWH(13));
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = FKYWH(3);
        btn.layer.borderWidth = FKYWH(1);
        btn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-FKYWH(10));
            make.size.equalTo(NVFromSizeWH(FKYWH(70), FKYWH(30)));
        }];
        @weakify(self);
        [btn bk_whenTapped:^{
            @strongify(self);
            if (self.clickShopListBtn) {
                self.clickShopListBtn();
            }
        }];
        btn;
    });
}
@end
