//
//  FKYVersionCheckService.m
//  FKY
//
//  Created by yangyouyong on 15/10/9.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYVersionCheckService.h"
#import "FKYCartModel.h"
#import "FKYAccountLaunchLogic.h"
#import "FKYPublicNetRequestSevice.h"
#import "FKYCartNetRequstSever.h"


@interface FKYVersionCheckService ()

@property (nonatomic, strong) FKYAccountLaunchLogic *accountLaunchLogic;
@property (nonatomic, strong) FKYPublicNetRequestSevice *publicRequstSever;
@property (nonatomic, strong) FKYCartNetRequstSever *cartRequstSever;

@end


@implementation FKYVersionCheckService

#pragma mark - Life Cycle

+ (FKYVersionCheckService *)shareInstance
{
    static dispatch_once_t onceToken;
    static FKYVersionCheckService *staticInstance;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    
    return staticInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mustUpdate = NO;
        _hasNewVersion = NO;
    }
    return self;
}


#pragma mark - Public

// 版本检查
// 接口文档: http://rap.yiyaowang.com/workspace/myWorkspace.do?projectId=251#2658
// 检查APP是否升级adapter接口: ypassport/app_check_up
- (void)checkAppVersionSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    if (self.hasNewVersion) {
        safeBlock(successBlock,YES);
        return;
    }
    
    // 传参
    NSMutableDictionary *dict = @{}.mutableCopy;
    // 数字版本号...<内部版本号: 3920>
    dict[@"version_code"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    // 平台
    dict[@"plat_type"] = @"IOS";
    
    @weakify(self);
    [self.accountLaunchLogic checkAppVersionWithParam:dict CompletionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil && aResponseObject != nil) {
            // 请求成功 && 有数据
            NSDictionary *dic = (NSDictionary *)aResponseObject;
            // test
            //NSDictionary *dic = @{@"updateVersion":@"Y", @"remark":@"hello world~!@", @"updateFag":@"1", @"versionCode":@"3930", @"versionPath":@"www.cookov.com"};
            if ([dic[@"updateVersion"] isEqualToString:@"Y"]) {
                // 有新版本
                self.hasNewVersion = YES;
                
                if ([(dic[@"updateFlag"]) integerValue] == 1) {
                    // 强更
                    self.mustUpdate = YES;
                }
                else {
                    // 不需要强更
                    self.mustUpdate = NO;
                }
                
                // 更新说明
                self.updateMessage = dic[@"remark"];
                
                safeBlock(successBlock,YES);
            }
            else {
                // 无新版本
                self.hasNewVersion = NO;
                self.mustUpdate = NO;
                safeBlock(successBlock,NO);
            }
            
            // 请求完成
            [self toShowUpdateAlert];
        }
        else {
            // 请求失败 or 无数据
            if (anError && anError.code == 2) {
                [kAppDelegate showToast:@"用户登录过期，请重新手动登录"];
            }
            self.hasNewVersion = NO;
            self.mustUpdate = NO;
            safeBlock(successBlock,NO);
        }
    }];
}

//获取一起购购物车商品数量
- (void)syncTogeterBuyCartNumberSuccess:(FKYSuccessBlock)successBlock
                                failure:(FKYFailureBlock)failureBlock
{
    // 若用户未登录，则不调接口
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        [FKYCartModel shareInstance].togeterBuyProductCount = 0;
        [[FKYCartModel shareInstance].togeterBuyProductArr removeAllObjects];
        if (successBlock) {
            successBlock(YES);
        }
        return;
    }
    
    NSMutableDictionary *jsonParam = [NSMutableDictionary dictionary];
    [jsonParam setObject:@"2" forKey:@"numDetailFlag"];
    [jsonParam setObject:@"2" forKey:@"fromwhere"];
    [self.cartRequstSever productsCountBlockWithParam:jsonParam  completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            NSNumber *pcount = aResponseObject[@"count"];
            if (pcount && pcount.integerValue >= 0) {
                [FKYCartModel shareInstance].togeterBuyProductCount = pcount.integerValue;
            }else {
                [FKYCartModel shareInstance].togeterBuyProductCount = 0;
            }
            NSArray *dataArr = aResponseObject[@"cartNumList"];
            [[FKYCartModel shareInstance].togeterBuyProductArr removeAllObjects];
            if (dataArr && dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    FKYCartOfInfoModel *model = [FKYCartOfInfoModel new];
                    model.buyNum = dic[@"buyNum"];
                    model.cartId =  dic[@"cartId"];
                    model.spuCode = dic[@"spuCode"];
                    model.supplyId = dic[@"supplyId"];
                    model.promotionId = dic[@"promotionId"];
                    [[FKYCartModel shareInstance].togeterBuyProductArr addObject:model];
                }
            }
            if (successBlock) {
                successBlock(YES);
            }
        }
        else {
            if (failureBlock) {
                failureBlock(anError.userInfo[HJErrorTipKey]?anError.userInfo[HJErrorTipKey]:@"请求失败");
            }
        }
    }];
}

// 获取购物车商品数量
- (void)syncCartNumberSuccess:(FKYSuccessBlock)successBlock
                      failure:(FKYFailureBlock)failureBlock
{
    // 若用户未登录，则不调接口
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        [FKYCartModel shareInstance].productCount = 0;
        [[FKYCartModel shareInstance].productArr removeAllObjects];
        if (successBlock) {
            successBlock(YES);
        }
        return;
    }
    
    NSMutableDictionary *jsonParam = [NSMutableDictionary dictionary];
    [jsonParam setObject:@"2" forKey:@"numDetailFlag"];
    [self.cartRequstSever productsCountBlockWithParam:jsonParam  completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            // 购物车中商品数量
            NSNumber *pcount = aResponseObject[@"count"];
            if (pcount && pcount.integerValue >= 0) {
                // 有返回数量
                [FKYCartModel shareInstance].productCount = pcount.integerValue;
            }else {
                // 未返回数量，默认为0
                [FKYCartModel shareInstance].productCount = 0;
            }
            // 购物车中商品基本信息列表
            [[FKYCartModel shareInstance].productArr removeAllObjects];
            NSArray *dataArr = aResponseObject[@"cartNumList"];
            if (dataArr && dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    FKYCartOfInfoModel *model = [FKYCartOfInfoModel new];
                    model.buyNum = dic[@"buyNum"];
                    model.cartId =  dic[@"cartId"];
                    model.spuCode = dic[@"spuCode"];
                    model.supplyId = dic[@"supplyId"];
                    [[FKYCartModel shareInstance].productArr addObject:model];
                }
            }
            
            // 固定套餐列表
            NSArray *comboArr = aResponseObject[@"fixComboNumList"];
            if (comboArr && comboArr.count > 0) {
                for (NSDictionary *dic in comboArr) {
                    FKYCartOfInfoModel *model = [FKYCartOfInfoModel new];
                    model.buyNum = dic[@"buyNum"];
                    model.promotionId = dic[@"promotionId"];
                    model.comboItems = [NSArray arrayWithArray:dic[@"comboItems"]];
                    [[FKYCartModel shareInstance].productArr addObject:model];
                }
            }
            
            if (successBlock) {
                successBlock(YES);
            }
        }
        else {
            NSString *errMsg = (anError.userInfo[HJErrorTipKey] ? anError.userInfo[HJErrorTipKey] : @"请求失败");
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期, 请重新手动登录";
            }
            
            if (failureBlock) {
                failureBlock(errMsg);
            }
        }
    }];
}

// 获取混合商品数量
- (void)syncMixCartNumberSuccess:(FKYSuccessBlock)successBlock
                         failure:(FKYFailureBlock)failureBlock{
    // 若用户未登录，则不调接口
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        [[FKYCartModel shareInstance].mixProductArr removeAllObjects];
        [[FKYCartModel shareInstance].productArr removeAllObjects];
        [[FKYCartModel shareInstance].togeterBuyProductArr removeAllObjects];
        [FKYCartModel shareInstance].togeterBuyProductCount = 0;
        [FKYCartModel shareInstance].productCount = 0;
        if (successBlock) {
            successBlock(YES);
        }
        return;
    }
    NSMutableDictionary *jsonParam = [NSMutableDictionary dictionary];
    [jsonParam setObject:@"2" forKey:@"numDetailFlag"];
    [jsonParam setObject:@"20" forKey:@"fromwhere"];
    [self.cartRequstSever productsCountBlockWithParam:jsonParam  completionBlock:^(id aResponseObject, NSError *anError) {
        if (anError == nil) {
            // 购物车中商品数量
            NSNumber *totalPcount = aResponseObject[@"count"];
            NSArray *dataArr = aResponseObject[@"cartNumList"];
            [[FKYCartModel shareInstance].productArr removeAllObjects];
            [[FKYCartModel shareInstance].togeterBuyProductArr removeAllObjects];
            [[FKYCartModel shareInstance].mixProductArr removeAllObjects];
            if (dataArr && dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    FKYCartOfInfoModel *model = [FKYCartOfInfoModel new];
                    model.buyNum = dic[@"buyNum"];
                    model.cartId =  dic[@"cartId"];
                    model.spuCode = dic[@"spuCode"];
                    model.supplyId = dic[@"supplyId"];
                    model.promotionId = dic[@"promotionId"];
                    model.fromWhere = dic[@"fromWhere"];
                    [[FKYCartModel shareInstance].mixProductArr addObject:model];
                    if (model.fromWhere.integerValue == 2) {
                        [[FKYCartModel shareInstance].togeterBuyProductArr addObject:model];
                    }else {
                        [[FKYCartModel shareInstance].productArr addObject:model];
                    }
                }
            }
            // 固定套餐列表
            NSArray *comboArr = aResponseObject[@"fixComboNumList"];
            if (comboArr && comboArr.count > 0) {
                for (NSDictionary *dic in comboArr) {
                    FKYCartOfInfoModel *model = [FKYCartOfInfoModel new];
                    model.buyNum = dic[@"buyNum"];
                    model.promotionId = dic[@"promotionId"];
                    model.comboItems = [NSArray arrayWithArray:dic[@"comboItems"]];
                    [[FKYCartModel shareInstance].productArr addObject:model];
                }
            }
            
            //重置一起购和普通商品数据
            if ([FKYCartModel shareInstance].togeterBuyProductArr.count>0) {
                [FKYCartModel shareInstance].togeterBuyProductCount = [FKYCartModel shareInstance].togeterBuyProductArr.count;
            }else{
                [FKYCartModel shareInstance].togeterBuyProductCount = 0;
            }
            if ([FKYCartModel shareInstance].productArr.count>0) {
                [FKYCartModel shareInstance].productCount = totalPcount.integerValue - [FKYCartModel shareInstance].togeterBuyProductArr.count;
            }else{
                [FKYCartModel shareInstance].productCount = 0;
            }
            
            if (successBlock) {
                successBlock(YES);
            }
        }
        else {
            if (failureBlock) {
                failureBlock(anError.userInfo[HJErrorTipKey]?anError.userInfo[HJErrorTipKey]:@"请求失败");
            }
        }
    }];
}

// 保存推送(设备)信息接口
- (void)saveDeviceInfoWithClientid:(NSString *)clientid devicetoken:(NSString *)devicetoken success:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:[FKYLoginAPI currentUserId] forKey:@"userId"];
    [dic setValue:clientid forKey:@"clientId"];
    [dic setValue:devicetoken forKey:@"devicetoken"];
    [dic setValue:@2 forKey:@"platform"];//ios 2
    
    [[FKYRequestService sharedInstance] saveDeviceInfoWithParam:dic completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        if (isSucceed) {
            // 成功
            //NSLog(@"Save Success~!@");
        }
        else {
            // 失败
            //NSLog(@"Save Failed~!@");
        }
    }];
}


#pragma mark - Private

// 请求完成or首页展示后，调当前方法
- (void)toShowUpdateAlert
{
    if (_hasNewVersion) {
        // 有新版本
        NSString *message = _updateMessage;
        message = [message stringByReplacingOccurrencesOfString:@"<br/> " withString:@"\n"];
        [FKYUpdateAlertView alertWithMessage:message shouldForceUpdate:_mustUpdate];
    }
}


#pragma mark - Property

- (FKYCartNetRequstSever *)cartRequstSever
{
    if (_cartRequstSever == nil) {
        _cartRequstSever  = [FKYCartNetRequstSever logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _cartRequstSever;
}

- (FKYAccountLaunchLogic *)accountLaunchLogic
{
    if (_accountLaunchLogic == nil) {
        _accountLaunchLogic = [FKYAccountLaunchLogic logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _accountLaunchLogic;
}

- (FKYPublicNetRequestSevice *)publicRequstSever
{
    if (_publicRequstSever == nil) {
        _publicRequstSever = [FKYPublicNetRequestSevice logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _publicRequstSever;
}

@end
