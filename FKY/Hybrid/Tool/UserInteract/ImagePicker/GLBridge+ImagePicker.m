//
//  GLBridge+ImagePicker.m
//  YYW
//
//  Created by Rabe on 02/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLBridge+ImagePicker.h"
#import "GLImagePicker.h"
#import "UIImage+Resize.h"
#import "FKYShareManage.h"

typedef NS_ENUM(NSUInteger, GLPickType) {
    GLPickTypeCameraAndAlbum = 0, /* <选择拍照或选取图片 */
    GLPickTypeCamera = 1,         /* <选择拍照 */
    GLPickTypeAlbum = 2,          /* <选取图片 */
};

typedef NS_ENUM(NSUInteger, GLEditOption) {
    GLEditOptionNotAllow = 0, /* <不允许用户编辑 */
    GLEditOptionAllow = 1,    /* <允许用户编辑 */
};

@implementation GLBridge (ImagePicker)

#pragma mark - public

/**
 上传图片
 
 gl://pickImage?callid=11111&param={
 "pickType":0,         //pickType 0:让用户选择拍照或选取图片 1:拍照 2:图片
 "allowEdit":0,        //0:读取图片后不允许用户编辑  1:允许
 "uploadUrl":"https://eaifjfe.com",     //网路上传地址
 }
 
 callback({
 "callid":11111,
 "errcode":0,
 "errmsg":"ok",
 "data":{
 "url":"https://wofjef.jpg"  //图片上传成功后返回的链接
 }
 })
 
 */
- (void)pickImage:(GLJsRequest *)request
{
    GLPickType pickType = [[request paramForKey:@"pickType"] integerValue];
    GLEditOption editOption = [[request paramForKey:@"allowEdit"] integerValue];
    [self.viewController.view endEditing:YES];
    __block PickImageMethod pm;
    if (pickType == GLPickTypeCamera) {
        pm = editOption == GLEditOptionAllow ? PickImageMethodShootPictureAllowEdit : PickImageMethodShootPicture;
        [self pickImageWithMethod:pm request:request];
    }
    else if (pickType == GLPickTypeAlbum) {
        pm = editOption == GLEditOptionAllow ? PickImageMethodSelectExistingPictureAllowEdit : PickImageMethodSelectExistingPicture;
        [self pickImageWithMethod:pm request:request];
    }
    else {
        __weak typeof(self) weakself = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择拍照或相册" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           if ([FKYJurisdictionTool getCameraJueiaDiction]) {
                                                               __strong typeof(weakself) self = weakself;
                                                               pm = editOption == GLEditOptionAllow ? PickImageMethodShootPictureAllowEdit : PickImageMethodShootPicture;
                                                               [self pickImageWithMethod:pm request:request];
                                                           }
                                                           
                                                       }];
        UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
                                                          if ([FKYJurisdictionTool getPhotoLibraryJueiaDiction]) {
                                                              __strong typeof(weakself) self = weakself;
                                                              pm = editOption == GLEditOptionAllow ? PickImageMethodSelectExistingPictureAllowEdit : PickImageMethodSelectExistingPicture;
                                                              [self pickImageWithMethod:pm request:request];
                                                          }
                                                          
                                                      }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           NSLog(@"用户取消拍照或选取图片");
                                                       }];
        [alertController addAction:camera];
        [alertController addAction:album];
        [alertController addAction:cancel];
        if (self.viewController.presentedViewController == nil ) {
            //防止模态窗口错误
            [self.viewController presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - private

- (void)pickImageWithMethod:(PickImageMethod)method request:(GLJsRequest *)request
{
    __weak typeof(self) weakself = self;
    [GLImagePicker pickImageByMethod:method
             presentedViewController:self.viewController
                    didFinishHandler:^(UIImagePickerController *picker, UIImage *image) {
                        [picker dismissViewControllerAnimated:YES
                                                   completion:^{
                                                       __strong typeof(weakself) self = weakself;
                                                       [self uploadImage:image request:request];
                                                   }];
                    }
                       cancelHandler:^(UIImagePickerController *picker) {
                           [picker dismissViewControllerAnimated:NO completion:nil];
                       }];
}

- (void)uploadImage:(UIImage *)image request:(GLJsRequest *)request
{
    // 显示loading
    [self.viewController showLoading];
    
    // 子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 压缩图片
        NSData *imgData = [FKYShareManage compressImage:image withMaxLength:1.2];
        // 主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 隐藏loading
            [self.viewController dismissLoading];
            // 判断
            if (!imgData) {
                // 图片压缩失败
                [self.viewController toast:@"图片压缩失败"];
                [self sendResponseToJsWithRequest:request data:nil isSuccess:NO];
            }
            else {
                // 图片压缩成功
                [self requestForUploadImage:imgData request:request];
            }
        });
    });
    
    // 老的上传图片接口
//    NSString *uploadUrl = [request paramForKey:@"uploadUrl"];
//    [[FKYRequestService sharedInstance] uploadIMMessagePicture:image param:nil uploadUrl:uploadUrl completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
//        if (isSucceed) {
//            NSInteger statusCode =  [[response objectForKey:@"statusCode"] integerValue];
//            if (statusCode == 0) {
//                NSString *imgUrl = [[response objectForKey:@"data"] objectForKey:@"imgUrl"];
//                [self sendResponseToJsWithRequest:request data:@{ @"url" : imgUrl } isSuccess:YES];
//            }else{
//                //上传失败
//                NSString *message = [response objectForKey:@"message"];
//                [self.viewController toast:message];
//                [self sendResponseToJsWithRequest:request data:nil isSuccess:NO];
//            }
//        }else{
//            //上传失败
//            if (error == nil) {
//                [self.viewController toast:@"图片压缩失败"];
//            }else{
//                [self.viewController toast:error.localizedDescription];
//            }
//            [self sendResponseToJsWithRequest:request data:nil isSuccess:NO];
//        }
//    }];
}

- (void)sendResponseToJsWithRequest:(GLJsRequest *)request data:(id)data isSuccess:(BOOL)isSuccess
{
    GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:isSuccess ? GLBridgeRespCode_OK : GLBridgeRespCode_WRONG_PARAM data:data];
    [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:request.callbackId];
}


#pragma mark - Request

- (void)requestForUploadImage:(NSData *)imgData request:(GLJsRequest *)request
{
    // 显示loading
    [self.viewController showLoading];
    
    // 入参
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"tag"] = @"yc"; // url二级目录，区分不同应用模块，避免文件被相互覆盖...<可为空>...<若tag为空，默认为common>
    param[@"filename"] = [CredentialsImagePickController createImageName]; // 文件名...<可为空>...<若filename为空，自动生成uuid作为文件名>
    // 上传图片
    @weakify(self);
    [[FKYRequestService sharedInstance] requestForUploadPicWithParam:param image:nil data:imgData completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        @strongify(self);
        // 隐藏loading
        [self.viewController dismissLoading];
        // 失败
        if (!isSucceed) {
            NSString *msg = @"上传失败!";
            if (model && [model isKindOfClass:[NSString class]]) {
                NSString *tip = (NSString *)model;
                if (tip.length > 0) {
                    msg = tip;
                }
            }
            [self.viewController toast:msg];
            [self sendResponseToJsWithRequest:request data:nil isSuccess:NO];
            return;
        }
        // 成功
        NSString *url = @"";
        if (model && [model isKindOfClass:[NSString class]]) {
            NSString *result = (NSString *)model;
            if (result.length > 0) {
                url = result;
            }
        }
        if (url && url.length > 0) {
            // 返回url
            [self sendResponseToJsWithRequest:request data:@{ @"url" : url } isSuccess:YES];
        }
        else {
            // 未返回url
            [self.viewController toast:@"上传失败!"];
            [self sendResponseToJsWithRequest:request data:nil isSuccess:NO];
        }
    }];
}

@end
