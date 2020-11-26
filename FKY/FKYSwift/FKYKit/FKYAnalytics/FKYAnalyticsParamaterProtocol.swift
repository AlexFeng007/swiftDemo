//
//  FKYAnalyticsParamaterProtocol.swift
//  FKYAnalytics
//
//  Created by yangyouyong on 2016/8/16.
//  Copyright © 2016年 yangyouyong. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol FKYAnaliticsParamaterProtocol {
    @objc optional
    func ViewControllerParamaters() -> [String: AnyObject]?
    func ViewControllerParamatersHtmlType() -> Bool
    func ViewControllerSingleParams() -> String?
    func ViewControllerPageCode() -> String?    // 获取当前页面code
}

extension UIViewController: FKYAnaliticsParamaterProtocol {
    
    /**
     拼接cururl 和refer 的参数列表
     */
    func ViewControllerParamaters() -> [String : AnyObject]? {
        return nil
    }
    
    /**
     是否带html 后缀
     */
    func ViewControllerParamatersHtmlType() -> Bool {
        return false
    }
    
    /**
     单个参数链接
     */
    func ViewControllerSingleParams() -> String? {
        return nil
    }
    
    /**
     返回当前页面的页面类型, 用于追溯前一页的页面类型
     */
    func ViewControllerPageType() -> String? {
        return nil
    }
    
    /**
     返回当前页面的pagecode
     */
    func ViewControllerPageCode() -> String? {
        return nil
    }
    
    /**
     swift 下controller的BI统计
     */
     //MARK: - BI Action
//    func BI_Record(_ action: ACTIONITEM) {
//        FKYAnalyticsManager.sharedInstance.BI_Record(action, eventId: nil, viewController: self)
//    }
    
    // OBJC
//    @objc func BI_Record(_ action: String) {
//        FKYAnalyticsManager.sharedInstance.BI_Record(true, action: action, viewController: self)
//    }
}
