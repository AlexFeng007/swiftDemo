//
//  FKYOrderCell.m
//  FKY
//
//  Created by mahui on 15/9/24.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderCell.h"
#import "FKYProductionLabel.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"
#import "FKYOrderModel.h"
#import "FKYOrderProductModel.h"


@interface FKYOrderCell ()

// 顶部视图相关
@property (nonatomic, strong) UIImageView *photoView;               // 供应商图标
@property (nonatomic, strong) FKYProductionLabel *suplyNameLabel;   // 供应商名称
@property (nonatomic, strong) UILabel *statusLable;                 // 订单状态
@property (nonatomic, strong) UILabel *msgLabel;                 // 留言状态
// 打标
@property (nonatomic, strong) UIImageView *huangouIcon;             // 换购图标
@property (nonatomic, strong) UIImageView *yiqigouIcon;             // 一起拼图标
@property (nonatomic, strong) UIImageView *yqgIcon;                 // 一起购图标
@property (nonatomic, strong) UILabel *yiqipinLable;                // 一起拼的提示文描
//@property (nonatomic, strong) UILabel *yiqigouLable;                // 一起购的提示文描
// 商品（图片）
@property (nonatomic, strong) UIImageView *onePic;                  // 商品图片1
@property (nonatomic, strong) UIImageView *twoPic;                  // 商品图片2
@property (nonatomic, strong) UIImageView *threePic;                // 商品图片3
// 底部视图相关
@property (nonatomic, strong) FKYProductionLabel *varietyLabel;     // 品类
@property (nonatomic, strong) FKYProductionLabel *moneyLabel;       // 金额
@property (nonatomic, strong) UIButton *settingBtn;                 // 小能按钮...<联系供应商>

@property (nonatomic, strong) UIButton *deliveryMark;               // 部分发货标识

@property (nonatomic, strong) UIView *mideLine;                     // 上面分隔线
@property (nonatomic, strong) UIView *line;                         // 下面分隔线

@property (nonatomic, strong) FKYOrderModel *model;

@end


@implementation FKYOrderCell

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
    // 顶部分隔线
    self.mideLine = [[UIView alloc] init];
    [self.contentView addSubview:self.mideLine];
    [self.mideLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(FKYWH(12));
        make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-12));
        make.top.equalTo(self.contentView.mas_top).offset(FKYWH(40));
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    self.mideLine.backgroundColor = UIColorFromRGB(0xebedec);
    
    // 供应商图标
    self.photoView = [[UIImageView alloc] init];
    self.photoView.image = [UIImage imageNamed:@"icon_account_shop_image"];
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(FKYWH(12));
        make.top.equalTo(self.contentView.mas_top).offset(FKYWH(12));
        make.width.equalTo(@(FKYWH(16)));
        make.height.equalTo(@(FKYWH(16)));
    }];
    
    // 订单状态
    self.statusLable = [[UILabel alloc] init];
    self.statusLable.font = FKYSystemFont(FKYWH(12));
    self.statusLable.textColor = UIColorFromRGB(0xe60012);
    [self.contentView addSubview:self.statusLable];
    [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-12));
        make.centerY.equalTo(self.photoView);
    }];
    
    
    // 订单状态
    self.msgLabel = [[UILabel alloc] init];
    self.msgLabel.font = FKYSystemFont(FKYWH(12));
    self.msgLabel.text = @"（有卖家留言）";
    self.msgLabel.textColor = UIColorFromRGB(0x3F7FDC);
    [self.contentView addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusLable.mas_left).offset(FKYWH(-2));
        make.centerY.equalTo(self.photoView);
    }];
    // 供应商名称
    self.suplyNameLabel = [[FKYProductionLabel alloc] init];
    self.suplyNameLabel.font = FKYSystemFont(FKYWH(12));
    self.suplyNameLabel.textColor = UIColorFromRGB(0x3f4257);
    [self.contentView addSubview:self.suplyNameLabel];
    [self.suplyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView.mas_right).offset(FKYWH(5));
        make.centerY.equalTo(self.photoView);
        make.trailing.lessThanOrEqualTo(self.statusLable.mas_leading).offset(FKYWH(-46));
    }];
    
    /******************************************************************/
    
    // 换购Icon
    self.huangouIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.huangouIcon];
    [self.huangouIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoView);
        make.left.equalTo(self.suplyNameLabel.mas_right).offset(FKYWH(5));
    }];
    
    // 一起拼Icon
    self.yiqigouIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.yiqigouIcon];
    [self.yiqigouIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoView);
        make.left.equalTo(self.huangouIcon.mas_right).offset(FKYWH(5));
    }];
    
    // 一起购Icon
    self.yqgIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.yqgIcon];
    [self.yqgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoView);
        make.left.equalTo(self.huangouIcon.mas_right).offset(FKYWH(5));
    }];
    
    /******************************************************************/
    
    // 部分发货???
    self.deliveryMark = [[UIButton alloc] init];
    [self.deliveryMark setTitle:@"部分发货" forState:UIControlStateNormal];
    [self.deliveryMark setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.deliveryMark.titleLabel.font = FKYSystemFont(FKYWH(11));
    [self.deliveryMark setBackgroundImage:[UIImage imageNamed:@"icon_delivery_background"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.deliveryMark];
    [self.deliveryMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoView);
        make.height.equalTo(@(FKYWH(20)));
        make.width.equalTo(@(FKYWH(60)));
        if(!self.yiqigouIcon.hidden){
            make.left.equalTo(self.yiqigouIcon.mas_right).offset(FKYWH(5));
        }else{
            make.left.equalTo(self.yqgIcon.mas_right).offset(FKYWH(5));
        }
    }];
    
    // 底部分隔线
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = UIColorFromRGB(0xebedec);
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(FKYWH(12));
        make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-12));
        make.top.equalTo(self.mideLine.mas_bottom).offset(FKYWH(90));
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    
    // 一起拼文描
    self.yiqipinLable = [[UILabel alloc] init];
    self.yiqipinLable.text = @"     1起拼订单成团后发货";
    self.yiqipinLable.textColor=[UIColor colorWithRed:255/255.0 green:42/255.0 blue:89/255.0 alpha:1/1.0];
    self.yiqipinLable.font=[UIFont systemFontOfSize:12];
    self.yiqipinLable.backgroundColor=UIColorFromRGB(0xFFF9F9);;
    [self.contentView addSubview:self.yiqipinLable];
    [self.yiqipinLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(FKYWH(0));
        make.top.equalTo(self.mideLine.mas_top).offset(FKYWH(0));
        make.right.equalTo(self.contentView).offset(FKYWH(0));
        //        make.right.equalTo(self).offset(FKYWH(-10));
        //        make.width.equalTo(@(FKYWH(1000)));
        make.height.equalTo(@(FKYWH(20)));
    }];
    
    //    // 一起购文描
    //    self.yiqigouLable = [[UILabel alloc] init];
    //    self.yiqigouLable.textColor=[UIColor colorWithRed:255/255.0 green:42/255.0 blue:89/255.0 alpha:1/1.0];
    //    self.yiqigouLable.font=[UIFont systemFontOfSize:12];
    //    self.yiqigouLable.backgroundColor=UIColorFromRGB(0xFFF9F9);;
    //    [self.contentView addSubview:self.yiqigouLable];
    //    [self.yiqigouLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.contentView.mas_left).offset(FKYWH(0));
    //        make.top.equalTo(self.mideLine.mas_top).offset(FKYWH(0));
    //        make.right.equalTo(self.contentView).offset(FKYWH(0));
    //        make.height.equalTo(@(FKYWH(20)));
    //    }];
    
    // 商品1
    self.onePic = [UIImageView new];
    [self.contentView addSubview:self.onePic];
    [self.onePic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(FKYWH(12));
        make.top.equalTo((self.yiqipinLable.hidden==YES)?self.mideLine.mas_top:(self.yiqipinLable.mas_bottom)).offset(FKYWH(10));
        //        make.top.equalTo(self.yiqipinLable.hidden==NO?self.yiqipinLable.mas_bottom:self.mideLine.mas_top).offset(FKYWH(10));
        make.bottom.equalTo(self.line.mas_top).offset(FKYWH(-10));
        make.height.equalTo(@(FKYWH(70)));
        make.width.equalTo(@(FKYWH(70)));
    }];
    
    // 商品2
    self.twoPic = [UIImageView new];
    [self.contentView addSubview:self.twoPic];
    [self.twoPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onePic.mas_right).offset(FKYWH(10));
        make.top.bottom.width.equalTo(self.onePic);
    }];
    
    // 商品3
    self.threePic = [UIImageView new];
    [self.contentView addSubview:self.threePic];
    [self.threePic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.twoPic.mas_right).offset(FKYWH(10));
        make.top.bottom.width.equalTo(self.onePic);
    }];
    
    // 金额
    self.moneyLabel = [[FKYProductionLabel alloc] init];
    self.moneyLabel.textAlignment = NSTextAlignmentRight;
    self.moneyLabel.textColor = UIColorFromRGB(0x333333);
    self.moneyLabel.font = FKYSystemFont(FKYWH(12));
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-20));
        make.top.equalTo(self.line.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    // 小能按钮
    [self.contentView addSubview:self.settingBtn];
    self.settingBtn.hidden = YES;
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel);
        make.left.equalTo(self.contentView).offset(FKYWH(14));
        make.width.equalTo(@(FKYWH(70)));
        make.height.equalTo(@(FKYWH(24)));
    }];
}

- (void)configCellWithModel:(FKYOrderModel *)model
{
    if (!model) {
        return;
    }
    
    //    model.xiaoNengId = @"yp_1000_1510897525523";
    self.model = model;
    
    // 初始化cell内容
    self.onePic.image = nil;
    self.twoPic.image = nil;
    self.threePic.image = nil;
    self.huangouIcon.image = nil;
    self.yqgIcon.image=nil;
    self.yiqigouIcon.image=nil;
    
    //    if (model.portionDelivery) {
    //        self.deliveryMark.hidden = NO;
    //    }else{
    //        self.deliveryMark.hidden = YES;
    //    }
    self.deliveryMark.hidden = (model.portionDelivery.integerValue == 0);
    
    // 商品列表
    NSArray *arr = model.productList;
    // 商品1
    FKYOrderProductModel *prodcut = arr.firstObject;
    if (![prodcut.productPicUrl isKindOfClass:[NSNull class]] && prodcut.productPicUrl.length != 0) {
        [self.onePic sd_setImageWithURL:[NSURL URLWithString:[prodcut.productPicUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"image_default_img"]];
    }
    // 商品2
    if (arr.count >= 2) {
        FKYOrderProductModel *two = arr[1];
        if (![two.productPicUrl isKindOfClass:[NSNull class]] && two.productPicUrl.length != 0) {
            [self.twoPic sd_setImageWithURL:[NSURL URLWithString:[two.productPicUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"image_default_img"]];
        }
    }
    // 商品3
    if (arr.count >= 3) {
        FKYOrderProductModel *th = arr[2];
        if (![th.productPicUrl isKindOfClass:[NSNull class]] && th.productPicUrl.length != 0) {
            [self.threePic sd_setImageWithURL:[NSURL URLWithString:[th.productPicUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"image_default_img"]];
        }
    }
    
    // 订单状态
    self.statusLable.text = [model getOrderStatus];
    
    // 供应商
    self.suplyNameLabel.text = [NSString stringWithFormat:@"%@",model.supplyName];
    
    // 是否为换购
    if (model.isHuanGouSonOrder) {
        [self.huangouIcon setImage:[UIImage imageNamed:@"icon_increasePriceGifts"]];
    }
    if (model.hasSellerRemark == 1){
        self.msgLabel.hidden = NO;
    }else{
        self.msgLabel.hidden = YES;
    }
    if (model.orderType.integerValue == 3) { // 一起拼订单
        [self.yiqigouIcon setImage:[UIImage imageNamed:@"icon_yiqipin"]];
        if (model.orderStatus.integerValue == 2) { // 待发货的状态才显示成团发货的文描
            self.yiqipinLable.hidden = NO;
        } else {
            self.yiqipinLable.hidden = YES;
        }
    } else {
        self.yiqipinLable.hidden = YES;
    }
    
    if (model.orderType.integerValue == 1) { // 一起购订单
        [self.yqgIcon setImage:[UIImage imageNamed:@"icon_yiqigou"]];
        [self.suplyNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.lessThanOrEqualTo(self.statusLable.mas_leading).offset(FKYWH(-46));
        }];
    } else {
        [self.suplyNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.lessThanOrEqualTo(self.statusLable.mas_leading).offset(FKYWH(-5));
        }];
    }
    
    
    [self.onePic mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(FKYWH(12));
        make.top.equalTo(self.yiqipinLable.hidden==YES ?self.mideLine.mas_top:(self.yiqipinLable.mas_bottom)).offset(FKYWH(10));
        //        make.top.equalTo(self.yiqipinLable.hidden==NO?self.yiqipinLable.mas_bottom:self.mideLine.mas_top).offset(FKYWH(10));
        make.bottom.equalTo(self.line.mas_top).offset(FKYWH(-10));
        make.height.equalTo(@(FKYWH(70)));
        make.width.equalTo(@(FKYWH(70)));
    }];
    
    // 金额
    self.moneyLabel.text = [NSString stringWithFormat:@"共%@个品种  %@件商品  合计: ¥ %.2f",model.varietyNumber,model.productNumber,model.finalPay.doubleValue];
    
    // 联系客服
    if (model.isSupportIM != nil && model.isSupportIM.integerValue == 0) {
        self.settingBtn.hidden = NO;
    }
    else {
        self.settingBtn.hidden = YES;
    }
}

#pragma mark - property

- (UIButton *)settingBtn
{
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_settingBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xff394e)] forState:UIControlStateNormal];
        [_settingBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xff394e)] forState:UIControlStateHighlighted];
        [_settingBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        _settingBtn.titleLabel.textColor = [UIColor whiteColor];
        _settingBtn.titleLabel.font = FKYSystemFont(FKYWH(12));
        _settingBtn.layer.cornerRadius = 3;
        _settingBtn.layer.masksToBounds = YES;
        @weakify(self);
        [_settingBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.settingBtnBlock) {
                self.settingBtnBlock([NSString stringWithFormat:@"%d",self.model.supplyId]);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}


@end
