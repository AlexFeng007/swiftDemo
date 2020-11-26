//
//  FKYShipeInfoCell.m
//  FKY
//
//  Created by mahui on 15/10/13.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYShipeInfoCell.h"
#import <Masonry/Masonry.h>
#import "FKYOrderModel.h"
#import "FKYPersonModel.h"


@interface FKYShipeInfoCell ()

//@property (nonatomic, strong)  UILabel *telePhoneLabel;
//@property (nonatomic, strong)  UILabel *addressLabel;
//@property (nonatomic, strong)  UILabel *nameLabel;
//@property (nonatomic, strong)  UIImageView *addressIcon;
////@property (nonatomic, strong)  UIImageView *rightIcon;

// V3.7.3需求：新增销售单仓库地址
// 0. top view
@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblPhone;
@property (nonatomic, strong) UILabel *lblAddress;
// 1. bottom view
@property (nonatomic, strong) UIView *viewBottom;
@property (nonatomic, strong) UILabel *lblStockAddress;

@end


@implementation FKYShipeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self setUI];
        [self setupView];
    }
    return self;
}


#pragma mark -

- (void)setupView
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.viewTop];
    [self.contentView addSubview:self.viewBottom];
    
    // 30 + 86
    [self.viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(FKYWH(30+86));
    }];
    
    // 30 + 56
    [self.viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.viewTop.mas_bottom);
    }];
}


/*
- (void)setUI
{
//    self.rightIcon = ({
//        UIImageView *view = [[UIImageView alloc] init];
//        [self.contentView addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-10));
//            make.height.with.equalTo(@(FKYWH(30)));
//        }];
//        view.image = [UIImage imageNamed:@"icon_account_black_arrow"];
//
//        view;
//    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(50));
            make.top.equalTo(self.contentView.mas_top).offset(FKYWH(10));
            make.height.equalTo(@(FKYWH(25)));
        }];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = FKYSystemFont(FKYWH(14));
        label;
    });
    
    self.telePhoneLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-FKYWH(40));
            make.top.equalTo(self.nameLabel);
            make.height.equalTo(@(FKYWH(25)));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textColor = UIColorFromRGB(0x333333);
        label;
    });
    
    self.addressIcon = ({
        UIImageView *view = [[UIImageView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(FKYWH(45));
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(10));
            make.height.with.equalTo(@(FKYWH(30)));
        }];
        view.image = [UIImage imageNamed:@"icon_order_address_gray"];
        view;
    });
    
    self.addressLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.right.equalTo(self.telePhoneLabel.mas_right).offset(-FKYWH(50));
            make.height.equalTo(@(FKYWH(50)));
        }];
        label.numberOfLines = 2;
        label.font = FKYSystemFont(FKYWH(13));
        label.textColor = UIColorFromRGB(0x333333);
        label;
    });
}
*/


#pragma mark - Public

- (void)configCellWithModel:(FKYOrderModel *)infoModel
{
    // 姓名
    self.lblName.text = [NSString stringWithFormat:@"%@",infoModel.address.deliveryName];
    // 地址
    self.lblAddress.text = [NSString stringWithFormat:@"%@",infoModel.address.addressDetail];
    // 手机号
    NSString *contact = nil;
    if ([infoModel.address.deliveryPhone containsString:@"/"]) {
        contact = [infoModel.address.deliveryPhone componentsSeparatedByString:@"/"].firstObject;
    }
    else {
        contact = infoModel.address.deliveryPhone;
    }
    self.lblPhone.text = contact;
    // 仓库地址
    self.lblStockAddress.text = infoModel.address.printAddress;
}


#pragma mark - Property

- (UIView *)viewTop
{
    if (!_viewTop) {
        _viewTop = [UIView new];
        _viewTop.backgroundColor = [UIColor whiteColor];
        
        UILabel *lblTip = [UILabel new];
        lblTip.backgroundColor = [UIColor clearColor];
        lblTip.textAlignment = NSTextAlignmentLeft;
        lblTip.textColor = UIColorFromRGB(0x909090);
        lblTip.font = FKYSystemFont(FKYWH(13));
        lblTip.text = @"收货信息：";
        [_viewTop addSubview:lblTip];
        [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.viewTop).offset(FKYWH(10));
            make.height.mas_equalTo(FKYWH(20));
        }];
        
        UIImageView *imgview = [UIImageView new];
        imgview.image = [UIImage imageNamed:@"icon_order_address_gray"];
        [_viewTop addSubview:imgview];
        [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(28, 28));
            //make.size.mas_equalTo(CGSizeMake(16, 15));
            make.left.equalTo(self.viewTop).offset(FKYWH(5));
            make.centerY.equalTo(self.viewTop).offset(FKYWH(15));
        }];
        
        [_viewTop addSubview:self.lblPhone];
        [_viewTop addSubview:self.lblName];
        [_viewTop addSubview:self.lblAddress];
        
        [self.lblPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewTop).offset(FKYWH(30+5));
            make.right.equalTo(self.viewTop).offset(FKYWH(-10));
            make.height.mas_equalTo(FKYWH(20));
            make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - FKYWH(5) - 28 - FKYWH(5) - FKYWH(85) - FKYWH(10)*2); // 设置最大宽度，避免将姓名挤掉
        }];
        [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewTop).offset(FKYWH(30+5));
            make.left.equalTo(imgview.mas_right).offset(FKYWH(5));
            make.right.equalTo(self.lblPhone.mas_left).offset(FKYWH(-10));
            make.height.mas_equalTo(FKYWH(20));
            //make.width.mas_greaterThanOrEqualTo(FKYWH(80)); // 姓名需有一个最小宽度，以免手机号过长，将其挤掉
        }];
        [self.lblAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblName.mas_bottom).offset(FKYWH(5));
            make.bottom.equalTo(self.viewTop.mas_bottom).offset(FKYWH(-5));
            make.left.equalTo(imgview.mas_right).offset(FKYWH(5));
            make.right.equalTo(self.viewTop).offset(FKYWH(-10));
        }];
    }
    return _viewTop;
}

- (UILabel *)lblName
{
    if (!_lblName) {
        _lblName = [UILabel new];
        _lblName.backgroundColor = [UIColor clearColor];
        _lblName.textAlignment = NSTextAlignmentLeft;
        _lblName.textColor = UIColorFromRGB(0x343434);
        _lblName.font = FKYSystemFont(FKYWH(16));
        
    }
    return _lblName;
}

- (UILabel *)lblPhone
{
    if (!_lblPhone) {
        _lblPhone = [UILabel new];
        _lblPhone.backgroundColor = [UIColor clearColor];
        _lblPhone.textAlignment = NSTextAlignmentRight;
        _lblPhone.textColor = UIColorFromRGB(0x343434);
        _lblPhone.font = FKYSystemFont(FKYWH(16));
        
    }
    return _lblPhone;
}

- (UILabel *)lblAddress
{
    if (!_lblAddress) {
        _lblAddress = [UILabel new];
        _lblAddress.backgroundColor = [UIColor clearColor];
        _lblAddress.textAlignment = NSTextAlignmentLeft;
        _lblAddress.textColor = UIColorFromRGB(0x343434);
        _lblAddress.font = FKYSystemFont(FKYWH(14));
        _lblAddress.numberOfLines = 3;
        _lblAddress.minimumScaleFactor = 0.8;
        _lblAddress.adjustsFontSizeToFitWidth = YES;
    }
    return _lblAddress;
}

- (UIView *)viewBottom
{
    if (!_viewBottom) {
        _viewBottom = [UIView new];
        _viewBottom.backgroundColor = [UIColor whiteColor];
        
        UILabel *lblTip = [UILabel new];
        lblTip.backgroundColor = [UIColor clearColor];
        lblTip.textAlignment = NSTextAlignmentLeft;
        lblTip.textColor = UIColorFromRGB(0x909090);
        lblTip.font = FKYSystemFont(FKYWH(13));
        lblTip.text = @"销售单上打印的仓库地址：";
        [_viewBottom addSubview:lblTip];
        [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.viewBottom).offset(FKYWH(10));
            make.height.mas_equalTo(FKYWH(20));
        }];
        
        UIImageView *imgview = [UIImageView new];
        imgview.image = [UIImage imageNamed:@"img_stock_address"];
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        [_viewBottom addSubview:imgview];
        [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.size.mas_equalTo(CGSizeMake(30, 30));
            make.size.mas_equalTo(CGSizeMake(16, 15));
            make.left.equalTo(self.viewBottom).offset(FKYWH(10));
            make.centerY.equalTo(self.viewBottom).offset(FKYWH(15));
        }];
        
        // 分隔线
        UIView *viewLine = [UIView new];
        viewLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
        [_viewBottom addSubview:viewLine];
        [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.viewBottom);
            make.left.equalTo(self.viewBottom).offset(FKYWH(10));
            make.height.equalTo(@0.5);
        }];
        
        [_viewBottom addSubview:self.lblStockAddress];
        [self.lblStockAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblTip.mas_bottom).offset(FKYWH(5));
            make.bottom.equalTo(self.viewBottom.mas_bottom).offset(FKYWH(-5));
            make.left.equalTo(imgview.mas_right).offset(FKYWH(10));
            make.right.equalTo(self.viewBottom).offset(FKYWH(-10));
        }];
    }
    return _viewBottom;
}

- (UILabel *)lblStockAddress
{
    if (!_lblStockAddress) {
        _lblStockAddress = [UILabel new];
        _lblStockAddress.backgroundColor = [UIColor clearColor];
        _lblStockAddress.textAlignment = NSTextAlignmentLeft;
        _lblStockAddress.textColor = UIColorFromRGB(0x343434);
        _lblStockAddress.font = FKYSystemFont(FKYWH(14));
        _lblStockAddress.numberOfLines = 3;
        _lblStockAddress.minimumScaleFactor = 0.8;
        _lblStockAddress.adjustsFontSizeToFitWidth = YES;
    }
    return _lblStockAddress;
}


@end
