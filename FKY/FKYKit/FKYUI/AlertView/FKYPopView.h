//
//  FKYPopView.h
//  FKY
//
//  Created by yangyouyong on 15/9/29.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN CGFloat FKYPopViewEdgesTop;
FOUNDATION_EXTERN CGFloat FKYPopViewEdgesLeft;
FOUNDATION_EXTERN CGFloat FKYPopViewEdgesRight;
FOUNDATION_EXTERN CGFloat FKYPopViewCornerRadius;

@interface FKYPopView : UIView {
@protected
    UIView *_forgroundView;
    UILabel *_titleLabel;
}

@property (nonatomic, copy) NSString *title;

- (void)show;

- (void)dismiss;

- (void)fky_layoutSubviews;

@end
