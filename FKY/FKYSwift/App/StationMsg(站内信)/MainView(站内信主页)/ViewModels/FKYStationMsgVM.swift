//
//  FKYStationMsgVM.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYStationMsgVM: NSObject ,HandyJSON{
    required override init() {    }
    
    var sectionList:[FKYStationMsgSectionModel] = []
    
    /// 原始数据
    
    /// 下方消息列表
    var list:[FKYStationMsgModel] = []
    
    /// 上方消息模块（交易物流 活动优惠）
    var topList:[FKYStationMsgModel] = []
    
    var page = 1
    
    var pageSize = 10
    /// 本地字段
    var isHaveNextPage = true;
}

//MARK: - 整理数据
extension FKYStationMsgVM{
    
    /// 重置数据
    func resetData(){
        self.sectionList.removeAll()
        self.list.removeAll()
        self.topList.removeAll()
        self.page = 1
        self.isHaveNextPage = true
    }
    
    /// 初始化数据
    func installData(){
        
        // 头部 交易物流 活动优惠
        if self.topList.count > 0 {
            let section1 = FKYStationMsgSectionModel()
            section1.type = .modelSeciton
            let cell1 = FKYStationMsgCellModel()
            cell1.type = .type1Cell
            cell1.type1DataList += self.topList
            section1.cellList.append(cell1)
            self.sectionList.append(section1)
        }
        
        // 下方消息列表
        var currentWeakMsg:[FKYStationMsgModel] = []
        var lastWeakMsg:[FKYStationMsgModel] = []
        for msg in self.list {
            if msg.beforeWeek {
                lastWeakMsg.append(msg)
            }else{
                currentWeakMsg.append(msg)
            }
        }
        // 本周前消息
        let section2 = FKYStationMsgSectionModel()
        section2.type = .currentMsg
        for data in currentWeakMsg {
            let cell = FKYStationMsgCellModel()
            cell.type = .type2Cell
            cell.data = data
            section2.cellList.append(cell)
        }
        
        if section2.cellList.count > 0{
            self.sectionList.append(section2)
        }
        
        // 一周前消息
        let section3 = FKYStationMsgSectionModel()
        section3.type = .lastWeakMsg
        section3.sectionHeaderText = "一周前的消息"
        for data in lastWeakMsg{
            let cell = FKYStationMsgCellModel()
            cell.type = .type2Cell
            cell.data = data
            section3.cellList.append(cell)
        }
        
        if section3.cellList.count > 0{
            self.sectionList.append(section3)
        }
        
    }
    /*func configTestData(){
        let section1 = FKYStationMsgSectionModel()
        let cell1 = FKYStationMsgCellModel()
        cell1.type = .type1Cell
        section1.cellList.append(cell1)
        
        let section2 = FKYStationMsgSectionModel()
        let cell2 = FKYStationMsgCellModel()
        cell2.type = .type2Cell
        let cell3 = FKYStationMsgCellModel()
        cell3.type = .type2Cell
        let cell4 = FKYStationMsgCellModel()
        cell4.type = .type2Cell
        let cell5 = FKYStationMsgCellModel()
        cell5.type = .type2Cell
        let cell6 = FKYStationMsgCellModel()
        cell6.type = .type2Cell
        section2.cellList.append(cell3)
        section2.cellList.append(cell4)
        section2.cellList.append(cell5)
        section2.cellList.append(cell6)
        section2.cellList.append(cell2)
        
        let section3 = FKYStationMsgSectionModel()
        section3.sectionHeaderText = "一周前的消息"
        let cell7 = FKYStationMsgCellModel()
        cell7.type = .type2Cell
        let cell8 = FKYStationMsgCellModel()
        cell8.type = .type2Cell
        let cell9 = FKYStationMsgCellModel()
        cell9.type = .type2Cell
        section3.cellList.append(cell7)
        section3.cellList.append(cell8)
        section3.cellList.append(cell9)
        
        self.sectionList.append(section1)
        self.sectionList.append(section2)
        self.sectionList.append(section3)
    }*/
    
    
}


//AMRK: - 网络请求
extension FKYStationMsgVM{
    
    /// 拉取消息列表
    func getMsgList(callBack: @escaping (_ isSuccess:Bool,_ msg:String)->()){
        let param = [
            //"deviceId":"\(UIDevice.current.identifierForVendor?.uuidString)",
                     "page":self.page,
                     "pageSize":self.pageSize] as [String : Any]
        FKYRequestService.sharedInstance()?.getMsgList(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let weakSelf = self else {
                callBack(false, "内存溢出")
                return
            }
            guard let resDic = response as? NSDictionary else{
                callBack(false, "解析错误")
                return
            }
            let model_t = FKYStationMsgVM.deserialize(from: resDic) ?? FKYStationMsgVM()
            weakSelf.list += model_t.list
            weakSelf.topList += model_t.topList
            if model_t.list.count < weakSelf.pageSize {
                // 没有下一页
                weakSelf.isHaveNextPage = false
            }else{
                weakSelf.isHaveNextPage = true
                weakSelf.page += 1
            }
            weakSelf.installData()
            callBack(true, "")
        })
    }
    
}
