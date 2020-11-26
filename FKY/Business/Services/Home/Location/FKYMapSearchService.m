//
//  FKYMapSearchService.m
//  FKY
//
//  Created by airWen on 2017/7/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "FKYMapSearchService.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <MapKit/MapKit.h>


@interface FKYMapSearchService () <BMKSuggestionSearchDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKSuggestionSearch *searcher;
@property (nonatomic, strong) BMKGeoCodeSearch *baiduGeoSearch;

@end


@implementation FKYMapSearchService

#pragma mark - Public

// 搜索
- (void)searchLocationInfo:(NSString *)searchText
{
    if ((nil == searchText) || (0 >= searchText.length)) {
        if (nil != _callBackDelegate && [_callBackDelegate respondsToSelector:@selector(searchFailed:)]) {
            [_callBackDelegate searchFailed:@"搜索关键字为空"];
        }
        return;
    }
    
    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
    option.keyword  = searchText;
    BOOL flag = [self.searcher suggestionSearch:option];
    
    if(!flag) {
        if (nil != _callBackDelegate && [_callBackDelegate respondsToSelector:@selector(searchFailed:)]) {
            [_callBackDelegate searchFailed:@"搜索关键字失败"];
        }
    }
    option = nil;
}

// 从定位地址中进行反编码获取省市区信息
- (void)toGetAdressDetailFromLocation:(CLLocationCoordinate2D)lcation
{
    // 可以检索
    BMKReverseGeoCodeOption *op = [[BMKReverseGeoCodeOption alloc] init];
    op.reverseGeoPoint = lcation;
    BOOL reverseResult = [self.baiduGeoSearch reverseGeoCode:op];
    if (!reverseResult) {
        if (nil != _callBackDelegate && [_callBackDelegate respondsToSelector:@selector(getDetailAddressFailed:)]) {
            [_callBackDelegate getDetailAddressFailed:@"检索详细地址失败"];
        }
    }
}


#pragma mark- <BMKSuggestionSearchDelegate>

// 返回地址信息搜索结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher
                       result:(BMKSuggestionResult *)result
                    errorCode:(BMKSearchErrorCode)error
{
    if (BMK_SEARCH_NO_ERROR == error) {
        if (_callBackDelegate && [_callBackDelegate respondsToSelector:@selector(searchResult:cityList:districtList:poiIdList:ptList:)]) {
            [_callBackDelegate searchResult:result.keyList cityList:result.cityList districtList:result.districtList poiIdList:result.poiIdList ptList:result.ptList];
        }
    }
    else {
        if (_callBackDelegate && [_callBackDelegate respondsToSelector:@selector(searchFailed:)]) {
            [_callBackDelegate searchFailed:@"搜索失败"];
        }
    }
}


#pragma mark - BMKGeoCodeSearchDelegate

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"省份province -- %@, 城市city -- %@, 区域district -- %@", result.addressDetail.province, result.addressDetail.city,  result.addressDetail.district);
    
    if (BMK_SEARCH_NO_ERROR == error) {
        // 定位后反地址编码成功
        
        NSString *provinceName = result.addressDetail.province;
        NSString *cityName = result.addressDetail.city;
        NSString *districtName = result.addressDetail.district;
        NSString *detailAddress = [NSString stringWithFormat:@"%@%@", result.addressDetail.streetName, result.addressDetail.streetNumber];
        
        if (_callBackDelegate && [_callBackDelegate respondsToSelector:@selector(getDetailAddress:provinceName:cityName:districtName:)]) {
            [_callBackDelegate getDetailAddress:detailAddress provinceName:provinceName cityName:cityName districtName:districtName];
        }
    }
    else {
        // 定位后反地址编码失败
        
        if (_callBackDelegate && [_callBackDelegate respondsToSelector:@selector(getDetailAddressFailed:)]) {
            // 说明：返回error其实没有意义。能走到当前方法，说明已经获取到位置信息(经纬度)，只是反地址编码失败；即app已获取定位权限~!@
            [_callBackDelegate getDetailAddressFailed:@"检索详细地址失败"];
        }
    }
}


#pragma mark- Getter

- (BMKSuggestionSearch *)searcher
{
    if (nil == _searcher) {
        _searcher =[[BMKSuggestionSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}

- (BMKGeoCodeSearch *)baiduGeoSearch
{
    if (!_baiduGeoSearch) {
        _baiduGeoSearch = [BMKGeoCodeSearch new];
        _baiduGeoSearch.delegate = self;
    }
    return _baiduGeoSearch;
}


@end
