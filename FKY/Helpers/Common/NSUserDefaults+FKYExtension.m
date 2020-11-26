//
//  NSUserDefaults+FKYExtension.m
//  FKY
//
//  Created by yangyouyong on 15/9/9.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import "NSUserDefaults+FKYExtension.h"

NSString *const FKYLocationKey = @"FKYLocationKey";

NSString *const FKYCurrentUserKey = @"FKYCurrentUserKey";
NSString *const FKYCurrentAddressKey = @"FKYCurrentAddressKey";
NSString *const FKYMainAPIKey = @"FKYMainAPIKey";
NSString *const FKYMarkAuditStatusForHomeWebPage = @"FKYMarkAuditStatusForHomeWebPage";//根据资料审核状态刷新首页


NSString * GET_MAIN_API(){
    NSString *api = nil;
    api = UD_OB(FKYMainAPIKey);
    return api != nil ? api : FKY_PREFER_API;
}
void SET_MAIN_API(NSString *apiString) {
    UD_ADD_OB(apiString, FKYMainAPIKey);
    [UD synchronize];
}

NSString * GET_PIC_HOST() {
//    NSString *mainAPI = GET_MAIN_API();
//    if ([mainAPI isEqualToString:FKY_PREFER_API]) {
//        return FKY_PC_TEST_HOST;
//    }else{
        return FKY_PC_HOST;
//    }
}

NSString * GET_PC_HOST() {
//    return FKY_PC_TEST_HOST;
    return FKY_PC_HOST;
}

@implementation NSUserDefaults (FKYExtension)

+ (void)load{
    {
        Method originalMethod = class_getInstanceMethod([self class], @selector(setObject:forKey:));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(setObject:forKeyS:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    {
        Method originalMethod = class_getInstanceMethod([self class], @selector(objectForKey:));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(objectForKeyS:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setObject:(nullable id)value forKeyS:(NSString *)defaultName;{
    
    if ([defaultName isEqualToString:@"WebKitDatabasesEnabledPreferenceKey"]) {
        NSLog(@"");//这个key没有调用set,但会调用get
    }
    
    [self setObject:value forKeyS:defaultName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //本来想定义在一个文件里，但是还要处理同步文件读取就写多个文件吧
    NSString *filename = [plistPath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"myNSUserDefaults_%@.plist",defaultName]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filename] == NO){
        //创建plist
        [fm createFileAtPath:filename contents:nil attributes:nil];
        //NSLog(@"不存在");
    }
    
    //文件转字典
    NSDictionary *dic= [NSDictionary dictionaryWithContentsOfFile:filename];
    
    //nil的话mutableCopy也没用
    if (dic == nil) dic = @{};
    
    NSMutableDictionary *muDic = dic.mutableCopy;
    
    //nil直接set会崩溃
    if (value == nil) {
        value = @"-199999";
    }
    [muDic setObject:value forKey:defaultName];
 
    //NSLog(@"比较哪个值有问题：系统 %@ %@ %@",filename,muDic.allValues,muDic.allKeys);
    //字典写入文件
    [muDic writeToFile:filename atomically:YES];
 
    
}
- (nullable id)objectForKeyS:(NSString *)defaultName;
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //本来想定义在一个文件里，但是还要处理同步文件读取就写多个文件吧
    NSString *filename = [plistPath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"myNSUserDefaults_%@.plist",defaultName]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filename] == NO){
        //创建plist
        [fm createFileAtPath:filename contents:nil attributes:nil];
       // NSLog(@"不存在");
    }
    NSDictionary *dic= [NSDictionary dictionaryWithContentsOfFile:filename];
    
    id obj = [self objectForKeyS:defaultName];//系统方法取值
 
    id myObj = [dic objectForKey:defaultName];//自己方法取值
    if([myObj isEqual:[NSNull null]] || [[NSString stringWithFormat:@"%@",myObj] isEqualToString:@"-199999"]){
        myObj = nil;
    }
    
    if (obj != myObj) {
        ///NSLog(@"比较哪个值有问题：系统 %@ %@",defaultName,obj);
       // NSLog(@"比较哪个值有问题：自己 %@ %@",defaultName,myObj);
    }
 
    //原来存的nil 取出来还是nil
    if (obj) {
        return obj;
    }
    return myObj;
}

@end
