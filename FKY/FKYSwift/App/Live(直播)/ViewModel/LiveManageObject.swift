//
//  LiveManageObject.swift
//  FKY
//
//  Created by 寒山 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

@objc class LiveManageObject: NSObject {
    @objc static let shareInstance = LiveManageObject()
    var enterFlag = true  //进入直播间 防止重复点击
    //跳入对应的直播间 1：正常进来 2：口令进来
    @objc func enterLiveViewController(_ activityId:String,_ source:String){
        if FKYLoginAPI.loginStatus() == .unlogin {
            FKYNavigator.shared()?.openScheme(FKY_Login.self, setProperty:nil, isModal: true)
            return
        }
        //防治重复点击
        if enterFlag == false{
            return
        }
        enterFlag = false
        self.perform(#selector(setEnterFlag), with: nil, afterDelay: 1.0)
        
        let dic = NSMutableDictionary()
        dic["activityId"] =  activityId
        FKYRequestService.sharedInstance()?.getLiveStatus(withParam: (dic as! [AnyHashable : Any]), completionBlock: {[weak self]  (success, error, response, model) in
            guard let _ = self else {
                return
            }
            guard success else {
                return
            }
            // 请求成功
            if let dic = response as? NSDictionary {
                //0：直播中，1：已结束，2：预告
                if let status = dic["status"] as? Int{
                    // block(true, "获取成功",status)
                    if status == 0{
                        MobClick.event("start_live_show", attributes: ["liveId":activityId,"from":"liveList"])
                        FKYNavigator.shared()?.openScheme(FKY_FKYLiveViewController.self, setProperty: { (vc) in
                            let liveVC = vc as! FKYLiveViewController
                            liveVC.activityId = activityId
                            liveVC.source = source
                        }, isModal: false)
                    }else if status == 1{
                        FKYNavigator.shared()?.openScheme(FKY_LiveEndViewController.self, setProperty:  { (vc) in
                            let liveVC = vc as! LiveEndViewController
                            liveVC.activityId = activityId
                            //liveVC.source = source
                        }, isModal: false)
                    }
                    return
                }else{
                    FKYNavigator.shared()?.topNavigationController.topViewController?.toast("当前直播间不存在")
                }
                return
            }
            FKYNavigator.shared()?.topNavigationController.topViewController?.toast("直播信息错误")
        })
    }
    @objc func setEnterFlag(){
        enterFlag = true
    }
}
