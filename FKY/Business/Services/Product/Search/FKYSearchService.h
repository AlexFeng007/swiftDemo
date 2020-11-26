//
//  FKYSearchService.h
//  FKY
//
//  Created by yangyouyong on 15/9/10.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseService.h"
@class FKYSearchRemindModel;
@class FKYSearchHistoryModel;
@class FKYSearchProductSectionModel;
@class FKYSearchProductCellModel;

typedef NS_ENUM(NSUInteger, FKYSearchKeyWordCellType) {
    /// 搜索历史词cell
    FKYSearchKeyWordCellTypeHistoryCell,
    /// 发现cell
    FKYSearchKeyWordCellTypeFoundCell,
};

@interface FKYSearchService : FKYBaseService

@property (nonatomic, strong, readonly) NSArray *searchHistoryArray; // 搜索历史list
@property (nonatomic, strong, readonly) NSArray *searchRemindArray;  // 实时联想搜索list
@property (nonatomic, strong, readonly) NSArray *searchActivityArray; // 搜索历史list
/// 数据list
@property (nonatomic, strong)NSMutableArray<FKYSearchProductSectionModel *> *dataList;

/// 折叠状态下历史搜索词的数据源
@property (nonatomic, strong)NSMutableArray<FKYSearchProductCellModel *> *foldHistoryList;

// 保存
- (void)save:(NSString *)history
        type:(NSNumber *)type
      shopId:(NSNumber *)shopId
     success:(FKYSuccessBlock)successBlock
     failure:(FKYFailureBlock)failureBlock;

// 保存用户在实时联想搜索中（点击）选择的关键词
- (void)saveSearchRemindModel:(FKYSearchRemindModel *)remindModel
                      success:(FKYSuccessBlock)successBlock
                      failure:(FKYFailureBlock)failureBlock;

// 清空
- (void)clearHistorytype:(NSNumber *)type
                  shopId:(NSNumber *)shopId Success:(FKYSuccessBlock)successBlock
                    failure:(FKYFailureBlock)failureBlock;

//

/// 获取搜索历史...<与店铺id无关：在获取所有搜索历史结果中过滤掉店铺内的商品搜索>
/// @param type 1商品历史词 2搜店铺 3 搜索一起购活动4订单搜索5专区6药福利7优惠券可用商品8包邮商品
/// @param successBlock
/// @param failureBlock
- (void)fetchSearchHistoryWithType:(NSNumber *)type
                           Success:(FKYSuccessBlock)successBlock
                          failure:(FKYFailureBlock)failureBlock;
// 获取店铺内的商品搜索历史...<与店铺id相关>
- (void)fetchSearchHistoryWithType:(NSNumber *)type
                            shopid:(NSString *)shopid
                           Success:(FKYSuccessBlock)successBlock
                           failure:(FKYFailureBlock)failureBlock;

//
- (void)emptySearchRemindArray;

// 实时联想搜索
- (void)searchRemindForKeyword:(NSString *)searchKeyword
                       success:(FKYSuccessBlock)successBlock
                       failure:(FKYFailureBlock)failureBlock;
// 店铺内实时联想搜索
- (void)searchRemindForStoreByKeyword:(NSString *)searchKeyword
                              storeID:(NSString *)storeID
                              success:(FKYSuccessBlock)successBlock
                              failure:(FKYFailureBlock)failureBlock;

//删除单个联想词
- (void)clearSigleHistorytype:(NSNumber *)type
                       shopId:(NSNumber *)shopId
                      keyWord:(NSString *)keyWord
                      Success:(FKYSuccessBlock)successBlock
                      failure:(FKYFailureBlock)failureBlock;

// 获取搜索活动
-(void)getSearchActivityDataSuccess:(FKYSuccessBlock)successBlock
                            failure:(FKYFailureBlock)failureBlock;

/// 初始化转换model类型
-(void)mapperToCellModel;

/// 搜索商家的搜索发现
- (void)mapperToSearchSellerFoundWithList:(NSArray *)list;

/// 搜索商家折叠展开切换数据
- (void)switchSearchSellerHistoryListWithType:(NSString *)type andIsOverTwoLine:(BOOL)isOverTwoLine;

/// 折叠展开切换数据
- (void)switchHistoryListWithType:(NSString *)type andIsOverTwoLine:(BOOL)isOverTwoLine;

/// 初始化历史搜索数据
- (void)installHistoryData;

/// 初始化发现列表数据
- (void)installFoundData;

/// 清空内存中的历史搜索词数据
- (void)clearHistoryWordListInMemory;
@end
