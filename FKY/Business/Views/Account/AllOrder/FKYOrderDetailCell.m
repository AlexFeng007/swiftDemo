//
//  FKYOrderDetailCell.m
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderDetailCell.h"
#import <Masonry/Masonry.h>
#import "UIControl+BlocksKit.h"
#import "FKYOrderModel.h"
#import "FKYMoreInfoModel.h"

@interface FKYOrderDetailCell ()

//@property (nonatomic, strong)  UILabel *orderNumLabel;      // 订单号
//@property (nonatomic, strong)  UILabel *statusLabel;        // 订单状态
//@property (nonatomic, strong)  UILabel *dateLabel;          // 下单时间
//@property (nonatomic, strong)  UILabel *salserLabel;        // 销售顾问

@property (nonatomic, strong)  UILabel *titleLabel;         // 标题
@property (nonatomic, strong)  UILabel *orderIdCopyLabel;   // 复制订单编号
@property (nonatomic, strong)  UIButton *moreInfoButton;    // 按钮

@property (nonatomic, assign)  CellType cellType;           //
@property (nonatomic, strong)  NSString *orderId;           // 订单编号

@end


@implementation FKYOrderDetailCell


#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}


#pragma mark - UI

- (void)setUI
{
    //
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-10));
            make.centerY.equalTo(self.contentView);
        }];
        label.font = FKYSystemFont(FKYWH(13));
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textColor = UIColorFromRGB(0x333333);
        label;
    });
    //
    self.orderIdCopyLabel =({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(FKYWH(-10));
            make.centerY.equalTo(self.contentView);
        }];
        label.font = FKYSystemFont(FKYWH(13));
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderIdCopy)];
        [label addGestureRecognizer:tap];
        label;
    });

    // 箭头btn
    self.moreInfoButton = ({
        UIButton *button = [[UIButton alloc] init];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-FKYWH(12));
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@(FKYWH(25)));
        }];
        [button setImage:[UIImage imageNamed:@"icon_account_black_arrow"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            safeBlock(self.moreInfoButtonClickBlock);
        } forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    UITapGestureRecognizer *tapOnBank = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabel)];
    [self.titleLabel addGestureRecognizer:tapOnBank];
}


#pragma mark - Private

- (void)setCopyLable
{
    NSString *str = @"| 复制";
    NSRange rangeA = [str rangeOfString:@"|"];
    NSRange rangeB = [str rangeOfString:@" 复制"];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:str];
    // 4.给每一部分分别设置颜色
    [aStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:rangeA];
    [aStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x3F7FDC) range:rangeB];
    // 5.分别设置字体
    if (rangeA.location != NSNotFound){
         [aStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:13] range:rangeA];
    }
    if (rangeB.location != NSNotFound){
        [aStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13] range:rangeB];
    }
    
    self.orderIdCopyLabel.attributedText = aStr;
}

- (void)orderIdCopy
{
    [[UIPasteboard generalPasteboard] setString:self.orderId];
    [FKYToast showToast:@"复制成功"];
    
    if (self.copyHandler) {
        self.copyHandler();
    }
}

- (void)tapOnLabel
{
    safeBlock(self.tapBlock, self.cellType);
}


#pragma mark - Public

- (void)configCellWithModel:(FKYOrderModel *)model andCellType:(CellType)cellType
{
    //  保存类型
    self.cellType = cellType;
    
    // 重置
    self.titleLabel.userInteractionEnabled = NO;
    self.titleLabel.attributedText = nil;
    self.titleLabel.text = nil;
    self.orderIdCopyLabel.attributedText = nil;
    self.orderIdCopyLabel.text = nil;
    self.moreInfoButton.hidden = YES;
    
    if ([[model getOrderStatus] isEqualToString:@"已取消"] && cellType == OrderStatus) {
        self.moreInfoButton.hidden = YES;
    }
    
    if (cellType == OrderNumber) {
        // 0.订单编号
        self.titleLabel.text = [NSString stringWithFormat:@"订单编号: %@", model.orderId];
        self.orderId = model.orderId;
        [self setCopyLable];
    }
    if (cellType == OrderStatus) {
        // 1.订单状态
        self.titleLabel.text = [NSString stringWithFormat:@"订单状态: %@", [model getOrderStatus]];
    }
    if (cellType == OrderTime) {
        // 2.下单时间
        self.titleLabel.text = [NSString stringWithFormat:@"下单时间: %@",model.createTime];
       // self.lookReturnBtn.hidden = !model.selfHasReturnOrder;
    }
    if (cellType == BankInfo) {
        // 3.银行账户
        self.titleLabel.userInteractionEnabled = YES;
        NSString *title = @"银行账户: 查看商家银行账户";
        NSString *sub = @"查看商家银行账户";
        NSRange rang = [title rangeOfString:sub];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
        [str addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:UIColorFromRGB(0xbf990b)} range:rang];
        self.titleLabel.attributedText = str;
    }
    if (cellType == SellerName) {
        // 销售顾问
        if (model.adviserName && model.adviserName.length > 0) {
            self.titleLabel.text = [NSString stringWithFormat:@"销售顾问: %@  %@", model.adviserName, model.adviserPhoneNumber];
        }
    }
    if (cellType == OtherBHStatus) {
        // 剩余商品补货状态
        self.titleLabel.text = [NSString stringWithFormat:@"部分发货的剩余商品处理状态: 补货"];
    }
    if (cellType == OtherTKStatus) {
        // 剩余商品退款状态
        self.titleLabel.text = [NSString stringWithFormat:@"部分发货的剩余商品处理状态: 退款"];
    }
}

- (void)configCancelCellWithModel:(FKYMoreInfoModel *)model andCellType:(CellType)cellType{
    //  保存类型
       self.cellType = cellType;
       
       // 重置
       self.titleLabel.userInteractionEnabled = NO;
       self.titleLabel.attributedText = nil;
       self.titleLabel.text = nil;
       self.orderIdCopyLabel.attributedText = nil;
       self.orderIdCopyLabel.text = nil;
       self.moreInfoButton.hidden = YES;
      if (cellType == CancelOrderReason) {
          // 1.取消原因
          NSMutableString *cancelReasonStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"取消原因: %@", model.cancelResult]];
          if (model.cancelReasonValue != nil && model.cancelReasonValue.length > 0){
              [cancelReasonStr appendString:[NSString stringWithFormat:@"-%@", model.cancelReasonValue]];
          }
          if (model.otherCancelReason != nil && model.otherCancelReason.length > 0){
              [cancelReasonStr appendString:[NSString stringWithFormat:@"-%@", model.otherCancelReason]];
          }
          self.titleLabel.text = [NSString stringWithFormat:@"%@", cancelReasonStr];
      }
      if (cellType == CancelOrderTime) {
          // 2.取消时间
          self.titleLabel.text = [NSString stringWithFormat:@"取消时间: %@",model.cancelTime];
      }
 
}

@end
