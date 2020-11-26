//
//  LiveIMManagerView.swift
//  FKY
//
//  Created by yyc on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

let COMMAND = "command" //自定消息key
//自定消息COMMAND对应的value
let FAVOR_VALUE = "favor" //点赞
//MARK:管理IM相关
class LiveIMManagerView: NSObject ,V2TIMSimpleMsgListener{
    
    //入参数
    var userId = "" 
    var userSig = ""
    var groupId = ""
    var nickName = ""
    
    //回调
    //类型，消息相关信息<1:收到消息2:收到进群3:自己发送消息成功>
    var getActionType:((Int,[LiveMessageMode])->())?
    //刷新接口回调
    var refreshDemandType:((LiveRoomIMRefreshInfo)->())?
    //提示消息
    var showToast : ((String)->())?
    //自定义消息
    var getCustomActionType:((Int)->())?
    
    override init() {
        super.init()
    }
    //MARK:登录im
    func loginTXIM()  {
        V2TIMManager.sharedInstance()?.login(userId, userSig: userSig, succ: { [weak self] in
            //登录成功
            if let strongSelf = self {
                strongSelf.resetIMInfo()
            }
            }, fail: { [weak self] (code, des) in
                //登录失败
                if let strongSelf = self ,let block = strongSelf.showToast{
                    block(des ?? "登录失败")
                }
        })
    }
    
    //MARK:加入im群
    fileprivate func joinIMGroup() {
        V2TIMManager.sharedInstance()?.joinGroup(groupId, msg: "", succ: { [weak self] in
            //加群成功
            if let strongSelf = self {
                strongSelf.addRecvGroupMessage()
                strongSelf.addGroupInfo()
            }
            }, fail: { [weak self] (code, des) in
                //加群失败
                if let strongSelf = self ,let block = strongSelf.showToast{
                    block(des ?? "加群失败")
                }
        })
    }
    //MARK:退出群and退出登录
    func quitIMGroupAndQuitLogin(){
        V2TIMManager.sharedInstance()?.quitGroup(groupId, succ: nil, fail: nil)
        V2TIMManager.sharedInstance()?.logout(nil, fail: nil)
    }
    
    //MARK:设置用户信息
    fileprivate func resetIMInfo() {
        let userFullInfo = V2TIMUserFullInfo()
        userFullInfo.nickName = self.nickName
        V2TIMManager.sharedInstance()?.setSelfInfo(userFullInfo, succ: { [weak self] in
            //设置成功
            if let strongSelf = self {
                strongSelf.joinIMGroup()
            }
        }, fail: { [weak self] (code, des) in
            //加群失败
            if let strongSelf = self ,let block = strongSelf.showToast{
                block(des ?? "设置失败")
            }
        })
    }
    //MARK:发送消息
    func sendIMMessageInfo(_ messageStr:String) {
        V2TIMManager.sharedInstance()?.sendGroupTextMessage(messageStr, to: groupId, priority: .PRIORITY_NORMAL, succ: { [weak self] in
            //发送消息成功
            if let strongSelf = self {
                if let block = strongSelf.getActionType {
                    let model = LiveMessageMode()
                    model.groupId = strongSelf.groupId
                    model.messageStr = messageStr
                    model.nickName = strongSelf.nickName
                    block(3,[model])
                }
            }
            }, fail: { [weak self] (code, des) in
                //发送消息失败
                if let strongSelf = self ,let block = strongSelf.showToast{
                    if code == 10017 {
                        block("您已被禁言")
                    }else {
                        block("发送消息失败")
                    }
                    
                }
        })
    }
    //MARK:发送自定义消息<type==1:发送爱心（{ "command": "favor", "value": 101 }）>
    func sendIMCustomInfo(_ type:Int) {
        if self.groupId.count == 0 {
            return
        }
        //发送爱心
        if type == 1 {
            let dic = [COMMAND:FAVOR_VALUE]
            do {
                // dic转data
                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
                V2TIMManager.sharedInstance()?.sendGroupCustomMessage(jsonData, to: self.groupId, priority: .PRIORITY_NORMAL, succ: {
                    
                }, fail: { (code, des) in
                    
                })
            } catch {
                
            }
        }
    }
    //MARK:添加群组消息监听
    func addRecvGroupMessage() {
        V2TIMManager.sharedInstance()?.remove(self)
        V2TIMManager.sharedInstance()?.add(self)
    }
    //MARK:移除群组消息监听
    func removeGroupMessage() {
        V2TIMManager.sharedInstance()?.remove(self)
    }
    //MARK:添加监听有新观众进入群
    func addGroupInfo()  {
        V2TIMManager.sharedInstance()?.setGroupListener(self)
    }
}
//MARK:接收到消息
extension LiveIMManagerView {
    func onRecvC2CTextMessage(_ msgID: String!, sender info: V2TIMUserInfo!, text: String!) {
        
    }
    
    func onRecvC2CCustomMessage(_ msgID: String!, sender info: V2TIMUserInfo!, customData data: Data!) {
        
    }
    //收到群简单消息
    func onRecvGroupTextMessage(_ msgID: String!, groupID: String!, sender info: V2TIMGroupMemberInfo!, text: String!) {
        if groupID == self.groupId {
            if let block = self.getActionType {
                if let str = text ,str.count > 0 {
                    let model = LiveMessageMode()
                    model.groupId = groupID
                    model.messageStr = str
                    model.nickName = info.nickName ?? "游客"
                    block(1,[model])
                }
            }
        }
    }
    
    func onRecvGroupCustomMessage(_ msgID: String!, groupID: String!, sender info: V2TIMGroupMemberInfo!, customData data: Data!) {
        if groupID == self.groupId {
            do {
                if let getDic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                    if let block = self.getCustomActionType {
                        if let str = getDic[COMMAND] as? String {
                            if str==FAVOR_VALUE {
                                //点赞
                                block(1)
                            }
                        }
                    }
                }
            }catch{
                
            }
        }
    }
}
//MARK:监听有新人加入群，以及有人离开
extension LiveIMManagerView : V2TIMGroupListener{
    //有新成员加入
    func onMemberEnter(_ groupID: String!, memberList: [V2TIMGroupMemberInfo]!) {
        if let block = self.getActionType ,memberList.count > 0 {
            var getArr = [LiveMessageMode]()
            for infoModel in memberList {
                let model = LiveMessageMode()
                model.groupId = groupID
                model.nickName = infoModel.nickName ?? "游客"
                getArr.append(model)
            }
            block(2,getArr)
        }
    }
    //有成员离开
    func onMemberLeave(_ groupID: String!, member: V2TIMGroupMemberInfo!) {
    }
    //某个已加入的群被解散了
    func onGroupDismissed(_ groupID: String!, opUser: V2TIMGroupMemberInfo!) {
        if  self.groupId == groupID {
            //关闭直播间
            let refreshModel = LiveRoomIMRefreshInfo()
            refreshModel.type = 8
            if let block = self.refreshDemandType{
                block(refreshModel)
            }
        }
    }
    //监听系统消息《目前使用接收到的类型刷新直播间对应的接口》
    func onReceiveRESTCustomData(_ groupID: String!, data: Data!) {
        do {
            if let dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                let refreshModel = dic.mapToObject(LiveRoomIMRefreshInfo.self)
                refreshModel.groupId = groupID ?? ""
                if let block = self.refreshDemandType{
                    block(refreshModel)
                }
            }
        }catch{
            
        }
    }
}

