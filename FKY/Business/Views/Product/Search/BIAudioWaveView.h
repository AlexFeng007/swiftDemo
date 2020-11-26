//
//  BIAudioWaveView.h
//  AudioWave
//
//  Created by fanminhu on 16/11/30.
//  Copyright © 2016年 fanminhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BIAudioWaveAnchorType) {
    BIAudioWaveAnchorCenter,
    BIAudioWaveAnchorTwoSide,
    BIAudioWaveAnchorWhole,
};

@interface BIAudioWaveView : UIView

/**
 *  @brief barColor 波形颜色
 */
@property (nonatomic, strong) UIColor *barColor;
/**
 *  @brief spaceWidth 空白间隔宽度
 */
@property (nonatomic) CGFloat spaceWidth;
/**
 *  @brief barWidth 单条波形宽度
 */
@property (nonatomic) CGFloat barWidth;
/**
 *  @brief maxHeigth 波形最大高度 一般可以直接设置成view的高度
 */
@property (nonatomic) CGFloat maxHeigth;
/**
 *  @brief volumeThreshold 最小响应的音量值,默认值为30
 */
@property (nonatomic) NSInteger volumeThreshold;
/**
 *  @brief anchorType 频点优化选取类型
 */
@property (nonatomic) BIAudioWaveAnchorType anchorType;
/**
 *  @brief 开始波形动画
 */
- (void)startWave;
/**
 *  @brief 添加新的频点
 *  @parame amplitude 振幅(0 - 100)
 */
- (void)addFrequencyPointWithAmplitude:(NSInteger) amplitude;


- (void)updateSpeechWave;

@end
