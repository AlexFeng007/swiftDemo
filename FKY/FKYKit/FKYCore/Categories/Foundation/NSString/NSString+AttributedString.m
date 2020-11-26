//
//  NSString+AttributedString.m
//  FKY
//
//  Created by Rabe on 02/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "NSString+AttributedString.h"

@implementation NSString (AttributedString)

#pragma mark - Public

- (NSMutableAttributedString *)fky_rightArrowAttributed
{
    return [self fky_rightAttributedWithImageName:@"icon_gray_indicator" andFrame:CGRectMake(0, -FKYWH(5), FKYWH(20), FKYWH(20))];
}
- (NSMutableAttributedString *)fky_rightArrowTipsAttributed
{
    return [self fky_rightAttributedWithImageName:@"icon_yellow_indicator" andFrame:CGRectMake(0, -FKYWH(5), FKYWH(20), FKYWH(20))];
}

- (NSMutableAttributedString *)fky_rightImageAttributedWithImageName:(NSString *)imagename {
    return [self fky_rightAttributedWithImageName:imagename andFrame:CGRectMake(0, -1.25, 12, 12)];
}
- (NSMutableAttributedString *)fky_homeRightImageAttributedWithImageName:(NSString *)imagename{
     return [self fky_rightAttributedWithImageName:imagename andFrame:CGRectMake(0, -3, 12, 12)];
}
- (NSMutableAttributedString *)fky_rightQuestionAttributed
{
    return [self fky_rightAttributedWithImageName:@"cart_rebeat_icon" andFrame:CGRectMake(1, FKYWH(14) -20,20, 20)];
}

- (NSMutableAttributedString *)fky_rightLocationAttributed
{
    return [self fky_rightAttributedWithImageName:@"icon_home_searchbar_location" andFrame:CGRectMake(0, 0, 12, 11)];
}

- (NSMutableAttributedString *)fky_setupLineSpace:(CGFloat)space
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = space;
    NSRange range = NSMakeRange(0, CFStringGetLength((CFStringRef)self));
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:range];
    return attributedString;
}

#pragma mark - Private

// 不再使用~!@
- (NSMutableAttributedString *)fky_rightAttributedWithImageName:(NSString *)imageName
{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self];
    // 添加attach
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 右图片
    attch.image = [UIImage imageNamed:imageName];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -3, 12, 12);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    // 用label的attributedText属性来使用富文本
    return attri;
}

// 图片大小不同，展示的效果会有偏差，故需单独设置bounds
- (NSMutableAttributedString *)fky_rightAttributedWithImageName:(NSString *)imageName andFrame:(CGRect)frame
{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self];
    // 添加attach
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 右图片
    attch.image = [UIImage imageNamed:imageName];
    // 设置图片大小
    attch.bounds = frame;
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    // 用label的attributedText属性来使用富文本
    return attri;
}

@end
