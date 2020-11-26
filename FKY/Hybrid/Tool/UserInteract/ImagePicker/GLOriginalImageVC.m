//
//  GLOriginalImageVC.m
//  CommonLib
//
//  Created by lily on 15/12/23.
//  Copyright © 2015年 ihome. All rights reserved.
//

#import "GLOriginalImageVC.h"
#import <Masonry/Masonry.h>

@interface GLOriginalImageVC ()

@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *determineButton;

@end

@implementation GLOriginalImageVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - action
- (void)cancelButtonClick:(UIButton *)sender
{
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
}

- (void)determineButtonClick:(UIButton *)sender
{
    if (self.determineBtnBlock) {
        self.determineBtnBlock();
    }
}
#pragma mark - delegate

#pragma mark - notification

#pragma mark - ui
- (void)initView
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.originalImageView];
    [self.view addSubview:self.actionView];
    [self.actionView addSubview:self.cancelButton];
    [self.actionView addSubview:self.determineButton];
    
    
    [self.originalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@67);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.bottom.equalTo(@0).offset(-13);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    [self.determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0).offset(-15);
        make.bottom.equalTo(@0).offset(-13);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
}

#pragma mark - data

#pragma mark - private

#pragma mark - property
- (UIImageView *)originalImageView
{
    if (!_originalImageView) {
        _originalImageView = [UIImageView new];
        _originalImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _originalImageView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)determineButton
{
    if (!_determineButton) {
        _determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_determineButton setTitle:@"确定" forState:UIControlStateNormal];
        [_determineButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_determineButton addTarget:self action:@selector(determineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineButton;
}

- (UIView *)actionView
{
    if (!_actionView) {
        _actionView = [[UIView alloc]init];
        _actionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _actionView;
}
@end
