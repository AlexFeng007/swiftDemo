//
//  UIImage+FKYKit.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "UIImage+FKYKit.h"

@implementation UIImage (FKYKit)

+ (UIImage *)FKY_imageWithColor:(UIColor *)color {
    CGSize size = CGSizeMake(1.0f, 1.0f);
    return [self FKY_imageWithColor:color size:size];
}

+ (UIImage *)FKY_imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)FKY_imageWithBrightness:(CGFloat)brightness{
    
    CIImage *aCIImage = [CIImage imageWithCGImage:self.CGImage];
    //CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues: @"inputImage", aCIImage, nil];
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputBrightness"];
    CIImage *outputImage = [filter outputImage];
    /*
     CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
     UIImage *newImage = [UIImage imageWithCGImage:cgimg];
     */
    UIImage *newImage = [UIImage imageWithCIImage:outputImage scale:self.scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)FKY_imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

- (UIImage *)FKY_imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

+ (UIImage *)FKY_imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)FKY_synthesizeImage:(UIImage *)firstImage withImage:(UIImage *)otherImage {
    CGSize size= CGSizeMake(firstImage.size.width + otherImage.size.width,firstImage.size.height);
    UIGraphicsBeginImageContext(size);
    // Draw image2
    [otherImage drawInRect:CGRectMake(firstImage.size.width, 0, otherImage.size.width, otherImage.size.height)];
    
    // Draw image1
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

// 当前方法有问题...<旋转方向后图片变模糊>
+ (UIImage *)FKY_image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


@end
