//
//  FKYEnterpriseListView.h
//  FKY
//
//  Created by 夏志勇 on 2017/11/30.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  企业列表视图...<用于切换企业>

#import <UIKit/UIKit.h>

@interface FKYEnterpriseListView : UIView

@property (nonatomic, copy) void(^dismissBlock)(void);
@property (nonatomic, copy) void(^selectEnterpriseBlock)(NSInteger index, id data);

//
- (void)setEnterpriseList:(NSArray *)arrayList withCurrentEnterprise:(NSString *)name;
//
- (void)showOrHideListView:(BOOL)showFlag withAnimation:(BOOL)animation;

@end
