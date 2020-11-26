//
//  FKYSearchBar.m
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYSearchBar.h"
#import "FKYDefines.h"
#import "UIButton+FKYKit.h"
#import "FKY-Swift.h"

@interface FKYSearchBar () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *leftIcon;
@property (nonatomic, strong) UIButton *rightIcon;
@property (nonatomic, strong) UIView *line;
/// TFleftView
@property (nonatomic, strong) UIView *TFLeftMarginView;
/// 容器视图
@property (nonatomic, strong) UIView *containerView;
/// 右边搜索按钮
@property (nonatomic,strong)UIButton *searchButton;

@end

static NSString * _searchAction = nil;
@implementation FKYSearchBar

- (instancetype)initWithLeftIconType:(LeftIconStyle)leftIconStyle
{
    if (self = [super init]) {
        //self.backgroundColor = UIColorFromRGB(0xf4f4f4);
        self.leftIconSyle = leftIconStyle;
        [self setupView];
    }
    return self;
}


/// 新的UI样式
- (void)newUIStyleLayout{
    self.leftIcon.hidden = true;
    self.line.hidden = true;
    self.rightIcon.hidden = true;
    self.containerView.layer.cornerRadius = FKYWH(17);
    self.containerView.layer.masksToBounds = true;
    self.containerView.backgroundColor = RGBACOLOR(244, 244, 244, 1);
    [self.containerView addSubview:self.searchButton];
    [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.containerView);
        make.right.equalTo(self.searchButton.mas_left).offset(0);
    }];
    
    [self.searchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView).offset(FKYWH(-4));
        make.centerY.equalTo(self.containerView);
        make.height.mas_equalTo(FKYWH(26));
        make.width.equalTo(self.containerView).multipliedBy(63.0/348);
    }];
}

- (void)setupView
{
    self.containerView.layer.cornerRadius = FKYWH(4);
    self.containerView.layer.masksToBounds = true;
    self.leftIcon.hidden = false;
    self.line.hidden = false;
    self.rightIcon.hidden = false;
    self.containerView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    switch (self.leftIconSyle) {
        case LeftIconStyle_SearchIcon:
            self.leftIcon = ({
                UIButton *button = [[UIButton alloc] init];
                [self addSubview:button];
                [button setImage:[UIImage imageNamed:@"icon_search_gray"] forState:UIControlStateNormal];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@(FKYWH(20)));
                    make.centerY.equalTo(self);
                    make.left.equalTo(self.mas_left).offset(FKYWH(7.5));
                }];
                button;
            });
            break;
        case LeftIconStyle_SearchIconNone:
            self.leftIcon = ({
                UIButton *button = [[UIButton alloc] init];
                [self addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@(FKYWH(0)));
                    make.centerY.equalTo(self.mas_centerY);
                    make.width.equalTo(@(FKYWH(0)));
                    make.height.equalTo(self.mas_height);
                }];
                button;
            });
            break;
        case LeftIconStyle_TypeList:
        default:
            self.leftIcon = ({
                UIButton *button = [[UIButton alloc] init];
                [self addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@(FKYWH(0)));
                    make.centerY.equalTo(self.mas_centerY);
                    make.width.equalTo(@(FKYWH(55)));
                    make.height.equalTo(self.mas_height);
                }];
                [button setTitle:@"商品" forState:UIControlStateNormal];
                button.titleLabel.font = FKYSystemFont(FKYWH(14));
                [button setTitleColor:UIColorFromRGB(0xFF2D5C) forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"icon_search_arrow_down_red"] forState:UIControlStateNormal];
                [button setTitleLeftAndImageRightWithSpace:FKYWH(5)];
                @weakify(self);
                [button bk_addEventHandler:^(id sender) {
                    @strongify(self);
                    safeBlock(self.selectedSearchType);
                } forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            break;
    }
    
    self.line = ({
        UIView *line = [[UIView alloc] init];
        [self.containerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftIcon.mas_right);
            make.top.equalTo(self.containerView.mas_top).offset(FKYWH(2));
            make.bottom.equalTo(self.containerView.mas_bottom).offset(FKYWH(-2));
            make.width.equalTo(@(0.5));
        }];
        line.backgroundColor = UIColorFromRGB(0xE5E5E5);
        line;
    });
    
    self.inputTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.delegate = self;
        textField.leftView = self.TFLeftMarginView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.backgroundColor = [UIColor clearColor];
        textField.tintColor = UIColorFromRGB(0xFF2D5C);
        textField.keyboardType = UIKeyboardTypeWebSearch;
        textField.returnKeyType = UIReturnKeySearch;
        textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        textField.textAlignment = NSTextAlignmentLeft;
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.font = FKYSystemFont(FKYWH(12.5));
        textField.textColor = UIColorFromRGB(0x333333);
        textField.placeholder = self.placeholder;
        [textField addTarget:self action:@selector(inputTextChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [self.containerView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftIcon.mas_right).offset(FKYWH(8));
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.right.equalTo(self.containerView.mas_right);
            make.height.equalTo(self.containerView.mas_height);
        }];
        textField;
    });
    
    self.rightIcon = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.containerView addSubview:btn];
        btn.hidden = YES;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(FKYWH(-12)));
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.width.equalTo(@(FKYWH(20)));
            make.height.equalTo(@(FKYWH(20)));
        }];
        [btn setImage:[UIImage imageNamed:@"icon_search_clear"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearInputText) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    //[self.containerView addSubview:self.inputTextField];
    
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapped)];
    [self addGestureRecognizer:tap];
}


#pragma mark - setter & getter

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.inputTextField.placeholder = placeholder;
}

- (NSString *)text
{
    return self.inputTextField.text;
}

- (void)setText:(NSString *)text
{
    self.inputTextField.text = text;
}

- (void)setLeftIconName:(NSString *)title
{
    [self.leftIcon setTitle:title forState:UIControlStateNormal];
}

- (void)placeholderChange:(NSString *)text
{
    _placeholder = text;
    self.inputTextField.placeholder = text;
}

#pragma mark - 事件响应
- (void)searchBtnClicked{
    [self routerEventWithName:FKYSearchBar.searchAction userInfo:@{FKYUserParameterKey:self}];
}

#pragma mark - Action

- (void)selfTapped
{
    [self.inputTextField becomeFirstResponder];
}

- (void)clearInputText
{
    self.inputTextField.text = nil;
    [self.inputTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    [self.inputTextField resignFirstResponder];
}

- (void)setRightIconHidden:(BOOL)hidden
{
    // self.rightIcon.hidden = hidden;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidEndEditing:)]) {
        [self.delegate searchBar:self textDidEndEditing:textField.text];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string != nil && range.location != NSNotFound){
        NSMutableString *str = [NSMutableString stringWithString:textField.text];
        [str replaceCharactersInRange:range withString:string];
        if ([self.delegate respondsToSelector:@selector(searchBar:textFieldidChangingText:)]) {
            [self.delegate searchBar:self textFieldidChangingText:str];
        }
    }
    return true;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(searchBar:textFieldDidBeginEditing:)]) {
        [self.delegate searchBar:self textFieldDidBeginEditing:textField.text];
    }
}

- (void)inputTextChanged:(UITextField *)textField
{
    UITextRange *selectedRange = [textField markedTextRange];
    NSString *newText = [textField textInRange:selectedRange];
    // 有未选中的字符
    if (newText && newText.length > 0) {
        return;
    }
    
    // 过滤表情符
    if ([NSString stringContainsEmoji:textField.text] || [NSString hasEmoji:textField.text]) {
        textField.text = [NSString disableEmoji:textField.text];
    }
    
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchBarTextClear)]) {
        [self.delegate searchBarTextClear];
    }
    return YES;
}


#pragma mark - override

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    [self.inputTextField resignFirstResponder];
    return YES;
}

- (void)setInnerUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    self.inputTextField.userInteractionEnabled = userInteractionEnabled;
    self.leftIcon.userInteractionEnabled = userInteractionEnabled;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = FKYWH(4);
    // self.layer.borderWidth = FKYWH(0.5);
    //self.layer.borderColor = UIColorFromRGB(0xebedec).CGColor;
    self.layer.masksToBounds = YES;
}



- (UIView *)containerView{
    if(!_containerView){
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = RGBACOLOR(244, 244, 244, 1);
    }
    return _containerView;
}

- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc]init];
        _searchButton.backgroundColor = RGBCOLOR(255, 255, 255);
        [_searchButton addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont boldSystemFontOfSize:FKYWH(14)];
        _searchButton.layer.cornerRadius = FKYWH(13);
        _searchButton.layer.masksToBounds = true;
        _searchButton.layer.borderColor = RGBCOLOR(229, 229, 229).CGColor;
        _searchButton.layer.borderWidth = 1;
    }
    return _searchButton;
}

-(UIView *)TFLeftMarginView{
    if (!_TFLeftMarginView) {
        _TFLeftMarginView = [[UIView alloc]init];
        _TFLeftMarginView.backgroundColor = [UIColor clearColor];
        _TFLeftMarginView.hd_width = FKYWH(10);
    }
    return _TFLeftMarginView;
}

+ (NSString *)searchAction{
    if (!_searchAction) {
        _searchAction = @"FKY_search";
    }
    return _searchAction;
}

@end

