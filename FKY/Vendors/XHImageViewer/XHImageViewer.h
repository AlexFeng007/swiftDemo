//
//  XHImageViewer.h
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+XHURLDownload.h"

@class XHImageViewer;


@protocol XHImageViewerDelegate <NSObject>

@optional
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView pageIndex:(NSInteger)index;

- (void)imageViewerDidDismissFromSuperView;

@end


@interface XHImageViewer : UIView

@property (nonatomic, weak) id<XHImageViewerDelegate> delegate;
@property (nonatomic, assign) CGFloat backgroundScale;

// 默认不展示PageControl
@property (nonatomic, assign) BOOL showPageControl; // 是否显示PageControl
@property (nonatomic, assign) BOOL userPageNumber;  // PageControl使用数字or点
@property (nonatomic, assign) BOOL hideWhenOnlyOne; // 仅一张图片时是否隐藏PageControl

// 保存图片
@property (nonatomic, assign) BOOL showSaveBtn;     // 是否显示保存图片按钮

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView;

@end
