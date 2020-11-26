//
//  FKYByteCache.m
//  FKY
//
//  Created by yangyouyong on 15/9/7.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "FKYByteCache.h"
#import <pthread.h>
#import "sqlite3.h"

@interface FKYByteCache () {
    NSString *filename;
    NSString *name;
    
    sqlite3 *db;
    pthread_rwlock_t rwlock;
}

@end

@implementation FKYByteCache

- (id)init {
    return nil;
}

- (id)initWithFile:(NSString *)path name:(NSString *)tableName {
    if(self = [super init]) {
        db = NULL;
        if(sqlite3_libversion_number() < 3006012) {
            if(sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
                sqlite3_close(db);
                return nil;
            }
        } else {
            if(sqlite3_open_v2([path UTF8String], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, NULL) != SQLITE_OK) {
                sqlite3_close(db);
                return nil;
            }
        }
        NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (URL TEXT PRIMARY KEY, TIME INTEGER, SIZE INTEGER, DATA BOLB);", tableName];
        const char *sql = [sqlstr UTF8String];
        if(sqlite3_exec(db, sql, NULL, NULL, NULL) != SQLITE_OK) {
            sqlite3_close(db);
            return nil;
        }
        if(pthread_rwlock_init(&rwlock, NULL)) {
            return nil;
        }
        filename = path;
        name = tableName;
    }
    return self;
}

- (NSData *)fetch:(NSString *)url timestamp:(time_t *)ti {
    NSString *sql = [NSString stringWithFormat:@"SELECT DATA, TIME FROM %@ WHERE URL = ?;", name];
    if(pthread_rwlock_rdlock(&rwlock))
        return nil;
    sqlite3_stmt *stmt = NULL;
    NSData *data = nil;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
        pthread_rwlock_unlock(&rwlock);
        return nil;
    }
    
    sqlite3_bind_text(stmt, 1, [url UTF8String], (uint)[url length], NULL);
    
    if(SQLITE_ROW == sqlite3_step(stmt)) {
        time_t t = sqlite3_column_int(stmt, 1);
        if(ti) {
            *ti = t;
        }
        data = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 0) length:sqlite3_column_bytes(stmt, 0)];
    }
    
    sqlite3_finalize(stmt);
    pthread_rwlock_unlock(&rwlock);
    return data;
}

- (BOOL)push:(NSData *)data forKey:(NSString *)url {
    return [self push:data timestamp:time(0) forKey:url];
}

- (BOOL)push:(NSData *)data timestamp:(time_t)time forKey:(NSString *)url {
    NSString *sqlstr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (URL, TIME, SIZE, DATA) VALUES(?, ?, ?, ?);", name];
    const char *sql = [sqlstr UTF8String];
    if(pthread_rwlock_wrlock(&rwlock))
        return NO;
    sqlite3_stmt *stmt = NULL;
    if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
        pthread_rwlock_unlock(&rwlock);
        return NO;
    }
    
    sqlite3_bind_text(stmt, 1, [url UTF8String], (int)[url length], NULL);
    
    sqlite3_bind_int(stmt, 2, (int)time);
    
    sqlite3_bind_int(stmt, 3, (int)[data length]);
    
    if(sqlite3_bind_blob(stmt, 4, [data bytes], (int)[data length], NULL) != SQLITE_OK) {
        sqlite3_finalize(stmt);
        pthread_rwlock_unlock(&rwlock);
        return NO;
    }
    
    BOOL result = (SQLITE_DONE == sqlite3_step(stmt));
    sqlite3_finalize(stmt);
    
    pthread_rwlock_unlock(&rwlock);
    return result;
}

- (BOOL)remove:(NSString *)url {
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE URL = \"%@\";", name, url];
    if(pthread_rwlock_wrlock(&rwlock))
        return NO;
    BOOL result = SQLITE_OK == sqlite3_exec(db, [sqlstr UTF8String], NULL, NULL, NULL);
    pthread_rwlock_unlock(&rwlock);
    return result;
}

- (BOOL)trimToTimestamp:(time_t)time {
    BOOL result = YES;
    if(pthread_rwlock_wrlock(&rwlock))
        return NO;
    if(sqlite3_exec(db, "BEGIN TRANSACTION", NULL, NULL, NULL) != SQLITE_OK) {
        pthread_rwlock_unlock(&rwlock);
        return NO;
    }
    do {
        NSString *sqlstr = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE TIME <= %ld", name, time];
        if(SQLITE_OK != sqlite3_exec(db, [sqlstr UTF8String], NULL, NULL, NULL)) {
            result = NO;
            break;
        }
    } while(NO);
    
    if(result && sqlite3_exec(db, "COMMIT", NULL, NULL, NULL) != SQLITE_OK)
        result = NO;
    
    if(result) {
    } else {
        sqlite3_exec(db, "ROLLBACK", NULL, NULL, NULL);
    }
    
    pthread_rwlock_unlock(&rwlock);
    return result;
}

- (void)dealloc {
    sqlite3_close(db);
    pthread_rwlock_destroy(&rwlock);
}

@end
