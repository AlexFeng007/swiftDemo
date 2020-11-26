//
//  FKYCartCheckModel.h
//  FKY
//  购物车校验接口用，当购物车商品与库存数量不一致时返回的该商品信息
// http://rap.yiyaowang.com/workspace/myWorkspace.do?projectId=246#2597
//  Created by zhangxuewen on 2018/3/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//
#import "FKYBaseModel.h"

@interface FKYCartCheckModel : FKYBaseModel

@property (nonatomic, copy) NSString *productName;          // 商品名称
@property (nonatomic, copy) NSString *message;          // 处理信息
@property (nonatomic, assign) NSInteger shoppingCartId;       //购物车id
@property (nonatomic, copy) NSString *specification;                 // 规格
@property (nonatomic, copy) NSString *spuCode;       //    SPU编码
@property (nonatomic, assign) NSInteger statusCode;       //   处理状态 200070002:"您的购物车中没有供应商"; 200070003:"不能购买自己的商品"; 200070004:"搜索该商品不存在".....;
@property (nonatomic, assign) NSInteger supplyId;       //供应商

-(void)initWithDict:(NSDictionary *)dict;
@end
