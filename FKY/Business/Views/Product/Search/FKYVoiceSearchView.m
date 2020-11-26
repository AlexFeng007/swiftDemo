//
//  FKYVoiceSearchView.m
//  FKY
//
//  Created by 寒山 on 2018/6/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYVoiceSearchView.h"
static NSString * _inputVoice = nil;
@implementation FKYVoiceSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *micImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_try_mic_new"]];
        micImageView.userInteractionEnabled = YES;
        [self addSubview:micImageView];
        @weakify(self);
        [micImageView bk_whenTapped:^{
            @strongify(self);
            [self routerEventWithName:FKYVoiceSearchView.inputVoice userInfo:@{FKYUserParameterKey:@""}];
            if (self.inputVoiceAction) {
                self.inputVoiceAction();
                
            }
        }];
    
        [micImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(FKYWH(57), FKYWH(57)));
        }];
    }
    return self;
}

+ (NSString *)inputVoice{
    if (!_inputVoice) {
        _inputVoice = @"FKYVoiceSearchView-inputVoice";
    }
    return _inputVoice;
}

@end
