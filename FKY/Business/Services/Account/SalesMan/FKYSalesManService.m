//
//  FKYSalesManService.m
//  FKY
//
//  Created by 寒山 on 2018/4/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYSalesManService.h"
#import "NSDictionary+SafeAccess.h"
@interface FKYSalesManService()
@property (nonatomic, strong) FKYPublicNetRequestSevice *saleRequestSever;
@end

@implementation FKYSalesManService
- (instancetype)init {
    if (self = [super init]) {
        self.salesManModel = [[FKYSalesManModel alloc] init];
    }
    return self;
}
- (FKYPublicNetRequestSevice *)saleRequestSever {
    if (_saleRequestSever == nil) {
        _saleRequestSever  = [FKYPublicNetRequestSevice logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _saleRequestSever;
}
- (void)getSalesManListInfoSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock{
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        NSString *token = @"";
        //测试环境token返回可能为nil
        if ([FKYLoginAPI currentUser].token) {
            token = [FKYLoginAPI currentUser].token;
        }
        NSDictionary *parms = @{@"token":token};
        [self.saleRequestSever selectSalesmanInfoBlockWithParam:parms completionBlock:^(id aResponseObject, NSError *anError) {
            if (aResponseObject) {
                NSDictionary *data = (NSDictionary *)aResponseObject;
                if([data hasKey:@"name"]&&data){
                    self.salesManModel.name = [aResponseObject stringForKey:@"name"];
                }else{
                    self.salesManModel.name = @"无";
                }
                if([data hasKey:@"mobile"]&&data){
                    self.salesManModel.mobile = [data stringForKey:@"mobile"];
                }else{
                    self.salesManModel.mobile = @"";
                }
                safeBlock(successBlock,NO);
            }
            else {
                NSString *errMsg = anError.localizedDescription;
                if (anError && anError.code == 2) {
                    errMsg = @"用户登录过期，请重新手动登录";
                }
                safeBlock(failureBlock, errMsg);
            }
        }];
    }
    else {
        safeBlock(successBlock,NO);
    }
    
//    NSString *urlString = [self.usermanageReleaseAPI stringByAppendingString:@"/enterpriseInfo/selectSalesmanInfo"];
//    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
//        NSString *token = [FKYLoginAPI currentUserSessionId];
//        NSDictionary *parms = @{@"token":token};
//        [self GET:urlString
//       parameters:parms
//          success:^(NSURLRequest *request, FKYNetworkResponse *response) {
//              NSDictionary *data = response.originalContent[@"data"];
//              NSLog(@"%@",data);
//              if([data hasKey:@"name"]&&data){
//                  self.salesManModel.name = [data stringForKey:@"name"];
//              }else{
//                  self.salesManModel.name = @"无";
//              }
//              if([data hasKey:@"mobile"]&&data){
//                  self.salesManModel.mobile = [data stringForKey:@"mobile"];
//              }else{
//                  self.salesManModel.mobile = @"";
//              }
//              safeBlock(successBlock,NO);
//          } failure:^(NSString *reason) {
//              safeBlock(failureBlock,reason);
//          }];
//    }else{
//        safeBlock(successBlock,NO);
//    }
}

@end
