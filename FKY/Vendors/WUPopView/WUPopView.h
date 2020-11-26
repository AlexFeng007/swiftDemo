//
//  WUPopView.h
//  
//
//  Created by Rabe on 10/11/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUPopViewCategories.h"

typedef NS_ENUM(NSUInteger, WUPopType) {
    WUPopTypeAlert,
    WUPopTypeSheet,
    WUPopTypeCustom,
};

@class WUPopView;

typedef void(^WUPopBlock)(WUPopView *);
typedef void(^WUPopCompletion)(WUPopView *, BOOL);


@interface WUPopView : UIView

@property (nonatomic, assign) WUPopType type;                // Default is WUPopTypeAlert.
@property (nonatomic, assign) NSTimeInterval animationDuration;   // Default is 0.3 sec.
@property (nonatomic, assign) BOOL tapDismissEnabled; // Tap window background to dismiss the panel, Default is NO.

@property (nonatomic, copy  ) WUPopCompletion showCompletion;
@property (nonatomic, copy  ) WUPopCompletion hideCompletion;

- (void)show;
- (void)showWithBlock:(WUPopCompletion)block;

- (void)hide;
- (void)hideWithBlock:(WUPopCompletion)block;

@end




typedef void(^WUPopItemHandler)(NSInteger index);

@interface WUPopItem : NSObject

@property (nonatomic, assign) BOOL     highlight;
@property (nonatomic, assign) BOOL     disabled;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor  *color;

@property (nonatomic, copy)   WUPopItemHandler handler;

@end

typedef NS_ENUM(NSUInteger, WUPopItemType) {
    WUPopItemTypeNormal,
    WUPopItemTypeHighlight,
    WUPopItemTypeDisabled
};

NS_INLINE WUPopItem* WUPopItemMake(NSString* title, WUPopItemType type, WUPopItemHandler handler)
{
    WUPopItem *item = [WUPopItem new];
    
    item.title = title;
    item.handler = handler;
    
    switch (type) {
        case WUPopItemTypeNormal: {
            break;
        }
        case WUPopItemTypeHighlight: {
            item.highlight = YES;
            break;
        }
        case WUPopItemTypeDisabled: {
            item.disabled = YES;
            break;
        }
        default:
        break;
    }
    
    return item;
}
