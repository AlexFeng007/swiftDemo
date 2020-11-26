//
//  FKYActivityWebService.m
//  FKY
//
//  Created by yangyouyong on 2017/1/11.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYActivityWebService.h"
#import "FKYLoginAPI.h"
#import "FKYUserInfoModel.h"

@implementation FKYActivityWebService

- (void)signUpActivitySuccess:(void(^)(NSString *, NSInteger))success
                      failure:(FKYFailureBlock)failure {
    NSString *urlString =[[self usermanageReleaseAPI] stringByAppendingString:@"enterpriseInfo/createEnroll"];
    NSMutableDictionary *para = @{}.mutableCopy;
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        para[@"seller_id"] = @"33266";
    }
    para[@"source"] = @"3";
    [self POST:urlString
          body:para
       success:^(NSURLRequest *request, FKYNetworkResponse *response) {
        if (response.originalContent && response.originalContent[@"data"]) {
            NSDictionary *dataDict = response.originalContent[@"data"];
            NSString *remark = dataDict[@"remark"];
            NSNumber *states = dataDict[@"states"];
            safeBlock(success, remark, states.integerValue);
            return;
        }
        safeBlock(success, @"", 0);
    } failure:^(NSString *reason) {
        safeBlock(failure,reason);
    }];
}

- (void)signupActivityInViewController:(UIViewController *)vc
{
    [vc showLoading];
    [self signUpActivitySuccess:^(NSString *remark, NSInteger states) {
        [vc dismissLoading];
        if (states == 1 || states == -2) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:^(id destinationViewController) {
                //
            } isModal:true];
        }
        if (states == 2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fky://account/credentials"]]) {
                    if (iOS10Later()) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fky://account/credentials"] options:@{} completionHandler:nil];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fky://account/credentials"]];
                    }
                }
            });
        }
        [vc toast:remark];
    } failure:^(NSString *reason) {
        [vc toast:reason];
        [vc dismissLoading];
    }];
}

@end
