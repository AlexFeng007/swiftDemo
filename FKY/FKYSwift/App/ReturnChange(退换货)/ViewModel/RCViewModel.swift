//
//  RCViewModel.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/20.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货之列表界面ViewModel

import UIKit

@objc
class RCViewModel: NSObject {
    //
    var dataSource: Array<RCListModel> = []
    
    var rcDetail: RCDModel?
    var expressState: String?
    var expressList: Array<RCExpressInfoModel> = []
    var logistDetail: RCLogistDetailInfoModel?
    
    // 创建临时用于查看大图的图片数组
    func createImageList(_ viewY:CGFloat) -> [UIImageView]? {
        guard (rcDetail?.attachmentList!.count)! > 0 else {
            return nil
        }
        
        var list = [UIImageView]()
        for index in 0..<(rcDetail?.attachmentList!.count)! {
            let model:RCAttachmentModel =  (rcDetail?.attachmentList![index])!
            let url = model.filePath
            let x = (WH(55) + WH(18)) * CGFloat(index) + WH(15)
            
            let imgview = UIImageView.init(frame: CGRect.init(x: x, y: viewY, width: WH(55), height: WH(55)))
            imgview.backgroundColor = .clear
            imgview.contentMode = .scaleAspectFit
            imgview.clipsToBounds = true
            imgview.isUserInteractionEnabled = true
            imgview.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "image_default_img"))
            list.append(imgview)
        } // for
        return list
    }
    
    //获取退换货列表
    func getRClListData(withParams soNo: String?, callback: @escaping (_ goods : [RCListModel])->(), fail: @escaping (_ reason : String)->()) { // /home/recommend/frequentlyBuy
        // 入参
        let dic: [String: Any] = [
            "soNo":soNo as Any
        ]
        // 请求
        FKYRequestService.sharedInstance()?.queryUserRmaOrderList(withParam: dic, completionBlock: { (success, error, response, model) in
            if error == nil {
                if let data = response as? NSArray {
                    if  let rclModelArray = data.mapToObjectArray(RCListModel.self) {
                        self.dataSource = rclModelArray
                        // 有数据
                        callback(self.dataSource)
                    }else {
                        // 无数据
                        callback(self.dataSource)
                    }
                }
                else {
                    // 无数据
                    callback(self.dataSource)
                }
            }
            else {
                var msg = "访问失败"
                if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                fail(msg)
            }
        })
    }
    
    //获取退换货详情
    func getRCDetailData(withParams dic: Dictionary<String, Any>, callback: @escaping (_ goods : [RCListModel])->(), fail: @escaping (_ reason : String)->()) { // /home/recommend/frequentlyBuy
        // 请求
        FKYRequestService.sharedInstance()?.getOcsRmaApplyInfo(withParam: dic, completionBlock: { (success, error, response, model) in
            if error == nil {
                if let data = response as? NSDictionary {
                    self.rcDetail = data.mapToObject(RCDModel.self)
                    callback([])
                }
                else {
                    // 无数据
                    fail("访问失败")
                }
            }
            else {
                var msg = "访问失败"
                if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                fail(msg)
            }
        })
    }
    
    //撤销申请
    @objc func cancleOcsRmaApplyData(withParams applyId: String?,_ isMp:Bool, callback: @escaping (_ goods : [RCListModel])->(), fail: @escaping (_ reason : String)->()) { // /home/recommend/frequentlyBuy
        // 入参
        if isMp == true {
            //mp订单取消
            let dic: [String: Any] = ["jsonParams": applyId as Any]
            FKYRequestService.sharedInstance()?.requestForMPCancleOcsRmaApplyInfo(withParam: dic, completionBlock: { (success, error, response, model) in
                      if error == nil {
                          if (response as? NSDictionary) != nil {
                              //if let data = response as? NSDictionary {
                              //self.rcDetail = data.mapToObject(RCDModel.self)
                              callback([])
                          }
                          else {
                              // 无数据
                              callback([])
                          }
                      }
                      else {
                          var msg = "访问失败"
                          if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String {
                              msg = errorMsg;
                          }
                          if let err = error {
                              let e = err as NSError
                              if e.code == 2 {
                                  // token过期
                                  msg = "用户登录过期，请重新手动登录"
                              }
                          }
                          fail(msg)
                      }
                  })
        }else {
            //自营订单取消
            let dic: [String: Any] = ["applyId": applyId as Any]
            FKYRequestService.sharedInstance()?.requestForCancleOcsRmaApplyInfo(withParam: dic, completionBlock: { (success, error, response, model) in
                      if error == nil {
                          if (response as? NSDictionary) != nil {
                              //if let data = response as? NSDictionary {
                              //self.rcDetail = data.mapToObject(RCDModel.self)
                              callback([])
                          }
                          else {
                              // 无数据
                              callback([])
                          }
                      }
                      else {
                          var msg = "访问失败"
                          if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String {
                              msg = errorMsg;
                          }
                          if let err = error {
                              let e = err as NSError
                              if e.code == 2 {
                                  // token过期
                                  msg = "用户登录过期，请重新手动登录"
                              }
                          }
                          fail(msg)
                      }
                  })
        }
    }
    
    //获取物流日志接口
    func requestForqueryLogisticsList(withParams dic: Dictionary<String, Any>, block: @escaping (Bool, String?)->()) {
        // 请求
        FKYRequestService.sharedInstance()?.requestForqueryLogisticsList(withParam: dic, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = "访问失败"
                if let errorMsg: String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String {
                    msg = errorMsg
                }
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
            if let data = response as? NSArray {
                let expressInfoList = data.mapToObjectArray(RCExpressListInfoModel.self)
                let  codeList =  dic["subscribeKD100DtoList"] as! [Any]
                let codeDic =  codeList[0] as! [String: String]
                let expressId:String = codeDic["waybillCode"]!
                for object in expressInfoList! {
                    if object.waybillNo ==  expressId {
                        self.expressList = object.logs!
                        self.expressState = object.orderStatus!
                        block(true, "")
                        return
                    }
                }
            }
            block(true, "")
        })
    }
    
    //订阅物流日志接口
    func requestForsubscribeLogisticsInfo(withParams dic: Dictionary<String, Any>, block: @escaping (Bool, String?)->()) {
        // 请求
        FKYRequestService.sharedInstance()?.requestForSubscribeSendInfo(withParam: dic, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = "访问失败"
                if let errorMsg: String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String {
                    msg = errorMsg
                }
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
    
    //
    func queryTmsLogByChildOrderId(withParams dic: Dictionary<String, Any>, block: @escaping (Bool, String?)->()) {
        // 请求
        FKYRequestService.sharedInstance()?.queryTmsLogByChildOrderId(withParam: dic, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = "访问失败"
                if let errorMsg: String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String {
                    msg = errorMsg
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            } //logistDetail: RCLogistDetailInfoModel
            if let data = response as? NSDictionary {
                self.logistDetail = data.mapToObject(RCLogistDetailInfoModel.self)
                block(true, "")
                return
            }
            block(true, "")
        })
    }
    // 查询订单的所有退换货  换货返回物流
    
    //MARK:获取全部订单的申请记录
    @objc var applyList: Array<FKYAllAfterSaleModel> = []  //申请记录列表
    var currentNum = 0
    var totalNum = 1 //记录接口返回的总页数
    
    //判断是否有更多
    @objc func hasNextPage() -> Bool {
        return totalNum > currentNum
    }
    
    @objc func getAllWorkOrderList(withParams type: String?, callback: @escaping (_ goods : [FKYAllAfterSaleModel])->(), fail: @escaping (_ reason : String)->()) {
        if type == "1" {
            //刷新
            currentNum = 1
        }else {
            //加载更多
            currentNum = currentNum + 1
        }
        // 入参
        let dic: [String: Any] = [
            "start":"\(currentNum)",
            "pagesize":"\(10)",
            "source" : "app"
        ]
        // 请求
        FKYRequestService.sharedInstance()?.queryAllWorkOrderList(withParam: dic, completionBlock: { (success, error, response, model) in
            if error == nil {
                if let data = response as? NSDictionary ,let arr = data["resultList"] as? NSArray {
                    //总页数
                    if let totalNum = data["count"] as? Int {
                        self.totalNum = totalNum/10
                        if totalNum%10 > 0 {
                           self.totalNum = self.totalNum + 1
                        }
                    }
                    
                    if  let rclModelArray = arr.mapToObjectArray(FKYAllAfterSaleModel.self),rclModelArray.count > 0 {
                        if type == "1" {
                            //刷新
                            self.applyList = rclModelArray
                        }else {
                            //加载更多
                            self.applyList = self.applyList + rclModelArray
                        }
                        // 有数据
                        callback(self.applyList)
                    }else {
                        // 无数据
                        self.currentNum = self.currentNum - 1
                        callback(self.applyList)
                    }
                }else {
                    self.currentNum = self.currentNum - 1
                    // 无数据
                    callback(self.applyList)
                }
            }
            else {
                var msg = "访问失败"
                if let errorMsg : String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
                }
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                self.currentNum = self.currentNum - 1
                fail(msg)
            }
        })
    }
    
}

