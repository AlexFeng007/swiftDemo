//
//  FKYInputVideoView.m
//  FKY
//
//  Created by 寒山 on 2018/6/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYInputVideoView.h"
#import <iflyMSC/iflyMSC.h>
#import "FKYISRDataHelper.h"
#import "BIAudioWaveView.h"

@interface FKYInputVideoView()<IFlySpeechRecognizerDelegate, UIGestureRecognizerDelegate>
{
    int _volumeLevel;
}

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, strong) NSMutableString *voiceAllStr;


@property (nonatomic, strong) UIView *subSpeechView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *speechTitleLabel;
@property (nonatomic, strong) UILabel *speechTipLabel;
@property (nonatomic, strong) UIButton *tryMicBtn;

@property (nonatomic, strong) CADisplayLink *disPlayLink;
@property (nonatomic, strong) BIAudioWaveView *waveView;
@end
static NSString * _closeAction = nil;
static NSString * _resultAction = nil;
static NSString * _resetSpeechAgainAction = nil;
@implementation FKYInputVideoView
-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initIflyMSCParam];
        [self configViews];
        [self addTapGesture];
    }
    return self;
}

- (void)dealloc{
    if (_iFlySpeechRecognizer != nil){
        [_iFlySpeechRecognizer cancel];
        [_iFlySpeechRecognizer setDelegate:nil];
    }
}
#pragma mark - UI
- (void)configViews {
    [self addSubview:self.subSpeechView];
    [self.subSpeechView addSubview:self.closeBtn];
    [self.subSpeechView addSubview:self.speechTitleLabel];
    [self.subSpeechView addSubview:self.speechTipLabel];
    [self.subSpeechView addSubview:self.tryMicBtn];
    [self.subSpeechView addSubview:self.waveView];
    
    [self.subSpeechView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.mas_equalTo(FKYWH(400));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subSpeechView).offset(FKYWH(15));
        make.right.equalTo(self.subSpeechView).offset(-FKYWH(15));
        make.size.mas_offset(CGSizeMake(FKYWH(30), FKYWH(30)));
    }];
    
    [self.speechTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subSpeechView).offset(FKYWH(15));
        make.right.equalTo(self.subSpeechView).offset(-FKYWH(15));
        make.top.equalTo(self.closeBtn.mas_bottom).offset(FKYWH(15));
    }];
    
    [self.speechTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.speechTitleLabel);
        make.top.equalTo(self.speechTitleLabel.mas_bottom).offset(FKYWH(20));
    }];

    [self.tryMicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.subSpeechView);
        make.top.equalTo(self.speechTipLabel.mas_bottom).offset(FKYWH(40));
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speechTipLabel.mas_bottom).offset(FKYWH(40));
        make.height.mas_equalTo(35);
        make.left.equalTo(self.subSpeechView).offset(FKYWH(70));
        make.right.equalTo(self.subSpeechView).offset(-FKYWH(70));
    }];
    
    [self layoutIfNeeded];
}


#pragma mark -- lazy
- (UIView *)subSpeechView {
    if (!_subSpeechView) {
        _subSpeechView = [[UIView alloc] initWithFrame:CGRectZero];
        _subSpeechView.backgroundColor = [UIColor whiteColor];
        _subSpeechView.layer.cornerRadius = FKYWH(20);
        _subSpeechView.clipsToBounds = YES;
    }
    return _subSpeechView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_pd_group_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closePopView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)speechTitleLabel {
    if (!_speechTitleLabel) {
        _speechTitleLabel = [[UILabel alloc] init];
        _speechTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _speechTitleLabel.adjustsFontSizeToFitWidth = YES;
        _speechTipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _speechTitleLabel.font = FKYBoldSystemFont(FKYWH(20));
    }
    return _speechTitleLabel;
}

- (UILabel *)speechTipLabel {
    if (!_speechTipLabel) {
        _speechTipLabel = [[UILabel alloc] init];
        _speechTipLabel.numberOfLines = 2;
        _speechTipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _speechTipLabel.textAlignment = NSTextAlignmentCenter;
        _speechTipLabel.adjustsFontSizeToFitWidth = YES;
        NSString *tipStr = @"您可以尝试这样说：";
        NSString *contentStr = @"您可以尝试这样说：苯磺酸氨氯地平片、阿托伐他汀钙片、汤臣倍健、阿莫西林胶囊";
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedStr addAttribute:NSFontAttributeName value:FKYSystemFont(FKYWH(14)) range:NSMakeRange(0, contentStr.length)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, contentStr.length)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, tipStr.length)];
        _speechTipLabel.attributedText = attributedStr.copy;
    }
    return _speechTipLabel;
}

- (UIButton *)tryMicBtn {
    if (!_tryMicBtn) {
        _tryMicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tryMicBtn setBackgroundImage:[UIImage imageNamed:@"search_try_mic"] forState:UIControlStateNormal];
        [_tryMicBtn addTarget:self action:@selector(trySpeechAgain:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tryMicBtn;
}


- (BIAudioWaveView *)waveView {
    if (!_waveView) {
        _waveView = [[BIAudioWaveView alloc] initWithFrame:CGRectZero];
        _waveView.barColor = UIColorFromRGB(0xFF2D5D);
        _waveView.barWidth = FKYWH(2);
        _waveView.spaceWidth = FKYWH(3);
        _waveView.maxHeigth = 40;
        _waveView.volumeThreshold = 20;
        _waveView.anchorType = BIAudioWaveAnchorTwoSide;
    }
    return _waveView;
}


- (void)showToVC:(UIViewController *)vc {
    if (!vc) {
        return;
    }
    [self resetDefaultSubViewsConfig];
    if (![self superview]) {
        [vc.view addSubview:self];
        [vc.view bringSubviewToFront:self];
    }
    
    [self.subSpeechView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-FKYWH(350));
    }];
    @weakify(self);
    [UIView animateWithDuration:.3 animations:^{
        @strongify(self);
        self.backgroundColor = self.backgroundColor = UIColorFromRGBA(0x000000, .7);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        @strongify(self);
        [self startRecord];
    }];
}

- (void)trySpeechAgain:(id)sender {
    [self resetDefaultSubViewsConfig];
    [self startRecord];
    [self routerEventWithName:FKYInputVideoView.resetSpeechAgainAction userInfo:@{FKYUserParameterKey:@""}];
    if (self.resetSpeechAgainBtn) {
        self.resetSpeechAgainBtn();
    }
}


#pragma mark - UITapGestureRecognizer
- (void)addTapGesture {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    @weakify(self);
    [self.waveView bk_whenTapped:^{
        @strongify(self);
        [self stopRecord];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.subSpeechView.frame, point)) {
        return NO;
    }
    return YES;
}

- (void)closePopView {
    [self routerEventWithName:FKYInputVideoView.closeAction userInfo:@{FKYUserParameterKey:@""}];
    if (self.closeBtnClicked) {
        
        self.closeBtnClicked();
    }
    [_disPlayLink invalidate];
    _disPlayLink = nil;
    [self resetRecognizerConfigs];
    [self dismissPopView:NO result:nil];
}

- (void)dismissPopView:(BOOL)shouldBlock result:(NSString *)result {
    [self.subSpeechView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
    }];
    @weakify(self);
    [UIView animateWithDuration:.3 animations:^{
        @strongify(self);
        self.backgroundColor = [UIColor clearColor];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        @strongify(self);
        if ([self superview]) {
            [self removeFromSuperview];
        }
        if (shouldBlock) {
            
            if (self.resultHandler) {
                
                self.resultHandler(result);
            }
        }
    }];
}

- (void)resetRecognizerConfigs {
    [_iFlySpeechRecognizer cancel];
}

- (void)resetDefaultSubViewsConfig {
    self.speechTipLabel.hidden = NO;
    self.speechTitleLabel.textColor = UIColorFromRGB(0x333333);
    self.speechTitleLabel.text = @"请说，我在聆听…";
    self.tryMicBtn.hidden = YES;
    self.waveView.hidden = NO;
}

- (void)updateNewLevel {
    if (_volumeLevel > 0) {
        [self.waveView addFrequencyPointWithAmplitude:_volumeLevel * 0.8 + self.waveView.volumeThreshold];
    }else {
        [self.waveView addFrequencyPointWithAmplitude:self.waveView.volumeThreshold];
    }
    [self.waveView updateSpeechWave];
}

- (void)resetErrorSubViewsConfig {
    self.speechTipLabel.hidden = NO;
    self.tryMicBtn.hidden = NO;
    self.waveView.hidden = YES;
    self.speechTitleLabel.textColor = UIColorFromRGB(0xFF2D5D);
    self.speechTitleLabel.text = @"未能识别，请点击麦克风重试";
    [_disPlayLink invalidate];
    _disPlayLink = nil;
}

- (void)initIflyMSCParam{
    //初始化语音识别控件
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    //设置听写模式
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    _iFlySpeechRecognizer.delegate = self;
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置最长录音时间
    [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    //设置后端点
    [_iFlySpeechRecognizer setParameter:@"1500" forKey:[IFlySpeechConstant VAD_EOS]];
    //设置前端点
    [_iFlySpeechRecognizer setParameter:@"4000" forKey:[IFlySpeechConstant VAD_BOS]];
    //网络等待时间
    [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    //设置采样率，推荐使用16K
    [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //设置语言
    [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
    [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
    //设置是否返回标点符号
    [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
}


- (void)startRecord {
    _volumeLevel = 0;
    self.waveView.hidden = NO;
    [self.waveView startWave];
    _voiceAllStr = [NSMutableString string];
    //启动识别服务
    [_iFlySpeechRecognizer cancel];
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (!ret) {
    }
    
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateNewLevel)];
    _disPlayLink.frameInterval = 2;
    [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopRecord {
    [_iFlySpeechRecognizer stopListening];
    if (self.voiceIsOver) {
        self.voiceIsOver();
    }
}


#pragma mark -- IFlySpeechRecognizerDelegate
//音量变化0-30
- (void)onVolumeChanged:(int)volume {
    _volumeLevel = volume;
}

/**
 停止录音回调
 ****/
- (void)onEndOfSpeech {
}
/*!
 *  开始录音回调
 *   当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void)onBeginOfSpeech {
}
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResults:(NSArray *)results isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [results objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    NSMutableString *resultFromJson = [NSMutableString stringWithString: [FKYISRDataHelper stringFromJson:result]];

    if([resultFromJson length]>0){
        resultFromJson = [NSMutableString stringWithString:[resultFromJson stringByReplacingOccurrencesOfString:@"。" withString:@""]];
        resultFromJson = [NSMutableString stringWithString:[resultFromJson stringByReplacingOccurrencesOfString:@"，" withString:@""]];
         resultFromJson = [NSMutableString stringWithString:[resultFromJson stringByReplacingOccurrencesOfString:@"？" withString:@""]];
        if([resultFromJson length] > 0){
            [_voiceAllStr appendString:resultFromJson];
        }
    }
    
    if(isLast){
        NSString *result = _voiceAllStr.copy;
        if (result.length) {
            self.speechTitleLabel.text = result;
            self.speechTipLabel.hidden = YES;
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self routerEventWithName:FKYInputVideoView.resultAction userInfo:@{FKYUserParameterKey:result}];
                [self dismissPopView:YES result:result];
                [self.disPlayLink invalidate];
                self.disPlayLink = nil;
            });
        }else {
            [self resetErrorSubViewsConfig];
        }
    }
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onCompleted: (IFlySpeechError *) error {
    
}

+ (NSString *)closeAction{
    if (!_closeAction) {
        _closeAction = @"FKYInputVideoView-closeAction";
    }
    return _closeAction;
}

+ (NSString *)resultAction{
    if (!_resultAction) {
        _resultAction = @"FKYInputVideoView-resultAction";
    }
    return _resultAction;
}

+ (NSString *)resetSpeechAgainAction{
    if (!_resetSpeechAgainAction) {
        _resetSpeechAgainAction = @"FKYInputVideoView-resetSpeechAgainAction";
    }
    return _resetSpeechAgainAction;
}

@end
