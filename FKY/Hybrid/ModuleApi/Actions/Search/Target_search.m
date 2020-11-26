//
//  Target_search.m
//  FKY
//
//  Created by Rabe on 29/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "Target_search.h"
#import "NSDictionary+GLParam.h"

@implementation Target_search

- (id)Action_jsFetchSearchResultViewController:(NSDictionary *)params
{
    NSString *keyword = [params paramForKey:@"keyword" defaultValue:nil class:NSString.class];
    NSString *categoryId = [params paramForKey:@"categoryId" defaultValue:nil class:NSString.class];
    NSString *provinceName = [params paramForKey:@"provinceName" defaultValue:nil class:NSString.class];
    NSString *code = [params paramForKey:@"code" defaultValue:nil class:NSString.class];
    NSString *isCommon = [params paramForKey:@"isCommon" defaultValue:nil class:NSString.class];
    NSString *type = [params paramForKey:@"type" defaultValue:nil class:NSString.class];
    NSString *spuCode = [params paramForKey:@"spuCode" defaultValue:nil class:NSString.class];
    
    // 搜索结果VC
    FKYSearchResultVC *vc = [[FKYSearchResultVC alloc] init];
    
    // 商品关键字搜索方式
    if (keyword.length > 0) {
        vc.keyword = keyword;
    }
    if (categoryId.length > 0) {
        vc.selectedAssortId = categoryId;
    }
    
    // 店铺搜索方式
    if (provinceName.length && code.length && isCommon.length) {
        [[NSUserDefaults standardUserDefaults] setValue:code forKey:@"homeSelectedStation"];
        vc.searchResultType = @"Product";
        vc.station = code;
        vc.keyword = @"all";
        //vc.contentType = 1; // pilotProjectSelfShop
        vc.sellerCode = @(SELF_SHOP); // 固定为自营?!
    }
    
    // spu商品编码搜索方式
    if (type.length > 0) {
        if ([type isEqualToString:@"1"]) {
            vc.searchResultType = @"Shop";
        }
        else {
            vc.searchResultType = @"";
        }
        vc.keyword = [keyword stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (spuCode.length > 0) {
            vc.spuCode = spuCode;
        }
    }
    
    return vc;
}

- (id)Action_jsPushSearchViewController:(NSDictionary *)params
{
//    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_TabBarController) setProperty:^(id<FKY_TabBarController> destinationViewController) {
//        destinationViewController.index = 0;
    /*
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_Search) setProperty:^(FKYSearchViewController* destinationViewController) {
        destinationViewController.vcSourceType = SourceTypeCommon;
        destinationViewController.fromePage = 2;
    } isModal:NO animated:NO];
    */
    [[FKYNavigator sharedNavigator] openScheme:@protocol(FKY_NewSearch) setProperty:^(FKYSearchInputKeyWordVC* destinationViewController) {
        destinationViewController.searchType = 1;
    } isModal:NO animated:NO];
//    } isModal:NO animated:NO];
    return nil;
}

@end
