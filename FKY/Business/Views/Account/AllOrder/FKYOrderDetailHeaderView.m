//
//  FKYOrderDetailHeaderView.m
//  FKY
//
//  Created by mahui on 15/9/28.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYOrderDetailHeaderView.h"
#import "FKYProductionLabel.h"
#import <Masonry/Masonry.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import "FKYOrderProductModel.h"
#import "FKYOrderModel.h"
#import <YYText/YYText.h>

@interface FKYOrderDetailHeaderView ()

@property (nonatomic, strong)  UIImageView *iconView;   // 供应商图标
@property (nonatomic, strong)  UILabel *nameLabel;      // 供应商名称
@property (nonatomic, strong)  UILabel *remarkLabel;    // 备注

@property (nonatomic, strong)  UIView *bottomView;      // 底部分隔线
@property (nonatomic, strong)  UIView *lineOne;         // 分隔线
@property (nonatomic, strong)  UIView *lineTwo;         // 分隔线
@property (nonatomic, strong)  UIView *lineThree;       // 分隔线
@property (nonatomic, strong)  YYLabel *contactLabel;   // 联系方式
@property (nonatomic, strong)  YYLabel *bdLabel;        // 招商经理

@end


@implementation FKYOrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    // 底部分隔线
    self.bottomView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    // 图标
    self.iconView = ({
        UIImageView *view = [UIImageView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.top.equalTo(self.mas_top).offset(FKYWH(10));
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        view.image = [UIImage imageNamed:@"icon_account_shop_image"];
        view;
    });
    // 名称
    self.nameLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(FKYWH(10));
            make.centerY.equalTo(self.iconView);
            make.right.equalTo(self.mas_right).offset(-FKYWH(10));
            make.width.lessThanOrEqualTo(@(FKYWH(200)));
        }];
        label.font = FKYSystemFont(FKYWH(14));
        label.textColor = UIColorFromRGB(0x333333);
        label;
    });

    // 分隔线
    self.lineOne = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(FKYWH(44));
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    
    // 联系方式
    self.contactLabel = ({
        YYLabel * label = [YYLabel new];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = FKYSystemFont(12);
        label.textColor = UIColorFromRGB(0x333333);
        label.text = @"联系方式：";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineOne.mas_bottom);
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.height.equalTo(@(FKYWH(43.5)));
        }];
        label;
    });
    
    // 分隔线
    self.lineTwo = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineOne.mas_bottom).offset(FKYWH(44));
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
    
    // 备注
    self.remarkLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(FKYWH(12));
            make.right.equalTo(self.mas_right).offset(-FKYWH(12));
            make.top.equalTo(self.lineTwo.mas_bottom);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        label.font = FKYSystemFont(12);
        label.textColor = UIColorFromRGB(0x333333);
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label;
    });
    
    // 分隔线
    self.lineThree = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineTwo.mas_bottom).offset(FKYWH(44));
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.height.equalTo(@(FKYWH(0.5)));
        }];
        view.backgroundColor = UIColorFromRGB(0xebedec);
        view;
    });
}

- (void)setValueWithDetailModel:(FKYOrderModel *)detailModel
{
    NSInteger integer = 0;
    CGFloat total = 0;
    for (FKYOrderProductModel *model in detailModel.productList) {
        integer += model.quantity.integerValue;
        total += (model.productPrice.floatValue * model.quantity.floatValue);
    }
    if ([detailModel.supplyName isKindOfClass:[NSNull class]]) {
        detailModel.supplyName = @"";
    }

    self.nameLabel.text = detailModel.supplyName;
  
    CGFloat imageHeight = 14;
    NSMutableAttributedString *mobileText = [NSMutableAttributedString new];
     @weakify(self);
    if (detailModel.enterpriseTelephone && detailModel.enterpriseTelephone.length > 0) {
        UIImage *image = [UIImage imageNamed:@"enterpriseTelephone"];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(image.size.width/image.size.height*imageHeight, imageHeight) alignToFont:FKYSystemFont(12) alignment:YYTextVerticalAlignmentCenter];
        [mobileText appendAttributedString:attachText];
        
        [mobileText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
        
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:detailModel.enterpriseTelephone];
        one.yy_font = FKYSystemFont(12);
        one.yy_underlineStyle = NSUnderlineStyleSingle;
        
        [one yy_setTextHighlightRange:one.yy_rangeOfAll
                                color:UIColorFromRGB(0x3F7FDC)
                      backgroundColor:UIColorFromRGB(0xebedec)
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
            @strongify(self);
            if (self.contactBlock) {
                self.contactBlock(@"联系客服", @"1");
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",detailModel.enterpriseTelephone];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            UIViewController * viewC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [viewC.view addSubview:callWebview];
        }];
        
        [mobileText appendAttributedString:one];
    }
    NSMutableAttributedString *phoneText = [NSMutableAttributedString new];
    if (detailModel.enterpriseCellphone && detailModel.enterpriseCellphone.length > 0) {
        UIImage *image = [UIImage imageNamed:@"enterpriseCellphone"];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(image.size.width/image.size.height*imageHeight, imageHeight) alignToFont:FKYSystemFont(12) alignment:YYTextVerticalAlignmentCenter];
        [phoneText appendAttributedString:attachText];
        
        [phoneText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
        
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:detailModel.enterpriseCellphone];
        one.yy_font = FKYSystemFont(12);
        one.yy_underlineStyle = NSUnderlineStyleSingle;
        [one yy_setTextHighlightRange:one.yy_rangeOfAll
                                color:UIColorFromRGB(0x3F7FDC)
                      backgroundColor:UIColorFromRGB(0xebedec)
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
            @strongify(self);
            if (self.contactBlock) {
                self.contactBlock(@"联系客服", @"1");
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",detailModel.enterpriseCellphone];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            UIViewController * viewC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [viewC.view addSubview:callWebview];
        }];
        
        [phoneText appendAttributedString:one];
    }
    NSMutableAttributedString *contactText = [NSMutableAttributedString new];
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"联系方式："];
        one.yy_font = FKYSystemFont(12);
        one.yy_color = UIColorFromRGB(0x333333);
        [contactText appendAttributedString:one];
    }
    if (detailModel.enterpriseTelephone &&
        detailModel.enterpriseCellphone &&
        detailModel.enterpriseTelephone.length > 0 &&
        detailModel.enterpriseCellphone.length > 0) {
        
        [contactText appendAttributedString:mobileText];
        [contactText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  "]];
        [contactText appendAttributedString:phoneText];
    } else if (detailModel.enterpriseTelephone &&
               detailModel.enterpriseTelephone.length > 0 &&
               (!detailModel.enterpriseCellphone || detailModel.enterpriseCellphone.length <= 0)) {
        
        [contactText appendAttributedString:mobileText];
    } else if (detailModel.enterpriseCellphone &&
               detailModel.enterpriseCellphone.length > 0 &&
               (!detailModel.enterpriseTelephone || detailModel.enterpriseTelephone.length <= 0)) {
        
        [contactText appendAttributedString:phoneText];
    }
    self.contactLabel.attributedText = contactText;
    if ((detailModel.enterpriseCellphone && detailModel.enterpriseCellphone.length > 0)||(detailModel.enterpriseTelephone && detailModel.enterpriseTelephone.length > 0)){
        self.lineOne.hidden = NO;
        self.contactLabel.hidden = NO;
        [self.contactLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineOne.mas_bottom);
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.height.equalTo(@(FKYWH(43.5)));
        }];
        [self.lineTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineOne.mas_bottom).offset(FKYWH(44));
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.height.equalTo(@(FKYWH(0.5)));
        }];
    }else{
        self.lineOne.hidden = YES;
        self.contactLabel.hidden = YES;
        [self.contactLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.width.offset(0);
        }];
        [self.lineTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(FKYWH(44));
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.height.equalTo(@(FKYWH(0.5)));
        }];
    }
    if (detailModel && detailModel.leaveMsg && detailModel.leaveMsg.length > 0) {
        self.remarkLabel.hidden = NO;
    }else{
        self.remarkLabel.hidden = YES;
    }
    self.remarkLabel.attributedText = ({
        NSString *remark = @"";
        if (detailModel && detailModel.leaveMsg && detailModel.leaveMsg.length > 0) {
            remark = detailModel.leaveMsg;
            
            self.lineTwo.hidden = NO;
            [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(FKYWH(12));
                make.right.equalTo(self.mas_right).offset(-FKYWH(12));
                make.top.equalTo(self.lineTwo.mas_bottom);
                make.bottom.equalTo(self.bottomView.mas_top);
            }];
        }else{
             self.lineTwo.hidden = YES;
            [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
                make.width.offset(0);
            }];
        }
        NSString *message = [NSString stringWithFormat:@"留言: %@", remark];
        NSValue *rang = [NSValue valueWithRange:NSMakeRange(0, 2)];
        NSAttributedString *string = FKYAttributedStringForStringAndRangesOfSubString(message, FKYWH(12), UIColorFromRGB(0x999999), @[rang], FKYWH(12), UIColorFromRGB(0x333333));
        string;
    });
    
    if (detailModel.bdPhone &&
        detailModel.bdName &&
        detailModel.bdPhone.length > 0 &&
        detailModel.bdName.length > 0) {
        [self addDBViewWithName:detailModel];
    }else{
         self.lineThree.hidden = YES;
    }
}

- (void)addDBViewWithName:(FKYOrderModel *)detailModel {
    // 招商经理
    self.bdLabel = ({
        YYLabel * label = [YYLabel new];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineTwo.mas_bottom);
            make.left.equalTo(self.mas_left).offset(FKYWH(10));
            make.right.equalTo(self.mas_right).offset(FKYWH(-10));
            make.height.equalTo(@(FKYWH(43.5)));
        }];
        label;
    });
    if (detailModel && detailModel.leaveMsg && detailModel.leaveMsg.length > 0){
        self.lineThree.hidden = NO;
        self.lineTwo.hidden = NO;
        [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineThree.mas_bottom);
            make.left.equalTo(self.mas_left).offset(FKYWH(12));
            make.right.equalTo(self.mas_right).offset(-FKYWH(12));
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
    }else{
        self.lineTwo.hidden = NO;
        self.lineThree.hidden = YES;
    }
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    {
        NSString * str = [NSString stringWithFormat:@"1号药城招商经理：%@ ", detailModel.bdName];
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
        one.yy_font = FKYSystemFont(12);
        one.yy_color = UIColorFromRGB(0x333333);
        [text appendAttributedString:one];
    }
    {
        @weakify(self);
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:detailModel.bdPhone];
        one.yy_font = FKYSystemFont(12);
        one.yy_underlineStyle = NSUnderlineStyleSingle;
        [one yy_setTextHighlightRange:one.yy_rangeOfAll
                                color:UIColorFromRGB(0x3F7FDC)
                      backgroundColor:UIColorFromRGB(0xebedec)
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
            @strongify(self);
            if (self.contactBlock) {
                self.contactBlock(@"联系BD", @"2");
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",detailModel.bdPhone];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            UIViewController * viewC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [viewC.view addSubview:callWebview];
        }];
        
        [text appendAttributedString:one];
    }

    self.bdLabel.attributedText = text;
}

+ (float)configHeightWithDetailModel:(FKYOrderModel *)detailModel{
    float headerHeight = FKYWH(44.0);
    if (detailModel && detailModel.leaveMsg && detailModel.leaveMsg.length > 0) {
        NSString *message = [NSString stringWithFormat:@"留言: %@", detailModel.leaveMsg];
        CGSize msgSize =  [message sizeWithFont:FKYSystemFont(12) constrainedToWidth:SCREEN_WIDTH - FKYWH(20)];
        headerHeight += msgSize.height + FKYWH(32);
    }
    if ((detailModel.enterpriseCellphone && detailModel.enterpriseCellphone.length > 0)||(detailModel.enterpriseTelephone && detailModel.enterpriseTelephone.length > 0)){
        headerHeight += FKYWH(44.0);
    }
    if (detailModel.bdName && detailModel.bdName.length > 0 && detailModel.bdPhone && detailModel.bdPhone.length > 0){
        headerHeight += FKYWH(44.0);
    }
    return headerHeight ;
}

@end
