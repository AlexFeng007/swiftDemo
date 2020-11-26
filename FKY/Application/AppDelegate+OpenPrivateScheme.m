//
//  AppDelegate+OpenPrivateScheme.m
//  FKY
//
//  Created by Rabe on 11/09/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "AppDelegate+OpenPrivateScheme.h"
#import "NSURL+Param.h"

@implementation AppDelegate (OpenPrivateScheme)


- (void)p_openPriveteSchemeString:(NSString *)urlStr {
    if (urlStr.length > 0){
        NSURL *url = [NSURL URLWithString:urlStr];
        if (!url) {
            //包含中文导致url为空需要编码
            NSString *encodeStr = (NSString *)[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [NSURL URLWithString:encodeStr];
        }
        [self p_openPriveteScheme:url];
    }
}

- (BOOL)p_openPriveteScheme:(NSURL *)url
{
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissLoading];
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissLoading];
    // 从短信url中跳转到app指定界面...<deeplink>
    if ([self smsJumpHandle:url]) {
        return NO;
    }
    
#pragma mark 订单相关
    if ([url.absoluteString hasPrefix:@"fky://account/allorders"]) {
        // 全部订单
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                destinationViewController.status = @"0";
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/waitPaymentOrders"]) {
        // 待付款订单
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                destinationViewController.status = @"1";
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/waitDeliverOrders"]) {
        // 待发货订单
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                destinationViewController.status = @"2";
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/waitTakeOrders"]) {
        // 待收货订单
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                destinationViewController.status = @"3";
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/finishOrders"]) {
        // 已完成订单
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                destinationViewController.status = @"4";
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/exceptionorders"]) {
        // 异常订单(拒收补货列表)
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_RefuseOrder)];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://orderdetail"]) {
        // 订单详情
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderDetailController) setProperty:^(FKYOrderDetailViewController *destinationViewController) {
                NSDictionary *params = [url parameters];
                FKYOrderModel *model = [[FKYOrderModel alloc] init];
                model.orderId = params[@"orderid"];
                destinationViewController.orderModel = model;
            } isModal:NO animated:YES];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://logisticsDetail"]) {
        // 物流详情详情
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            NSDictionary *params = [url parameters];
            if (params[@"deliveryMethod"]) {
                // 1自有物流、 2、第三方物流
                if ([params[@"deliveryMethod"] intValue] ==  2) {
                    // 查看第三方物流
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LogisticsDetailController) setProperty:^(FKYLogisticsDetailViewController *destinationViewController) {
                        destinationViewController.orderId = params[@"orderId"];
                    } isModal:NO animated:YES];
                }
                else {
                    // 查看自有物流
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LogisticsController) setProperty:^(FKYLogisticsViewController *destinationViewController) {
                        destinationViewController.deliveryType = deliveryMethod_own;
                        destinationViewController.orderId = params[@"orderId"];
                    } isModal:NO animated:YES];
                }
            }
        }
    }
#pragma mark 登录/注册
    else if ([url.absoluteString hasPrefix:@"fky://account/login"]) {
        // 跳转登陆
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
            if ([FKYLoginAPI checkLoginExistByModelStyle] == NO) {
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:^(LoginController *destinationViewController) {
                    //
                } isModal:YES animated:YES];
            }
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/register"]) {
        // 跳转注册
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_RegisterController)];
    }
#pragma mark 店铺、商品、搜索、分类
    else if ([url.absoluteString hasPrefix:@"fky://shop/shopLabel"]) {// 高毛专区
        NSDictionary *params = [url parameters];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_HeightGrossMarginVC) setProperty:^(FKYHeightGrossMarginVC * destinationViewController) {
            destinationViewController.labelId = [NSString stringWithFormat:@"%@",params[@"labelId"]];
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://shopList"]) {
        if ([url.absoluteString hasPrefix:@"fky://shopList/specialPrice"]) {
            // 特价专区
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllPrefecture) setProperty:^(FKYAllPrefectureViewController * destinationViewController) {
                destinationViewController.type = 1;
            }];
        }
        else if ([url.absoluteString hasPrefix:@"fky://shopList/fullScale"]) {
            // 满减专区
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllPrefecture) setProperty:^(FKYAllPrefectureViewController * destinationViewController) {
                destinationViewController.type = 2;
            }];
        }
        else if ([url.absoluteString hasPrefix:@"fky://shopList/couponCenter"]) {
            // 领券中心
            if ([self isLoginThenLoginWithOpenUrl:url]) {
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopListCouponCenter) setProperty:^(id destinationViewController) {
                }];
            }
        }
        else {
            // 店铺馆
            NSDictionary *params = [url parameters];
            FKYShopHomeViewController *vc = [FKYTabBarController shareInstance].viewControllers[2];
            if (params[@"selectIndex"]) {
                vc.selIndex = params[@"selectIndex"];
            }
            else {
                vc.selIndex = @"";
            }
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController *tabBarVC) {
                tabBarVC.index = 2;
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://setTogether"]){
        // 店铺详情中的套餐列表
        NSDictionary *params = [url parameters];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ComboList) setProperty:^(FKYComboListViewController *destinationViewController) {
            if (params) {
                if (params[@"enterpriseId"]) {
                    destinationViewController.sellerCode = [params[@"enterpriseId"] integerValue];
                }else{
                    destinationViewController.sellerCode = 0;
                }
                if (params[@"enterpriseName"]) {
                    destinationViewController.enterpriseName = params[@"enterpriseName"];
                }else{
                    destinationViewController.enterpriseName = @"";
                }
                if (params[@"spuCode"]){
                    destinationViewController.spuCode = params[@"spuCode"];
                }else{
                    destinationViewController.spuCode = @"";
                }
            }
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://shop/shopItem"]) {
        // 店铺主页
        NSDictionary *params = [url parameters];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItem) setProperty:^(FKYNewShopItemViewController *destinationViewController) {
            if (params) {
                if (params[@"shopId"]) {
                    destinationViewController.shopId = params[@"shopId"];
                }else{
                    destinationViewController.shopId = @"";
                }
                if (params[@"target"]) {
                    destinationViewController.selectType = params[@"target"];
                }else{
                    destinationViewController.selectType = @"";
                }
                if (params[@"isSpecial"]) {
                    destinationViewController.shopType = params[@"isSpecial"];
                }else{
                    destinationViewController.shopType = @"";
                }
                
            }
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://search/searchResult"]) {
        // 搜索结果
        NSDictionary *params = [url parameters];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_SearchResult) setProperty:^(FKYSearchResultVC *destinationViewController) {
            if (params != nil) {
                if (params[@"type"]) {
                    if ([params[@"type"] isKindOfClass:NSString.class]) {
                        if ([params[@"type"] integerValue] == 1) {
                            destinationViewController.searchResultType = @"Shop";
                        } else {
                            destinationViewController.searchResultType = @"";
                        }
                    } else {
                        destinationViewController.searchResultType = @"";
                    }
                } else {
                    destinationViewController.searchResultType = @"";
                }
                if(params[@"sellerCode"]){
                    //店铺内搜索
                    destinationViewController.sellerCode = params[@"sellerCode"]; // 商家id
                    destinationViewController.searchFromType = @"fromShop";
                    destinationViewController.shopProductSearch = YES;
                }
                NSString *keyword = params[@"keyword"];
                destinationViewController.keyword = [keyword stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // 搜索关键词
                destinationViewController.spuCode = params[@"spuCode"]; // 商品id
                destinationViewController.selectedAssortId = params[@"categoryId"]; // 分类id
            }
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://product/productionDetail"]) {
        // 商品详情
        NSDictionary *params = [url parameters];
        // productId: 商品spuCode sellerID:供应商ID
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
            if (params != nil) {
                destinationViewController.productionId = params[@"productId"];
                destinationViewController.vendorId = params[@"sellerId"];
                if (params[@"pushType"]) {
                    destinationViewController.pushType = params[@"pushType"];
                }
            }
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://categoryList"]) {
        // 分类
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* tabBarVC) {
            tabBarVC.index = 1;
            // 获取categoryVC
            FKYCategoryWebViewController *categoryVC = tabBarVC.viewControllers[1];
            NSDictionary *params = [url parameters];
            if (params[@"categoryId"]) {
                categoryVC.categoryId = params[@"categoryId"];
            }
        }];
    }
#pragma mark 首页、秒杀、一起购
    else if ([url.absoluteString hasPrefix:@"fky://home"]) {
        // 首页
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
            destinationViewController.index = 0;
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://yqgActive"]){
        NSDictionary *params = [url parameters];
        // 一起购列表
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TogeterBuy) setProperty:^(FKYTogeterBuyViewController* destinationViewController) {
            if(params[@"sellerCode"]){
                destinationViewController.sellerCode = params[@"sellerCode"]; // 商家id
            }
            //
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://yqgDetailActive"]){
        // 一起购详情
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Togeter_Detail_Buy) setProperty:^(FKYTogeterBuyDetailViewController * destinationViewController) {
            NSDictionary *params = [url parameters];
            destinationViewController.productId = params[@"productId"];
            destinationViewController.typeIndex = params[@"typeIndex"];
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://secKillList"]) {
        // 秒杀专区之查看更多
        NSDictionary *params = [url parameters];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_SecondKillActivityDetail) setProperty:^(FKYSecondKillActivityController * destinationViewController) {
            destinationViewController.sellerCode = params[@"sellerCode"]; // 商家id
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://cart"]) {
        // 购物车
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
            destinationViewController.index = 3;
        }];
    }else if ([url.absoluteString hasPrefix:@"fky://package"]){
        // 搭配套餐聚合页
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MatchingPackageVC) setProperty:^(FKYMatchingPackageVC* destinationViewController) {
            NSDictionary *params = [url parameters];
            if (params[@"shopId"]){
                destinationViewController.enterpriseId = params[@"shopId"];
            }
        }];
    }else if ([url.absoluteString hasPrefix:@"fky://product/promotionList"]){
        /// 降价专区
        NSDictionary *params = [url parameters];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_HeightGrossMarginVC) setProperty:^(FKYHeightGrossMarginVC * destinationViewController) {
            if (params[@"type"]) {
                destinationViewController.typeIndex = [params[@"type"] intValue];
            }
            if (params[@"spuCode"]){
                destinationViewController.spuCode = [NSString stringWithFormat:@"%@",params[@"spuCode"]];
            }
            if (params[@"sellerCode"]){
                destinationViewController.sellCode = [NSString stringWithFormat:@"%@",params[@"sellerCode"]];
            }
            
        }];
        
    }
#pragma mark 个人中心
    else if ([url.absoluteString hasPrefix:@"fky://userCenter"]) {
        // 个人中心
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
            destinationViewController.index = 4;
        }];
    }
    else if ([url.absoluteString hasPrefix:@"fky://suggestPill"]) {
        // 推荐药品/常购清单
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OfftenProductList) setProperty:^(id destinationViewController) {
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/suggestPill"]) {
        // 推荐药品/常购清单
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OfftenProductList) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/dataManage"]) {
        // 打开资质管理
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_CredentialsController) setProperty:^(id destinationViewController) {
                //
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/baseinfo"]) {
        // 基本资料
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_QualiticationBaseInfo) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://rebate/rebateDetail"]) {
        // 我的资产
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_RebateInfoController) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/customerService"]) {
        // 联系客服
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(GLWebVC  *destinationViewController) {
                destinationViewController.urlPath = [NSString stringWithFormat:@"%@?platform=3&supplyId=8353&openFrom=%d",API_IM_H5_URL,0];
                destinationViewController.navigationController.navigationBarHidden = YES;
            } isModal:false];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/setting"]) {
        // 设置
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_SetUpController)];
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/coupon"]) {
        // 我的优惠券
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MyCoupon) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/qualification"]) {
        // 我的资质
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                destinationViewController.urlPath = @"https://m.yaoex.com/pageSwitch/pageSwap.html";
            }];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/invoice"]) {
        // 发票信息
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            // 通过电子审核之后才可维护发票信息
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_FKYInvoiceViewController) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/keepSellers"]) {
        // 常购商家
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OftenSellerListViewController) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/salesman"]) {
        // 负责业务员
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MySalesMan) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://account/collection"]) {
        // 我的收藏
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MyFavShopController) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://message/box"]) {
        // 消息盒子<预定义key> fky://message/box
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Message_List) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://message/box"]) {
        // 消息盒子<预定义key> fky://message/box
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Message_List) setProperty:nil];
        }
    }
    else if ([url.absoluteString hasPrefix:@"fky://message/expiredTips"]) {
        // 资质过期或者即将过期  去消息中心 资质列表
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ExpiredTipsMessageVC) setProperty:^(id destinationViewController) {
        }];
        
    }
    else if ([url.absoluteString hasPrefix:@"fky://message/serviceNotice"]) {
        // 降价消息通知
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_PriceChangeNoticeVC) setProperty:^(id destinationViewController) {
        }];
        
    }
#pragma mark 新品登记
    else if ([url.absoluteString hasPrefix:@"fky://newproductregister/newproductregister"]) {
        // 打开新品登记页
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_NewProductRegisterVC) setProperty:^(id destinationViewController) {
            }];
        }
    }
#pragma mark 药福利
    else if ([url.absoluteString hasPrefix:@"fky://drugwelfare"]) {
        // 打开药福利介绍页面
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_FKYYflIntroDetailViewController) setProperty:^(id destinationViewController) {
            }];
        }
    }
#pragma mark 逛一逛送券
    else if ([url.absoluteString hasPrefix:@"fky://product/viewGetCoupon"]) {
        // 逛一逛送券
        if ([self isLoginThenLoginWithOpenUrl:url]) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Send_Coupon_Info) setProperty:^(id destinationViewController) {
                
            }];
        }
    }
#pragma mark // 1-特价活动 2-满减活动 3-满赠活动 4-返利专区 5-满折专区 6-口令分享
    /*
     特价专区：  fky://promotion/zone?type=1&shopId=8353
     满减专区：  fky://promotion/zone?type=2&shopId=100728&promotionId=40790
     满赠专区：  fky://promotion/zone?type=3&shopId=200825&promotionId=40864
     返利专区 ： fky://promotion/zone?type=4&shopId=8353&promotionId=1152
     满折专区 ： fky://promotion/zone?type=5&shopId=8353&promotionId=40800
     口令专区：  fky://promotion/zone?type=6&promotionId=XX
     */
    else if ([url.absoluteString hasPrefix:@"fky://promotion/zone"]){
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItemOld) setProperty:^(ShopItemOldViewController *destinationViewController) {
            NSDictionary *params = [url parameters];
            if ([params[@"type"] integerValue]==6){
                destinationViewController.commandShareId = params[@"promotionId"];
            }else if ([params[@"type"] integerValue]==1) {
                destinationViewController.shopId = params[@"shopId"];
            }else {
                destinationViewController.shopId = params[@"shopId"];
                destinationViewController.promotionId = params[@"promotionId"];
            }
            destinationViewController.type = [params[@"type"] integerValue];
        }];
    }
#pragma mark 单品包邮列表
    else if ([url.absoluteString hasPrefix:@"fky://product/freeDelivery"]){
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Product_Pinkage) setProperty:^(FKYProductPinkageViewController *destinationViewController) {
            NSDictionary *params = [url parameters];
            if (params[@"freeDeliveryType"]){
                destinationViewController.freeDeliveryType = [params[@"freeDeliveryType"] intValue];
            }
        }];
    }
#pragma mark 到货通知
    else if ([url.absoluteString hasPrefix:@"fky://product/arrivalnotice"]){
        [[FKYNavigator sharedNavigator]openScheme:@protocol(FKY_ArrivalProductNoticeVC) setProperty:^(id destinationViewController) {
            NSDictionary *params = [url parameters];
            ArrivalProductNoticeVC *shopItemVC = (ArrivalProductNoticeVC *)destinationViewController;
            if (params[@"shopId"]) {
                shopItemVC.venderId  = params[@"shopId"];
            }
            if (params[@"spucode"]) {
                shopItemVC.productId=  params[@"spucode"];
            }
            shopItemVC.productUnit = @"";
        }];
    }
#pragma mark 优惠券可用商品列表
    else if ([url.absoluteString hasPrefix:@"fky://coupon/product"]){
        [[FKYNavigator sharedNavigator]openScheme:@protocol(FKY_ShopCouponProductController) setProperty:^(id destinationViewController) {
            NSDictionary *params = [url parameters];
            CouponProductListViewController *shopItemVC = (CouponProductListViewController *)destinationViewController;
            if (params[@"enterpriseId"]) {
                shopItemVC.shopId  = params[@"enterpriseId"];
            }
            if (params[@"couponCode"]) {
                shopItemVC.couponCode =  params[@"couponCode"];
            }
            if (params[@"templateCode"]) {
                shopItemVC.couponTemplateId = params[@"templateCode"];
            }
            shopItemVC.couponName = @"";
        }];
    }
#pragma mark 直播入口
    else if ([url.absoluteString hasPrefix:@"fky://live/show"]){
        NSDictionary *params = [url parameters];
        if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
            // 未登录
            @weakify(self)
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                @strongify(self);
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:^(LoginController *destinationViewController) {
                    @strongify(self);
                    destinationViewController.loginSuccessBlock = ^(void) {
                        @strongify(self);
                        [self p_openPriveteScheme:url];
                    };
                } isModal:YES animated:YES];
            }];
        }else{
            [[LiveManageObject shareInstance] enterLiveViewController:[NSString stringWithFormat:@"%@",params[@"activityId"]] :@"1"];
        }
    }
#pragma mark 直播列表
    else if ([url.absoluteString hasPrefix:@"fky://live/video"]){
        [[FKYNavigator sharedNavigator]openScheme:@protocol(FKY_FKYVideoPlayerDetailVC) setProperty:^(id destinationViewController) {
            NSDictionary *params = [url parameters];
            FKYVideoPlayerDetailVC *videoVC= (FKYVideoPlayerDetailVC *)destinationViewController;
            if (params[@"id"]) {
                videoVC.activityId  = params[@"id"];
            }
        }];
    }
#pragma mark 视频播放首页
    else if ([url.absoluteString hasPrefix:@"fky://live/list"]){
        if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
            @weakify(self)
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                @strongify(self);
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:^(LoginController *destinationViewController) {
                    @strongify(self);
                    destinationViewController.loginSuccessBlock = ^(void) {
                        @strongify(self);
                        [self p_openPriveteScheme:url];
                    };
                } isModal:YES animated:YES];
            }];
        }else{
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_LiveContentListViewController) setProperty:nil isModal:NO animated:YES];
        }
    }
#pragma mark http/https
    else if ([url.absoluteString hasPrefix:@"http"] || [url.absoluteString hasPrefix:@"https"]) {
        // 若是进入H5页面后立即重定向到本地界面，则不需要跳H5，而是直接进入本地界面
        // 即：过滤以避免进H5后直接重定向到本地界面，再返回时H5页面白屏
        if ([FKYNewShopItemViewController jumpLocalPageByUrl:url.absoluteString]) {
            // 跳本地界面
            return NO;
        }
        NSDictionary *params = [url parameters];
        @weakify(self)
        if (params[@"needLogin"]) {
            NSInteger needLogin = [params[@"needLogin"] integerValue];
            if (needLogin == 1 && [FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
                // 未登录
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                    @strongify(self);
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:^(LoginController *destinationViewController) {
                        @strongify(self);
                        destinationViewController.loginSuccessBlock = ^(void) {
                            @strongify(self);
                            [self p_openPriveteScheme:url];
                        };
                    } isModal:YES animated:YES];
                }];
                return NO;
            }
        }
        if ([url.absoluteString containsString:@"needLogin=1"]&&[FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin){
            // 未登录
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                @strongify(self);
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:^(LoginController *destinationViewController) {
                    @strongify(self);
                    destinationViewController.loginSuccessBlock = ^(void) {
                        @strongify(self);
                        [self p_openPriveteScheme:url];
                    };
                } isModal:YES animated:YES];
            }];
            return NO;
        }
        // 进入H5页面
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
            destinationViewController.urlPath = url.absoluteString;
            ///NSDictionary *params = [url parameters];
            if (params != nil) {
                if (params[@"appNeedTitle"]) {
                    NSInteger needTitle = [params[@"appNeedTitle"] integerValue];
                    if (needTitle == 1) {
                        destinationViewController.barStyle = FKYBarStyleWhite;
                    }
                }
                if (params[@"appFinishAlways"]) {
                    NSInteger needTitle = [params[@"appFinishAlways"] integerValue];
                    if (needTitle == 1) {
                        destinationViewController.isShutDown = true;
                    }
                }
                if (params[@"appTitle"]) {
                    NSString * title = [params[@"appTitle"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    destinationViewController.barStyle = FKYBarStyleWhite;
                    destinationViewController.title = title;
                }
            }
            
        }];
    }
    
    return NO;
}

// widget打开app界面
- (BOOL)openUrlFromWidget:(NSURL *)url
{
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissLoading];
    
    if ([url.absoluteString hasPrefix:@"fkywidget://mall?tag="]) {
        NSDictionary *params = [url parameters];
        NSString *tag = params[@"tag"];
        if (tag && tag.length > 0) {
            NSInteger type = tag.integerValue;
            if (type == 0) {
                // 首页
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                    destinationViewController.index = 0;
                }];
                return YES;
            }
            else if (type == 1) {
                // 搜索
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Search) setProperty:^(FKYSearchViewController *destinationViewController) {
                    FKYSearchViewController *vc = destinationViewController;
                    vc.vcSourceType = SourceTypeCommon;
                    vc.searchType = SearchTypeProdcut;
                    vc.searchFromType = SearchResultContentTypeFromCommon;
                } isModal:NO];
                return YES;
            }
            else if (type == 2) {
                // 购物车
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                    destinationViewController.index = 3;
                }];
                return YES;
            }
            else if (type == 3) {
                // 订单...<全部订单>
                if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
                    // 未登录
                    @weakify(self)
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                        @strongify(self);
                        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:^(LoginController *destinationViewController) {
                            @strongify(self);
                            destinationViewController.loginSuccessBlock = ^(void) {
                                @strongify(self);
                                [self openUrlFromWidget:url];
                            };
                        } isModal:YES animated:YES];
                    }];
                    return NO;
                }
                else {
                    // 已登录
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                        destinationViewController.status = @"0";
                    }];
                    return YES;
                }
            }
            else if (type == 4) {
                // 店铺
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                    destinationViewController.index = 2;
                }];
                return YES;
            }
        }
    }
    
    return NO;
}


#pragma mark - Private

- (BOOL)isLoginThenLoginWithOpenUrl:(NSURL *)url
{
    if ([FKYLoginAPI loginStatus] == FKYLoginStatusUnlogin) {
        @weakify(self)
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
            @strongify(self);
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Login) setProperty:^(LoginController *destinationViewController) {
                @strongify(self);
                destinationViewController.loginSuccessBlock = ^(void) {
                    @strongify(self);
                    [self p_openPriveteScheme:url];
                };
            } isModal:YES animated:YES];
        }];
        return NO;
    }
    else {
        return YES;
    }
}

/*
 首页: fky://yhyc?model=mainPage
 个人中心: fky://yhyc?model=userCenter
 (自营)店铺详情: fky://yhyc?model=shopPage&shopId=
 cms活动页: fky://yhyc?model=actionPage&url=http://163.com
 */
- (BOOL)smsJumpHandle:(NSURL *)url
{
    if ([url.absoluteString hasPrefix:@"fky://yhyc?model="]) {
        NSDictionary *params = [url parameters];
        NSString *page = params[@"model"];
        if (page && page.length > 0) {
            if ([page isEqualToString:@"mainPage"]) {
                // 首页
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                    destinationViewController.index = 0;
                }];
                return YES;
            }
            else if ([page isEqualToString:@"userCenter"]) {
                // 个人中心
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(FKYTabBarController* destinationViewController) {
                    destinationViewController.index = 4;
                }];
                return YES;
            }
            else if ([page isEqualToString:@"shopPage"]) {
                // 店铺详情...<自营>
                NSString *shopid = params[@"shopId"];
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItem) setProperty:^(id <FKY_ShopItem> destinationViewController) {
                    destinationViewController.shopId = shopid;
                }];
                return YES;
            }
            else if ([page isEqualToString:@"actionPage"]) {
                // cms活动页
                NSString *cmsUrl = params[@"url"];
                if (cmsUrl && cmsUrl.length > 0) {
                    // 不为空
                }
                else {
                    // 为空...<设置默认url>
                    cmsUrl = @"https://m.yaoex.com";
                }
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                    destinationViewController.urlPath = cmsUrl;
                    NSURL *url = [NSURL URLWithString:cmsUrl];
                    NSDictionary *params = [url parameters];
                    if (params != nil) {
                        if (params[@"appNeedTitle"]) {
                            NSInteger needTitle = [params[@"appNeedTitle"] integerValue];
                            if (needTitle == 1) {
                                destinationViewController.barStyle = FKYBarStyleWhite;
                            }
                        }
                        if (params[@"appFinishAlways"]) {
                            NSInteger needTitle = [params[@"appFinishAlways"] integerValue];
                            if (needTitle == 1) {
                                destinationViewController.isShutDown = true;
                            }
                        }
                        if (params[@"appTitle"]) {
                            NSString * title = [params[@"appTitle"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            destinationViewController.barStyle = FKYBarStyleWhite;
                            destinationViewController.title = title;
                        }
                    }
                }];
                return YES;
            }
            // 以下为新增
            else if ([page isEqualToString:@"productDetail"]) {
                // 商详页
                NSDictionary *params = [url parameters];
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
                    if (params != nil) {
                        // productId: 商品spuCode sellerID:供应商ID
                        destinationViewController.productionId = params[@"productId"];
                        destinationViewController.vendorId = params[@"sellerId"];
                    }
                }];
                return YES;
            }
            else if ([page isEqualToString:@"secKillList"]) {
                // 秒杀专区之查看更多
                [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_SecondKillActivityDetail) setProperty:^(id destinationViewController) {
                    //
                }];
            }
            else if ([page isEqualToString:@"allorders"]) {
                // 全部订单
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                        destinationViewController.status = @"0";
                    }];
                }
                return YES;
            }
            else if ([page isEqualToString:@"waitPaymentOrders"]) {
                // 待付款订单
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                        destinationViewController.status = @"1";
                    }];
                }
                return YES;
            }
            else if ([page isEqualToString:@"waitDeliverOrders"]) {
                // 待发货订单
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                        destinationViewController.status = @"2";
                    }];
                }
                return YES;
            }
            else if ([page isEqualToString:@"waitTakeOrders"]) {
                // 待收货订单
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                        destinationViewController.status = @"3";
                    }];
                }
                return YES;
            }
            else if ([page isEqualToString:@"finishOrders"]) {
                // 已完成订单
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_AllOrderController) setProperty:^(FKYAllOrderViewController *destinationViewController) {
                        destinationViewController.status = @"4";
                    }];
                }
                return YES;
            }
            else if ([page isEqualToString:@"rebateDetail"]) {
                // 我的资产
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_RebateInfoController) setProperty:nil];
                }
                return YES;
            }
            else if ([page isEqualToString:@"coupon"]) {
                // 我的优惠券
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MyCoupon) setProperty:nil];
                }
                return YES;
            }
            else if ([page isEqualToString:@"qualification"]) {
                // 我的资质
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
                        destinationViewController.urlPath = @"https://m.yaoex.com/pageSwitch/pageSwap.html";
                    }];
                }
                return YES;
            }
            else if ([page isEqualToString:@"orderdetail"]) {
                // 订单详情
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    // orderid: 订单id
                    NSDictionary *params = [url parameters];
                    FKYOrderModel *model = [[FKYOrderModel alloc] init];
                    model.orderId = params[@"orderid"];
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderDetailController) setProperty:^(FKYOrderDetailViewController *destinationViewController) {
                        destinationViewController.orderModel = model;
                    } isModal:NO animated:YES];
                }
                return YES;
            }
            else if ([page isEqualToString:@"baseinfo"]) {
                // 基本资料
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_QualiticationBaseInfo) setProperty:nil];
                }
                return YES;
            }
            else if ([page isEqualToString:@"invoice"]) {
                // 发票信息
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    // 通过电子审核之后才可维护发票信息
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_FKYInvoiceViewController) setProperty:nil];
                }
                return YES;
            }
            else if ([page isEqualToString:@"keepSellers"]) {
                // 常购商家
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OftenSellerListViewController) setProperty:nil];
                }
                return YES;
            }
            else if ([page isEqualToString:@"salesman"]) {
                // 负责业务员
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MySalesMan) setProperty:nil];
                }
                return YES;
            }
            else if ([page isEqualToString:@"collection"]) {
                // 我的收藏
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_MyFavShopController) setProperty:nil];
                }
                return YES;
            }
            else if ([page isEqualToString:@"messagebox"]) {
                // 消息盒子
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Message_List) setProperty:nil];
                }
                return YES;
            }
            else if ([page isEqualToString:@"suggestPill"]) {
                // 常购清单
                if ([self isLoginThenLoginWithOpenUrl:url]) {
                    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OfftenProductList) setProperty:nil];
                }
                return YES;
            }
        }
    }
    
    return NO;
}

// 开屏广告跳转类型判断
- (void)jumpSplash:(FKYSplashModel *)model
{
    // 无跳转信息则返回不跳转
    if (!model.jumpInfo || model.jumpInfo.length == 0) {
        return;
    }
    
    if (model.jumpType == 2) {
        if (!model.jumpExpandTwo || model.jumpExpandTwo.length == 0) {
            return;
        }
        // 商品详情页
        [self.splashView hideView];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ProdutionDetail) setProperty:^(id<FKY_ProdutionDetail> destinationViewController) {
            // productId: 商品spuCode sellerID:供应商ID
            destinationViewController.productionId = model.jumpInfo;
            destinationViewController.vendorId = model.jumpExpandTwo;
        }];
    }
    else if (model.jumpType == 4) {
        // 店铺主页
        [self.splashView hideView];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_ShopItem) setProperty:^(id<FKY_ShopItem> destinationViewController) {
            destinationViewController.shopId = model.jumpInfo;
        }];
    }
    else if (model.jumpType == 5) {
        // 活动链接
        [self.splashView hideView];
        [self p_openPriveteSchemeString:model.jumpInfo];
        //        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Web) setProperty:^(id<FKY_Web> destinationViewController) {
        //            destinationViewController.urlPath = model.jumpInfo;
        //            NSURL *url = [NSURL URLWithString:model.jumpInfo];
        //            NSDictionary *params = [url parameters];
        //            if (params != nil) {
        //                if (params[@"appNeedTitle"]) {
        //                    NSInteger needTitle = [params[@"appNeedTitle"] integerValue];
        //                    if (needTitle == 1) {
        //                        destinationViewController.barStyle = FKYBarStyleWhite;
        //                    }
        //                }
        //                if (params[@"appFinishAlways"]) {
        //                    NSInteger needTitle = [params[@"appFinishAlways"] integerValue];
        //                    if (needTitle == 1) {
        //                        destinationViewController.isShutDown = true;
        //                    }
        //                }
        //                if (params[@"appTitle"]) {
        //                    NSString * title = [params[@"appTitle"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //                    destinationViewController.barStyle = FKYBarStyleWhite;
        //                    destinationViewController.title = title;
        //                }
        //            }
        //        }];
    }
    else {
        // 其他类型不处理
        [self.splashView hideView];
        [self p_openPriveteSchemeString:model.jumpInfo];
    }
}

@end
