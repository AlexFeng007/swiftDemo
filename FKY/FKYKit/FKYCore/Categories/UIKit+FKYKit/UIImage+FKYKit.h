//
//  UIImage+FKYKit.h
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FKYKit)

/**
 *  根据颜色生成图片
 *
 *  @param color指定颜色
 *
 *  @return UIImage图片对象
 */
+ (UIImage *)FKY_imageWithColor:(UIColor *)color;

+ (UIImage *)FKY_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  根据亮度参数处理图片生成新的图片对象
 *
 *  @param brightness 0.0~1.0
 *
 *  @return 处理好的图片
 */
- (UIImage *)FKY_imageWithBrightness:(CGFloat)brightness;


/**
 *  裁减图片
 *
 */
+ (UIImage *)FKY_imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/** 压缩图片到指定尺寸 */
+ (UIImage *)FKY_imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

// 反转合成图片
+ (UIImage *)FKY_synthesizeImage:(UIImage *)firstImage withImage:(UIImage *)otherImage;

// 旋转image
+ (UIImage *)FKY_image:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end
