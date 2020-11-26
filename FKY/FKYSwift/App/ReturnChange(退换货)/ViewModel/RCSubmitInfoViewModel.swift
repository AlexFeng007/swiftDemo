//
//  RCSubmitInfoViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退货or换货界面ViewModel

import UIKit

class RCSubmitInfoViewModel: NSObject {
    // MARK: - Property
    
    ///银行信息viewmodel
    var bankInfoModel = FKYSaleReturnBankInfoModel()
    ///银行cell的viewModel
    var cellModel = FKYInvoiceCellModel()
    // 类型：(退货 or 换货)
    var returnFlag: Bool = false
    var rcType = 2 //1:mp退货 2:自营退货 3:自营的极速理赔 (上个界面传过来的)
    // 订单号
    var orderId: String?
    // 商品列表
    var productList = [FKYOrderProductModel]()
    
    // 提交退/换货信息相关内容
    var applyReason: RCApplyReasonModel?    // 申请原因
    var sendType: RCSendBackType?           // 退回方式
    var problemDescription: String?         // 问题描述
    var picList = [String]()                // 上传的图片数组
    
    // 选中的申请原因索引...<默认未选中>
    var index4Reason: Int = -1
    // 退回方式之展示类型...<默认三个均不显示>
    var sendShowType: RCSendBackShowType = .noShow
    
    // 当前最大可上传照片个数...<默认为5>
    let maxUploadNumber = 5
    
    /**退货时，支付方式为线下转账需要参数**/
    var bankName: String?//开户行
    var bankAccount: String?//银行账户
    var userName: String?//开户名
    ///所选银行ID
    var bankType = ""
    
    // MARK: - Public
    
    // 用户选择申请原因后，需更新退回方式之展示类型 mp退货只显示客户寄回
    func updateSendBackShowType(_ rcType:Int) {
        guard let reason = applyReason, let id = reason.id, id > 0 else {
            sendShowType = .noShow
            sendType = nil
            return
        }
        if rcType == 1 {
            //mp退货只显示客户寄回<目前只支持退货>
            sendShowType = .showOnyCustomerSend
        } else if rcType == 3 {
            sendShowType = .noShow
        }else {
            //自营的退换货
            if id == 149 {
                sendShowType = .showCustomerSend
            }
            else if id == 150 {
                sendShowType = .showCustomerSend
            }
            else if id == 151 {
                sendShowType = .showHomePickup
            }
            else if id == 152 {
                sendShowType = .showHomePickup
            }
            else if id == 153 {
                sendShowType = .showHomePickup
            }
            else if id == 154 {
                sendShowType = .showHomePickup
            }
            else if id == 155 {
                sendShowType = .showHomePickup
            }
            else {
                // 非以上id，默认为顾客寄回
                sendShowType = .showCustomerSend
            }
        }
        sendType = nil
    }
    
    // 更新上传图片数据内容
    func deletePicAtIndex(_ index: Int) {
        guard picList.count > 0, index >= 0, index < picList.count else {
            return
        }
        picList.remove(at: index)
    }
    
    // 若上传图片超过最大数量，则自动移除前面的
    func updatePicListForException() {
        if picList.count > maxUploadNumber {
            let list = picList.suffix(maxUploadNumber)
            picList = Array.init(list)
        }
    }
    
    // 创建临时用于查看大图的图片数组
    func createImageList() -> [UIImageView]? {
        guard picList.count > 0 else {
            return nil
        }
        
        var list = [UIImageView]()
        for index in 0..<picList.count {
            let url = picList[index]
            let x = WH(17) + (WH(60) + WH(5)) * CGFloat(index) + WH(8)
            var y = WH(42+94) + WH(10) + WH(45) * 2 + WH(40) + WH(130) + WH(3) + WH(8)
            
            if applyReason == nil {
                // 若未选择申请原因，则不会显示退回方式， 故坐标需调整
                y -= WH(45)
            }
            
            // 适配iPhoneX
            var top = WH(20) + WH(44)
            if #available(iOS 11, *) {
                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                    top = iPhoneX_SafeArea_TopInset
                }
            }
            y += top
            
            let imgview = UIImageView.init(frame: CGRect.init(x: x, y: y, width: WH(44), height: WH(44)))
            imgview.backgroundColor = .clear
            imgview.contentMode = .scaleAspectFit
            imgview.clipsToBounds = true
            imgview.isUserInteractionEnabled = true
            imgview.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_default_img"))
            list.append(imgview)
        } // for
        return list
    }
    
    // 判断用户输入信息是否完整
    func checkSubmitInfoStatus() -> (status: Int, msg: String) {
        guard index4Reason >= 0, applyReason != nil else {
            return (1, "请选择申请原因")
        }
        //极速理赔方式，退回方式不是必填
        if self.rcType != 3 {
            guard sendType != nil else {
                return (2, "请选择退回方式")
            }
        }
        guard let txt = problemDescription, txt.isEmpty == false else {
            return (3, "请输入问题描述")
        }
        guard txt.count > 0, txt.count <= 200 else {
            return (5, "问题描述长度不符")
        }
        guard picList.count > 0 else {
            return (4, "请上传图片")
        }
        //        guard picList.count <= 5 else {
        //            return (6, "上传图片超过5张")
        //        }
        guard let oid = orderId, oid.isEmpty == false else {
            return (7, "子订单id为空")
        }
        guard productList.count > 0 else {
            return (8, "无选中商品")
        }
        
        // 异常情况的特殊处理
        guard picList.count <= maxUploadNumber else {
            // 若超过5张，则取后5张图片
            let list = picList.suffix(maxUploadNumber)
            picList = Array.init(list)
            return (0, "ok")
        }
        
        // ok
        return (0, "ok")
    }
}

// MARK: - Private
extension RCSubmitInfoViewModel {
    // 封装入参
    fileprivate func getSubmitData() -> Dictionary<NSString, Any>? {
        // 0.退货or换货
        let type = (returnFlag ? 0 : 1)
        // 1.子订单号
        var orderid = ""
        if let oid = orderId, oid.isEmpty == false {
            orderid = oid
        }
        // 2.退换货原因ID
        var reasonId = ""
        if let reason = applyReason, let id = reason.id {
            reasonId = "\(id)"
        }
        // 3.退回方式<极速理赔，退回方式可为空>
        var returnType = (self.rcType == 3 ? "": "MIC")
        if let rType = sendType {
            switch rType {
            case .homePickup:
                returnType = "MIB"
            case .customerSend:
                returnType = "MIC"
            case .refuseReceive:
                returnType = "MIF"
            }
        }
        // 4.退换货说明
        var remark = ""
        if let txt = problemDescription, txt.isEmpty == false {
            remark = txt
        }
        // 5.附件图片url
        let attachments = picList
        // 6.退换货商品
        var selectedGoods = ""
        var totalMoneyNum = 0.0
        for product in productList {
            if product.orderDetailId > 0, product.steperCount > 0 {
                let pid = product.orderDetailId
                if selectedGoods == "" {
                    selectedGoods = "\(product.steperCount)" + "_" + "\(pid)"
                }
                else {
                    let str = "," + "\(product.steperCount)" + "_" + "\(pid)"
                    selectedGoods.append(str)
                }
                totalMoneyNum = totalMoneyNum + Double(product.steperCount) * product.productPrice.doubleValue
            } // if
            
        } // for
        
        var param: [NSString: Any] = ["type":type, "orderId":orderid, "reasonId":reasonId, "remark":remark, "attachments":attachments, "selectedGoods":selectedGoods, "backWay":returnType]
        
        //极速理赔
        if self.rcType == 3 {
            param["rmaBizType"] = 1
            param["refundAmount"] = "\(totalMoneyNum)"
        }
        
        /**退货时，支付方式为线下转账需要参数**/
        //开户行
        if let str = self.bankName {
            param["bankName"] = str
        }
        //银行账户
        if let str = self.bankAccount {
            param["bankAccountNo"] = str
        }
        //开户名
        if let str = self.userName {
            param["bankAccountName"] = str
        }
        //所选银行ID
        param["bankType"] = self.bankType
        
        return param
    }
    // 封装MP入参
    fileprivate func getMpSubmitData() -> Dictionary<NSString, Any>? {
        // 1.退货 2:换货
        let returnType = (returnFlag ? 1 : 2)
        let source = 3 //订单来源
        
        // 1.子订单号
        var orderid = ""
        if let oid = orderId, oid.isEmpty == false {
            orderid = oid
        }
        // 2.退换货原因ID
        var reasonId = ""
        if let reason = applyReason, let id = reason.id {
            reasonId = "\(id)"
        }
        // 4.退换货说明
        var remark = ""
        if let txt = problemDescription, txt.isEmpty == false {
            remark = txt
        }
        
        // 5.附件图片url
        var filePath = ""
        if picList.count > 0 {
            if picList.count == 1 {
                filePath = picList[0]
            }else {
                filePath = picList.joined(separator: ",")
            }
        }
        
        // 6.退换货商品
        var list = [Any]()
        for product in productList {
            var selectedGoods = ""
            if product.steperCount > 0 {
                selectedGoods = "\(product.steperCount)"
            }
            let batchNumber = product.batchNumber ?? "0"
            let orderDeliveryDetailId = product.orderDeliveryDetailId
            let orderDetailId = product.orderDetailId
            
            let param: [NSString: Any] = ["returnType":returnType, "source":source, "returnReason":reasonId, "returnDesc":remark, "filePath":filePath, "flowId":orderid, "returnCount":selectedGoods, "batchNumber":batchNumber,"orderDeliveryDetailId":orderDeliveryDetailId,"orderDetailId":orderDetailId]
            list.append(param)
        } // for
        
        return ["jsonParams":list]
    }
}

// MARK: - Request
extension RCSubmitInfoViewModel {
    
    /// 获取退款银行信息
    /// - Parameter block:
    func requestBankInfo(_ param:[String:Any] ,block: @escaping (_ isSuccess:Bool, _ Msg:String?)->()) {
        FKYRequestService.sharedInstance()?.requestForSaleReturnBankInfoList(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let selfStrong = self else {
                block(false, "请求失败")
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
            
            // 请求成功 整理数据
            if let data = response as? NSDictionary {
                selfStrong.bankInfoModel = data.mapToObject(FKYSaleReturnBankInfoModel.self)
                selfStrong.cellModel.inputText = selfStrong.bankInfoModel.bankTypeVO.name
                selfStrong.cellModel.inputHolder = "银行类型"
                selfStrong.cellModel.titleName = "银行类型"
                selfStrong.cellModel.isCanEditer = true
                selfStrong.cellModel.AccessoryType = .bankCellTypr
                block(true,"获取成功")
            }
        })
    }
    
    // 提交退换货相关信息...<包含解析>
    func submitRCInfo(_ isReturn: Bool, _ isMp:Bool , _ block: @escaping (Bool, String?)->()) {
        // 保存
        returnFlag = isReturn
        if isMp == true {
            let param: [NSString: Any]? = getMpSubmitData()
            FKYRequestService.sharedInstance()?.requestForMpSubmitApplyInfo(withParam: param, completionBlock: { (success, error, response, model) in
                guard success else {
                    // 失败
                    var msg = error?.localizedDescription ?? "提交失败"
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
                // 操作成功
                block(true, "提交成功")
            })
            
        }else {
            let param: [NSString: Any]? = getSubmitData()
            FKYRequestService.sharedInstance()?.requestForSubmitApplyInfo(withParam: param, completionBlock: { (success, error, response, model) in
                guard success else {
                    // 失败
                    var msg = error?.localizedDescription ?? "提交失败"
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
                guard let res = response as? NSDictionary else {
                    // 无返回值
                    block(false, "提交失败")
                    return
                }
                // 有返回值<解析>
                let code = res["code"] as? String
                let msg = res["message"] as? String
                guard let co = code, let value = Int(co), value > 0 else {
                    // 操作失败...<code=0失败；code>0成功>
                    block(false, msg ?? "提交失败")
                    return
                }
                // 操作成功
                block(true, "提交成功")
            })
        }
    }
    
    // 请求申请原因列表...<已自动解析>...<未使用>
    class func requestApplyReasonList(_ param: Dictionary<String, Any>?, block: @escaping RequestServiceBlock) {
        FKYRequestService.sharedInstance()?.requestForApplyReasonList(withParam: param, completionBlock: { (success, error, response, model) in
            block(success, error, response, model)
        })
    }
}
