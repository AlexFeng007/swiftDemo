//
//  FKYInputVideoView.h
//  FKY
//
//  Created by 寒山 on 2018/6/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYInputVideoView : UIView

@property (nonatomic, copy) void (^closeBtnClicked)(void);
@property (nonatomic, copy) void (^voiceIsOver)(void);
@property (nonatomic, copy) void (^resultHandler)(NSString *resultStr);
@property (nonatomic, copy) void (^resetSpeechAgainBtn)(void); //重新点击了语言按钮
//展示
- (void)showToVC:(UIViewController *)vc;

/// 点击关闭
@property (nonatomic, copy,class)NSString *closeAction;
/// 搜索有了结果
@property (nonatomic, copy,class)NSString *resultAction;
///重新点击了语言按钮
@property (nonatomic, copy,class)NSString *resetSpeechAgainAction;

@end
