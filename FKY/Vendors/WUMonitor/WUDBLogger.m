//
//  WUDBLogger.m
//  FKY
//
//  Created by Rabe on 29/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

#import "WUDBLogger.h"
#import <FMDB/FMDB.h>
#import "WUMonitorConfiguration.h"

static NSString *WUM_CACHE_DIR = @"com.wumonitor.reporter.data";
static NSString *WUM_ERROR_REPORT = @"report.sqlite";

static NSString *WUM_LOGIN_TABLE = @"t_login_report";
static NSString *WUM_LOGOUT_TABLE = @"t_logout_report";

@implementation WUDBLogger

#pragma mark - public

- (id)initWithBundle: (NSBundle *) bundle configuration: (WUMonitorConfiguration *) config {
    NSString *bundleIdentifier = [bundle bundleIdentifier];
    
    return [self initWithApplicationIdentifier: bundleIdentifier configuration:config];
}

- (BOOL)hasErrorReportWithFileType:(WUMonitorFileType)fileType {
    FMDatabase *db = [FMDatabase databaseWithPath:[self errorReportPath]];
    if ([db open]) {
        NSString *tableName = fileType == WUMonitorFileTypeLogin ? WUM_LOGIN_TABLE : WUM_LOGOUT_TABLE;
        NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName];
        NSInteger count = [db intForQuery:querySql];
        if (count > 0) {
            [db close];
            return YES;
        } else {
            [db close];
            return NO;
        }
    }
    return NO;
}

- (void)saveErrorMessage:(WUErrorMessage *)message fileType:(WUMonitorFileType)fileType {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            // 如果没有表格则创表
            NSString *tableName = fileType == WUMonitorFileTypeLogin ? WUM_LOGIN_TABLE : WUM_LOGOUT_TABLE;
            NSString *createSql = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoincrement,value text);", tableName];
            BOOL ret = [db executeUpdate:createSql];
            if (ret) {
               // NSLog(@"\n【WUMonitor DEBUG】已存在监控日志数据库表 %@\n", tableName);
            } else {
               // NSLog(@"\n【WUMonitor DEBUG】未获取到监控日志数据库表，并且创建失败\n");
            }
            
            NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName];
            NSInteger count = [db intForQuery:querySql];
            if (count >= self->_maxItemsInDatabase) {
                NSInteger n = count + 1 - self->_maxItemsInDatabase;
                // 删除超出限制的前n条数据
                NSString *delSql = [NSString stringWithFormat:@"delete from %@ where (select count(id) from %@)> %ld and id in (select id from %@ order by id ASC limit %ld)", tableName, tableName, n, tableName, n];
                if ([db executeUpdate:delSql withArgumentsInArray:nil]) {
                    //NSLog(@"\n【WUMonitor DEBUG】删除监控日志表中时间较早的溢出数据 成功\n");
                    goto finish;
                } else {
                   // NSLog(@"\n【WUMonitor DEBUG】删除监控日志表中时间较早的溢出数据 失败\n");
                }
            } else {
                goto finish;
            }
        finish: {
            // 插入数据
            if (fileType == WUMonitorFileTypeLogin) {
                if ([db executeUpdate:@"INSERT INTO t_login_report (VALUE) VALUES(?) ", [message yy_modelToJSONString]]) {
                  //  NSLog(@"\n【WUMonitor DEBUG】增加数据到监控日志数据库表t_login_report 成功\n");
                } else {
                   // NSLog(@"\n【WUMonitor DEBUG】增加数据到监控日志数据库表t_login_report 失败\n");
                }
            } else {
                if ([db executeUpdate:@"INSERT INTO t_logout_report (VALUE) VALUES(?) ", [message yy_modelToJSONString]]) {
                   // NSLog(@"\n【WUMonitor DEBUG】增加数据到监控日志数据库表t_logout_report 成功\n");
                } else {
                   // NSLog(@"\n【WUMonitor DEBUG】增加数据到监控日志数据库表t_logout_report 失败\n");
                }
            }
        }
            [db close];
        }
    }];
}

- (void)eraseErrorReportWithFileType:(WUMonitorFileType)fileType {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            // 清空数据库表内所有数据
            NSString *tableName = fileType == WUMonitorFileTypeLogin ? WUM_LOGIN_TABLE : WUM_LOGOUT_TABLE;
            NSString *eraseSql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
            BOOL ret = [db executeUpdate:eraseSql];
            if (ret) {
                //NSLog(@"\n【WUMonitor DEBUG】清除监控日志数据库表所有数据 成功\n");
            } else {
               // NSLog(@"\n【WUMonitor DEBUG】清除监控日志数据库表所有数据 失败\n");
            }
            [db close];
        }
    }];
}

- (void)writeTempFileAtPath:(NSString *)tempPath fileType:(WUMonitorFileType)fileType {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            // 1.取出表中所有数据
            NSString *tableName = fileType == WUMonitorFileTypeLogin ? WUM_LOGIN_TABLE : WUM_LOGOUT_TABLE;
            NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
            FMResultSet *resultSet = [db executeQuery:querySql];
            // 2.创建临时文件txt
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL ret = [fileManager createFileAtPath:tempPath contents:nil attributes:nil];
            if (ret) {
                NSFileHandle *tempFile = [NSFileHandle fileHandleForWritingAtPath:tempPath];
                if (tempFile == nil) {
                   // NSLog(@"\n【WUMonitor DEBUG】无法打开临时路径文件用于写入操作\n");
                }
                // 3.将数据库表内数据逐条写入临时文件
                while ([resultSet next]) {
                    [tempFile seekToEndOfFile];
                    NSString *value = [resultSet objectForColumnName:@"value"];
                    value = [value stringByAppendingString:@"\n"];
                    NSData *buffer = [value dataUsingEncoding:NSUTF8StringEncoding];
                    [tempFile writeData:buffer];
                }
                [tempFile closeFile];
            }
            
            [db close];
        }
    }];
}

- (void)removeTempFileAtPath:(NSString *)tempPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ret = [fileManager removeItemAtPath:tempPath error:nil];
    if (ret) {
      //  NSLog(@"\n【WUMonitor DEBUG】删除临时路径文件 成功\n");
    } else {
       // NSLog(@"\n【WUMonitor DEBUG】删除临时路径文件 失败\n");
    }
}

#pragma mark - private

- (id)initWithApplicationIdentifier: (NSString *) applicationIdentifier configuration: (WUMonitorConfiguration *) config {
    if ((self = [super init]) == nil)
        return nil;
    
    NSString *appIdPath = [applicationIdentifier stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (paths.count<=0) {
       // NSLog(@"\n【WUMonitor DEBUG】获取文件路径失败\n");
        return nil;
    }
    NSString *cacheDir = [paths objectAtIndex: 0];
    _maxItemsInDatabase = config.maxItemsInDatabase;
    _reportDirectory = [[cacheDir stringByAppendingPathComponent: WUM_CACHE_DIR] stringByAppendingPathComponent: appIdPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL ret = [fm createDirectoryAtPath:_reportDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (ret) {
       // NSLog(@"\n【WUMonitor DEBUG】获取错误监控日志路径文件夹 成功\n");
    } else {
        //NSLog(@"\n【WUMonitor DEBUG】创建错误监控日志路径文件夹 失败\n");
    }
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self errorReportPath]];
    return self;
}

- (NSString *)errorReportPath {
    return [_reportDirectory stringByAppendingPathComponent: WUM_ERROR_REPORT];
}

@end


