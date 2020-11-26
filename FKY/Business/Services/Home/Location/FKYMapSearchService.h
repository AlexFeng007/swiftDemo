//
//  FKYMapSearchService.h
//  FKY
//
//  Created by airWen on 2017/7/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  搜索服务类...<使用第三方地图服务：百度地图>

#import <Foundation/Foundation.h>

@protocol FKYMapSearchServiceDelegate <NSObject>

#pragma mark - 搜索结果回调

- (void)searchFailed:(NSString *)reason;

/*
 * ptList列表，成员是：封装成NSValue的CLLocationCoordinate2D
 */
- (void)searchResult:(NSArray<NSString *> *)keyList
            cityList:(NSArray<NSString *> *)cityList
        districtList:(NSArray<NSString *> *)districtList
           poiIdList:(NSArray<NSString *> *)poiIdList
              ptList:(NSArray<NSValue *> *)ptList;


#pragma mark - 地址反编码结果回调

- (void)getDetailAddressFailed:(NSString *)reason;

- (void)getDetailAddress:(NSString *)address
            provinceName:(NSString *)provinceName
                cityName:(NSString *)cityName
            districtName:(NSString *)districtName;

@end



#pragma mark -

@interface FKYMapSearchService: NSObject

@property (nonatomic, weak) id<FKYMapSearchServiceDelegate> callBackDelegate;

// 搜索
- (void)searchLocationInfo:(NSString *)searchText;

// 反地理编辑出省市区和地址
- (void)toGetAdressDetailFromLocation:(CLLocationCoordinate2D)lcation;

@end
