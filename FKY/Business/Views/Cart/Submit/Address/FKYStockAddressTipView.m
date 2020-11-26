//
//  FKYStockAddressTipView.m
//  FKY
//
//  Created by 夏志勇 on 2017/11/3.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYStockAddressTipView.h"
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "FKYShowSaleInfoViewController.h"


@interface FKYStockAddressTipView ()

@property (nonatomic, strong) YYLabel *lblTip;  

@end


@implementation FKYStockAddressTipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


#pragma mark - SetupView

- (void)setupView
{
    self.backgroundColor = UIColorFromRGB(0xFFF6E7);
    
    [self addSubview:self.lblTip];
    [self.lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(5);
        make.bottom.right.equalTo(self).offset(-5);
    }];
}


#pragma mark - Private

// 跳转到销售单示例界面
- (void)showSaleInfo
{
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShowSaleInfoViewController)
                                   setProperty:^(FKYShowSaleInfoViewController *destinationViewController) {
                                       //
                                   }];
}


#pragma mark - Property

- (YYLabel *)lblTip
{
    if (!_lblTip) {
        // 提示文字
        NSString *before = @"如果收货地址和销售单上打印的仓库地址不一致，请编辑收货信息单独维护销售单上打印的仓库地址。";
        NSString *after = @"查看销售单示例";
        NSString *tip = [NSString stringWithFormat:@"%@        %@", before, after];
        // 设置内容及样式
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:tip];
        strAttr.yy_font = FKYSystemFont(FKYWH(13));
        strAttr.yy_backgroundColor = [UIColor clearColor];
        strAttr.yy_color = UIColorFromRGB(0xB37B31);
        strAttr.yy_lineSpacing = FKYWH(5);  // 行间距
        //strAttr.yy_kern = [NSNumber numberWithFloat:1.0]; // 字间距
        [strAttr yy_setUnderlineColor:UIColorFromRGB(0x4192EB) range:NSMakeRange(tip.length-after.length, after.length)];
        [strAttr yy_setUnderlineStyle:NSUnderlineStyleSingle range:NSMakeRange(tip.length-after.length, after.length)];
        @weakify(self);
        [strAttr yy_setTextHighlightRange:NSMakeRange(tip.length-after.length, after.length)
                                    color:UIColorFromRGB(0x4192EB)
                          backgroundColor:[UIColor colorWithWhite:.0 alpha:0.2]
                                tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                    @strongify(self);
                                    // 点击超链接
                                    [self showSaleInfo];
                                }];
        
        // 查看销售单示例
        _lblTip = [YYLabel new];
        _lblTip.backgroundColor = [UIColor clearColor];
        _lblTip.textAlignment = NSTextAlignmentLeft;
        _lblTip.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _lblTip.numberOfLines = 0;
        _lblTip.attributedText = strAttr;
    }
    return _lblTip;
}


@end
