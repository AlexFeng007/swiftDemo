//
//  FKYCommandManager.swift
//  FKY
//
//  Created by My on 2019/10/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

//口令类型
enum COMMAND_TYPE: Int {
    case COMMAND_TYPE_NONE =   0    ///无特殊类型
    case COMMAND_TYPE_CPS  =  1    //cps口令
    case COMMAND_TYPE_LIVE =   2    //直播口令
    case COMMAND_TYPE_ENTERSTORE =   3   //一键入库
}
@objc class FKYCommandManager: NSObject {
    fileprivate lazy var provider: LiveViewModel = {
        let viewModel = LiveViewModel()
        return viewModel
    }()
    fileprivate lazy var commandProvider: FKYCommandProvider = {
        let viewModel = FKYCommandProvider()
        return viewModel
    }()
    //展示口令提示框
    @objc func showCommandView() {
        var commandType:COMMAND_TYPE = .COMMAND_TYPE_NONE
        UserDefaults.standard.set(false, forKey: "FKY_COMMAND_JUMPTOSHOP_KEY")
        UserDefaults.standard.set(false, forKey: "FKY_COMMAND_LIVE_KEY")
        UserDefaults.standard.set(false, forKey: "FKY_COMMAND_SMARTSTORE_KEY")
        let pasteBoard = UIPasteboard.general;
        guard let command = pasteBoard.string, command.isEmpty == false else {
            return
        }
        
        //解析出口令逻辑...
        //~[ABC123]~ 解析出~[]~的里面的内容
        var startRange: NSRange? = (command as NSString).range(of: "~[")
        var endRange: NSRange? = (command as NSString).range(of: "]~")
        //直播的口令
        let liveStartRange: NSRange? = (command as NSString).range(of: "~#")
        let liveEndRange: NSRange? = (command as NSString).range(of: "#~")
        //一键入库的口令
        let storeStartRange: NSRange? = (command as NSString).range(of: "~{")
        let storeEndRange: NSRange? = (command as NSString).range(of: "}~")
        //修改剪贴板奔溃的问题
        if endRange?.location != NSNotFound && startRange?.location != NSNotFound{
            //cps 口令
            commandType = .COMMAND_TYPE_CPS
        }else if liveEndRange?.location != NSNotFound && liveStartRange?.location != NSNotFound{
            //直播口令
            commandType = .COMMAND_TYPE_LIVE
            startRange = liveStartRange
            endRange = liveEndRange
        }else if storeEndRange?.location != NSNotFound && storeStartRange?.location != NSNotFound{
            //一键入库口令
            commandType = .COMMAND_TYPE_ENTERSTORE
            startRange = storeStartRange
            endRange = storeEndRange
        }else{
            return
        }
        guard let start = startRange, let end = endRange, end.location > start.location else { return }
        let subRange: NSRange = NSMakeRange(start.location + start.length, end.location - start.location - start.length)
        var subCommand = (command as NSString).substring(with: subRange)
        var shareType = "0" //一键入库口令分享类型
        guard subCommand.isEmpty == false else { return }
        
        if commandType == .COMMAND_TYPE_CPS{
            //解密
            let decodedData = NSData(base64Encoded: subCommand, options: NSData.Base64DecodingOptions.init(rawValue: 0))
            guard decodedData != nil else {
                return
            }
            let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
            guard decodedString.isEmpty == false else {
                return
            }
            pasteBoard.string = ""
            enterCpsCommandView(decodedString)
        }else if commandType == .COMMAND_TYPE_LIVE{
            pasteBoard.string = ""
            if FKYLoginAPI.loginStatus() == .unlogin {
                FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: { (destinationViewController) in
                    let loginVC = destinationViewController as! LoginController
                    loginVC.loginSuccessBlock = {[weak self] in
                        if let strongSelf = self{
                            strongSelf.enterLiveCommandView(subCommand)
                        }
                    }
                }, isModal: true)
            }else {
                enterLiveCommandView(subCommand)
            }
            
        }else if commandType == .COMMAND_TYPE_ENTERSTORE{
            let decodedData = NSData(base64Encoded: subCommand, options: NSData.Base64DecodingOptions.init(rawValue: 0))
            guard decodedData != nil else {
                return
            }
            let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
            guard decodedString.isEmpty == false else {
                return
            }
            let arraySubstrings: [Substring] = decodedString.split(separator: ",")//一键入库类型和ID
            if arraySubstrings.count == 2{
                pasteBoard.string = ""
                //只有两个元素都有才行
                subCommand = String(arraySubstrings[0])
                shareType = String(arraySubstrings[1])
                if FKYLoginAPI.loginStatus() == .unlogin {
                    FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: { (destinationViewController) in
                        let loginVC = destinationViewController as! LoginController
                        loginVC.loginSuccessBlock = {[weak self] in
                            if let strongSelf = self{
                                UserDefaults.standard.set(true, forKey: "FKY_COMMAND_SMARTSTORE_KEY")
                                strongSelf.enterEnterStoreCommandView(subCommand,shareType)
                            }
                        }
                    }, isModal: true)
                }else {
                    enterEnterStoreCommandView(subCommand,shareType)
                }
            }
        }
        
    }
}
//一键入库口令的处理
extension FKYCommandManager {
    @objc func enterEnterStoreCommandView(_ commandString:String,_ commandType:String){
        commandProvider.getEnterTreasuryCommendDecrypt(commandString,commandType) { [weak self] (success, msg,model) in
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.accessTreasuryCommandView(model)
            }
        }
    }
    @objc func accessTreasuryCommandView(_ activityModel:FKYCommandEnterTreasuryModel?){
        guard let model = activityModel else {
            return
        }
        if let isPopup = model.isPopup, isPopup == 0{
            //不用弹窗
            return
        }
        UserDefaults.standard.set(false, forKey: "FKY_COMMAND_SMARTSTORE_KEY")
        //1 商品列表 2 5 文描弹窗  4 不弹 3 6 新的
        if model.status == 1{
            //已开通
            //已开通一键入库，分享缺货和优势商品
            let window = UIApplication.shared.keyWindow!
            //弹框已经有了
            for subView in window.subviews {
                if subView is FKYCommandEnterTreasuryListView {
                    let commandView = subView as! FKYCommandEnterTreasuryListView
                    commandView.configPreferentialViewController(activityModel)
                    commandView.enterTreasuryView = { (isConfirm,jumpUrl) in
                        if isConfirm == false{
                            //关闭
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10201", sectionPosition: "0", sectionName: "药店易已开通已运行", itemId: "I10201", itemPosition:"0", itemName: "关闭弹窗", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                        }else{
                            //进入详情
                            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10201", sectionPosition: "0", sectionName: "药店易已开通已运行", itemId: "I10203", itemPosition:"0", itemName: "查看更多", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                            if let app = UIApplication.shared.delegate as? AppDelegate {
                                if jumpUrl.isEmpty == false {
                                    app.p_openPriveteSchemeString(jumpUrl)
                                }
                            }
                        }
                    }
                    return
                }
            }
            let commandView = FKYCommandEnterTreasuryListView()
            commandView.configPreferentialViewController(activityModel)
            commandView.enterTreasuryView = { (isConfirm,jumpUrl) in
                if isConfirm == false{
                    //关闭
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10201", sectionPosition: "0", sectionName: "药店易已开通已运行", itemId: "I10201", itemPosition:"0", itemName: "关闭弹窗", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                }else{
                    //进入详情
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10201", sectionPosition: "0", sectionName: "药店易已开通已运行", itemId: "I10202", itemPosition:"0", itemName: "查看更多", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                    if let app = UIApplication.shared.delegate as? AppDelegate {
                        if jumpUrl.isEmpty == false {
                            app.p_openPriveteSchemeString(jumpUrl)
                        }
                    }
                }
                
            }
        }else{
            //未开通或者已开通未运行
            if model.status == 3 || model.status == 6{
                //未开通
                let window = UIApplication.shared.keyWindow!
                guard let rootView = window.rootViewController?.view else { return }
                
                //弹框已经有了
                for subView in rootView.subviews {
                    if subView is FKYCommandEnterTreasuryTipView {
                        let commandView = subView as! FKYCommandEnterTreasuryTipView
                        commandView.animateShow(model)
                        return
                    }
                }
                
                //展示弹框逻辑...
                let cmdView = FKYCommandEnterTreasuryTipView(frame: UIScreen.main.bounds)
                // //0 关闭 1、申请开通 2、了解更多
                cmdView.operateClosure = { (actionType,jumpUrl) in
                    if actionType == 0{
                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10202", sectionPosition: nil, sectionName: "药店易未开通", itemId: "I10204", itemPosition:"0", itemName: "关闭弹窗", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                    }else if actionType == 1{
                        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10202", sectionPosition: nil, sectionName: "药店易未开通", itemId: "I10203", itemPosition:"0", itemName: "立即申请", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                    }
                    //                    else if actionType == 2{
                    //                        //FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10202", sectionPosition: "0", sectionName: "药店易未开通", itemId: "I10206", itemPosition:"0", itemName: "了解详情", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                    //                    }
                    if let jumpUrlStr = jumpUrl,jumpUrlStr.isEmpty == false{
                        if let app = UIApplication.shared.delegate as? AppDelegate {
                            app.p_openPriveteSchemeString(jumpUrl)
                        }
                    }
                }
                rootView.addSubview(cmdView)
                
                //调整位置
                for  subView in rootView.subviews {
                    if subView is FKYUpdateAlertView {
                        rootView.insertSubview(cmdView, belowSubview: subView)
                        break
                    } else if subView is FKYSplashView {
                        rootView.insertSubview(cmdView, belowSubview: subView)
                    }
                }
                cmdView.animateShow(model)
                return
            }
            
            // , OFFRUN(2,"已开通未运行") ：NOTOPEN_APLLY(5, "未开通已申请"),
            let alert = COAlertView.init(frame: CGRect.zero)
            alert.configView(model.text ?? "", "", "", model.buttonText ?? "", .oneBtn)
            alert.showAlertView()
            alert.doneBtnActionBlock = {
                //跳转到对应
                if model.status == 2{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10204", sectionPosition: "0", sectionName: "药店易已开通未运行", itemId: "I10206", itemPosition:"0", itemName: "知道了", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                }else if model.status == 5{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId:"S10203", sectionPosition: "0", sectionName: "药店易已申请待开通", itemId: "I10205", itemPosition:"0", itemName: "知道了", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                }
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let jumpUrl = model.jumpUrl, jumpUrl.isEmpty == false {
                        app.p_openPriveteSchemeString(jumpUrl)
                    }
                }
            }
        }
    }
}
//直播口令
extension FKYCommandManager {
    @objc func enterLiveCommandView(_ decodedString:String){
        provider.getLiveCommendDecrypt(decodedString) { [weak self] (success, msg,model) in
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.accessLiveView(model)
            }
        }
    }
    @objc func accessLiveView(_ activityModel:LiveCommandInfoModel?){
        guard let model = activityModel else {
            return
        }
        provider.getLiveStatus(model.activityId) { [weak self] (success, msg,status) in
            guard let _ = self else {
                return
            }
            if success{
                if let vc = FKYCommandManager.topVC() as? FKYLiveViewController{
                    if vc.activityId == model.activityId{
                        return
                    }else{
                        //发送直播结束和点播结束的通知
                        NotificationCenter.default.post(name:NSNotification.Name.FKYLiveEndForCommand, object: self, userInfo: nil)
                    }
                }
                if let vc = FKYCommandManager.topVC() as? FKYVodPlayerViewController{
                    if vc.activityId == model.activityId{
                        return
                    }else{
                        //发送直播结束和点播结束的通知
                        NotificationCenter.default.post(name:NSNotification.Name.FKYLiveEndForCommand, object: self, userInfo: nil)
                    }
                }
                let window = UIApplication.shared.keyWindow!
                guard let rootView = window.rootViewController?.view else { return }
                
                //弹框已经有了
                for subView in rootView.subviews {
                    if subView is LiveCommandView {
                        let commandView = subView as! LiveCommandView
                        commandView.animateShow(model)
                        return
                    }
                }
                
                //展示弹框逻辑...
                let cmdView = LiveCommandView(frame: UIScreen.main.bounds)
                cmdView.operateClosure = { (isConfirm, activityId) in
                    if isConfirm == false{
                        //关闭弹窗
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F9609", floorPosition: nil, floorName: "分享直播口令进直播间", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9625", itemPosition:nil, itemName: "关闭按钮", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                        
                    }else{
                        //查看详情
                        FKYAnalyticsManager.sharedInstance.BI_New_Record("F9609", floorPosition: nil, floorName: "分享直播口令进直播间", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9626", itemPosition:nil, itemName: "进入直播间", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                    }
                    if isConfirm, activityId?.isEmpty == false {
                        //判断是否登录,未登录先登录
                        if FKYLoginAPI.loginStatus() == .unlogin {
                            FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: { (destinationViewController) in
                                let loginVC = destinationViewController as! LoginController
                                loginVC.loginSuccessBlock = {
                                    UserDefaults.standard.set(true, forKey: "FKY_COMMAND_LIVE_KEY")
                                    //bug，不延迟无法push
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        FKYCommandManager.toLiveVC("\(status)",activityId ?? "")
                                    }
                                }
                            }, isModal: true)
                        }else {
                            FKYCommandManager.toLiveVC("\(status)",activityId ?? "")
                        }
                    }
                }
                rootView.addSubview(cmdView)
                
                //调整位置
                for  subView in rootView.subviews {
                    if subView is FKYUpdateAlertView {
                        rootView.insertSubview(cmdView, belowSubview: subView)
                        break
                    } else if subView is FKYSplashView {
                        rootView.insertSubview(cmdView, belowSubview: subView)
                    }
                }
                
                cmdView.animateShow(model)
            }
        }
    }
}
//cps 口令
extension FKYCommandManager {
    
    @objc func enterCpsCommandView(_ decodedString:String){
        //已经在促销页面 && 两次的口令相同  直接返回
        if let vc = FKYCommandManager.topVC() as? ShopItemOldViewController, vc.commandShareId == decodedString {
            return
        }
        
        let provider = ShopItemProvider()
        provider.getCrmProductList(true, true, decodedString) { (success, msg, needLoadMore) in
            guard success else {
                return
            }
            
            let window = UIApplication.shared.keyWindow!
            guard let rootView = window.rootViewController?.view else { return }
            
            //弹框已经有了
            for subView in rootView.subviews {
                if subView is FKYCommandView {
                    let commandView = subView as! FKYCommandView
                    commandView.animateShow(decodedString)
                    return
                }
            }
            
            //展示弹框逻辑...
            let cmdView = FKYCommandView(frame: UIScreen.main.bounds)
            cmdView.operateClosure = { (isConfirm, commandShareId) in
                if isConfirm == false{
                    //关闭弹窗
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "BD分享口令弹窗", itemId: "I1102", itemPosition:"1", itemName: "关闭弹窗", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                    
                }else{
                    //查看详情
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "BD分享口令弹窗", itemId: "I1102", itemPosition:"2", itemName: "查看详情", itemContent: nil, itemTitle: nil, extendParams:nil, viewController: CurrentViewController.shared.item)
                }
                if isConfirm, commandShareId?.isEmpty == false {
                    //判断是否登录,未登录先登录
                    if FKYLoginAPI.loginStatus() == .unlogin {
                        FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty: { (destinationViewController) in
                            let loginVC = destinationViewController as! LoginController
                            loginVC.loginSuccessBlock = {
                                UserDefaults.standard.set(true, forKey: "FKY_COMMAND_JUMPTOSHOP_KEY")
                                //bug，不延迟无法push
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    FKYCommandManager.toShopVC(commandShareId)
                                }
                            }
                        }, isModal: true)
                    }else {
                        FKYCommandManager.toShopVC(commandShareId)
                    }
                }
            }
            rootView.addSubview(cmdView)
            
            //调整位置
            for  subView in rootView.subviews {
                if subView is FKYUpdateAlertView {
                    rootView.insertSubview(cmdView, belowSubview: subView)
                    break
                } else if subView is FKYSplashView {
                    rootView.insertSubview(cmdView, belowSubview: subView)
                }
            }
            
            cmdView.animateShow(decodedString)
        }
    }
}
extension FKYCommandManager {
    //获取当前显示的VC
    static func topVC() -> UIViewController? {
        var vc = fkyTopVC(UIApplication.shared.keyWindow?.rootViewController)
        while((vc?.presentedViewController) != nil) {
            vc = fkyTopVC(vc?.presentedViewController)
        }
        return vc
    }
    
    static func fkyTopVC(_ vc: UIViewController?) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return fkyTopVC(nav.children.last)
        }
        
        if let tabVC = vc as? UITabBarController {
            return fkyTopVC(tabVC.selectedViewController)
        }
        
        if let fkyTabVC = vc as? FKYTabBarController {
            return fkyTopVC(fkyTabVC.selectedViewController)
        }
        
        return vc
    }
    
    static func toShopVC(_ commandShareId: String?) {
        let window = UIApplication.shared.keyWindow!
        if let rootView = window.rootViewController?.view  {
            for subView in rootView.subviews {
                if subView is RedPacketView {
                    subView.removeFromSuperview()
                    break;
                }
            }
        }
        UserDefaults.standard.set(false, forKey: "FKY_COMMAND_JUMPTOSHOP_KEY")
        //跳转页面 传剪切板内容过去
        FKYNavigator.shared()?.openScheme(FKY_ShopItemOld.self, setProperty: { (vc) in
            let shopVC = vc as! ShopItemOldViewController
            shopVC.type = 6
            shopVC.commandShareId = commandShareId
        })
    }
    
    static func toLiveVC(_ status: String,_ activityId:String) {
        let window = UIApplication.shared.keyWindow!
        if let rootView = window.rootViewController?.view  {
            for subView in rootView.subviews {
                if subView is RedPacketView {
                    subView.removeFromSuperview()
                    break;
                }
            }
        }
        UserDefaults.standard.set(false, forKey: "FKY_COMMAND_LIVE_KEY")
        //0：直播中，1：已结束，2：预告
        if status == "0"{
            MobClick.event("start_live_show", attributes: ["liveId":activityId,"from":"command"])
            FKYNavigator.shared()?.openScheme(FKY_FKYLiveViewController.self, setProperty: { (vc) in
                let liveVC = vc as! FKYLiveViewController
                liveVC.activityId = activityId
                liveVC.source = "2"
            }, isModal: false)
        }else if status == "1"{
            FKYNavigator.shared()?.openScheme(FKY_LiveEndViewController.self, setProperty:  { (vc) in
                let liveVC = vc as! LiveEndViewController
                liveVC.activityId = activityId
                // liveVC.source = "2"
            }, isModal: false)
        }
        
    }
}
