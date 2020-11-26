//
//  FKYBlankView.h
//  FKY
//
//  Created by mahui on 15/10/16.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYBlankView : UIView

+ (FKYBlankView *)FKYBlankViewInitWithFrame:(CGRect)frame andImage:(UIImage *)image andTitle:(NSString *)title andSubTitle:(NSString *)subTitle;
- (void)setTitle:(NSString *)title;
- (void)setSubTitle:(NSString *)subtitle;

@end
