//
//  FKYSearchHistoryMO+CoreDataProperties.h
//  
//
//  Created by mahui on 16/9/26.
//
//

#import "FKYSearchHistoryMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FKYSearchHistoryMO (CoreDataProperties)

+ (NSFetchRequest<FKYSearchHistoryMO *> *)fetchRequest;

@property (nullable, nonatomic, strong) NSDate *addedDate;  // 加入时间
@property (nullable, nonatomic, copy) NSString *name;       // 搜索关键词
@property (nullable, nonatomic, copy) NSString *vender;     // 商家名称
@property (nullable, nonatomic, strong) NSNumber *venderid; // 商家id
@property (nullable, nonatomic, strong) NSNumber *type;     // 搜索类型...1:商品 2:店铺

@end

NS_ASSUME_NONNULL_END
