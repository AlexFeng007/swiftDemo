//
//  GLOriginalImageVC.h
//  CommonLib
//
//  Created by lily on 15/12/23.
//  Copyright © 2015年 ihome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelButtonBlock)(void);
typedef void(^DetermineButtonBlock)(void);

@interface GLOriginalImageVC : UIViewController

@property (nonatomic, strong) UIImageView *originalImageView;
@property (nonatomic, copy) CancelButtonBlock cancelBtnBlock;
@property (nonatomic, copy) DetermineButtonBlock determineBtnBlock;

@end
