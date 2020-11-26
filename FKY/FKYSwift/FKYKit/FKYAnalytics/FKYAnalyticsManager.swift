//
//  FKYAnalyticsManager.swift
//  FKYAnalytics
//
//  Created by yangyouyong on 2016/8/16.
//  Copyright © 2016年 yangyouyong. All rights reserved.
//  BI埋点

import Foundation
import UIKit
import SwiftyJSON

@objc
final class FKYAnalyticsManager: NSObject {
    // MARK: - Property
    @objc static let sharedInstance = FKYAnalyticsManager()
    @objc var referPageCode:String = "startLoading" //记录上一个有效控制器的pageCode
    //var oldReferPageCode :String = "" //
	//var refferVCStr: String = ""
    @objc var h5ReferPageCode:String = PAGECODE.HOME.rawValue //记录界面出现后的pagecode
	
    // MARK: - init
    fileprivate override init() {

    }
    // MARK: 记录有效控制器界面消失的时的pageCode和refer<如控制器中弹出控制器，可设置弹出控制器的pagecode与父控制器相同>
    @objc
	func BI_OutViewController(_ viewController: UIViewController?) {
        //即将消失的控制器有pagecode，并且即将push出来的控制器有pageCode ,并且不同即重置referPageCode值<FKYTabBarController根控器不判断>
        if let vc = viewController ,let pageCode = vc.ViewControllerPageCode(){
            if let visibleVc = FKYNavigator.shared()?.visibleViewController {
                if visibleVc.isKind(of: FKYTabBarController.self){
                    self.referPageCode = pageCode
                }else if let nextPageCode = visibleVc.ViewControllerPageCode(), pageCode != nextPageCode {
                    self.referPageCode = pageCode
                }else if let nextPageCode = visibleVc.ViewControllerPageCode(), [PAGECODE.LOGIN.rawValue, PAGECODE.GLWebVcActivity.rawValue].contains(nextPageCode) == true {
                    //prsent弹出的控制器<最后一个控制权pop的时候，vc(消失的控制)和nextPageCode（栈中显示的控制）属于同一个>
                    self.referPageCode = pageCode
                }
            }
        }
	}

    @objc
    func BI_InViewController(_ viewController: UIViewController?) {
        if let vc = viewController ,let pageCode = vc.ViewControllerPageCode(){
            self.h5ReferPageCode = pageCode
        }
    }
    @objc
    func resetReferPageCodeOnViewHide(_ referPageCode:String) {
        self.referPageCode = referPageCode
    }
    
    // MARK:- 发送请求
    func requestParmas(_ params: [String: AnyObject]) {
        FKYRequestService.sharedInstance()?.requestForBI(withParam: params, completionBlock: { (isSuccess, error, response, model) in
            //
        })
    }
}
//MARK:公共方法
@objc
extension FKYAnalyticsManager {
    // MARK:- 空字符串校验
    func checkEmptyString(_ string: String?) -> String {
        if let str = string {
            return str
        }
        return ""
    }
    
    // MARK:- 未登录用户校验
    func checkEmptyUserId(_ userid: String?) -> String {
        if let str = userid {
            return str
        }
        return ""
    }
    
    // MARK: - 生成当前页链接
//    func generatorCurUrl(_ vc: UIViewController?) -> String {
//        if vc == nil {
//            return ""
//        }
//        let viewController = vc!
//        let currentString = NSMutableString()
//        var cururl:String? = nil
//        var classStr = getObjcClass(NSStringFromClass(type(of: viewController)))
//
//        if let searchVC = vc! as? FKYSearchResultVC {
//            if let searchType = searchVC.searchResultType {
//                 classStr =  classStr + "_" + searchType
//            }else{
//                classStr =  classStr + "_Product"
//            }
//        }
//
//        if BIViewControllerMap[classStr] == nil {
//            return ""
//        }
//
//        let host = String(validatingUTF8: BIViewControllerMap[classStr]!)!
//        if (viewController.ViewControllerParamaters() == nil && viewController.ViewControllerSingleParams() == nil) {
//            return host
//        }
//        if let singleParam = viewController.ViewControllerSingleParams() {
//            currentString.append(singleParam)
//            cururl = host + String(currentString)
//        }else{
//            if viewController.ViewControllerParamaters() == nil{
//                cururl = host
//            }else{
//                for (key,value) in viewController.ViewControllerParamaters()! {
//                    if currentString.length > 0 {
//                        currentString.append("&\(key)=\(value)")
//                    }else {
//                        currentString.append("\(key)=\(value)")
//                    }
//                }
//                cururl = host + "?" + (currentString as String)
//            }
//        }
//
//        if viewController.ViewControllerParamatersHtmlType() {
//            cururl = cururl! + ".html"
//        }
//        return cururl!
//    }
    
    // MARK: - 获取对象class名称
    func getObjcClass(_ classStr: String) -> String {
        if classStr.contains(".") {
            let index = (classStr as NSString).range(of: ".").location
            let className = (classStr as NSString).substring(from: index + 1)
            return className
        }
        return classStr
    }
    // MARK: - 公共参数
    func getPublicParams() -> [String: AnyObject] {
        var params :[String: AnyObject] = ["original" : "fangkuaiyi" as AnyObject]
        params["site"] = "b2b" as AnyObject
        params["autumn"] = "ios" as AnyObject
        params["brower"] = "ios" as AnyObject
        params["model"] = "iPhone" as AnyObject
        params["channelname"] = "App Store" as AnyObject
        params["channelId"] = "1051" as AnyObject
        //params["idfa"] = FKYAnalyticsUtility.getIDFA() as AnyObject。//暂时不用啦 如果后期要用记得判断iOS14 下面的权限申请
        params["operator"] = FKYAnalyticsUtility.getDeviceOperator() as AnyObject
        params["uuid"] = FKYAnalyticsUtility.getDeviceUUID() as AnyObject
        params["version"] = FKYAnalyticsUtility.appVersion() as AnyObject
        //params["visitid"] = FKYAnalyticsUtility.getVisitID() as AnyObject
        params["os"] = FKYAnalyticsUtility.getDevicePlatform() as AnyObject
        params["os_version"] = FKYAnalyticsUtility.getDeviceSystemVersion() as AnyObject
        params["screensize"] = NSString(format: "%.fx%.f" , SKMesurement.screenWidth,SKMesurement.screenHeight) as AnyObject // 屏幕尺寸
        params["time"] = FKYAnalyticsUtility.generateTimeIntervalWithTimeZone() as AnyObject
//        params["starttime"] = FKYAnalyticsUtility.generateTimeIntervalWithTimeZone() as AnyObject  // 开始时间
//        params["endtime"] = FKYAnalyticsUtility.generateTimeIntervalWithTimeZone() as AnyObject    // 结束时间
        params["userid"] = checkEmptyUserId(FKYLoginAPI.currentUserId()) as AnyObject
        // params["provinceId"] = "" as AnyObject
        //params["srn"] = "" as AnyObject
        //params["algorithm"] = "" as AnyObject
        //params["tracker_u"] = "" as AnyObject
        //params["xy"] = "" as AnyObject
        return params
    }
}
//MARK:埋点方法
@objc
extension FKYAnalyticsManager {
    /*
    pageValue    当前page唯一值    商品ID、订单ID、店铺ID
    keyword    搜索关键字
    srn    搜索返回的商品数量
    storage    特价/会员价最大可购买数量|原价最大可购买数量    中间以|区隔，缺货传0
    pm_pmtn_type    促销类型
    pm_price    可购买价格，特价/会员价|原价    中间以|区隔
    */
    //+++++新的bi事件统计(特定字段通过extendParams传入,如上述字段)++++++
    @objc
    func BI_New_Record(_ floorId: String?, floorPosition: String?, floorName: String?, sectionId: String?, sectionPosition: String?, sectionName: String?, itemId: String?, itemPosition: String?, itemName: String?, itemContent: String?, itemTitle: String?, extendParams:[String: AnyObject]?, viewController: UIViewController?) {
        // bi埋点入参
        var para:[String: AnyObject] = [:]
        // 公共参数
        getPublicParams().forEach{ (key , value) in
            para[key] = value
        }
        //所在站点名字
        var province = ""
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let name = user.substationName {
                province = name
            }
        }
        para["province"] = checkEmptyString(province) as AnyObject
        
        // 楼层ID
        para["floorId"] = checkEmptyString(floorId) as AnyObject
        // 楼层位置ID
        para["floorPosition"] = checkEmptyString(floorPosition) as AnyObject
        // 楼层名称
        para["floorName"] = checkEmptyString(floorName) as AnyObject
        // 栏位ID
        para["sectionId"] =  checkEmptyString(sectionId) as AnyObject
        // 栏位位置ID
        para["sectionPosition"] = checkEmptyString(sectionPosition) as AnyObject
        // 栏位名称
        para["sectionName"] = checkEmptyString(sectionName) as AnyObject
        // 坑位ID
        para["itemId"] = checkEmptyString(itemId) as AnyObject
        // 坑位位置ID
        para["itemPosition"] = checkEmptyString(itemPosition) as AnyObject
        // 坑位名称
        para["itemName"] = checkEmptyString(itemName) as AnyObject
        // 活动页标题名称
        para["itemTitle"] = checkEmptyString(itemTitle) as AnyObject
        // 活动页url
        para["itemContent"] = checkEmptyString(itemContent) as AnyObject
        // 操作类型
        para["action"] = "click" as AnyObject
        //必填字段  传空
        para["cururl"] = "" as AnyObject
        //必填字段  传空
        para["refer"] = "" as AnyObject
        // 当前vc界面code
        if checkEmptyString(viewController?.ViewControllerPageCode()) == "" {
            para["pageCode"] = "1haoyaocheng" as AnyObject
        } else {
            para["pageCode"] = checkEmptyString(viewController?.ViewControllerPageCode()) as AnyObject
        }
        // 前一个vc界面code
        if checkEmptyString(referPageCode) == "" {
            para["referPageCode"] = "1haoyaocheng" as AnyObject
        } else {
            para["referPageCode"] = referPageCode as AnyObject
        }
        
        // 当前vc界面url链接
        //para["cururl"] = generatorCurUrl(viewController) as AnyObject
        //前一个vc的ur链接
        //para["refer"] = refer as AnyObject
        
        //  额外数据
        if extendParams != nil {
            extendParams!.forEach { (key , value) in
                para[key] = value
            }
        }
        
        // 发送
        requestParmas(para)
    }
    //app进入前台和退出到后台埋点
    @objc
    func BI_New_App_Open_Close_Record(_ extendParams:[String: AnyObject]?) {
        // bi埋点入参
        var para:[String: AnyObject] = [:]
        // 公共参数
        getPublicParams().forEach{ (key , value) in
            para[key] = value
        }
        //所在站点名字
        var province = ""
        if FKYLoginAPI.loginStatus() != .unlogin {
            if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let name = user.substationName {
                province = name
            }
        }
        para["province"] = checkEmptyString(province) as AnyObject
        // 操作类型
        para["action"] = "none" as AnyObject
        
        //  额外数据
        if extendParams != nil {
            extendParams!.forEach { (key , value) in
                para[key] = value
            }
        }
        
        // 发送
        requestParmas(para)
    }
}
