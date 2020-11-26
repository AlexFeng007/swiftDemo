//
//  GLImagePicker.m
//  HJ
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "GLImagePicker.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "GLOriginalImageVC.h"
#import "UIImagePickerController+BlocksKit.h"

@interface GLImagePicker () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, copy) void (^handler)(NSString *resultString);

@end

@implementation GLImagePicker

+ (void)pickImageByMethod:(PickImageMethod)pickImageMethod presentedViewController:(UIViewController *)presentedViewController didFinishHandler:(PickerDidFinishHandler)didFinishHandler cancelHandler:(PickerCancelHandler)cancelHandler
{
    if (pickImageMethod == PickImageMethodShootPictureAllowEdit) {
        [self shootPictureWithEdit:YES presentedViewController:presentedViewController didFinishHandler:didFinishHandler cancelHandler:cancelHandler];
    }else if (pickImageMethod == PickImageMethodShootPicture){
        [self shootPictureWithEdit:NO presentedViewController:presentedViewController didFinishHandler:didFinishHandler cancelHandler:cancelHandler];
    }else if (pickImageMethod == PickImageMethodSelectExistingPictureAllowEdit){
        [self selectExistingPictureWithEdit:YES presentedViewController:presentedViewController didFinishHandler:didFinishHandler cancelHandler:cancelHandler];
    }else if(pickImageMethod == PickImageMethodSelectExistingPicture){
        [self selectExistingPictureWithEdit:NO presentedViewController:presentedViewController didFinishHandler:didFinishHandler cancelHandler:cancelHandler];
    }else{
    //
    }
}

+ (void)shootPictureWithEdit:(BOOL)edit presentedViewController:(UIViewController *)presentedViewController didFinishHandler:(PickerDidFinishHandler)didFinishHandler cancelHandler:(PickerCancelHandler)cancelHandler
{
    [GLImagePicker getMediaFromSource:UIImagePickerControllerSourceTypeCamera edit:edit presentedViewController:presentedViewController didFinishHandler:didFinishHandler cancelHandler:cancelHandler];
}

+ (void)selectExistingPictureWithEdit:(BOOL)edit presentedViewController:(UIViewController *)presentedViewController didFinishHandler:(PickerDidFinishHandler)didFinishHandler cancelHandler:(PickerCancelHandler)cancelHandler
{
    [GLImagePicker getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary edit:edit presentedViewController:presentedViewController didFinishHandler:didFinishHandler cancelHandler:cancelHandler];
}

/**
 *  获取图像
 *
 *  @param sourceType 获取途径
 */
+ (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType edit:(BOOL)edit presentedViewController:(UIViewController *)presentedViewController didFinishHandler:(PickerDidFinishHandler)didFinishHandler cancelHandler:(PickerCancelHandler)cancelHandler
{
       NSArray *mediaTypes = @[ (NSString *)kUTTypeImage ];
//    if ([GLImagePicker validateCameraFromSource:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.allowsEditing = edit;
        picker.sourceType = sourceType;
        if (@available(iOS 13.0, *)) {
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [picker setBk_didCancelBlock:^(UIImagePickerController *picker) {
          if (cancelHandler) {
              cancelHandler(picker);
          }
        }];
        [picker setBk_didFinishPickingMediaBlock:^(UIImagePickerController *picker, NSDictionary *info) {
            if (!edit && sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
                GLOriginalImageVC *originalImageVC = [[GLOriginalImageVC alloc]init];
                originalImageVC.originalImageView.image = chosenImage;
                originalImageVC.cancelBtnBlock = ^(void){
                    [picker popViewControllerAnimated:YES];
                };
                originalImageVC.determineBtnBlock = ^(void){
                    if (didFinishHandler) {
                        didFinishHandler(picker, chosenImage);
                    }
                };
                [picker pushViewController:originalImageVC animated:YES];
            }else{
                UIImage *chosenImage;
                if (!edit) {
                    chosenImage= [info objectForKey:UIImagePickerControllerOriginalImage];
                }else{
                    chosenImage= [info objectForKey:UIImagePickerControllerEditedImage];
                }
                if (didFinishHandler) {
                    didFinishHandler(picker, chosenImage);
                }
            }
        }];
        if (presentedViewController.presentedViewController == nil ) {
            //防止模态窗口错误
            [presentedViewController presentViewController:picker animated:YES completion:nil];
        }
    //}
}

/**
 *  验证相机状态
 */
+ (BOOL)validateCameraFromSource:(UIImagePickerControllerSourceType)sourceType
{
    //相机访问被关闭
    BOOL isCameraValid = YES;
    
    if (([UIDevice currentDevice].systemVersion.floatValue >7.0) && (sourceType == UIImagePickerControllerSourceTypeCamera)) { //拍照权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if ((authStatus == AVAuthorizationStatusDenied) || (authStatus == AVAuthorizationStatusRestricted)) {
            isCameraValid = NO;
        }
    }
    NSArray *mediaTypes = @[ (NSString *)kUTTypeImage ]; //相册不需要判断权限，系统会自动提示，这里是获取是否设备支持
    if (![UIImagePickerController isSourceTypeAvailable:sourceType] || ([mediaTypes count] <= 0)) {
        isCameraValid = NO;
    }
    if (!isCameraValid) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"无法打开相机" message:@"请在iPhone的\"设置-通用-访问限制\"选项中,打开你的相机访问权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
    return isCameraValid;
}

+ (GLImagePicker *)startReadingInView:(UIView *)view handler:(void (^)(NSString *resultString))handler
{
    GLImagePicker *imagePicker = [GLImagePicker new];

    //session
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    [captureSession setSessionPreset:AVCaptureSessionPresetHigh];

    //intput
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    [captureSession addInput:input];

    if (!input) {
        return nil;
    }

    //output
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];

    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:imagePicker queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode ]];
    //中间矩形区域实际扫描（y,x,height,width）稍微少一点，防用户呆
    captureMetadataOutput.rectOfInterest = CGRectMake(0.3, 0.2, 0.4, 0.6);

    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:view.layer.bounds];
    [view.layer addSublayer:videoPreviewLayer];

    // Start video capture.
    [captureSession startRunning];

    imagePicker.captureSession = captureSession;
    imagePicker.handler = handler;

    return imagePicker;
}

- (void)stopReading
{
    [self.captureSession stopRunning];
}

- (void)resumeReading
{
    [self.captureSession startRunning];
}

+ (BOOL)validateCameraWithCompletion:(void (^)(void))completion
{
    //相机访问被关闭
    BOOL isCameraValid = YES;
    if (([UIDevice currentDevice].systemVersion.floatValue >7.0)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if ((authStatus == AVAuthorizationStatusDenied) || (authStatus == AVAuthorizationStatusRestricted)) {
            isCameraValid = NO;
        }
    }
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        isCameraValid = NO;
    }
    if (!isCameraValid) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"无法打开相机" message:@"请在iPhone的\"设置-通用-访问限制\"选项中,打开你的相机访问权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
    return isCameraValid;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([metadataObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) { //排除人脸识别
            if (self.handler) {
                self.handler(metadataObj.stringValue);
            }
        }
    }
}

@end
