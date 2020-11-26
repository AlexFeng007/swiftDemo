//
//  YWSpeedUpManager.m
//  YYW
//
//  Created by 张斌 on 2017/10/17.
//  Copyright © 2017年 YYW. All rights reserved.
//

#import "YWSpeedUpManager.h"

#import "YWSpeedUpLogic.h"
#import "HJNetworkManager.h"

#pragma mark -

@interface YWSpeedUpManager()

@property (nonatomic, strong) NSMutableDictionary *innerDic;
@property (nonatomic, strong) YWSpeedUpLogic *logic;

@end

@implementation YWSpeedUpManager


+ (NSNumber *)currentMillisecond
{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    return @(theTime);
}

+ (NSString *)urlExceptSecondParamFromStr:(NSString *)urlString
{
    
    NSArray *arr = [urlString componentsSeparatedByString:@"&"];
    if ([arr count]>0) {
        return [arr objectAtIndex:0];
    }
    else
    {
        return urlString;
    }
}

DEF_SINGLETON(YWSpeedUpManager);

- (id)init
{
    self = [super init];
    if (self) {
        self.innerDic = @{}.mutableCopy;
    }
    
    return self;
}

- (void)startWithModule:(ModuleType)moduleType
{    
    YWSpeedUpEntity *entity = [[YWSpeedUpEntity alloc] init];
    entity.pageid = @(moduleType);
    entity.pagestarttime = [YWSpeedUpManager currentMillisecond];
    entity.requestdetail = @[].mutableCopy;
    [self.innerDic setValue:entity forKey:[NSString stringWithFormat:@"%zd",moduleType]];
}

- (void)addBrowserString:(NSString *)browserUrlString
{
    YWSpeedUpEntity *entity = [self.innerDic valueForKey:[NSString stringWithFormat:@"%zd",ModuleTypeFKYBrowser]];
    if (entity) {
        entity.pageurl = browserUrlString;
    }
}

- (void)addNetworkEntity:(YWSpeedUpNetworkEntity *)networkEntity withModule:(ModuleType)moduleType
{
    YWSpeedUpEntity *entity = [self.innerDic valueForKey:[NSString stringWithFormat:@"%zd",moduleType]];
    if (entity && networkEntity) {
        [entity.requestdetail addObject:networkEntity];
    }
}

- (void)endWithModule:(ModuleType)moduleType
{
    YWSpeedUpEntity *entity = [self.innerDic valueForKey:[NSString stringWithFormat:@"%zd",moduleType]];
    if (entity && !entity.usedtime) {//已统计结束时间，就不再统计，已最早的结束时间为准
        long long theTime = [[YWSpeedUpManager currentMillisecond] longLongValue];
        long long val = theTime-[entity.pagestarttime longLongValue];
        entity.usedtime = @(val);
    }
}

- (void)uploadWithModule:(ModuleType)moduleType
{
    YWSpeedUpEntity *entity = [self.innerDic valueForKey:[NSString stringWithFormat:@"%zd",moduleType]];
    if (entity) {//已上传过不再上传
        [self.logic upload:entity handle:^(id aResponseObject, NSError *anError) {
            
        }];
        //上传立刻清除
        [self.innerDic setValue:nil forKey:[NSString stringWithFormat:@"%zd",moduleType]];
    }
}

- (void)addNetworkEntity:(YWSpeedUpNetworkEntity *)networkEntity endAndUpdateWithModule:(ModuleType)moduleType
{
    [[YWSpeedUpManager sharedInstance] addNetworkEntity:networkEntity withModule:moduleType];
    [[YWSpeedUpManager sharedInstance] endWithModule:moduleType];
    [[YWSpeedUpManager sharedInstance] uploadWithModule:moduleType];
}

- (void)addBrowserString:(NSString *)browserUrlString endAndUpdateWithModule:(ModuleType)moduleType
{
    [[YWSpeedUpManager sharedInstance] addBrowserString:browserUrlString];
    [[YWSpeedUpManager sharedInstance] endWithModule:moduleType];
    [[YWSpeedUpManager sharedInstance] uploadWithModule:moduleType];
}

#pragma mark - private
- (YWSpeedUpEntity *)getEntityWithModule:(ModuleType)moduleType
{
    return [self.innerDic valueForKey:[NSString stringWithFormat:@"%zd",moduleType]];
}

#pragma mark - Property
/**
 *  功能:启动logic
 *
 *  @return 启动logic
 */
- (YWSpeedUpLogic *)logic
{
    if (_logic == nil) {
        _logic = [YWSpeedUpLogic logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _logic;
}

@end
