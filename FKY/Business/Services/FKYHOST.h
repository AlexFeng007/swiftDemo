//
//  FKYHOST.h
//  FKY
//
//  Created by mahui on 2016/11/18.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#ifndef FKYAPIHOST_h
#define FKYAPIHOST_h


#ifdef FKY_ENVIRONMENT_MODE

#if FKY_ENVIRONMENT_MODE == 1   // 线上环境

NSString *const MANAGE_HOST = @"https://manage.yaoex.com/api/"; // 首页
NSString *const MALL_HOST   = @"https://mall.yaoex.com/api/"; // 搜索
NSString *const PASSPORT_HOST = @"https://passport.yaoex.com/api/";// 登录注册
NSString *const PAY_HOST     = @"https://pay.yaoex.com/api/"; // 支付 sign签名 host
NSString *const DRUGGMP_HOST = @"https://druggmp.yaoex.com/api/"; // 分类
NSString *const P8_HOST      = @"https://p8.maiyaole.com/";   // 图片
NSString *const IMAGE_CODE_HOST = @"https://web-ycaptcha.yaoex.com/"; // 注册获取图片验证码
NSString *const MESSAGE_HOST = @"https://arch-sms.yaoex.com/"; // 短信验证码
NSString *const M_HOST       = @"https://m.yaoex.com/"; // M站 host
NSString *const LOGICTICS_HOST = @"http://oms.yaoex.com/api/"; // 物流详情 host
NSString *const ORDER_HOST = @"https://moms.yaoex.com/api/"; // 订单、购物车  host
NSString *const USERMANAGE_HOST = @"https://usermanage.yaoex.com/api/"; // 兴科蓉活动 host

#elif FKY_ENVIRONMENT_MODE == 2 // 开发环境

NSString *const MANAGE_HOST = @"http://manage.yaoex.com/api/"; // 首页
NSString *const MALL_HOST   = @"http://mall.yaoex.com/api/"; // 搜索
NSString *const PASSPORT_HOST = @"http://passport.yaoex.com/api/";// 登录注册
NSString *const PAY_HOST     = @"http://pay.yaoex.com/api/"; // 支付 sign签名 host
NSString *const DRUGGMP_HOST = @"http://druggmp.yaoex.com/api/"; // 分类
NSString *const P8_HOST      = @"http://p8.maiyaole.com/";   // 图片
NSString *const IMAGE_CODE_HOST = @"https://web-ycaptcha.yaoex.com/"; // 注册获取图片验证码
NSString *const MESSAGE_HOST = @"https://arch-sms.yaoex.com/"; // 短信验证码
NSString *const M_HOST       = @"https://m.yaoex.com/"; // M站 host
NSString *const LOGICTICS_HOST = @"http://oms.yaoex.com/api/"; // 物流详情 host
NSString *const ORDER_HOST = @"http://10.6.30.39:91/api/"; // 订单、购物车  host
NSString *const USERMANAGE_HOST = @"http://usermanage.yaoex.com/api/"; // 兴科蓉活动 host

#elif FKY_ENVIRONMENT_MODE == 3 // 测试环境

NSString *const MANAGE_HOST = @"http://manage.yaoex.com/api/"; // 首页
NSString *const MALL_HOST   = @"http://mall.yaoex.com/api/"; // 搜索
NSString *const PASSPORT_HOST = @"http://passport.yaoex.com/api/";// 登录注册
NSString *const PAY_HOST     = @"http://pay.yaoex.com/api/"; // 支付 sign签名 host
NSString *const DRUGGMP_HOST = @"http://druggmp.yaoex.com/api/"; // 分类
NSString *const P8_HOST      = @"http://p8.maiyaole.com/";   // 图片
NSString *const IMAGE_CODE_HOST = @"https://web-ycaptcha.yaoex.com/"; // 注册获取图片验证码
NSString *const MESSAGE_HOST = @"https://arch-sms.yaoex.com/"; // 短信验证码
NSString *const M_HOST       = @"https://m.yaoex.com/"; // M站 host
NSString *const LOGICTICS_HOST = @"http://oms.yaoex.com/api/"; // 物流详情 host
NSString *const ORDER_HOST = @"http://moms.yaoex.com/api/"; // 订单、购物车  host
NSString *const USERMANAGE_HOST = @"http://usermanage.yaoex.com/api/"; // 兴科蓉活动 host

#endif

#else

#error "Environment mode did not set. Open Target-BuildSetting-Preprocessor Macros & finish setting for dis, dev, test environment."

#endif


#endif /* FKYAPIHOST_h */
