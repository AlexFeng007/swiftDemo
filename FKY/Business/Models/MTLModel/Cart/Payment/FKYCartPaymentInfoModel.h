//
//  FKYCartPaymentInfoModel.h
//  FKY
//
//  Created by yangyouyong on 15/12/2.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYBaseModel.h"

@interface FKYCartPaymentInfoModel : FKYBaseModel

@property (nonatomic, copy) NSString *MerPageUrl;
@property (nonatomic, copy) NSString *CurryNo;
@property (nonatomic, copy) NSString *MerId;
@property (nonatomic, copy) NSString *SplitMethod;
@property (nonatomic, copy) NSString *Version;
@property (nonatomic, copy) NSString *MerOrderNo;
@property (nonatomic, copy) NSString *OrderAmt;
@property (nonatomic, copy) NSString *TranDate;
@property (nonatomic, copy) NSString *SplitType;
@property (nonatomic, copy) NSString *TranType;
@property (nonatomic, copy) NSString *BankInstNo;
@property (nonatomic, copy) NSString *BusiType;
@property (nonatomic, copy) NSString *MerBgUrl;
@property (nonatomic, copy) NSString *MerSplitMsg;
@property (nonatomic, copy) NSString *AccessType;
@property (nonatomic, copy) NSString *Signature;
@property (nonatomic, copy) NSString *TranTime;
@property (nonatomic, copy) NSString *CommodityMsg;

@end
