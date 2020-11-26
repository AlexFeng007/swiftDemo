//
//  FKYApplyWalfareTableViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYApplyWalfareTableViewModel: NSObject {
    
    /// sectionList
    var sectionList:[FKYApplyWalfareTableSectionModel] = []
    
    /// 选择的地址model
    var editAddress = ZZReceiveAddressModel()
    
    /// 输入的信息模型
    var inputInfoModel = FKYYflInfoModel()
    
    /// 提交的字段
    var submitParam = ["enterpriseType":"",//取enterPriseInfo.roleTypeValue
                       "enterpriseId":"",// 取enterPriseInfo中的信息
                       "ycSupplyId":"",// 取mainLocalInfo中的信息
                       "ycSupplyName":"",// 取mainLocalInfo中的信息
                       "addr":"",// 总店，分店，单体店详细地址
                       "bankCity":"",//开户行城市名称
                       "bankCityId":"",// 开户行城市id
                       "bankCode":"",//    开户行银行编码
                       "bankCodeName":"",// 开户行编码名称
                       "bankName":"",// 开户行名称
                       "bankNum":"",// 开户行卡号
                       "bankProvince":"",// 开户行省份名称
                       "bankProvinceId":"",// 开户行省份id
                       "bankUserName":"",// 开户户名
        //"employeeVOList":[["empUserName":"","empMobile":""]],// 店铺员工信息，分店或单体店bd添加的店铺店员信息array<object> 店铺员工信息，没有输入的地方，不传
                       "mobilePhone":"",// 管理员手机号
                       "storeName":"",// 用户名称，管理员名称，店长名称
                       //"subStoreAccountVOList":"",// 分店信息，客户类型为连锁总店时，bd添加的分店信息array<object> 没有输入的地方，不传
                       "userName":"",// 店铺名称
                       //"enterpriseName":"",//药店名称-账户名 不允许用户输入，不传
        ] as [String : Any]
    
}

//MARK - 数据整理
extension FKYApplyWalfareTableViewModel{
    
    /// 初始化设置一些数据
    func installData(){
        self.submitParam["enterpriseType"] = self.inputInfoModel.roleTypeValue
        self.submitParam["enterpriseId"] = self.inputInfoModel.enterpriseIdInEnterPriseInfo
        self.submitParam["ycSupplyId"] = self.inputInfoModel.mainEnterpriseId
        self.submitParam["ycSupplyName"] = self.inputInfoModel.mainEnterpriseName
        self.submitParam["addr"] = self.inputInfoModel.addr
        self.submitParam["bankCity"] = self.inputInfoModel.bankCity
        self.submitParam["bankCityId"] = self.inputInfoModel.bankCityId
        self.submitParam["bankCode"] = self.inputInfoModel.bankCode
        self.submitParam["bankCodeName"] = self.inputInfoModel.bankCodeName
        self.submitParam["bankName"] = self.inputInfoModel.bankName
        self.submitParam["bankNum"] = self.inputInfoModel.bankNum
        self.submitParam["bankProvince"] = self.inputInfoModel.bankProvince
        self.submitParam["bankProvinceId"] = self.inputInfoModel.bankProvinceId
        self.submitParam["bankUserName"] = self.inputInfoModel.bankUserName
        //self.submitParam["employeeVOList"] = [["empUserName":]]
        self.submitParam["mobilePhone"] = self.inputInfoModel.mobilePhone
        self.submitParam["storeName"] = self.inputInfoModel.storeName
        //self.submitParam["subStoreAccountVOList"] =
        self.submitParam["userName"] = self.inputInfoModel.userName
        //self.submitParam["enterpriseType"] =
        
        self.editAddress.provinceName = self.inputInfoModel.bankProvince
        self.editAddress.provinceCode = "\(self.inputInfoModel.bankProvinceId ?? 0)"
        
        self.editAddress.cityName = self.inputInfoModel.bankCity
        self.editAddress.cityCode = "\(self.inputInfoModel.bankCityId ?? 0)"
    }
    
    func ProcessingData(){
        self.sectionList.removeAll()
        
        /// 提示信息分区
        let section0 = FKYApplyWalfareTableSectionModel()
        let cell0_1 = FKYApplyWalfareTableCellModel()
        cell0_1.configCell(cellType: .tipCel)
        section0.cellList.append(cell0_1)
        
        ///店信息分区
        let section1 = FKYApplyWalfareTableSectionModel()
        let cell1_1 = FKYApplyWalfareTableCellModel()
        let cell1_2 = FKYApplyWalfareTableCellModel()
        cell1_1.configCell(cellType: .inputCell, isCanEditer: false, inputTitle1: "药店名称", holderText: "暂无药店名称", inputText1: self.inputInfoModel.enterpriseName.isEmpty ? "暂无药店名称":self.inputInfoModel.enterpriseName)
        cell1_2.configCell(cellType: .inputCell, isCanEditer: false, inputTitle1: "药店ID", holderText: "暂无药店ID", inputText1: self.inputInfoModel.enterpriseIdInEnterPriseInfo.isEmpty ? "暂无药店ID":self.inputInfoModel.enterpriseIdInEnterPriseInfo)
        section1.cellList.append(contentsOf: [cell1_1,cell1_2])
        
        /// 客户经理联系方式分区
        let section2 = FKYApplyWalfareTableSectionModel()
        section2.isHaveSectionHeader = true
        section2.sectionHeaderText = "客户经理联系方式"
        let cell2_1 = FKYApplyWalfareTableCellModel()
        cell2_1.configCell(cellType: .displayInfoCell, inputTitle1: "客户经理：", inputTitle2: "联系电话：", inputText1: self.inputInfoModel.name.isEmpty ? "暂无客户经理":self.inputInfoModel.name, inputText2: self.inputInfoModel.mobile.isEmpty ? "暂无客户经理电话":self.inputInfoModel.mobile)
        section2.cellList.append(cell2_1)
        
        ///微店信息补充分区
        let section3 = FKYApplyWalfareTableSectionModel()
        section3.isHaveSectionHeader = true
        section3.sectionHeaderText = "微店信息补充"
        let cell3_1 = FKYApplyWalfareTableCellModel()
        let cell3_2 = FKYApplyWalfareTableCellModel()
        let cell3_3 = FKYApplyWalfareTableCellModel()
        let cell3_4 = FKYApplyWalfareTableCellModel()
        let cell3_5 = FKYApplyWalfareTableCellModel()
        let cell3_6 = FKYApplyWalfareTableCellModel()
        let cell3_7 = FKYApplyWalfareTableCellModel()
        let cell3_8 = FKYApplyWalfareTableCellModel()
        let cell3_9 = FKYApplyWalfareTableCellModel()
        let cell3_10 = FKYApplyWalfareTableCellModel()
        let cell3_11 = FKYApplyWalfareTableCellModel()
        let cell3_12 = FKYApplyWalfareTableCellModel()
        
        
        let provinceName = (self.editAddress.provinceName ?? "")
        let cityName = (self.editAddress.cityName ?? "")
        let districtName = (self.editAddress.districtName ?? "")
        let avenu_name = (self.editAddress.avenu_name ?? "")
        var openingBankLocation = ""
        if provinceName.isEmpty == false || cityName.isEmpty == false || districtName.isEmpty == false || avenu_name.isEmpty == false {
            openingBankLocation = String.init(format: "%@ %@ %@ %@", provinceName,cityName,districtName ,avenu_name)
        }
        
        cell3_1.configCell(cellType: .inputCell,isCanEditer: false, inputTitle1: "账户名", holderText: "暂无账户名信息", inputText1: self.inputInfoModel.enterpriseName.isEmpty ? "暂无账户名信息":self.inputInfoModel.enterpriseName,paramKey: "")
        cell3_2.configCell(cellType: .inputCell,isCanEditer: false,inputTitle1: "返利金账户", holderText: "暂无返利金账户信息", inputText1: self.inputInfoModel.infoUsername.isEmpty ? "暂无返利金账户信息":self.inputInfoModel.infoUsername,paramKey: "")
        cell3_3.configCell(cellType: .inputCell,isCanEditer: false,inputTitle1: "返利金供应商", holderText: "暂无返利金供应商信息", inputText1: self.inputInfoModel.mainEnterpriseName.isEmpty ? "暂无返利金供应商信息":self.inputInfoModel.mainEnterpriseName,paramKey: "")
        cell3_4.configCell(cellType: .moreSelectCell,inputTitle1: "收款银行", holderText: "请选择", inputText1: self.inputInfoModel.bankCodeName,paramKey: "")
        cell3_4.popType = "1"
        cell3_5.configCell(cellType: .inputCell,inputTitle1: "银行账户名", holderText: "请填写银行账户名或开户人姓名", inputText1: self.inputInfoModel.bankUserName,paramKey: "bankUserName")
        cell3_6.configCell(cellType: .inputCell,inputTitle1: "收款卡号", holderText: "请输入收款卡号", inputText1: self.inputInfoModel.bankNum,paramKey: "bankNum")
        cell3_7.configCell(cellType: .moreSelectCell,inputTitle1: "开户行所在省市", holderText: "请选择", inputText1:openingBankLocation ,paramKey: "")
        cell3_7.popType = "2"
        cell3_8.configCell(cellType: .inputCell,inputTitle1: "开户支行名称", holderText: "请输入开户行名称", inputText1: self.inputInfoModel.bankName,paramKey: "bankName")
        cell3_9.configCell(cellType: .inputCell,inputTitle1: "总店名称", holderText: "请输入总店名称", inputText1: self.inputInfoModel.userName,paramKey: "userName")
        cell3_10.configCell(cellType: .inputCell,inputTitle1: "总店地址", holderText: "请输入总店地址", inputText1: self.inputInfoModel.addr,paramKey: "addr")
        cell3_11.configCell(cellType: .inputCell,inputTitle1: "总店管理员姓名", holderText: "请输入总店管理员姓名", inputText1: self.inputInfoModel.storeName,paramKey: "storeName")
        cell3_12.configCell(cellType: .inputCell,inputTitle1: "总店管理员手机", holderText: "请输入总店管理员手机", inputText1: self.inputInfoModel.mobilePhone,paramKey: "mobilePhone")
        section3.cellList.append(contentsOf: [cell3_1,cell3_2,cell3_3,cell3_4,cell3_5,cell3_6,cell3_7,cell3_8,cell3_9,cell3_10,cell3_11,cell3_12])
        
        self.sectionList.append(contentsOf: [section0,section1,section2,section3])
    }
}

//MARK - 网络请求
extension FKYApplyWalfareTableViewModel{
    /// 提交所填的参数
    func submitApplyWalfareTableInfo(block: @escaping (Bool, String?)->()){
        
        /// 检查必填参数是否填写完整
        guard self.checkParamIsFull().0 else {
            block(false,self.checkParamIsFull().1)
            return
        }
        let JSONStr = self.convertDictionaryToJSONString(dict: self.submitParam)
        guard JSONStr.count > 0 else{
            block(false,"JSON转换失败")
            return
        }
        let paramDic = ["reqStr":JSONStr]
        FKYRequestService.sharedInstance()?.postsubmitApplyWalfareTableInfo(paramDic, completionBlock: {[weak self]  (success, error, response, model) in
            guard let _ = self else {
                 block(false,"内存泄露")
                 return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            block(true, "")
            
        })
    }
    
    /// 检查必填参数是否填写完整
    func checkParamIsFull() -> (Bool,String){
        if ((self.submitParam["enterpriseType"] as? String) ?? "").isEmpty {
            return (false,"enterpriseType参数未填写")
        }else if ((self.submitParam["enterpriseId"] as? String) ?? "").isEmpty {
            return (false,"enterpriseId参数未填写")
        }else if ((self.submitParam["ycSupplyId"] as? String) ?? "").isEmpty{
            return (false,"ycSupplyId参数未填写")
        }else if ((self.submitParam["ycSupplyName"] as? String) ?? "").isEmpty{
            return (false,"ycSupplyName参数未填写")
        }
        return (true,"")
    }
    
    func convertDictionaryToJSONString(dict:[String:Any]?)->String {
        let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }
}


class FKYApplyWalfareTableSectionModel {
    
    /// 是否有分区头
    var isHaveSectionHeader = false
    
    /// 分区头显示的文字
    var sectionHeaderText = ""
    
    /// 分区中的cell列表
    var cellList:[FKYApplyWalfareTableCellModel] = []
}


class FKYApplyWalfareTableCellModel {
    enum cellType {
        case noType/// 未设置cell类型
        case tipCel/// 提示cell
        case inputCell//信息输入cell
        case displayInfoCell // 展示信息cell
        case moreSelectCell// 更多信息cell
    }
    
    /// cell类型
    var cellType:cellType = .noType
    
    /// 是否允许编辑
    var isCanEditer = true
    
    /// 显示的标题1
    var inputTitle1 = ""
    
    /// 显示的标题2
    var inputTitle2 = ""
    
    /// 占位文字
    var holderText = ""
    
    /// 显示的文字1
    var inputText1 = ""
    
    /// 显示的文字2
    var inputText2 = ""
    
    /// 提交给后台的key
    var paramKey = ""
    
    /// 弹出框类型 1 弹出银行选择框  2弹出地址选择框
    var popType = ""
    
    
    func configCell(cellType:cellType = .noType,isCanEditer:Bool = true,inputTitle1:String = "",inputTitle2:String = "",holderText:String = "",inputText1:String = "",inputText2:String = "",paramKey:String = ""){
        self.cellType = cellType
        self.isCanEditer = isCanEditer
        self.inputTitle1 = inputTitle1
        self.inputTitle2 = inputTitle2
        self.holderText = holderText
        self.inputText1 = inputText1
        self.inputText2 = inputText2
        self.paramKey = paramKey
    }
}
