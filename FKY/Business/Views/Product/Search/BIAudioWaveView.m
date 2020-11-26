//
//  BIAudioWaveView.m
//  AudioWave
//
//  Created by fanminhu on 16/11/30.
//  Copyright © 2016年 fanminhu. All rights reserved.
//

#import "BIAudioWaveView.h"


//#define BIAudioDEBUG

static CGFloat defaultHeight = 2;

@interface BIAudioWaveData : NSObject
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat position;
@end

@implementation BIAudioWaveData
@end

@interface BIAudioSubWaveData : NSObject
@property (nonatomic,assign) CGFloat speed;
@property (nonatomic,assign) CGFloat targetPosition;
@property (nonatomic,assign) CGFloat currentPosition;
@property (nonatomic,assign) NSInteger pointIndex;
@end

@implementation BIAudioSubWaveData
@end

@interface BIAudioWaveView()

@property (nonatomic,strong) NSMutableArray <BIAudioWaveData*> *waveDatas;
@property (nonatomic,strong) NSMutableArray *freeWavePoint;
@property (nonatomic,strong) NSMutableArray *waveViews;
@property (nonatomic,strong) NSMutableArray *shadowWaveViews;
@property (nonatomic,strong) NSMutableArray *subAudioWaveDatas;

@end

@implementation BIAudioWaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self internalInit];
    }
    return self;
}


- (void)internalInit
{
    self.waveDatas = [NSMutableArray new];
    self.waveViews = [NSMutableArray new];
    self.shadowWaveViews = [NSMutableArray new];
    self.freeWavePoint = [NSMutableArray new];
    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.spaceWidth = 4.0;
    self.barWidth = 2.0;
    self.maxHeigth = 175.0;
    self.barColor = [UIColor colorWithRed:17/255.0 green:129/255.0 blue:252/255.0 alpha:1.0];
    
    self.volumeThreshold = 15;
    
    self.anchorType = BIAudioWaveAnchorCenter;
    self.subAudioWaveDatas = [NSMutableArray new];
}


- (void)updateSpeechWave //更新waveDatas 并刷新waveViews
{
    [self updatewaveData];
    [self updateWaveView];
}


- (void)zeroWave
{
    [self.waveDatas enumerateObjectsUsingBlock:^(BIAudioWaveData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.position = 0.0;
    }];
    [self.subAudioWaveDatas removeAllObjects];
    [self updatewaveData];
    [self updateWaveView];
}

- (void)updatewaveData
{
    CGFloat timeInterval = 0.3;
    [self.freeWavePoint removeAllObjects];

    //遍历子波贡献
    [self.subAudioWaveDatas enumerateObjectsUsingBlock:^(BIAudioSubWaveData *subData, NSUInteger idx, BOOL * _Nonnull stop) {
        BIAudioWaveData *waveData = self.waveDatas[subData.pointIndex];
        if (subData.targetPosition <= subData.currentPosition && subData.speed > 0) {
            subData.speed *= (-1/3.0);
        }
        CGFloat currentSpeed = subData.speed;
        subData.currentPosition += timeInterval * currentSpeed;
        
        subData.speed = subData.currentPosition > 0 ? subData.speed : 0.0;
        
        waveData.position += timeInterval * currentSpeed;
        waveData.position = MAX(waveData.position, 0.0);
        
    }];
    
    //回收空闲点
    [self.waveDatas enumerateObjectsUsingBlock:^(BIAudioWaveData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.position <= 0.0)
        {
            [self.freeWavePoint addObject:@(idx)];
        }
    }];
    
    //移除归零的子波
    [self.subAudioWaveDatas removeObjectsAtIndexes:[self.subAudioWaveDatas indexesOfObjectsPassingTest:^BOOL(BIAudioSubWaveData *subData, NSUInteger idx, BOOL * _Nonnull stop) {
        return subData.speed <= 0.0 && subData.currentPosition <= 0.0;
    }]];
}

- (void)updateWaveView
{
    [CATransaction setValue:@(YES) forKey:kCATransactionDisableActions];
    [self.waveDatas enumerateObjectsUsingBlock:^(BIAudioWaveData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = obj.position * 2.0 + defaultHeight;
        height = height > self.maxHeigth ? self.maxHeigth : height;
        CALayer *tmpLayer = self.waveViews[idx];
        CGRect frame = tmpLayer.frame;
        frame.origin.y = (self.frame.size.height - height)/2.0;
        frame.size.height = height;
        [tmpLayer setFrame:frame];
        CALayer *tmppLayer = self.shadowWaveViews[idx];
        [tmppLayer setHidden:YES];
    }];
    [CATransaction commit];
}

#pragma mark - Public Method

- (void)buidleView
{
    if (self.waveViews.count == 0) {
    
        NSInteger barCount = (int)(self.bounds.size.width / (self.barWidth + self.spaceWidth));
        CGFloat barAreaWidth = barCount * (self.barWidth + self.spaceWidth);
        CGFloat headOffset = (self.bounds.size.width - barAreaWidth + self.spaceWidth)/2 + self.layer.bounds.origin.x;
        for (NSInteger index = 0; index < barCount; index ++)
        {
            CGRect frame = CGRectMake(headOffset+index*(self.barWidth + self.spaceWidth), self.bounds.size.height/2-defaultHeight/2, self.barWidth, defaultHeight);
            
            {
                CGRect shadowFrame = frame;
                
                CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
                
                [shadowLayer setStartPoint:CGPointMake(0, 0)];
                [shadowLayer setEndPoint:CGPointMake(0, 1)];
                
                CGFloat red,green,blue,alpha;
                [self.barColor getRed:&red green:&green blue:&blue alpha:&alpha];
                
                CGColorRef sideColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha * 0.5].CGColor;
                CGColorRef centerColoer = [UIColor colorWithRed:red green:green blue:blue alpha:alpha * 0.0].CGColor;
                [shadowLayer setColors:@[(__bridge id)sideColor,(__bridge id)centerColoer,(__bridge id)sideColor]];
                
                shadowLayer.cornerRadius = self.barWidth/2.0;//(self.barWidth + self.spaceWidth) / 2.0;
                [shadowLayer setFrame:shadowFrame];
                [self.layer addSublayer:shadowLayer];
                
                [self.shadowWaveViews addObject:shadowLayer];
            }
            
            CALayer *barLayer = [[CALayer alloc] init];
            [barLayer setBackgroundColor:self.barColor.CGColor];
            [barLayer setFrame:frame];
            [self.waveViews addObject:barLayer];
            barLayer.cornerRadius = self.barWidth / 2.0;
            [self.layer addSublayer:barLayer];
            
            BIAudioWaveData *waveData = [[BIAudioWaveData alloc] init];
            [self.waveDatas addObject:waveData];
            [self.freeWavePoint addObject:@(index)];
        }
        
//        [self.volumeLabel setFrame:CGRectMake(self.bounds.size.width - 300, self.bounds.size.height - 50, 300, 50)];
    }
}

- (void)startWave
{
    [self buidleView];
    [self zeroWave];
}


- (void)internalAddFrequencyPointWithAmplitude:(CGFloat)amplitude
{
    NSParameterAssert(amplitude >= 0 && amplitude <= 1);
    
    CGFloat y = 10;
    NSMutableArray *newWave = [NSMutableArray new];
    for (NSInteger x = 0; y > 0 ;  x++)
    {
        y = [self calcWaveHeightBy:amplitude xPoint:x];
        if (x == 0)
        {
//            self.volumeLabel.text = [self.volumeLabel.text stringByAppendingFormat:@":%f",y];
        }

        if (y > 0)
        {
            [newWave addObject:@(y)];
        }
    }
    
    if (newWave.count > 0)
    {
        NSInteger newHalfWaveCount = [newWave count];
        NSInteger newWaveCount = newHalfWaveCount * 2 - 1;
        NSInteger showWaveCount = [self.waveDatas count];
        
        if (showWaveCount >= newWaveCount)
        {
            BOOL showInCenter = fabs([self normalizeAmplictude:(int)self.volumeThreshold]- amplitude) > 0.01;
            
            NSInteger newWaveCenterPoint = [self randCenterPoint:showInCenter];; //随机计算出来Index
            
            NSInteger bandWidth = (newHalfWaveCount - 1) / 4 ;
            
            NSInteger startIndex = newWaveCenterPoint - bandWidth;
            NSInteger endIndex = newWaveCenterPoint + bandWidth;
            
            for (NSInteger index = startIndex; index <= endIndex; index ++) {
                [self.freeWavePoint removeObject:@(index)];
            }
            
            NSInteger subLocation = MAX(0, newWaveCenterPoint - (newHalfWaveCount - 1));
            subLocation = MIN(subLocation, showWaveCount - newWaveCount);
            
            NSInteger subLength = MIN(newWaveCount, showWaveCount - subLocation - 1);
            subLength = MAX(subLength, 0);
            
        
            NSArray *subShowWave = [self.waveDatas subarrayWithRange:NSMakeRange(subLocation, subLength)];
            [subShowWave enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSInteger newWaveIndex = newHalfWaveCount - 1 - idx;
                newWaveIndex = newWaveIndex >=0 ? newWaveIndex : idx - newHalfWaveCount + 1;
                
                BIAudioSubWaveData *item = [BIAudioSubWaveData new];
                item.targetPosition = [newWave[newWaveIndex] floatValue];
                item.currentPosition = 0; //在这儿可以修改叠加
                item.pointIndex = subLocation + idx;
                item.speed = 2 * (item.targetPosition / 4.0 + 1);
                [self.subAudioWaveDatas addObject:item];
            }];
        }
    }
}

// 每次都从中心1/3处获取
- (NSInteger)randCenterPoint:(BOOL)center
{
    if ([self.freeWavePoint count] > 0)
    {
        NSInteger randStart = 0;
        NSInteger randStop = 0;
        if (center)
        {
            switch (self.anchorType) {
                case BIAudioWaveAnchorWhole:
                    randStart = 0;
                    randStop = [self.freeWavePoint count] -1 ;
                    break;
                case BIAudioWaveAnchorCenter:
                    randStart = [self.freeWavePoint count] /4;
                    randStop = 3 * [self.freeWavePoint count] /4;
                    break;
                case BIAudioWaveAnchorTwoSide:
                    if (arc4random() % 2 == 0)
                    {
                        randStart = 0;
                        randStop = ([self.freeWavePoint count] -1)/3 ;
                    }
                    else
                    {
                        randStart = ([self.freeWavePoint count] -1)*2/3;
                        randStop = [self.freeWavePoint count] -1 ;
                    }
                    break;
                default:
                    break;
            }
        }
        else
        {
            randStart = 0;
            randStop = [self.freeWavePoint count] -1 ;
        }
        
        NSInteger newWaveCenterPoint = [self randValueFrom:randStart to:randStop];
        
        return [self.freeWavePoint[newWaveCenterPoint] integerValue];
    }
    else
    {
        return [self.waveDatas count] / 2;
    }
}

- (NSInteger)randValueFrom:(NSInteger)randStart to:(NSInteger)randStop
{
    return (NSInteger)(randStart + (arc4random() % (randStop - randStart + 1))); //随机计算出来Index;
}

- (CGFloat)normalizeAmplictude:(NSInteger)amplitude
{
    CGFloat normalizedValue = 0.0;
    if (amplitude <= self.volumeThreshold)
    {
        normalizedValue = self.volumeThreshold;//level * level /100.0;;
    }
    else
    {
        CGFloat y = 3/4.0;
        normalizedValue = pow(amplitude, y)*100/pow(100, y);
    }
    normalizedValue /= 100.0;
    normalizedValue = MIN(normalizedValue, 1.0);
    return normalizedValue;
}

- (void)addFrequencyPointWithAmplitude:(NSInteger)amplitude
{
    CGFloat normalizedValue = [self normalizeAmplictude:amplitude];
    
    NSInteger pointCount = MAX(round(normalizedValue / 0.4), 1) ;
    
    CGFloat tmpValue = normalizedValue;
    
    for (NSInteger index = 0; index < pointCount; index++) {
        [self internalAddFrequencyPointWithAmplitude:tmpValue];
    }

//    [self updateWaveView];
}

- (CGFloat)calcWaveHeightBy:(CGFloat)amplitude xPoint:(NSInteger) point
{
    NSParameterAssert(amplitude >= 0 && amplitude <= 1);
    CGFloat result = 0.0;
    CGFloat zeroCorrectionFactor = 1.3;
    CGFloat onePosition = 4.26;
    CGFloat zeroPosition = onePosition * zeroCorrectionFactor;
    CGFloat maxY = 20.0;
    CGFloat minY = 4.0;
    if (point == 0)
    {
        result = self.maxHeigth/(2.0 * zeroPosition)*(((maxY - minY)*amplitude+minY)/(3/5.0*labs(1) + 2.0) - 2.0) * zeroCorrectionFactor;
    }
    else
    {
        result = self.maxHeigth/(2.0 * zeroPosition)*(((maxY - minY)*amplitude+minY)/(3/5.0*labs(point) + 2.0) - 2.0);
    }
    return result;
}

@end

