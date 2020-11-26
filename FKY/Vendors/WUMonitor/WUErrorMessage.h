//
//  WUErrorMessage.h
//  FKY
//
//  Created by Rabe on 29/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 监控错误类型枚举
 
 - WUMonitorErrorUnknown: 未知
 - WUMonitorErrorApi: 接口错误
 - WUMonitorErrorWeb: 容器加载错误
 - WUMonitorErrorImageLoading: 图片下载错误
 */
typedef NS_ENUM(NSUInteger, WUMonitorError) {
    WUMonitorErrorUnknown = 0,
    WUMonitorErrorApi = 1,
    WUMonitorErrorWeb = 2,
    WUMonitorErrorImageLoading = 3,
};

@interface WUErrorInfo : NSObject

@property (nonatomic, copy) NSString *errorName;
@property (nonatomic, copy) NSString *errorType;
@property (nonatomic, copy) NSString *errorCode;
@property (nonatomic, copy) NSString *errorDes;

@end



@interface WUErrorMessage : NSObject

@property (nonatomic, copy  ) NSString *netType;
@property (nonatomic, copy  ) NSString *sp;
@property (nonatomic, copy  ) NSString *area;
@property (nonatomic, copy  ) NSString *uid;
@property (nonatomic, strong) WUErrorInfo *errorInfo;
@property (nonatomic, copy  ) NSString *deviceId;
@property (nonatomic, copy  ) NSString *deviceType;
@property (nonatomic, copy  ) NSString *appVersion;
@property (nonatomic, copy  ) NSString *osVersion;
@property (nonatomic, copy  ) NSString *time;

+ (instancetype)errorMessageWithErrName:(NSString *)errName errType:(WUMonitorError)errType errCode:(NSString *)errCode errDes:(NSString *)errDes;
- (instancetype)initWithErrName:(NSString *)errName errType:(WUMonitorError)errType errCode:(NSString *)errCode errDes:(NSString *)errDes;

- (NSString *)jsonValue;

@end


/*
 
 {
 "netType": "4G"，           //网络环境
 "sp": "电信",                   //运营商
 "area": "上海市",            //定位地区
 "uid": "2008392",          //用户id，登录时记录
 "errorInfo": {                  //具体的错误信息
 "errorName": "getversion",  //错误名称(如果是业务接口，记录接口名字)
 "errorType": "1",                  //错误类型(api、h5、img)
 "errorCode": "504",            //错误编码
 "errorDes": "timeout"         //错误描述
 },
 "deviceId": "erw2-2aws-231d-2das-2231",        //设备号
 "deviceType": "android",                                     //设备类型(android、iOS)
 "appVersion": "3.8.1",                                         //app版本
 "osVersion": "7"                                                  //系统版本
 "time":"20180125103025"          //错误发生时间(年月日时分秒)
 }
 
 */
