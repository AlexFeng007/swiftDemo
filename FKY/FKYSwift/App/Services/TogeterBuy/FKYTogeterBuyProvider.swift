//
//  FKYTogeterBuyProvider.swift
//  FKY
//
//  Created by hui on 2018/10/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterBuyProvider: NSObject {
    fileprivate lazy var publicService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    var pageNowTotalSize = 1 //总页码
    var pageOldTotalSize = 1 //总页码
    var pageSize = 20 //每页条数(修改时需相应修改页码计算)
    var currNowPage = 1//本期认购当前页
    var currOldPage = 1//往期认购当前页
    var sellerCode :String?//店铺ID
    //请求一起购列表
    func getTogeterBuyList(_ keyWordStr:String?,_ isFresh:Bool,_ typeStr : String,callback: @escaping (_ model: [FKYTogeterBuyModel]?,_ isCheck:String?, _ enterpriseId:String?,_ message: String?)->()){
        var params = ["type" : typeStr as AnyObject]
        if FKYLoginAPI.loginStatus() != .unlogin, FKYEnvironmentation().stationName != "默认"  {
            params["provinceName"] =  FKYEnvironmentation().stationName as AnyObject
        }else {
            params["provinceName"] = "" as AnyObject
        }
        if let keyStr = keyWordStr {
            params["keyword"] = keyStr as AnyObject
        }else {
            params["keyword"] = "" as AnyObject
        }
        if sellerCode != nil,sellerCode!.isEmpty == false{
             params["sellerCode"] = sellerCode! as AnyObject
        }
        params["pageSize"] = "\(self.pageSize)" as AnyObject
        if isFresh == true {
            //刷新
            if typeStr == "1" {
                //本期认购
                self.currNowPage = 1
                self.pageNowTotalSize = 1
                params["currPage"] = "\(self.currNowPage)" as AnyObject
            }else {
                //往期认购
                self.currOldPage = 1
                self.pageOldTotalSize = 1
                params["currPage"] = "\(self.currOldPage)" as AnyObject
            }
        }else {
            //加载更多
            if self.hasNext(typeStr) == false {
                return
            }
            if typeStr == "1" {
                //本期认购
                self.currNowPage = 1 + self.currNowPage
                params["currPage"] = "\(self.currNowPage)" as AnyObject
            }else {
                //往期认购
                self.currOldPage = 1 + self.currOldPage
                params["currPage"] = "\(self.currOldPage)" as AnyObject
            }
        }
        self.publicService?.getTogeterBuyListBlock(withParam: params, completionBlock: { (responseObj, error) in
            guard let data = responseObj as? Dictionary<String,AnyObject> else {
//                if error?.localizedDescription == "活动数据未查询到" {
//                    callback([],nil,nil)
//                    return
//                }
                if isFresh == false {
                    if typeStr == "1" {
                        //本期认购
                        self.currNowPage = self.currNowPage - 1
                    }else {
                        //往期认购
                        self.currOldPage = self.currOldPage - 1
                    }
                }
                callback(nil,nil,nil,error?.localizedDescription ?? "网络连接失败")
                return
            }
            if let code = data["code"] ,code as! String == "2" {
                //未查询到数据<界面需要获取自营店id，点击按钮跳到自营店>
                //获取用户自营店id
                var enterpriseId = "8353"
                if let dataDic = data["data"] as? NSDictionary ,let strId = dataDic["enterpriseId"] as? Int {
                    enterpriseId = "\(strId)"
                }
                callback([],nil,enterpriseId,nil)
                return
            }
            if let dataDic = data["data"] as? NSDictionary {
                let pageDic = dataDic["page"] as! NSDictionary
                if typeStr == "1" {
                    self.pageNowTotalSize = pageDic["allPages"] as! Int
                }else {
                    self.pageOldTotalSize = pageDic["allPages"] as! Int
                }
                let productArr = (pageDic["result"] as! NSArray).mapToObjectArray(FKYTogeterBuyModel.self)
                let isCheck = dataDic["isCheck"]
                callback(productArr,"\(isCheck ?? "" as AnyObject)",nil,nil)
            }else {
                callback(nil,nil,nil,error?.localizedDescription ?? "网络连接失败")
            }
        })
    }
    func hasNext(_ typeStr : String) -> Bool {
        if typeStr == "1" {
            return self.pageNowTotalSize > self.currNowPage
        }else {
            return self.pageOldTotalSize > self.currOldPage
        }
        
    }
    //请求一起购商品详情
    func getTogeterBuyDetailData(_ params:[String: AnyObject]?,callback: @escaping (_ model: FKYTogeterBuyDetailModel?, _ message: String?)->()){
        self.publicService?.getTogeterBuyDetailDataBlock(withParam: params, completionBlock: { (responseObj, error) in
            guard let data = responseObj as? Dictionary<String,AnyObject> else {
                callback(nil, error?.localizedDescription ?? "网络连接失败")
                return
            }
            let model = FKYTogeterBuyDetailModel.fromJSON((data["data"] as! Dictionary<String,AnyObject>))
            let isCheck = data["isCheck"]
            model.isCheck = "\(isCheck ?? "" as AnyObject)"
            callback(model, nil)
        })
    }
}
