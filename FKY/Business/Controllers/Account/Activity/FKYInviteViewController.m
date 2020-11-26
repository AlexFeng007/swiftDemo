//
//  FKYInviteViewController.m
//  FKY
//
//  Created by yangyouyong on 16/2/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "FKYInviteViewController.h"
#import <Masonry/Masonry.h>
#import "UIViewController+NavigationBar.h"
#import "UIViewController+ToastOrLoading.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "FKYNavigator.h"
#import "FKYTabBarSchemeProtocol.h"
#import "FKYShareAPI.h"
#import "FKYShareView.h"
#import "FKYLoginAPI.h"

@interface FKYInviteViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *nvBar;
@property (nonatomic, strong) FKYShareView *shareView;
@end

@implementation FKYInviteViewController

@synthesize completeBlock = _completeBlock;

- (void)loadView {
    [super loadView];
    [self setupView];
}

- (void)setupView {
    
    [self fky_setNavigationBarTitle:@"邀请有奖"];
    self.nvBar = [self fky_NavigationBar];
    self.nvBar.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        if (self.completeBlock){
            safeBlock(self.completeBlock);
        }else{
            [[FKYNavigator sharedNavigator] pop];
        }
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    
    self.webView = ({
        UIWebView *webView = [UIWebView new];
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nvBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        NSString *webViewUrlString = [FKY_PC_HOST stringByAppendingString:@"/public/shareInvition"];
        webView.delegate = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               [self showLoading];
               [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webViewUrlString]]];
           });
        });
        webView;
    });
    
    UIImage *image = [UIImage imageNamed:@"icon_account_share"];
    NSString *userCustId = [FKYLoginAPI currentUser].custId;
    NSString *urlString = [NSString stringWithFormat:@"%@/public/inviteCoupon?cssid=%@" , FKY_PC_HOST,userCustId];
    NSLog(@"shareUrl %@",urlString);
    self.shareView = [FKYShareAPI showShareViewWithURL:[NSURL URLWithString:urlString]
                                title:@"来1药城领红包!"
                          description:@"新用户首单立减50元，1药城是1药网旗下药品特价采购平台!"
                     previewImageData:UIImagePNGRepresentation(image)
                        completeBlock:^(BOOL success){
                            safeBlock(self.completeBlock);
                        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"shareInvition"] = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shareView.appearBlock();
        });
    };
    [self dismissLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self dismissLoading];
    [self toast:error.localizedDescription];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
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
