//
//  FKYSearchHistoryMO+CoreDataProperties.m
//  
//
//  Created by mahui on 16/9/26.
//
//

#import "FKYSearchHistoryMO+CoreDataProperties.h"

@implementation FKYSearchHistoryMO (CoreDataProperties)

+ (NSFetchRequest<FKYSearchHistoryMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FKYSearchHistoryMO"];
}

@dynamic addedDate;
@dynamic name;
@dynamic vender;
@dynamic venderid;
@dynamic type;

@end
