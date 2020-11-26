//
//  FKYUIDefines.m
//  FKY
//
//  Created by yangyouyong on 2016/9/12.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

NSDictionary * FKYFontTuble(UIColor *color, UIFont *font) {
    return @{
             @"color": color,
             @"font": font
             };
}

NSDictionary * FKYBtnStyle(CGFloat width, CGFloat height, UIColor *borderColor,UIColor *textColor, CGFloat fontSize) {
    return  @{
              @"width": @(width),
              @"height": @(height),
              @"borderColor": borderColor,
              @"textColor": textColor,
              @"textFont": FKYSystemFont(fontSize)
              };
}
