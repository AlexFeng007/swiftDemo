//
//  WUAlertSheet.h
//  
//
//  Created by Rabe on 10/11/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "WUPopView.h"

@interface WUAlertSheet : WUPopView

- (instancetype) initWithTitle:(NSString*)title
                         items:(NSArray*)items;

@end


/**
 *  Global Configuration of WUAlertSheet.
 */
@interface WUAlertSheetConfig : NSObject

+ (WUAlertSheetConfig*) shared;

@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 19.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #666666.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with WUPopItemTypeNormal
@property (nonatomic, strong) UIColor *itemDisableColor;    // Default is #CCCCCC. effect with WUPopItemTypeDisabled
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with WUPopItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消"

@end
