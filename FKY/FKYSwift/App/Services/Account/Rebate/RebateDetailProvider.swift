//
//  RebateDetailProvider.swift
//  FKY
//
//  Created by 寒山 on 2019/2/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

/*
 返利金记录
 */
enum FKYRebateRecordType: Int {
    case FKYRebateRecordTypeAll = 1 //全部记录
    case FKYRebateRecordTypeIn = 2 //收入记录
    case FKYRebateRecordTypeOut = 3 //支出记录
    case FKYRebateRecordTypeTotal = 4 //累计余额
    case FKYRebateRecordTypePending = 5 //待到账余额
    case FKYRebateRecordTypeAvaliable = 6 //可用余额
}

class RebateDetailProvider: NSObject {
    var dataArray: Array<RebateDetailInfoModel> = []  //返利金详情
    var rebateRecordArray = [RebateRecordModel]()    //返利金记录
    var mRebateRecordModel: FKYRebateRecordModel?
    let pageSize = 10 //页码数
    
    // 获取返利金详情
    func getRabteDetailInfo(block: @escaping (Bool,String?)->()) {
        // 请求
        FKYRequestService.sharedInstance()?.requestForGetRebateDetail(withParam: nil, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                block(false, "")
                return
            }
            // 失败
            guard success else {
                var msg = "请求失败"
                if let errorMsg: String = ((error as Any) as! NSError).userInfo[HJErrorTipKey] as? String{
                    msg = errorMsg;
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
            // 成功
            if let data: NSDictionary = response as? NSDictionary {
                if let list: NSArray = data["listAmount"] as? NSArray, let rebateArray = list.mapToObjectArray(RebateDetailInfoModel.self) {
                    strongSelf.dataArray = rebateArray
                }
                block(true, "")
                return
            }
            block(false, "")
        })
    }
    
    //我的余额
    func requestMyRebate(_ completionHandler: @escaping (_ success: Bool, _ msg: String?, _ model: FKYMyRebateModel?) -> ()) {
        FKYRequestService.sharedInstance()?.requestMyRebate(withParam: nil, completionBlock: { (success, error, response, model) in
            guard success else {
                var msg = error?.localizedDescription ?? "查询我的余额失败"
                if let err = error as NSError? {
                    if err.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                completionHandler(false, msg, nil)
                return
            }
            
            if let rebateModel = model as? FKYMyRebateModel {
                completionHandler(true, nil, rebateModel)
                return
            }
            
            completionHandler(false, "查询我的余额失败", nil)
        })
    }
    
    //返利金记录
    func requestRebateRecord(pageIndex: Int, rebateRecordType: FKYRebateRecordType, _ completionHandler: @escaping (_ success: Bool, _ msg: String?,_ needLoadMore: Bool) -> ()) {

        let param = ["recordType": rebateRecordType.rawValue,
                     "pageIndex": pageIndex,
                     "pageSize": pageSize]
        if pageIndex == 1 {
            rebateRecordArray.removeAll()
        }
        
        FKYRequestService.sharedInstance()?.requestRebateRecord(withParam: param, completionBlock: {
            [weak self] (success, error, response, model) in
            guard success else {
                var msg = error?.localizedDescription ?? "查询返利金记录失败"
                if let err = error as NSError? {
                    if err.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                completionHandler(false, msg, false)
                return
            }
            
            if let rebateRecordModel = model as? FKYRebateRecordModel {
                self?.mRebateRecordModel = rebateRecordModel
                var loadMore = true
                if let rebateRecord = rebateRecordModel.rebateRecord {
                    self?.rebateRecordArray.append(contentsOf: rebateRecord)
                    loadMore = (rebateRecord.count == 10);
                } else {
                    loadMore = false
                }
                completionHandler(true, nil, loadMore)
                return;
            }
            completionHandler(false, "查询返利金记录失败", false)
        })
    }
}
