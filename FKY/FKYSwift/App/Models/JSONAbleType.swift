//
//  JSONAbleType.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

protocol JSONAbleType {
    static func fromJSON(_: [String: AnyObject]) -> Self
}

protocol ReverseJSONType {
    func reverseJSON() -> [String: AnyObject]
}
