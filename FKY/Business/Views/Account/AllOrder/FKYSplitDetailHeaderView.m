//
//  YWSplitDetailHeaderView.m
//  YYW
//
//  Created by Rabe.☀️ on 16/1/11.
//  Copyright © 2016年 YYW. All rights reserved.
//

#import "FKYSplitDetailHeaderView.h"
#import "FKYCopyableLabel.h"
#import "UIControl+BlocksKit.h"
#import <Masonry/Masonry.h>

@interface FKYSplitDetailHeaderView () <HTCopyableLabelDelegate>

@property (nonatomic, strong) UILabel *splitStateLabel;                         // 配送状态
@property (nonatomic, strong) UILabel *splitCarrierLabel;                       // 承运商
@property (nonatomic, strong) FKYCopyableLabel *orderIdLabel;                    // 运单编号
@property (nonatomic, strong) UIButton *copyedButton;
@property (nonatomic, strong) FKYDeliveryHeadModel *headerModel;

@end

@implementation FKYSplitDetailHeaderView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.splitStateLabel];
        [self addSubview:self.splitCarrierLabel];
        [self addSubview:self.orderIdLabel];
        [self addSubview:self.copyedButton];
        
        [self.splitStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.splitCarrierLabel.mas_top).offset(-10);
            make.left.equalTo(self).offset(15);
        }];
        
        [self.splitCarrierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        
        [self.orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.splitCarrierLabel.mas_bottom).offset(10);
            make.left.equalTo(self).offset(15);
        }];
        
        [self.copyedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.orderIdLabel);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, 23));
        }];
    }
    return self;
}

#pragma mark - public

- (void)bindModel:(FKYDeliveryHeadModel *)headerModel
{
    _headerModel = headerModel;
    NSString *testString = STRING_FORMAT(@"配送状态:   %@", _headerModel.status ? _headerModel.status : @"暂无");
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:testString];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, 5)];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFE403B) range:NSMakeRange(6, testString.length-6)];
    self.splitStateLabel.attributedText = attrString;
    
    testString = STRING_FORMAT(@"承运商家:   %@", _headerModel.carrierName ? _headerModel.carrierName : @"暂无");
    attrString = [[NSMutableAttributedString alloc] initWithString:testString];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0, 5)];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(6, testString.length-6)];
    self.splitCarrierLabel.attributedText = attrString;
    
    testString = STRING_FORMAT(@"运单编号:   %@", _headerModel.expressNum ? _headerModel.expressNum : @"暂无");
    attrString = [[NSMutableAttributedString alloc] initWithString:testString];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0, 5)];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(6, testString.length-6)];
    self.orderIdLabel.attributedText = attrString;
    
    self.copyedButton.hidden = !(self.headerModel.expressNum.length);
}

#pragma mark - HTCopyableLabelDelegate

- (NSString *)stringToCopyForCopyableLabel:(FKYCopyableLabel *)copyableLabel
{
//    return _headerModel.orderNumber;
    return @"";
}

#pragma mark - action

#pragma mark - property

- (UILabel *)splitStateLabel
{
    if (_splitStateLabel == nil) {
        _splitStateLabel = [UILabel new];
        _splitStateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _splitStateLabel.font = [UIFont systemFontOfSize:14];
        _splitStateLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _splitStateLabel;
}

- (FKYCopyableLabel *)orderIdLabel
{
    if (_orderIdLabel == nil) {
        _orderIdLabel = [FKYCopyableLabel new];
        _orderIdLabel.font = [UIFont systemFontOfSize:13];
        _orderIdLabel.textColor = UIColorFromRGB(0x666666);
        _orderIdLabel.copyableLabelDelegate = self;
    }
    return _orderIdLabel;
}

- (UILabel *)splitCarrierLabel
{
    if (_splitCarrierLabel == nil) {
        _splitCarrierLabel = [UILabel new];
        _splitCarrierLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _splitCarrierLabel.font = [UIFont systemFontOfSize:13];
        _splitCarrierLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _splitCarrierLabel;
}

- (UIButton *)copyedButton
{
    if (_copyedButton == nil) {
        _copyedButton = [UIButton new];
        [_copyedButton setTitle:@"复制" forState:UIControlStateNormal];
        _copyedButton.hidden = YES;
        [_copyedButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _copyedButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _copyedButton.layer.borderWidth = 0.5;
        _copyedButton.layer.borderColor = UIColorFromRGB(0x979797).CGColor;
        _copyedButton.layer.cornerRadius = 4;
        @weakify(self);
        [_copyedButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.headerModel.expressNum.length > 0) {
                UIPasteboard *pb = [UIPasteboard generalPasteboard];
                [pb setString:self.headerModel.expressNum];
                self.copyBlock();
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyedButton;
}

@end
