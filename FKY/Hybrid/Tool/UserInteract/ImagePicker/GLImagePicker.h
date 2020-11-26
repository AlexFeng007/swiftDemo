//
//  GLImagePicker.h
//  HJ
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickImageMethod)
{
    PickImageMethodShootPictureAllowEdit = 0,//拍摄图片可编辑
    PickImageMethodSelectExistingPictureAllowEdit, //选择现有图片可编辑
    PickImageMethodShootPicture,//拍摄图片不可编辑
    PickImageMethodSelectExistingPicture//选择现有的图片不可编辑
};

typedef void(^PickerDidFinishHandler)(UIImagePickerController *picker, UIImage *image);
typedef void(^PickerCancelHandler)(UIImagePickerController *picker);

@interface GLImagePicker : NSObject

/**
 *  选取照片
 *
 *  @param pickImageMethod  选取方式
 *  @param presentedViewController           目标
 *  @param didFinishHandler 成功
 *  @param cancelHandler    取消
 */
+ (void)pickImageByMethod:(PickImageMethod)pickImageMethod presentedViewController:(UIViewController *)presentedViewController didFinishHandler:(PickerDidFinishHandler)didFinishHandler cancelHandler:(PickerCancelHandler)cancelHandler;

/**
 *  开启扫描扫码
 *
 *  @param view    呈现的视图
 *  @param handler
 *
 *  @return
 */
+ (GLImagePicker *)startReadingInView:(UIView *)view handler:(void(^)(NSString *resultString))handler;

/**
 *  停止扫描二维码
 */
- (void)stopReading;

/**
 *  继续扫描二维码
 */
- (void)resumeReading;

/**
 *  验证相机状态
 */
+ (BOOL)validateCameraWithCompletion:(void(^)(void))completion;

@end
