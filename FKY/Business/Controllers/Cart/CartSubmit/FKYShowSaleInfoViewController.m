//
//  FKYShowSaleInfoViewController.m
//  FKY
//
//  Created by 夏志勇 on 2017/11/1.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYShowSaleInfoViewController.h"
#import <Masonry/Masonry.h>
#import "BlocksKit+UIKit.h"
#import "XHImageViewer.h"


@interface FKYShowSaleInfoViewController () <XHImageViewerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *navBar;           // 导航栏
@property (nonatomic, strong) UIView *viewTip;          // 提示
@property (nonatomic, strong) UIImageView *imgviewPic;  // 销售单图片

@property (nonatomic, strong) UIImageView *imgviewShow; // 过渡动画中使用到的展示图片

@property (nonatomic, strong) UIScrollView *scrollview; //

@end


@implementation FKYShowSaleInfoViewController

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
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


#pragma mark - setupView

- (void)setupView
{
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    // 导航栏
    self.navBar = [self fky_NavigationBar];
    self.navBar.backgroundColor = [UIColor whiteColor];
    
    // 导航栏底部分隔线
    UIView *viewLine = [UIView new];
    viewLine.backgroundColor = [UIColorFromRGB(0x999999) colorWithAlphaComponent:0.6];
    [self.navBar addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navBar);
        make.height.equalTo(@(FKYWH(0.5)));
    }];
    
    // 导航栏设置
   // if (_isSaleContract){
        [self fky_setupNavigationBarWithTitle:@"销售合同示例"];
//    }else{
//        [self fky_setupNavigationBarWithTitle:@"销售单示例"];
//    }
    
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_setTitleColor:[UIColor blackColor]];
    [self fky_addNavitationBarBackButtonEventHandler:^(id sender) {
        [[FKYNavigator sharedNavigator] pop];
    }];
    [self fky_setNavitationBarLeftButtonImage:[UIImage imageNamed:@"icon_back_new_red_normal"]];
    
    // 内容
    [self.view addSubview:self.viewTip];
//    [self.view addSubview:self.imgviewPic];
    
    [self.viewTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(FKYWH(40));
    }];
//    [self.imgviewPic mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.viewTip.mas_bottom);
//    }];
    
    [self.view addSubview:self.scrollview];
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.viewTip.mas_bottom);
    }];
    
//    [self.scrollview addSubview:self.imgviewPic];
//    [self.imgviewPic mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = width * 448 / 719;
    CGFloat x = 0;
    CGFloat y = (SCREEN_HEIGHT - 20 - 44 - FKYWH(40) - height) / 2;
    self.imgviewPic.frame = CGRectMake(x, y, width, height);
    [self.scrollview addSubview:self.imgviewPic];
    self.scrollview.contentSize = CGSizeMake(width, SCREEN_HEIGHT - 20 - 44 - FKYWH(40));
//    if (_isSaleContract){
//        [_imgviewPic loadWithURL:[NSURL URLWithString:@"http://yhycstatic.yaoex.com/pc/shoppingV2/checkorder/images/img_saleInfo@2x.png"] placeholer:[UIImage imageNamed:@"image_default_img"] showActivityIndicatorView:NO];
//    }else{
        _imgviewPic.image = [UIImage imageNamed:@"img_saleInfo"];
//    }
}


#pragma mark - Private

- (void)showSaleInfoPic
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:[NSArray arrayWithObjects:self.imgviewShow, nil] selectedView:self.imgviewShow];
}


#pragma mark - XHImageViewerDelegate

- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView*)selectedView
{
    //
}

- (void)imageViewerDidDismiss
{
    if (self.imgviewShow.superview) {
        [self.imgviewShow removeFromSuperview];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgviewPic;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGRect frame = self.imgviewPic.frame;
    
    frame.origin.y = (self.scrollview.frame.size.height - self.imgviewPic.frame.size.height) > 0 ? (self.scrollview.frame.size.height - self.imgviewPic.frame.size.height) * 0.5 : 0;
    frame.origin.x = (self.scrollview.frame.size.width - self.imgviewPic.frame.size.width) > 0 ? (self.scrollview.frame.size.width - self.imgviewPic.frame.size.width) * 0.5 : 0;
    self.imgviewPic.frame = frame;
    
    self.scrollview.contentSize = CGSizeMake(self.imgviewPic.frame.size.width, self.imgviewPic.frame.size.height);
}


#pragma mark - Property

- (UIView *)viewTip
{
    if (!_viewTip) {
        _viewTip = [UIView new];
        _viewTip.backgroundColor = [UIColorFromRGB(0xD8D8D8) colorWithAlphaComponent:0.22];
        
        UILabel *lbl = [UILabel new];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"可放大查看";
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.textColor = UIColorFromRGB(0x494949);
        lbl.font = FKYSystemFont(FKYWH(14));
        [_viewTip addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_viewTip).offset(FKYWH(10));
            make.centerY.equalTo(self->_viewTip);
            make.height.mas_equalTo(FKYWH(22));
        }];
    }
    return _viewTip;
}

- (UIImageView *)imgviewPic
{
    if (!_imgviewPic) {
        _imgviewPic = [[UIImageView alloc] init];
        _imgviewPic.contentMode = UIViewContentModeScaleAspectFit;
//        _imgviewPic.userInteractionEnabled = YES;
//        @weakify(self);
//        [_imgviewPic bk_whenTapped:^{
//            @strongify(self);
//            [self showSaleInfoPic];
//        }];
    }
    return _imgviewPic;
}

- (UIImageView *)imgviewShow
{
    if (!_imgviewShow) {
        CGFloat width = SCREEN_WIDTH;
        CGFloat height = width * 448 / 719;
        CGFloat x = 0;
        CGFloat y = (SCREEN_HEIGHT - 20 - 44 - FKYWH(40) - height) / 2 + (20 + 44 + FKYWH(40));
        
        _imgviewShow = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _imgviewShow.image = self.imgviewPic.image;
        _imgviewShow.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgviewShow;
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollview.delegate = self;
        _scrollview.backgroundColor = [UIColor clearColor];
        _scrollview.minimumZoomScale = 1.0;
        _scrollview.maximumZoomScale = 2.2;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
    }
    return _scrollview;
}

@end
