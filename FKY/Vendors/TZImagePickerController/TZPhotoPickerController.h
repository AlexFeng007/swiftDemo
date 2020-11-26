//
//  TZPhotoPickerController.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//  当前类型(eg:相机胶卷)下的所有相片列表

#import <UIKit/UIKit.h>

@class TZAlbumModel;
@interface TZPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) TZAlbumModel *model;
@end


@interface TZCollectionView : UICollectionView

@end
