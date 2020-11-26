//
//  NSString+FKYKit.h
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FKYKit)

// 判断是否是银行卡号
- (BOOL)isBankCard;

// 判断字符串是否为整型
- (BOOL)isPureInteger;

// 判断是否为手机号...<不全，不再使用>
- (BOOL)isCellPhone;

// 判断是否为手机号
- (BOOL)isPhoneNumber;

/**
 *  为imageUrl添加前缀
 *
 *  @return 添加后的URL
 */
- (NSString *)fky_imageUrlAddHost;

+ (NSString *)getBankName:(NSString *)cardId;

/**
 *  将日 时 分 秒 转换成对应的字符串
 *
 *  @param day    日
 *  @param hour   时
 *  @param minute 分
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)stringForDay:(NSInteger)day
                      hour:(NSInteger)hour
                    minute:(NSInteger)minute;

/**
 *  将日 时 分 秒 转换成对应的字符串
 *
 *  @param day    日
 *  @param hour   时
 *  @param minute 分
 *  @param second 秒
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)stringForDay:(NSInteger)day
                      hour:(NSInteger)hour
                    minute:(NSInteger)minute
                    second:(NSInteger)second;


#pragma mark -  退换货

// 判断字符串是否只由英文和数字组成
+ (BOOL)validateOnlyEnglishAndNumber:(NSString *)text;

// 判断字符串是否只由汉字组成
+ (BOOL)validateOnlyChinese:(NSString *)text;

// 过滤非汉字字符
+ (NSString *)filterForChinese:(NSString *)text;

// 根据正则表达式，过滤特殊字符
+ (NSString *)filterCharactor:(NSString *)text withRegex:(NSString *)regexStr;

// 判断是否含有表情符号 yes-有 no-没有
+ (BOOL)stringContainsEmoji:(NSString *)text;

// 是否是系统自带九宫格输入 yes-是 no-不是
+ (BOOL)isNineKeyBoard:(NSString *)text;

// 判断第三方键盘中的表情
+ (BOOL)hasEmoji:(NSString *)text;

// 去除表情
+ (NSString *)disableEmoji:(NSString *)text;


#pragma mark - 短信验证码

// 6位数字
+ (BOOL)validateMessageCode:(NSString *)text;


#pragma mark -

// 判断字符串是否只由数字组成
+ (BOOL)validateOnlyNumber:(NSString *)text;

// 过滤字符串中所有的非数字字符
+ (NSString *)getPureNumber:(NSString *)text;


@end
