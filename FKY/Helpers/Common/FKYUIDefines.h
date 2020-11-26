//
//  FKYUIDefines.h
//  FKY
//
//  Created by yangyouyong on 2016/9/12.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#ifndef __FKY_UI_Defines_h__
#define __FKY_UI_Defines_h__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FKYDefines.h"


FOUNDATION_EXTERN NSDictionary * FKYFontTuble(UIColor *color, UIFont *font);
FOUNDATION_EXTERN NSDictionary * FKYBtnStyle(CGFloat width, CGFloat height, UIColor *borderColor,UIColor *textColor, CGFloat fontSize);


#pragma mark- Button

#define BTN1 \
    FKYBtnStyle(FKYWH(155), FKYWH(42), UIColorFromRGB(0xfe5050), UIColorFromRGB(0xffffff), FKYWH(16))
#define BTN11 \
    FKYBtnStyle(FKYWH(80), FKYWH(28), UIColorFromRGB(0xd5d9da), UIColorFromRGB(0xe60012), FKYWH(12))
#define BTN14 \
    FKYBtnStyle(FKYWH(117), FKYWH(43), UIColorFromRGB(0xfe5050), UIColorFromRGB(0xffffff), FKYWH(16))
#define BTN16 \
    FKYBtnStyle(FKYWH(335), FKYWH(42), UIColorFromRGB(0xfe5050), UIColorFromRGB(0xffffff), FKYWH(16))
#define BTN17 \
    FKYBtnStyle(FKYWH(154), FKYWH(42), UIColorFromRGB(0xd5d9da), UIColorFromRGB(0xe60012), FKYWH(16))
#define BTN18 \
    FKYBtnStyle(FKYWH(90), FKYWH(30), UIColorFromRGB(0xd5d9da), UIColorFromRGB(0xe60012), FKYWH(13))

#pragma mark- Font

#define T9 \
    FKYFontTuble(UIColorFromRGB(0x333333),FKYSystemFont(FKYWH(13)))
#define T901 \
FKYFontTuble(UIColorFromRGB(0x333333),FKYSystemFont(FKYWH(11)))

#define T10 \
    FKYFontTuble(UIColorFromRGB(0x666666),FKYSystemFont(FKYWH(13)))
#define T101 \
FKYFontTuble(UIColorFromRGB(0x666666),FKYSystemFont(FKYWH(11)))

#define T11 \
    FKYFontTuble(UIColorFromRGB(0x999999),FKYSystemFont(FKYWH(12)))
#define T19 \
    FKYFontTuble(UIColorFromRGB(0xe60012),FKYSystemFont(FKYWH(14)))
#define T22 \
    FKYFontTuble(UIColorFromRGB(0x3f4257),FKYSystemFont(FKYWH(12)))
#define T23 \
    FKYFontTuble(UIColorFromRGB(0x999999),FKYSystemFont(FKYWH(14)))

#define T31 \
FKYFontTuble(UIColorFromRGB(0x333333),FKYSystemFont(FKYWH(12)))
#define T32 \
FKYFontTuble(UIColorFromRGB(0xe60012),FKYSystemFont(FKYWH(12)))

#define T35 \
    FKYFontTuble(UIColorFromRGB(0x333333),FKYSystemFont(FKYWH(15)))
#define T36 \
    FKYFontTuble(UIColorFromRGB(0x333333),FKYSystemFont(FKYWH(14)))

#define T37 \
FKYFontTuble(UIColorFromRGB(0xFE5050),FKYSystemFont(FKYWH(12)))


#define T40 \
FKYFontTuble(UIColorFromRGB(0x707070),FKYSystemFont(FKYWH(11)))

#define T41 \
FKYFontTuble(UIColorFromRGB(0x666666),FKYSystemFont(FKYWH(12)))

#define T42 \
FKYFontTuble(UIColorFromRGB(0x999999),FKYSystemFont(FKYWH(14)))

#define T43 \
FKYFontTuble(UIColorFromRGB(0xE8772A),FKYSystemFont(FKYWH(12)))

#endif
