//
//  WUAlertView.m
//  
//
//  Created by Rabe on 10/11/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "WUAlertView.h"
#import <Masonry/Masonry.h>
#import "WUPopViewCategories.h"

@interface WUAlertView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) NSArray *actionItems;

@property (nonatomic, copy) WUPopInputHandler inputHandler;

@end

@implementation WUAlertView

- (instancetype) initWithInputTitle:(NSString*)title
                            message:(NSString*)message
                        placeholder:(NSString*)inputPlaceholder
                            handler:(WUPopInputHandler)inputHandler
{
    WUAlertViewConfig *config = [WUAlertViewConfig shared];
    
    NSArray *items =@[
                      WUPopItemMake(config.defaultTextCancel, WUPopItemTypeHighlight, nil),
                      WUPopItemMake(config.defaultTextConfirm, WUPopItemTypeHighlight, nil)
                      ];
    return [self initWithTitle:title message:message items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler];
}

- (instancetype) initWithConfirmTitle:(NSString*)title
                              message:(NSString*)message
{
    WUAlertViewConfig *config = [WUAlertViewConfig shared];
    
    NSArray *items =@[
                      WUPopItemMake(config.defaultTextOK, WUPopItemTypeHighlight, nil)
                      ];
    
    return [self initWithTitle:title message:message items:items];
}

- (instancetype) initWithTitle:(NSString*)title
                       message:(NSString*)message
                         items:(NSArray*)items
{
    return [self initWithTitle:title message:message items:items inputPlaceholder:nil inputHandler:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        items:(NSArray *)items
             inputPlaceholder:(NSString *)inputPlaceholder
                 inputHandler:(WUPopInputHandler)inputHandler
{
    self = [super init];
    
    if ( self ) {
        NSAssert(items.count>0, @"没有配置按钮items数组.");
        
        WUAlertViewConfig *config = [WUAlertViewConfig shared];
        
        self.type = WUPopTypeAlert;
        self.inputHandler = inputHandler;
        self.actionItems = items;
        
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        self.layer.borderWidth = WU_SPLIT_WIDTH;
        self.layer.borderColor = config.splitColor.CGColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(config.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 ) {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
            }];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:config.titleFontSize];
            self.titleLabel.numberOfLines = 5;
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.mas_bottom;
        }
        
        if ( message.length > 0 ) {
            self.messageLabel = [UILabel new];
            [self addSubview:self.messageLabel];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
            }];
            self.messageLabel.textColor = config.messageColor;
            self.messageLabel.textAlignment = NSTextAlignmentLeft;
            self.messageLabel.font = [UIFont systemFontOfSize:config.messageFontSize];
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.backgroundColor = self.backgroundColor;
            self.messageLabel.text = message;
            
            lastAttribute = self.messageLabel.mas_bottom;
        }
        
        if ( self.inputHandler ) {
            self.inputView = [UITextField new];
            [self addSubview:self.inputView];
            [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(10);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
                make.height.mas_equalTo(40);
            }];
            self.inputView.backgroundColor = self.backgroundColor;
            self.inputView.layer.borderWidth = WU_SPLIT_WIDTH;
            self.inputView.layer.borderColor = config.splitColor.CGColor;
            self.inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            self.inputView.leftViewMode = UITextFieldViewModeAlways;
            self.inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.inputView.placeholder = inputPlaceholder;
            
            lastAttribute = self.inputView.mas_bottom;
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(config.innerMargin);
            make.left.right.equalTo(self);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i ) {
            WUPopItem *item = items[i];
            
            UIButton *btn = [UIButton wu_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if ( items.count <= 2 ) {
                    make.top.bottom.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    
                    if ( !firstButton ) {
                        firstButton = btn;
                        make.left.equalTo(self.buttonView.mas_left).offset(config.innerMargin);
                        make.bottom.equalTo(self.buttonView.mas_bottom).offset(-config.innerMargin);
                    }
                    else {
                        make.left.equalTo(lastButton.mas_right).offset(config.innerMargin);
                        make.width.equalTo(lastButton);
                        make.bottom.equalTo(lastButton);
                    }
                }
                else
                    {
                    make.left.right.equalTo(self.buttonView);
                    make.height.mas_equalTo(config.buttonHeight);
                    
                    if ( !firstButton ) {
                        firstButton = btn;
                        make.top.equalTo(self.buttonView.mas_top).offset(-WU_SPLIT_WIDTH);
                    }
                    else {
                        make.top.equalTo(lastButton.mas_bottom).offset(-WU_SPLIT_WIDTH);
                        make.width.equalTo(firstButton);
                    }
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage wu_imageWithColor:item.highlight?config.itemHightlightBackgroundColor:config.itemNormalBackgroundColor] forState:UIControlStateNormal];
//            [btn setBackgroundImage:[UIImage wu_imageWithColor:config.itemPressedBackgroundColor] forState:UIControlStateHighlighted];
            // 修复highlighted展示状态下按压btn时btn消失的bug
            [btn setBackgroundImage:[UIImage wu_imageWithColor:item.highlight?config.itemHightlightBackgroundColor:config.itemPressedBackgroundColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage wu_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
            [btn setTitleColor:item.highlight?config.itemHighlightTextColor:item.disabled?config.itemDisableTextColor:config.itemNormalTextColor forState:UIControlStateNormal];
            if (!item.highlight || items.count > 2 || self.backgroundColor.hash == config.itemHightlightBackgroundColor.hash) {
                btn.layer.borderWidth = WU_SPLIT_WIDTH;
                btn.layer.borderColor = config.splitColor.CGColor;
            }
            if (items.count <= 2) {
                btn.layer.cornerRadius = config.cornerRadius;
                btn.layer.masksToBounds = YES;
            }
            btn.titleLabel.font = item.highlight?[UIFont boldSystemFontOfSize:config.buttonFontSize]:[UIFont systemFontOfSize:config.buttonFontSize];
        }
        
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            if ( items.count <= 2 ) {
                make.right.equalTo(self.buttonView.mas_right).offset(-config.innerMargin);
            }
            else {
                make.bottom.equalTo(self.buttonView.mas_bottom).offset(WU_SPLIT_WIDTH);
            }
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buttonView.mas_bottom);
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)actionButton:(UIButton*)btn
{
    WUPopItem *item = self.actionItems[btn.tag];
    
    if ( item.disabled ) {
        return;
    }
    
    [self hide];
    
    if ( self.inputHandler && (btn.tag>0) ) {
        self.inputHandler(self.inputView.text);
    }
    else {
        if ( item.handler ) {
            item.handler(btn.tag);
        }
    }
}

- (void)notifyTextChange:(NSNotification *)n
{
    if ( self.maxInputLength == 0 ) {
        return;
    }
    
    if ( n.object != self.inputView ) {
        return;
    }
    
    UITextField *textField = self.inputView;
    
    NSString *toBeString = textField.text;
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.maxInputLength) {
            textField.text = [toBeString wu_truncateByCharLength:self.maxInputLength];
        }
    }
}

- (void)showKeyboard
{
    [self.inputView becomeFirstResponder];
}

- (void)hideKeyboard
{
    [self.inputView resignFirstResponder];
}

@end


@interface WUAlertViewConfig()

@end

@implementation WUAlertViewConfig

+ (WUAlertViewConfig *)shared
{
    static WUAlertViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [WUAlertViewConfig new];
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        self.width          = SCREEN_WIDTH - FKYWH(25) * 2;
        self.buttonHeight   = FKYWH(40);
        self.innerMargin    = FKYWH(15);
        self.cornerRadius   = FKYWH(5);
        
        self.titleFontSize      = FKYWH(18);
        self.messageFontSize    = FKYWH(14);
        self.buttonFontSize     = FKYWH(17);
        
        self.backgroundColor    = [UIColor wu_colorWithHex:0xFFFFFFFF];
        self.titleColor         = [UIColor wu_colorWithHex:0x333333FF];
        self.messageColor       = [UIColor wu_colorWithHex:0x333333FF];
        self.splitColor         = [UIColor wu_colorWithHex:0xCCCCCCFF];
        
        self.itemNormalTextColor    = [UIColor wu_colorWithHex:0x333333FF];
        self.itemHighlightTextColor = [UIColor wu_colorWithHex:0xE76153FF];
        self.itemDisableTextColor   = [UIColor wu_colorWithHex:0xCCCCCCFF];
        
        self.itemNormalBackgroundColor = [UIColor wu_colorWithHex:0xFFFFFFFF];
        self.itemHightlightBackgroundColor = [UIColor wu_colorWithHex:0xFFFFFFFF];
        self.itemPressedBackgroundColor   = [UIColor wu_colorWithHex:0xFFFFFFFF];
        
        self.defaultTextOK      = @"好";
        self.defaultTextCancel  = @"取消";
        self.defaultTextConfirm = @"确定";
    }
    
    return self;
}

@end

