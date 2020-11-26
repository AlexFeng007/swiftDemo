//
//  FKYPaymentWebViewController.m
//  FKY
//
//  Created by yangyouyong on 15/11/30.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYPaymentWebViewController.h"
#import <Masonry/Masonry.h>
#import "UIViewController+NavigationBar.h"
#import "FKYNavigator.h"
#import "UIViewController+ToastOrLoading.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "FKYNavigator.h"
#import "FKYTabBarSchemeProtocol.h"
#import "FKYAccountSchemeProtocol.h"
#import "NSString+Contains.h"
#import "FKYTabBarController.h"
#import "FKY-Swift.h"
#import "UIButton+FKYKit.h"
#import "NSString+Trims.h"

@interface FKYPaymentWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *nvBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) PaymentSuccessView *successView;
@property (nonatomic, assign) BOOL isPayFinished;

@end


@implementation FKYPaymentWebViewController
@synthesize webHTMLString = _webHTMLString, schemeString = _schemeString;

- (void)loadView
{
    [super loadView];
    [self setupView];
}

- (void)setupView
{
    self.nvBar = [self fky_NavigationBar];
    [self fky_setNavigationBarTitle:@"在线支付"];
    [self fky_setNavigationBarBottomLineHidden:false];
    self.nvBar.backgroundColor = UIColorFromRGB(0xffffff);
    [self fky_setTitleColor:[UIColor blackColor]];
    @weakify(self);
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        @strongify(self);
        if (self.isPayFinished) {
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController)
                                           setProperty:^(id<FKY_TabBarController> destinationViewController) {
                                               destinationViewController.index = 0;
                                               if(self.schemeString){
                                                   [[FKYNavigator sharedNavigator] openScheme:NSProtocolFromString(self.schemeString) setProperty:nil];
                                               }
                                           }];
        }
        else {
            [FKYProductAlertView showAlertViewWithTitle:nil
                                              leftTitle:@"继续支付"
                                             rightTitle:@"放弃支付"
                                                message:@"确定要放弃支付"
                                                handler:^(FKYProductAlertView *alertView, BOOL isRight) {
                                                    if (isRight) {
                                                        if (self.schemeString) {
                                                            [[FKYNavigator sharedNavigator] popToScheme:NSProtocolFromString(self.schemeString)];
                                                        }else{
                                                            [[FKYNavigator sharedNavigator] popToScheme:@protocol(FKY_TabBarController)];
                                                        }
                                                        FKYNavigationController *nvController = [FKYNavigator sharedNavigator].topNavigationController;
                                                        nvController.dragBackDelegate = nil;
                                                    }
                                                }];
//            [[FKYNavigator sharedNavigator] pop];
        }
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    
    self.successView = ({
        PaymentSuccessView *v = [PaymentSuccessView new];
        [self.view addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nvBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(FKYWH(-62));
        }];
        v;
    });
    
    self.bottomBar = ({
        UIView *bar = [UIView new];
        bar.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [self.view addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@(FKYWH(62)));
        }];
        
        UIButton *cancelBtn = [UIButton new];
        [bar addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(FKYWH(20)));
            make.top.equalTo(@(FKYWH(10)));
            make.height.equalTo(@(FKYWH(42)));
            make.width.equalTo(@(FKYWH(154)));
        }];
        cancelBtn.btnStyle = BTN17;
        cancelBtn.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [cancelBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fky://account/allorders"]]) {
                 if (iOS10Later()) {
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fky://account/allorders"] options:@{} completionHandler:nil];
                 }else{
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fky://account/allorders"]];
                 }
             }
         }];
        
        UIButton *buyBtn = [UIButton new];
        [bar addSubview:buyBtn];
        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(FKYWH(-20)));
            make.top.equalTo(@(FKYWH(10)));
            make.height.equalTo(@(FKYWH(42)));
            make.width.equalTo(@(FKYWH(154)));
        }];
        buyBtn.btnStyle = BTN1;
        buyBtn.backgroundColor = UIColorFromRGB(0xfe5050);
        [buyBtn setTitle:@"继续购买" forState:UIControlStateNormal];
        [[buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
                 destinationViewController.index = 0;
             }];
         }];
        bar;
    });
    
    // 支付失败页
    self.webView = ({
        UIWebView *webView = [UIWebView new];
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nvBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        webView.delegate = self;
        webView;
    });
    
    // 支付成功页面
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //js调用iOS
    //第一种情况
    //其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
    context[@"backToOrderClick"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:@"fky://account/allorders"];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        });
        NSLog(@"backToOrder clicked");
    };
    
    context[@"backToMainClick"] = ^{
                dispatch_async(dispatch_get_main_queue(), ^{
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController)
                                       setProperty:^(id<FKY_TabBarController> destinationViewController) {
                                           destinationViewController.index = 0;
                                       }];
                            });
        NSLog(@"backToMain clicked");
    };
    
    context[@"backToShare"] = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_InviteViewController)];
        });
        NSLog(@"backToMain clicked");
    };
    
    // 获取标签值, 判断是否支付失败
    if ([webView.request.URL.absoluteString isEqualToString:@"file://www.fangkuaiyi.com"]) {
        NSLog(@"localUrlString");
    }
    NSLog(@"webview request ____ %@", webView.request.URL);
    
    NSString *payFailTag = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('payFail').innerHTML"];
    NSLog(@"pay_faile:");
    NSLog(@"pay_faile_tag:");
    payFailTag = [payFailTag stringByStrippingHTML];
    payFailTag = [payFailTag stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    payFailTag = [payFailTag stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if (payFailTag.length > 0) {
        // 支付失败
//        [FKYProductAlertView showAlertViewWithTitle:nil
//                                          leftTitle:@"确定"
//                                         rightTitle:@"取消"
//                                            message:payFailTag
//                                            handler:nil];
    }
    NSLog(@"%@",payFailTag);
    [self dismissLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString containsaString:@"transNumber="]) {
        [self dismissLoading];
    }
    if ([request.URL.absoluteString containsaString:@"pay.yaoex.com/orderPay/chinaPayAppSubmitSuccess"]) {
        // 支付成功
        [self dismissLoading];
//        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_PaySuccess) setProperty:nil isModal:NO animated:NO];
        [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_OrderPayStatus) setProperty:^(id destinationViewController) {
            FKYOrderPayStatusVC *paySuccessVC = (FKYOrderPayStatusVC*)destinationViewController;
            paySuccessVC.fromePage = 6;
        } isModal:false animated:false];
        return NO;
    }
    NSLog(@"%@",request);
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self toast:error.localizedDescription];
    [self dismissLoading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isPayFinished = NO;
    [self showLoading];
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.webView loadHTMLString:self.webHTMLString
                            baseURL:[NSURL URLWithString:@"www.fangkuaiyi.com"]];
    });
    if (self.webHTMLString.length <= 0) {
        // 支付成功页面
    }
    
    //[[FKYAnalyticsManager sharedInstance] BI_Record:self extendParams:nil eventId:@"PaySuccess"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
