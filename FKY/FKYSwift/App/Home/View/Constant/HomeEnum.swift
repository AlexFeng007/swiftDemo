//
//  HomeEnum.swift
//  FKY
//
//  Created by Rabe on 13/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

/// 首页楼层类型
///
/// - banner001: 轮播图 <xzy>
/// - newMember002: 新人专享
/// - activity003: 1起闪/拼/购 活动
/// - advertise004: 大型活动（广告栏）
/// - firstRecommend006: 首推特价（药城精选） <xzy>
/// - enterprise007: 供应商甄选
/// - categoryHotSale008: 类目热销（商品分类列表）<xzy>
/// - mostFavorite009: 区域热搜（消费者最爱买它们）
/// - rankList010: 排行榜（本周排行榜/区域热搜榜）<xzy>
/// - recentPurchase011: 最近采购
/// - topCategories012: 热门分类
/// - notices013: 药城公告
/// - navigation014: 导航按钮
/// - secondKill016: 秒杀专区

enum HomeTemplateType: Int {
    case unknow000 = 0
    case banner001 = 1
    case newMember002 = 2
    case activity003 = 3
    case advertise004 = 4
    case firstRecommend006 = 6
    case enterprise007 = 7
    case categoryHotSale008 = 8
    case mostFavorite009 = 9
    case rankList010 = 10
    case recentPurchase011 = 11
    case topCategories012 = 12
    case notices013 = 13
    case navigation014 = 14
    case secondKill016 = 16
}


/// 首页楼层点击事件
///
/// - unknow: 默认未定义事件
/// - banner001_clickItem: 轮播banner之查看详情
/// - newPrivillege002_clickItem: 新人专享之查看详情
/// - activityBuy003_clickItem: 一起系列之查看详情
/// - adWelfare004_clickItem: 广告活动之查看详情
/// - firstRecommend006_clickItem: 首推特价（药城精选）之查看商详
/// - firstRecommend006_clickItemMore: 首推特价（药城精选）更多按钮
/// - recommend006_clickMore: 药城精选点击更多
/// - supplySelect007_clickItem: 供应商甄选之进入店铺
/// - supplySelect007_clickMore: 供应商甄选之更多供应商
/// - categoryHotSale008_clickItem: 类目热销之查看搜索列表
/// - categoryHotSale008_clickMore: 类目热销之查看更多
/// - categoryHotSale008_clickSwitch: 类目热销之切换类目
/// - hexie009_clickItem: 消费者最爱之立即查看
/// - rankList010_clickMore: 排行榜之查看详情
/// - recentPurchase0011_clickItem: 最近采购之立即查看
/// - topCategories012_clickItem: 热门病症之点击分类
/// - topCategories012_clickMore: 热门病症之点击更多
/// - notice013_clickItem: 药城公告点击item
/// - navigation014_clickItem: 导航按钮点击item
/// - activityPatterm_clickMore: 一起系列查看更多
/// - secondKill016_clickMore: 秒杀专区之查看更多
/// - secondKill016_clickItem: 秒杀专区之查看商品详情

enum HomeTemplateActionType {
    case unknow
    case banner001_clickItem
    case newPrivillege002_clickItem
    case activityBuy003_clickItem
    case adWelfare004_clickItem
    case firstRecommend006_clickItem
    case firstRecommend006_clickItemMore
    case recommend006_clickMore
    case supplySelect007_clickItem
    case supplySelect007_clickMore
    case categoryHotSale008_clickItem
    case categoryHotSale008_clickMore
    case categoryHotSale008_clickSwitch
    case hexie009_clickItem
    case rankList010_clickMore
    case recentPurchase0011_clickItem
    case topCategories012_clickItem
    case topCategories012_clickMore
    case notice013_clickItem
    case navigation014_clickItem
    case activityPatterm_clickMore
    case secondKill016_clickMore
    case secondKill016_clickItem
    case category_home_ad_clickItem
}


