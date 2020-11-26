//
//  FKYUserHandleToast.m
//  FKY
//
//  Created by airWen on 2017/8/14.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYUserHandleToast.h"
#import <Masonry/Masonry.h>


@interface FKYUserHandleToast ()

@property (nonatomic, strong) UIControl *controlTouchMask;
@property (nonatomic, strong) FKYTipsUIView *lblTostContent;

@end


@implementation FKYUserHandleToast

- (instancetype)initWithFrame:(CGRect)frame WithShopName:(NSString *)shopName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIControl *control = [UIControl new];
        [control setBackgroundColor:[UIColor clearColor]];
        [control addTarget:self action:@selector(onControlTouchMask:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.controlTouchMask = control;
        
        NSString *strTips = @"该商品存在效期低于9个月的批次";
        
        FKYTipsUIView *viewTips  = [[FKYTipsUIView alloc] initWithFrame:CGRectZero];
        viewTips.layer.cornerRadius = 8;
        viewTips.layer.masksToBounds = YES;
        [viewTips setTipsContent:strTips font:[UIFont systemFontOfSize:FKYWH(13)] numberOfLines:0 backgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0] textColor:[UIColor whiteColor] egdeMargin:FKYWH(10)];
        [self addSubview:viewTips];
        [viewTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(self.mas_width).offset(-FKYWH(90));
        }];
        self.lblTostContent = viewTips;
    }
    return self;
}

- (void)setContentBackgroundColor:(UIColor *)bgColor
{
    [self.lblTostContent setBackgroundColor:bgColor];
}

+ (void)showInView:(UIView *)superView withShopName:(NSString *)shopName animationCompletion:(void (^ __nullable)(BOOL finished))completion
{
    FKYUserHandleToast *toast = [[FKYUserHandleToast alloc] initWithFrame:CGRectZero WithShopName:shopName];
    [superView addSubview:toast];
    [toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    [superView bringSubviewToFront:toast];
    
    [UIView animateWithDuration:0.3 animations:^{
        [toast setContentBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.88]];
    } completion:completion];
}

#pragma mark - User Action
- (void)onControlTouchMask:(id)sender
{
    @weakify(self);
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self);
        [self setContentBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
