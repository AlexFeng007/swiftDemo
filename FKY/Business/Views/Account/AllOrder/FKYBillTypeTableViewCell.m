//
//  FKYBillTypeTableViewCell.m
//  FKY
//
//  Created by Andy on 2018/10/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYBillTypeTableViewCell.h"
#import <Masonry/Masonry.h>
#import "FKYOrderModel.h"


@interface FKYBillTypeTableViewCell()

@property (nonatomic, strong)  UIView *bottomView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *infoLabel;
@property (nonatomic, strong)  UIButton *sendMailBtn;
@property (nonatomic, strong)  UIButton *lookBillBtn;
@property (nonatomic, strong) FKYOrderModel *orderModel;

@end


@implementation FKYBillTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(10));
            make.top.equalTo(self.contentView).offset(FKYWH(12));
            make.height.equalTo(@(FKYWH(20)));
            make.width.lessThanOrEqualTo(@(FKYWH(100)));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textColor = UIColorFromRGB(0x333333);
        label;
    });
    _infoLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.height.equalTo(@(FKYWH(20)));
            make.left.equalTo(self.nameLabel.mas_right).offset(FKYWH(13));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textAlignment = NSTextAlignmentRight;
        label;
    });
    
    _sendMailBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"发送邮箱" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        btn.titleLabel.font = FKYSystemFont(FKYWH(13));
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = FKYWH(3);
        btn.layer.borderWidth = FKYWH(1);
        btn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-FKYWH(13));
            make.right.equalTo(self.contentView.mas_right).offset(-FKYWH(10));
            make.size.equalTo(NVFromSizeWH(FKYWH(70), FKYWH(30)));
        }];
        @weakify(self);
        [btn bk_whenTapped:^{
            @strongify(self);
            if (self.clickSendMail) {
                self.clickSendMail();
            }
        }];
        btn;
    });
    _lookBillBtn = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"查看发票" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        btn.titleLabel.font = FKYSystemFont(FKYWH(13));
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = FKYWH(3);
        btn.layer.borderWidth = FKYWH(1);
        btn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.sendMailBtn.mas_centerY);
            make.right.equalTo(self.sendMailBtn.mas_left).offset(-FKYWH(10));
            make.size.equalTo(NVFromSizeWH(FKYWH(70), FKYWH(30)));
        }];
        @weakify(self);
        [btn bk_whenTapped:^{
            @strongify(self);
            if (self.clickLookBillMail) {
                self.clickLookBillMail();
            }
        }];
        btn;
    });
}

- (void)configCellWithModel:(FKYOrderModel *)model
{
    _nameLabel.text = @"发票类型";
    _infoLabel.text = [model getBillType];
    _infoLabel.textColor = UIColorFromRGB(0x666666);
    self.orderModel = model;
    self.sendMailBtn.hidden = true;
    self.lookBillBtn.hidden = true;

    if (self.eleArr&&self.eleArr.count > 0) {
        self.lookBillBtn.hidden = false;
        if (model.isZiYingFlag==1) {
           self.sendMailBtn.hidden = false;
            [self.lookBillBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.sendMailBtn.mas_left).offset(-FKYWH(10));
            }];
        }else{
            [self.lookBillBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.sendMailBtn.mas_left).offset(FKYWH(70));
            }];
        }
    }
}

@end
