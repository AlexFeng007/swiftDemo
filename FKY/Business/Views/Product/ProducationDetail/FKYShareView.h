//
//  FKYShareView.h
//  FKY
//
//  Created by mahui on 15/9/22.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^shareBlock)(void);

@interface FKYShareView : UIView

@property (nonatomic, copy) shareBlock WXShareBlock;
@property (nonatomic, copy) shareBlock WXFriendShareBlock;
@property (nonatomic, copy) shareBlock QQShareBlock;
@property (nonatomic, copy) shareBlock appearBlock;
@property (nonatomic, copy) shareBlock dismissBlock;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *descrip;
@property (nonatomic, strong) NSData *previewImageData;

@end
