//
//  WUAlertView.h
//  
//
//  Created by Rabe on 10/11/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "WUPopView.h"

typedef void(^WUPopInputHandler)(NSString *text);

@interface WUAlertView : WUPopView

@property (nonatomic, assign) NSUInteger maxInputLength;    // Default is 0. 0 means no limit.

- (instancetype) initWithInputTitle:(NSString*)title
                            message:(NSString*)message
                        placeholder:(NSString*)inputPlaceholder
                            handler:(WUPopInputHandler)inputHandler;

- (instancetype) initWithConfirmTitle:(NSString*)title
                              message:(NSString*)message;

- (instancetype) initWithTitle:(NSString*)title
                       message:(NSString*)message
                         items:(NSArray*)items;
@end



/**
 *  Global Configuration of WUAlertView.
 */
@interface WUAlertViewConfig : NSObject

+ (WUAlertViewConfig*) shared;

@property (nonatomic, assign) CGFloat width;                // Default is 285.
@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 40.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 20.
@property (nonatomic, assign) CGFloat cornerRadius;         // Default is 5.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 18.
@property (nonatomic, assign) CGFloat messageFontSize;      // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #333333.
@property (nonatomic, strong) UIColor *messageColor;        // Default is #333333.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalTextColor;     // Default is #333333. effect with WUPopItemTypeNormal
@property (nonatomic, strong) UIColor *itemHighlightTextColor;  // Default is #E76153. effect with WUPopItemTypeHighlight
@property (nonatomic, strong) UIColor *itemDisableTextColor;    // Default is #CCCCCC. effect with WUPopItemTypeDisabled

@property (nonatomic, strong) UIColor *itemNormalBackgroundColor;       // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *itemHightlightBackgroundColor;   // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *itemPressedBackgroundColor;      // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextOK;      // Default is "好".
@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消".
@property (nonatomic, strong) NSString *defaultTextConfirm; // Default is "确定".

@end
