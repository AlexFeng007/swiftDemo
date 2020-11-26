//
//  FKYSearchService.m
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYSearchService.h"
#import "FKYSearchRemindModel.h"
#import "FKYSearchHistoryModel.h"
#import "FKYTranslatorHelper.h"
#import <MagicalRecord/MagicalRecord.h>
#import "FKYSearchHistoryMO+CoreDataClass.h"
#import "FKYTranslatorHelper.h"
#import "FKYLocationService.h"
#import "FKYLocationModel.h"
#import "FKYLoginAPI.h"
#import "FKYSearchRequest.h"
#import "FKYSearchActivityModel.h"

static NSString  * const seriveUrl = @"https://mall.yaoex.com/api/";
static NSString  * const searchAssociation = @"search/searchAssociation";

//static NSString  * const searchStoreList = @"search/searchStoreList";
//static NSString  * const searchProductList = @"search/searchProductList";


@interface FKYSearchService () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) NSArray *searchActivityArray; // 搜索活动list
@property (nonatomic, strong, readwrite) NSArray *searchHistoryArray; // 搜索历史list
@property (nonatomic, strong, readwrite) NSArray *searchRemindArray;  // 实时联想搜索list

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) FKYSearchRequest *searchThinkRequest;

@end


@implementation FKYSearchService

#pragma mark - CoreData

// 保存...<带商家id>
- (void)save:(NSString *)history
        type:(NSNumber *)type
      shopId:(NSNumber *)shopId
     success:(FKYSuccessBlock)successBlock
     failure:(FKYFailureBlock)failureBlock
{
    FKYSearchRemindModel *model = [FKYSearchRemindModel new];
    model.drugName = history;   // 搜索关键词
    model.sellerName = @"";         // 商家名称
    model.sellerCode = shopId;      // 商家id（当赋值为-1的时候代表全部商品搜索，-2的时候为店铺搜索,-3的时候为一起购活动）
    model.type = type;              // 搜索类型...1:商品 2:店铺 3:1起购活动
    [self saveSearchRemindModel:model success:successBlock failure:failureBlock];
}

// 保存用户在实时联想搜索中（点击）选择的关键词
- (void)saveSearchRemindModel:(FKYSearchRemindModel *)remindModel
                      success:(FKYSuccessBlock)successBlock
                      failure:(FKYFailureBlock)failureBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        if (remindModel.sellerCode && remindModel.sellerCode.integerValue > 0) {
            //店铺内商品
        }else{
            //搜索通用商品时候，统一一个venderid字段
            remindModel.sellerCode = [self getLocalShopIdNumeberWithType:remindModel.type];
            remindModel.type = [self getLocalTypeNumeberWithType:remindModel.type];
        }
        // 先删除
        [FKYSearchHistoryMO MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"name=%@ && venderid=%@ && type=%@ ",remindModel.drugName,remindModel.sellerCode,remindModel.type] inContext:localContext];
        
        // 再添加
        FKYSearchHistoryMO *mo = [FKYSearchHistoryMO MR_createEntityInContext:localContext];
        mo.addedDate = [NSDate date];           // 加入时间
        mo.name = remindModel.drugName;     // 搜索关键词
        mo.vender = remindModel.sellerName;     // 商家名称
        mo.venderid = remindModel.sellerCode;   // 商家id
        mo.type = remindModel.type;             // 搜索类型...1:商品 2:店铺 3:一起购活动
    }completion:^(BOOL contextDidSave, NSError *error) {
        if (!error) {
            safeBlock(successBlock, NO);
        }
        else {
            safeBlock(failureBlock, error.description);
        }
    }];
}

// 清空
- (void)clearHistorytype:(NSNumber *)type
                  shopId:(NSNumber *)shopId Success:(FKYSuccessBlock)successBlock
                 failure:(FKYFailureBlock)failureBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        //[FKYSearchHistoryMO MR_truncateAllInContext:localContext];
        NSNumber *sid = nil;
        NSNumber *typeIndex = type;
        if (shopId && shopId.integerValue > 0) {
            //店铺内商品
            sid = shopId;
            //            [FKYSearchHistoryMO MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"venderid != %@ && type=%@ && venderid != %@",[NSNumber numberWithInt:-1],type,[NSNumber numberWithInt:-2]] inContext:localContext];
        }else{
            sid = [self getLocalShopIdNumeberWithType:type];
            typeIndex = [self getLocalTypeNumeberWithType:type];
        }
        [FKYSearchHistoryMO MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"venderid=%@ && type=%@ ",sid,typeIndex] inContext:localContext];
    }completion:^(BOOL contextDidSave, NSError *error) {
        if(!error) {
            self.searchHistoryArray = [NSArray array];
            safeBlock(successBlock, NO);
        }else{
            safeBlock(failureBlock, error.description);
        }
    }];
}

// 单个删除某个联想词
- (void)clearSigleHistorytype:(NSNumber *)type
                       shopId:(NSNumber *)shopId
                      keyWord:(NSString *)keyWord
                      Success:(FKYSuccessBlock)successBlock
                      failure:(FKYFailureBlock)failureBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        //[FKYSearchHistoryMO MR_truncateAllInContext:localContext];
        NSNumber *sid = nil;
        NSNumber *searchType = nil;
        searchType = type;
        if (shopId && shopId.integerValue > 0) {
            //店铺内商品
            sid = shopId;
            //            [FKYSearchHistoryMO MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"venderid != %@ && type=%@ && venderid != %@",[NSNumber numberWithInt:-1],type,[NSNumber numberWithInt:-2]] inContext:localContext];
        }else{
            //搜索通用商品时候，统一一个venderid字段
            sid = [self getLocalShopIdNumeberWithType:type];
            searchType = [self getLocalTypeNumeberWithType:type];
        }
        [FKYSearchHistoryMO MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"name=%@ && venderid=%@ && type=%@ ",keyWord,sid,searchType] inContext:localContext];
    }completion:^(BOOL contextDidSave, NSError *error) {
        if(!error) {
            safeBlock(successBlock, NO);
        }else{
            safeBlock(failureBlock, error.description);
        }
    }];
}
// 获取搜索历史
// 当获取商品搜索类型时，需要过滤掉店铺内的商品搜索
- (void)fetchSearchHistoryWithType:(NSNumber *)type
                           Success:(FKYSuccessBlock)successBlock
                           failure:(FKYFailureBlock)failureBlock
{
    @try {
        NSNumber *searchType = [self getLocalTypeNumeberWithType:type];
        self.fetchedResultsController = [FKYSearchHistoryMO MR_fetchAllSortedBy:@"addedDate" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"type=%@ ",searchType] groupBy:nil delegate:self];
        NSArray *arrTemp = [FKYTranslatorHelper translateCollectionfromManagedObjects:[self.fetchedResultsController fetchedObjects] withClass:[FKYSearchHistoryModel class]];
        //        for (FKYSearchHistoryModel *model in arrTemp) {
        //            if (model.type.integerValue == searchType.integerValue) {
        //                if (searchType.integerValue == 1) {
        //                    if (model.venderid && model.venderid.integerValue > 0) {
        //                        // 店铺内的商品搜索...<不加入>
        //                        NSLog(@"店铺内的商品搜索...<keyword:%@, shopid:%@>", model.name, model.venderid);
        //                    }
        //                    else {
        //                        // 全部商品，店铺内商品，专区内搜索商品，药福利内搜索商品，优惠券可用商品搜索
        //                        [mutable addObject:model];
        //                    }
        //                }else if (searchType.integerValue == 2) {
        //                    // 店铺搜索
        //                    [mutable addObject:model];
        //                } else if (searchType.integerValue == 3) {
        //                    // 一起购活动
        //                    [mutable addObject:model];
        //                }else if (searchType.integerValue == 4) {
        //                    // 订单搜索
        //                    [mutable addObject:model];
        //                }else if (type.integerValue == 8) {
        //                    // 包邮列表搜索
        //                    [mutable addObject:model];
        //                }
        //            }
        //        } // for
        self.searchHistoryArray = arrTemp;
        self.fetchedResultsController = nil;
    } @catch (NSException *exception) {
        //
    } @finally {
        //
    }
    
    //    if (mutable.count > 20) {
    //        NSArray *arr = [NSArray arrayWithArray:[mutable subarrayWithRange:NSMakeRange(0, 20)]];
    //        self.searchHistoryArray = arr;
    //    }
    //    else {
    
    //}
    
    safeBlock(successBlock,NO);
}

// 获取当前店铺的搜索历史
- (void)fetchSearchHistoryWithType:(NSNumber *)type
                            shopid:(NSString *)shopid
                           Success:(FKYSuccessBlock)successBlock
                           failure:(FKYFailureBlock)failureBlock
{
    NSMutableArray *mutable = @[].mutableCopy;
    
    @try {
        self.fetchedResultsController = [FKYSearchHistoryMO MR_fetchAllSortedBy:@"addedDate" ascending:NO withPredicate:nil groupBy:nil delegate:self];
        NSArray *arrTemp = [FKYTranslatorHelper translateCollectionfromManagedObjects:[self.fetchedResultsController fetchedObjects] withClass:[FKYSearchHistoryModel class]];
        for (FKYSearchHistoryModel *model in arrTemp) {
            if (model.type.integerValue == type.integerValue) {
                // 搜商品...<type=1>
                if (shopid && shopid.length > 0 && model.venderid && model.venderid.integerValue == shopid.integerValue) {
                    // 只获取指定店铺下的商品
                    [mutable addObject:model];
                }
            }
        }
    } @catch (NSException *exception) {
        //
    } @finally {
        //
    }
    
    self.searchHistoryArray = mutable;
    safeBlock(successBlock,NO);
}


#pragma mark - Public

- (FKYSearchRequest *)searchThinkRequest
{
    if (!_searchThinkRequest) {
        _searchThinkRequest = [FKYSearchRequest logicWithOperationManager:[[HJNetworkManager sharedInstance] generateOperationMangerWithOwner:self]];
    }
    return _searchThinkRequest;
}

- (void)emptySearchRemindArray
{
    self.searchRemindArray = [NSArray array];
}

/// 转换model类型
- (void)mapperToCellModel{
    [self.dataList removeAllObjects];
    FKYSearchProductSectionModel *section1 = [[FKYSearchProductSectionModel alloc]init];
    section1.sectionType = FKYSearchProductSectionTypeHistorySection;
    section1.sectionTitle = @"最近搜索";
    NSMutableArray *tempArrary1 = [[NSMutableArray alloc]init];
    for (FKYSearchHistoryModel *model in self.searchHistoryArray) {
        FKYSearchProductCellModel *cellModel = [[FKYSearchProductCellModel alloc]init];
        cellModel.cellType = FKYSearchProductCellTypeHistoryCell;
        cellModel.historyModel = model;
        [tempArrary1 addObject:cellModel];
        //[section1.cellList arrayByAddingObject:cellModel];
    }
    section1.cellList = [tempArrary1 copy];
    [self.dataList addObject:section1];
    
    NSMutableArray *tempArrary2 = [[NSMutableArray alloc]init];
    if (self.searchActivityArray.count > 0){
        FKYSearchProductSectionModel *section2 = [[FKYSearchProductSectionModel alloc]init];
        section2.sectionType = FKYSearchProductSectionTypeFoundSection;
        section2.sectionTitle = @"搜索发现";
        for (FKYSearchActivityModel *model in self.searchActivityArray) {
            FKYSearchProductCellModel *cellModel = [[FKYSearchProductCellModel alloc]init];
            cellModel.cellType = FKYSearchProductCellTypeFoundCell;
            cellModel.foundModel = model;
            [tempArrary2 addObject:cellModel];
            //[section2.cellList arrayByAddingObject:cellModel];
        }
        section2.cellList = [tempArrary2 copy];
        [self.dataList addObject:section2];
    }
}

/// 搜索商家的搜索发现
- (void)mapperToSearchSellerFoundWithList:(NSArray *)list{
    [self.dataList removeAllObjects];
    FKYSearchProductSectionModel *section1 = [[FKYSearchProductSectionModel alloc]init];
    section1.sectionType = FKYSearchProductSectionTypeHistorySection;
    section1.sectionTitle = @"最近搜索";
    NSMutableArray *tempArrary1 = [[NSMutableArray alloc]init];
    for (FKYSearchHistoryModel *model in self.searchHistoryArray) {
        FKYSearchProductCellModel *cellModel = [[FKYSearchProductCellModel alloc]init];
        cellModel.cellType = FKYSearchProductCellTypeHistoryCell;
        cellModel.historyModel = model;
        [tempArrary1 addObject:cellModel];
        //[section1.cellList arrayByAddingObject:cellModel];
    }
    section1.cellList = [tempArrary1 copy];
    [self.dataList addObject:section1];
    
    if (list.count > 0){
        FKYSearchProductSectionModel *section2 = [[FKYSearchProductSectionModel alloc]init];
        section2.sectionType = FKYSearchProductSectionTypeFoundSection;
        section2.sectionTitle = @"搜索发现";
        section2.cellList = [list copy];
        [self.dataList addObject:section2];
    }
}

- (void)switchHistoryListWithType:(NSString *)type andIsOverTwoLine:(BOOL)isOverTwoLine{
    /// 除掉已经添加进去的历史搜索词
    NSMutableArray *dataList_t = [self.dataList mutableCopy];
    for (int i = 0 ; i<self.dataList.count; i++) {
        FKYSearchProductSectionModel *section = self.dataList[i];
        if (section.sectionType == FKYSearchProductSectionTypeHistorySection){
            FKYSearchProductSectionModel *section_t = dataList_t[i];
            NSMutableArray *array_t = [section_t.cellList mutableCopy];
            [array_t removeAllObjects];
            section_t.cellList = [array_t copy];
            NSLog(@"asdf");
        }
    }

    // 加入历史搜索词
    if ([type isEqualToString:@"flodItem_down"]) {
        // 从折叠到展开
        for (FKYSearchProductSectionModel *section in dataList_t) {
            if (section.sectionType == FKYSearchProductSectionTypeHistorySection){
                NSMutableArray *cellList_t = [[NSMutableArray alloc]init];
                for (FKYSearchHistoryModel *history in self.searchHistoryArray) {
                    FKYSearchProductCellModel *cellModel = [[FKYSearchProductCellModel alloc]init];
                    cellModel.cellType = FKYSearchProductCellTypeHistoryCell;
                    cellModel.historyModel = history;
                    [cellList_t addObject:cellModel];
                }
                if(isOverTwoLine){
                    FKYSearchHistoryModel *history_t = [[FKYSearchHistoryModel alloc]init];
                    history_t.itemType = @"flodItem_down";
                    history_t.name = @"";
                    FKYSearchProductCellModel *cellModel = [[FKYSearchProductCellModel alloc]init];
                    cellModel.cellType = FKYSearchProductCellTypeFoldCell;
                    cellModel.historyModel = history_t;
                    [cellList_t addObject:cellModel];
                }
                section.cellList = [cellList_t copy];
            }
        }
    }else if ([type isEqualToString:@"flodItem_up"]){
        // 从展开到折叠
        for (FKYSearchProductSectionModel *section in dataList_t) {
            if (section.sectionType == FKYSearchProductSectionTypeHistorySection){
                section.cellList = [self.foldHistoryList copy];
                NSLog(@"asdfasf");
            }
        }
    }
    self.dataList = [dataList_t mutableCopy];
}

/// 清空内存中的历史搜索词数据
- (void)clearHistoryWordListInMemory{
    [self.foldHistoryList removeAllObjects];
    self.searchHistoryArray = [[NSArray alloc]init];
    
    for (FKYSearchProductSectionModel *section in self.dataList) {
        if (section.sectionType == FKYSearchProductSectionTypeHistorySection){
            NSMutableArray *array_t = [section.cellList mutableCopy];
            [array_t removeAllObjects];
            section.cellList = [array_t copy];
        }
    }
}


/// 初始化历史搜索数据

#pragma mark - Network Request

// 实时联想搜索
- (void)searchRemindForKeyword:(NSString *)searchKeyword
                       success:(FKYSuccessBlock)successBlock
                       failure:(FKYFailureBlock)failureBlock
{
    NSString *urlString = [seriveUrl stringByAppendingString:searchAssociation];
    NSMutableDictionary *dict = @{}.mutableCopy;
    //   NSString *key = [searchKeyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:(searchKeyword ? searchKeyword : @"") forKey:@"keyword"];
    @weakify(self);
    [self.searchThinkRequest getSearchThinkInShopWithParam:dict completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            self.searchRemindArray = [FKYTranslatorHelper translateCollectionFromJSON:[aResponseObject objectForKey:@"nameAgg"] withClass:[FKYSearchRemindModel class]];
            successBlock(YES);
        }
        else {
            NSString *errMsg = anError.description;
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            failureBlock(errMsg);
        }
    }];
    //    [self GET:urlString parameters:dict success:^(NSURLRequest *request, FKYNetworkResponse *response) {
    //        NSArray *result = response.originalContent[@"data"][@"result"];
    //        self.searchRemindArray = [FKYTranslatorHelper translateCollectionFromJSON:result withClass:[FKYSearchRemindModel class]];
    //        successBlock(NO);
    //    } failure:^(NSString *reason) {
    //        failureBlock(reason);
    //    }];
}

// 获取搜索活动
-(void)getSearchActivityDataSuccess:(FKYSuccessBlock)successBlock
                            failure:(FKYFailureBlock)failureBlock{
    NSMutableDictionary *dic = @{}.mutableCopy;
    NSString *siteCodeStr = @"000000";
    if ([FKYLoginAPI loginStatus] != FKYLoginStatusUnlogin) {
        NSString *code = [FKYLoginAPI currentUser].substationCode;
        if (code != nil && code.length >0) {
            siteCodeStr = code;
        }
    }
    [dic setObject:siteCodeStr forKey:@"siteCode"];
    
    [[FKYRequestService sharedInstance] sendSearchFoundWithParam:dic completionBlock:^(BOOL isSucceed, NSError *error, id response, id model) {
        if (isSucceed) {
            if (response && [response isKindOfClass:NSArray.class]) {
                // 有返回数据
                // NSDictionary *dic = (NSDictionary *)response;
                NSArray *list = response;
                if (list && list.count > 0) {
                    // 有数据
                    NSMutableArray *promotions = @[].mutableCopy;
                    for (NSDictionary *json in list) {
                        FKYSearchActivityModel *activityInfo = [FKYTranslatorHelper translateModelFromJSON:json withClass:[FKYSearchActivityModel class]];
                        [promotions addObject:activityInfo];
                    }
                    self.searchActivityArray = promotions;
                }
            }
            successBlock(YES);
        }else{
            NSString *errMsg = error.description;
            if (error && error.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            failureBlock(errMsg);
        }
    }];
}

// 店铺内实时联想搜索
- (void)searchRemindForStoreByKeyword:(NSString *)searchKeyword
                              storeID:(NSString *)storeID
                              success:(FKYSuccessBlock)successBlock
                              failure:(FKYFailureBlock)failureBlock
{
    
    NSMutableDictionary *dict = @{}.mutableCopy;
    NSString *key = [searchKeyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:(key ? key : @"") forKey:@"keyword"];
    [dict setObject:(storeID ? storeID : @"") forKey:@"sellerCode"];
    if (FKYLoginAPI.loginStatus != FKYLoginStatusUnlogin) {
        dict[@"buyerCode"] = (FKYLoginAPI.currentUserId ? FKYLoginAPI.currentUserId : @"");
        dict[@"roleId"] =  (FKYLoginAPI.currentUser.roleId ? FKYLoginAPI.currentUser.roleId : @"");
        dict[@"userType"] =  (FKYLoginAPI.currentUser.userType ? FKYLoginAPI.currentUser.userType : @"");
    }
    
    @weakify(self);
    [self.searchThinkRequest getSearchThinkInShopWithParam:dict completionBlock:^(id aResponseObject, NSError *anError) {
        @strongify(self);
        if (anError == nil) {
            self.searchRemindArray = [FKYTranslatorHelper translateCollectionFromJSON:[aResponseObject objectForKey:@"nameAgg"] withClass:[FKYSearchRemindModel class]];
            successBlock(YES);
        }
        else {
            NSString *errMsg = anError.description;
            if (anError && anError.code == 2) {
                errMsg = @"用户登录过期，请重新手动登录";
            }
            failureBlock(errMsg);
        }
    }];
}

#pragma mark 获取真实类型<专区，药福利，搜索优惠券可用商品，与全部商品搜索共用类型>
- (NSNumber *)getLocalTypeNumeberWithType:(NSNumber *)type{
    NSNumber *typeIndex = type;
    if (type.integerValue == SearchTypeJBPShop){
        typeIndex = @1;
    }else if (type.integerValue == SearchTypeYFLShop){
        typeIndex = @1;
    }else if (type.integerValue == SearchTypeCoupon){
        typeIndex = @1;
    }
    return typeIndex;
}
#pragma mark 获取真实类型<专区，药福利，搜索优惠券可用商品，与全部商品搜索共用本地存储的虚拟id>
- (NSNumber *)getLocalShopIdNumeberWithType:(NSNumber *)type{
    NSNumber *shopIdNum = type;
    if (type.integerValue == SearchTypeProdcut) {
        shopIdNum = [NSNumber numberWithInt:-1]; //通用商品
    }else if(type.integerValue == SearchTypeShop){
        shopIdNum = [NSNumber numberWithInt:-2]; //店铺搜索
    }else if (type.integerValue == SearchTypeTogeterProduct){
        shopIdNum = [NSNumber numberWithInt:-3];//一起购活动
    }else if (type.integerValue == SearchTypeOrder){
        shopIdNum = [NSNumber numberWithInt:-4];//订单搜索
    }else if (type.integerValue == SearchTypeJBPShop){
        shopIdNum = [NSNumber numberWithInt:-1];//专区搜索使用通用商品  记录保存
    }else if (type.integerValue == SearchTypeYFLShop){
        shopIdNum = [NSNumber numberWithInt:-1];//药福利专区使用通用商品  记录保存
    }else if (type.integerValue == SearchTypeCoupon){
        shopIdNum = [NSNumber numberWithInt:-1];//优惠券可用商品使用通用商品  记录保存
    }else if (type.integerValue == SearchTypePackageRate){
        shopIdNum = [NSNumber numberWithInt:-8];//包邮价列表搜索
    }
    return shopIdNum;
}

#pragma mark - 懒加载
-(NSMutableArray<FKYSearchProductSectionModel *> *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [FKYSearchHistoryMO MR_fetchAllSortedBy:@"addedDate" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    }
    return _fetchedResultsController;
}
                 
- (NSMutableArray<FKYSearchProductCellModel *> *)foldHistoryList{
    if(!_foldHistoryList){
        _foldHistoryList = [[NSMutableArray alloc]init];
    }
    return _foldHistoryList;
}

- (NSArray *)searchRemindArray{
    if (!_searchRemindArray) {
        _searchRemindArray = [[NSArray alloc]init];
    }
    return _searchRemindArray;
}

@end
