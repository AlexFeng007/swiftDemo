//
//  UIViewController+ToastOrLoading.m
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "UIViewController+ToastOrLoading.h"
#import "FKYDefines.h"
#import "FKYCore.h"
#import "FKYCategories.h"
#import "FKYToast.h"
#import <MBProgressHUD/MBProgressHUD.h>


static MBProgressHUD *_privateHUD = nil;

@interface UIViewController ()<MBProgressHUDDelegate>

@end


@implementation UIViewController (ToastOrLoading)
@dynamic toastDictionary;

#pragma mark - Data

- (void)setToastDictionary:(NSDictionary *)toastDictionary {
    self.toastDictionary = toastDictionary;
}

- (NSDictionary *)toastDictionary {
   static NSDictionary *dic;
    if (dic == nil) {
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"network_toast" ofType:@"json"]];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        dic = [NSDictionary dictionaryWithDictionary:dict];
    }
    return dic;
}


#pragma mark - Toast

// 默认时长
- (void)toast:(NSString *)msg {
    if (msg && msg.length > 0) {
        NSString *toast = [self.toastDictionary valueForKey:msg];
        if (toast) {
            [FKYToast showToast:toast];
        }else{
            [FKYToast showToast:msg];
        }
    }
}

// 自定义时长
- (void)toast:(NSString *)msg time:(CGFloat)time {
    [FKYToast showToast:msg withTime:time];
}

- (void)toast:(NSString *)msg andImage:(UIImage *)image {
    NSString *toast = [self.toastDictionary valueForKey:msg];
    if (toast) {
        [FKYToast showToast:toast withImage:image];
    }else{
        [FKYToast showToast:msg withImage:image];
    }
}

- (void)toast:(NSString *)msg delay:(CGFloat)delay numberOfLines:(NSInteger)numberOfLines {
    NSString *toast = [self.toastDictionary valueForKey:msg];
    if (toast) {
        [FKYToast showToast:toast delay:delay numberOfLines:numberOfLines];
    }else{
        [FKYToast showToast:msg delay:delay numberOfLines:numberOfLines];
    }
}


#pragma mark - Loading

- (void)showLoading {
    [self FKY_showLoading];
}

- (void)dismissLoading {
    [self FKY_dismissTips];
}

- (void)dismissLoadingWithoutAnimate {
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideHUD:) object:_privateHUD];
    _privateHUD = nil;
}


#pragma mark - Private

- (void)FKY_dismissTips {
    //
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:true];
    if (_privateHUD != nil){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    _privateHUD = nil;
}

- (void)FKY_showLoading {
    if (!_privateHUD) {
        UIWindow *window =  [[UIApplication sharedApplication] keyWindow];
        //添加到当前控制器的view上面，防止控制器退出时，loading不消失
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
        HUD.backgroundColor = UIColorFromRGBA(0x0, .1);
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.removeFromSuperViewOnHide = YES;
        HUD.activityIndicatorColor = [UIColor blackColor];
        HUD.color = UIColorFromRGB(0xffffff);
        HUD.labelColor = UIColorFromRGB(0x0);
        HUD.delegate = self;
        [HUD show:YES];
        _privateHUD = HUD;
        [self performSelector:@selector(hideHUD:) withObject:HUD afterDelay:5.0];
    }
}


#pragma mark - MBProgressHUDDelegate
-(void) hideHUD:(MBProgressHUD*) progress {
    __block MBProgressHUD* progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hide:YES];
        progressC = nil;
    });
}
 
- (void)hudWasHidden:(MBProgressHUD *)hud {
    _privateHUD = nil;
}

@end
