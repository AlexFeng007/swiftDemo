//
//  ShopListCouponCenterViewModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/12/4.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  领券中心

class ShopListCouponCenterViewModel {
    
    fileprivate lazy var requestService: FKYPublicNetRequestSevice = {
        let service = FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! FKYPublicNetRequestSevice
        return service
    }()
    
    fileprivate lazy var logic: ShopListCouponCenterLogic = {
        let service = ShopListCouponCenterLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! ShopListCouponCenterLogic
        return service
    }()
    
    var dataSource: Array<ShopListCouponModel> = []
    
    var hasMore: Bool = true
    
    var page: Int = 1
    
    fileprivate var pageSize: Int = 10
    
    init() { }
}

extension ShopListCouponCenterViewModel {
    // 资质状态查询
    func requestZzStatus(_ callback:@escaping (_ statusCode: Int?)->()) {
        requestService.getAuditStatusBlock(withParam: nil) { (response, error) in
            if error == nil {
                if let json = response as? NSDictionary {
                    if let statusCode = (json as AnyObject).value(forKeyPath: "statusCode") as? NSNumber {
                        callback(statusCode.intValue)
                    }
                    else {
                        callback(-2)
                    }
                }
                else {
                    callback(-2)
                }
            }
            else {
                callback(-2)
            }
        }
    }
    
    func getCouponListData(success: @escaping ()->(), fail: @escaping (String?)->()) {
        let param = ["page": page, "pageSize": pageSize]
        logic.fetchCouponListData(withParams: param) { (array, msg) in
            
            var dataSource: Array<ShopListCouponModel> = []
            if self.page != 1 && self.dataSource.count > 0 {
                dataSource = self.dataSource
            } else {
                dataSource = []
            }
            
            if let list = array as? Array<ShopListCouponModel> {
                dataSource.append(contentsOf: list)
                self.dataSource = dataSource
                if list.count < self.pageSize {
                    self.hasMore = false
                } else {
                    self.hasMore = true
                }
                success()
            } else {
                self.hasMore = true
                fail(msg)
            }
        }
    }
    
    func receiveCoupon(_ model: ShopListCouponModel!, _ finishedCallback : @escaping (_ isSuccess: Bool, _ msg: String?) -> ()) {
        logic.receiveCoupon(byTemplateCode: model.templateCode!) { [weak self] (couponModel, msg, isSuccess) in
            if isSuccess {
                for (_, value) in (self?.dataSource.enumerated())! {
                    if value.id == model.id {
                        value.couponCode = "couponCode"
                        break
                    }
                }
            }
            finishedCallback(isSuccess, msg)
        }
    }
}
