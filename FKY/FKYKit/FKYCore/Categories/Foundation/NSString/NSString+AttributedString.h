//
//  NSString+AttributedString.h
//  FKY
//
//  Created by Rabe on 02/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedString)

/**
 在一段文本的右侧添加>箭头图片

 @return 富文本
 */
- (NSMutableAttributedString *)fky_rightArrowAttributed;
- (NSMutableAttributedString *)fky_rightImageAttributedWithImageName:(NSString *)imagename;
- (NSMutableAttributedString *)fky_rightArrowTipsAttributed;
- (NSMutableAttributedString *)fky_homeRightImageAttributedWithImageName:(NSString *)imagename;
/**
 在一段文本的右侧添加?问号图片
 
 @return 富文本
 */
- (NSMutableAttributedString *)fky_rightQuestionAttributed;

/**
 在一段文本的右侧添加▽图片
 
 @return 富文本
 */
- (NSMutableAttributedString *)fky_rightLocationAttributed;

/**
 为一段文本设置行间距

 @param space 行间距
 @return 富文本
 */
- (NSMutableAttributedString *)fky_setupLineSpace:(CGFloat)space;

@end
