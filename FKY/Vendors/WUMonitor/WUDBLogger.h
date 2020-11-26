//
//  WUDBLogger.h
//  FKY
//
//  Created by Rabe on 30/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WUMonitorFileType) {
    WUMonitorFileTypeLogin,
    WUMonitorFileTypeLogout,
};

@class WUErrorMessage, FMDatabaseQueue, WUMonitorConfiguration;
@interface WUDBLogger : NSObject {
@private
    FMDatabaseQueue *_dbQueue;
    NSString *_reportDirectory;
    NSInteger _maxItemsInDatabase;
}

/**
 初始化方法

 @param bundle 沙盒
 @param config 配置
 @return 实例
 */
- (instancetype)initWithBundle:(NSBundle *)bundle configuration: (WUMonitorConfiguration *)config;
/**
 是否有错误日志数据在数据库中
 @param fileType 日志类型
 */
- (BOOL)hasErrorReportWithFileType:(WUMonitorFileType)fileType;
/**
 将错误信息写入监控日志
 
 @param message 错误信息model
 @param fileType 日志类型
 */
- (void)saveErrorMessage:(WUErrorMessage *)message fileType:(WUMonitorFileType)fileType;
/**
 清除错误日志表中所有数据
 
 @param fileType 日志类型
 */
- (void)eraseErrorReportWithFileType:(WUMonitorFileType)fileType;
/**
 将数据库文件转换成临时用于上传的txt文件
 @param tempPath 临时路径
 @param fileType 日志类型
 */
- (void)writeTempFileAtPath:(NSString *)tempPath fileType:(WUMonitorFileType)fileType;
/**
 删除临时用于上传的txt文件

 @param tempPath 临时路径
 */
- (void)removeTempFileAtPath:(NSString *)tempPath;
@end
