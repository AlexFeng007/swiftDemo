//
//  FKYAccountToolsModel.h
//  FKY
//
//  Created by 乔羽 on 2018/9/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKYAccountToolsModel : FKYBaseModel

@property (nonatomic, copy) NSString *imgPath;          // 工具图标地址
@property (nonatomic, copy) NSString *title;             // 工具名称
@property (nonatomic, copy) NSString *toolId;           // 工具唯一编号
@property (nonatomic, copy) NSString *jumpInfo;         // 跳转页面url
@property (nonatomic, assign) NSInteger newToolFlag;    // 是否新增 <1：新增；0：原有 新增的显示new角标>
/**
 资质过期提示
 */
@property (nonatomic, copy) NSString *qualificationExpiredDesc;
@end
