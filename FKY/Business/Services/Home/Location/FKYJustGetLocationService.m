//
//  FKYJustGetLocationService.m
//  FKY
//
//  Created by airWen on 2017/7/25.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYJustGetLocationService.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <CoreLocation/CoreLocation.h>


@interface FKYJustGetLocationService () <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKLocationService *baiduLocationService;
@property (nonatomic, strong) BMKGeoCodeSearch *baiduGeoSearch;

@end


@implementation FKYJustGetLocationService

#pragma mark- Public

- (void)fetchLocation
{
    [self.baiduLocationService startUserLocationService];
}

- (void)stopFetchLocation
{
    [self.baiduLocationService stopUserLocationService];
}


#pragma mark - Getter

- (BMKLocationService *)baiduLocationService
{
    if (!_baiduLocationService) {
        _baiduLocationService = [BMKLocationService new];
        _baiduLocationService.delegate = self;
    }
    return _baiduLocationService;
}

- (BMKGeoCodeSearch *)baiduGeoSearch
{
    if (!_baiduGeoSearch) {
        _baiduGeoSearch = [BMKGeoCodeSearch new];
        _baiduGeoSearch.delegate = self;
    }
    return _baiduGeoSearch;
}


#pragma mark - <BMKLocationServiceDelegate>

/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    //
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    //
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    //NSLog(@"didFailToLocateUserWithError...<code:%ld, description:%@, reason:%@>", (long)error.code, error.localizedDescription, error.localizedFailureReason);
    
    if (_callBackDelegate && [_callBackDelegate respondsToSelector:@selector(getDetailLocationFailedCode:reason:)]) {
        [_callBackDelegate getDetailLocationFailedCode:-1 reason:@"定位失败"];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateBMKUserLocation");
    
    // 获取位置成功
    CLLocationDegrees latitude = userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = userLocation.location.coordinate.longitude;
    
//    latitude = 22.618681;
//    longitude = 113.197;
    NSLog(@"latitude:%f, longitude:%f", latitude, longitude);
    
    // 检索详情地址
    BMKReverseGeoCodeOption *reverseGeo = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeo.reverseGeoPoint = CLLocationCoordinate2DMake(latitude, longitude);
    BOOL reverseResult = [self.baiduGeoSearch reverseGeoCode:reverseGeo];
    if (!reverseResult) {
        if (_callBackDelegate && [_callBackDelegate respondsToSelector:@selector(getDetailLocationFailedCode:reason:)]) {
            [_callBackDelegate getDetailLocationFailedCode:-2 reason:@"检索详细地址失败"];
        }
    }
}


#pragma mark- <BMKGeoCodeSearchDelegate>

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"省份province -- %@, 城市city -- %@, 区域district -- %@", result.addressDetail.province, result.addressDetail.city,  result.addressDetail.district);
    
    [self.baiduLocationService stopUserLocationService];
 
    if (BMK_SEARCH_NO_ERROR == error) {
        // 定位后反地址编码成功
        
        NSString *provinceName = result.addressDetail.province;
        NSString *cityName = result.addressDetail.city;
        NSString *districtName = result.addressDetail.district;
        NSString *detailAddress = [NSString stringWithFormat:@"%@%@", result.addressDetail.streetName, result.addressDetail.streetNumber];
        
        if (_callBackDelegate && [_callBackDelegate respondsToSelector:@selector(getLocationAddress:provinceName:cityName:districtName:)]) {
            [_callBackDelegate getLocationAddress:detailAddress provinceName:provinceName cityName:cityName districtName:districtName];
        }
    }
    else {
        // 定位后反地址编码失败
        
        if (_callBackDelegate && [_callBackDelegate respondsToSelector:@selector(getDetailLocationFailedCode:reason:)]) {
            // 说明：返回error其实没有意义。能走到当前方法，说明已经获取到位置信息(经纬度)，只是反地址编码失败；即app已获取定位权限~!@
            [_callBackDelegate getDetailLocationFailedCode:-2 reason:@"检索详细地址失败"];
        }
    }
}


@end
