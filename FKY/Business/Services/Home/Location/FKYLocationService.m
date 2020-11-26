//
//  FKYLocationService.m
//  FKY
//
//  Created by yangyouyong on 15/9/11.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYLocationService.h"
#import "FKYTranslatorHelper.h"
#import "FKYLocationModel.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <CoreLocation/CoreLocation.h>
#import "NSArray+Block.h"
#import "FKYAccountLaunchLogic.h"


@interface FKYLocationService () <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) NSArray *locationsArray;

@property (nonatomic, copy) FKYSuccessBlock locationSuccessBlock;
@property (nonatomic, copy) FKYFailureBlock locationFailureBlock;
@property (nonatomic, assign) BOOL locationHasChanged;
@property (nonatomic, copy) NSString *currentAreaString;
@property (nonatomic, strong) BMKLocationService *baiduLocationService;
@property (nonatomic, strong) BMKGeoCodeSearch *baiduGeoSearch;

@end


@implementation FKYLocationService

- (NSArray *)locations
{
    return self.locationsArray;
}

- (NSArray *)locationsArray
{
    if (!_locationsArray) {
        _locationsArray = [NSArray array];
    }
    return _locationsArray;
}

- (BMKGeoCodeSearch *)baiduGeoSearch
{
    if (!_baiduGeoSearch) {
        _baiduGeoSearch = [BMKGeoCodeSearch new];
        _baiduGeoSearch.delegate = self;
    }
    return _baiduGeoSearch;
}

- (BMKLocationService *)baiduLocationService
{
    if (!_baiduLocationService) {
        _baiduLocationService = [BMKLocationService new];
        _baiduLocationService.delegate = self;
    }
    return _baiduLocationService;
}

- (NSString *)currentAreaString
{
    if (!_currentAreaString || self.locationHasChanged) {
        _currentAreaString = self.currentLoaction.substationName;
        self.locationHasChanged = NO;
    }
    return _currentAreaString;
}

- (FKYLocationModel *)currentLoaction
{
    FKYLocationModel *location = nil;
    id obj = UD_OB(FKYLocationKey);
    if (obj) {
        location = [NSKeyedUnarchiver unarchiveObjectWithData:UD_OB(FKYLocationKey)];
    }
    if (!location) {
        location = [FKYLocationModel new];
        location.substationName = @"默认";
        location.substationCode = @"000000";
        location.showIndex = @(1);
        NSData *locationData = [NSKeyedArchiver archivedDataWithRootObject:location];
        UD_ADD_OB(locationData, FKYLocationKey);
    }
    return location;
}

- (NSString *)currentLocationName
{
    NSString *name = [self currentLoaction].substationName;
    //name = UD_OB(@"currentStation");
    name = [name stringByReplacingOccurrencesOfString:@"市" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"省" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"站" withString:@""];
    return name;
}

- (void)saveLocation:(FKYLocationModel *)location
{
    if (!location) {
        return;
    }
    
    self.locationHasChanged = YES;
        
    // 保存整个model
    NSData *locationData = [NSKeyedArchiver archivedDataWithRootObject:location];
    UD_ADD_OB(locationData, FKYLocationKey);
    
    // 保存code
    if ([location.substationCode isKindOfClass:NSString.class]) {
        UD_ADD_OB(location.substationCode, @"currentStation");
    }
    else if ([location.substationCode isKindOfClass:NSNumber.class]) {
        NSNumber *number = (NSNumber *)location.substationCode;
        UD_ADD_OB(number.stringValue, @"currentStation");
    }
    
    // 保存name
    UD_ADD_OB(location.substationName, @"currentStationName");
    
    // 同步保存到用户model中
    FKYUserInfoModel *userModel = [FKYLoginAPI currentUser];
    userModel.substationCode = location.substationCode;
    userModel.city_id = location.substationCode;
    // 保存用户登录信息
    NSData *userInfo = [NSKeyedArchiver archivedDataWithRootObject:userModel];
    UD_ADD_OB(userInfo, FKYCurrentUserKey);

    // 同步
    [UD synchronize];
    
    // 更新cookies
    [[GLCookieSyncManager sharedManager] loadSavedCookies];
}


#pragma mark -

- (void)setCurrentLocation:(FKYLocationModel *)location
{
    if (!location) {
        return;
    }
    
    self.locationHasChanged = YES;
    
    // 保存整个model
    NSData *locationData = [NSKeyedArchiver archivedDataWithRootObject:location];
    UD_ADD_OB(locationData, FKYLocationKey);
    
    // 保存code
    if ([location.substationCode isKindOfClass:NSString.class]) {
        UD_ADD_OB(location.substationCode, @"currentStation");
    }
    else if ([location.substationCode isKindOfClass:NSNumber.class]) {
        NSNumber *number = (NSNumber *)location.substationCode;
        UD_ADD_OB(number.stringValue, @"currentStation");
    }
    
    // 保存name
    UD_ADD_OB(location.substationName, @"currentStationName");
    
    // 同步
    [UD synchronize];
}

// adapter
- (void)getLocationsSuccess:(FKYSuccessBlock)successBlock failure:(FKYFailureBlock)failureBlock
{
    @weakify(self);
    FKYAccountLaunchLogic *accountLaunchLogic = [FKYAccountLaunchLogic logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    [accountLaunchLogic getStationListCompletionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            // success
            if (aResponseObject) {
                // has data
                if ([aResponseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)aResponseObject;
                    NSArray *locationList = dic[@"data"];
                    NSMutableArray *locations = [FKYTranslatorHelper translateCollectionFromJSON:locationList withClass:[FKYLocationModel class]].mutableCopy;
                    self.locationsArray = locations;
                    
                    // 设置默认省份 区域接口第一个对象
                    if ([self currentLoaction] == nil && self.locationsArray.count > 0) {
                        [self setCurrentLocation:self.locationsArray[0]];
                    }
                    safeBlock(self.locationSuccessBlock, NO);
                    
                    safeBlock(successBlock, NO);
                }
                else if ([aResponseObject isKindOfClass:[NSArray class]]) {
                    NSArray *arr = (NSArray *)aResponseObject;
                    NSMutableArray *locations = [FKYTranslatorHelper translateCollectionFromJSON:arr withClass:[FKYLocationModel class]].mutableCopy;
                    self.locationsArray = locations;
                    
                    // 设置默认省份 区域接口第一个对象
                    if ([self currentLoaction] == nil && self.locationsArray.count > 0) {
                        [self setCurrentLocation:self.locationsArray[0]];
                    }
                    safeBlock(self.locationSuccessBlock, NO);
                    
                    safeBlock(successBlock, NO);
                }
                else {
                    safeBlock(failureBlock, nil);
                }
            }
            else {
                // no data
                safeBlock(failureBlock, nil);
            }
        }
        else {
            // fail
            safeBlock(failureBlock, nil);
        }
    }];
}

- (void)fetchBaiduMapLocationSuccess:(FKYSuccessBlock)successBlock
                             failure:(FKYFailureBlock)failureBlock
{
    self.locationSuccessBlock = successBlock;
    self.locationFailureBlock = failureBlock;
    [self.baiduLocationService startUserLocationService];
}


#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    // 搜索
    CLLocationDegrees latitude = userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = userLocation.location.coordinate.longitude;
    BMKReverseGeoCodeOption *op = [[BMKReverseGeoCodeOption alloc] init];
    op.reverseGeoPoint = CLLocationCoordinate2DMake(latitude, longitude);
    BOOL reverseResult = [self.baiduGeoSearch reverseGeoCode:op];
    if (!reverseResult) {
        safeBlock(self.locationFailureBlock,nil);
    }
}

// 反编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"省份province -- %@, 城市city -- %@, 区域district -- %@", result.addressDetail.province, result.addressDetail.city,  result.addressDetail.district);
    
    [self.baiduLocationService stopUserLocationService];
    
    NSArray *filteredArray = [self.locationsArray filter:^BOOL(FKYLocationModel *object) {
        NSString *filterProvince = [result.addressDetail.province stringByReplacingOccurrencesOfString:@"省" withString:@""];
        filterProvince = [filterProvince stringByReplacingOccurrencesOfString:@"市" withString:@""];
        return [object.substationName isEqualToString:filterProvince];
    }];
    
    if (filteredArray.count > 0) {
        [self setCurrentLocation:filteredArray[0]];
        safeBlock(self.locationSuccessBlock, NO);
    }
    else {
        // 设置默认省份 区域接口第一个对象
        if (self.locationsArray.count > 0) {
            [self setCurrentLocation:self.locationsArray[0]];
        }
        safeBlock(self.locationSuccessBlock, NO);
    }
}


@end
