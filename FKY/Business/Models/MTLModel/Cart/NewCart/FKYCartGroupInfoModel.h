//
//  FKYCartGroupInfoModel.h
//  FKY
//
//  Created by 寒山 on 2018/6/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKYBaseModel.h"
#import "FKYPromotionHGInfo.h"
#import "FKYCartVipModel.h"
#import "FKYShareStockInfoModel.h"

@interface FKYCartGroupInfoModel : FKYBaseModel

@property (nonatomic, strong) NSNumber *checkStatus;    //    商品勾选状态    number    @mock=1
@property (nonatomic, copy) NSString *productImageUrl;    //    商品图片地址    string    @mock=https://p8.maiyaole.com//fky/img/%E5%B9%BF%E5%91%8A.jpg?x-oss-process=image/resize,h_120
@property (nonatomic, copy) NSString *manufactures;    //    生产企业    string    @mock=上海APP生产商
@property (nonatomic, strong) NSDictionary *messageMap ;    //   提示消息：实际库存展示信息，超出实际最大可售库存时提示等    object
@property (nonatomic, strong) NSNumber *minPackingNum;    //    商品最小拆零包装    number    @mock=1
@property (nonatomic, strong) NSNumber *productMaxNum;    //    商品最大可购买数量    number
@property (nonatomic, strong) NSString *promoteJoinedDesc ;    //  已参与过促销的描述 number   
@property (nonatomic, strong) NSNumber *productCount;    //    商品购买数量    number    @mock=5
@property (nonatomic, strong) NSDictionary *productLimitBuy;    //    商品限购    object
@property (nonatomic, copy)   NSString *productName;    //    商品名称    string    @mock=测试专用WF
@property (nonatomic, strong) NSNumber *productPrice;    //    商品单价    number    @mock=11
@property (nonatomic, strong) NSDictionary *productRebate;    //    商品返利    object
@property (nonatomic, strong) NSNumber *productStatus;    //    商品状态    number    @mock=0
@property (nonatomic, strong) NSDictionary *promotionFlashSale ;    //   闪购    object    @mock=
@property (nonatomic, strong) NSDictionary  *promotionHG;    //    换购促销活动    array<object>
@property (nonatomic, strong) NSDictionary *promotionJF;    //    送积分促销活动    object
@property (nonatomic, strong) NSDictionary *promotionMJ;    //       object
@property (nonatomic, strong) NSDictionary *promotionMZ;    //       object
@property (nonatomic, strong) NSDictionary *promotionTJ;    //        object
@property (nonatomic, strong) NSDictionary *promotionManzhe;    //        object
@property (nonatomic, strong) NSDictionary  *agreementRebate;    //    协议返利金
@property (nonatomic, strong) NSNumber *saleStartNum;    //    商品起售门槛/起订量    number    @mock=1
@property (nonatomic, strong) NSNumber *settlementPrice;    //    商品结算金    number    @mock=55
@property (nonatomic, strong) NSNumber *shoppingCartId;    //    购物车商品ID    string    @mock=240836
@property (nonatomic, copy) NSString *specification;    //    商品规格    string    @mock=10g
@property (nonatomic, copy) NSString *spuCode;    //    SPU编码    string    @mock=012345AAAZ40001
@property (nonatomic, copy) NSString *unit;    //    商品的最小包装单位    string    @mock=袋
@property (nonatomic, assign)int supplyId; 
@property (nonatomic, copy) NSString *deadLine;//有效时间
@property (nonatomic, copy) NSString *batchNum;//截止时间
@property (nonatomic, copy) NSString *outMaxReason;//超出最大可售数量，最多只能购买9999
@property (nonatomic, copy) NSString *lessMinReson;//该普通商品最小起批量为1
@property (nonatomic, assign) NSInteger editStatus; // 0:(默认)未编辑状态, 1:编辑未选中, 2: 编辑已选中
@property (nonatomic, assign) BOOL reachLimitNum;    //    是否达到限购
@property (nonatomic, assign) BOOL nearEffect;   //    是否是近效期
//@property (nonatomic,strong) NSNumber *productCodeCompany;
@property (nonatomic, copy) NSString *productCodeCompany;
@property (nonatomic, assign) BOOL canUseCouponFlag; //商品是否不可用劵标识 0:不可用券, 1:可用券
@property (nonatomic, strong) NSNumber *promotionId;
@property (nonatomic, strong) FKYCartVipModel *vipPromotionInfo; //vip相关信息
@property (nonatomic, strong) FKYShareStockInfoModel *shareStockVO; //分享库存信息
@property (nonatomic, strong) NSNumber *isMutexTeJia;//是否为不可用券商品(1是：0不是)
@property (nonatomic, copy) NSString *shareStockDesc;//共享库存需要弹窗的信息，有则提示
@property (nonatomic, assign) BOOL isMixRebate;    //    判断是不是多品返利
@end



