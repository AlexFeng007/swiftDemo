//
//  FKYVoiceSearchView.h
//  FKY
//
//  Created by 寒山 on 2018/6/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKYVoiceSearchView : UIView

@property (nonatomic, copy) void(^inputVoiceAction)(void);

/// 开始语音输入
@property (nonatomic, copy,class)NSString *inputVoice;

@end
