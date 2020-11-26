//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

class MyCouponViewModel: MyCouponViewModelInterface {
    // MARK: - properties
    /// 初始化配置
    var usageType: CouponItemUsageType
    
    /// 页面信
    var paginator: PaginatorModel = PaginatorModel.defaultPaginator()
    
    var hasNextPage: Bool? {
        get {
            return paginator.hasNextPage
        }
    }
    
    lazy var models: [CouponModel] = [CouponModel]()
    
    // MARK: - life cycle
    required init(withUsageType type: CouponItemUsageType) {
        self.usageType = type
    }
}

extension MyCouponViewModel {
    
    func loadDataBinding(finishedCallback : @escaping (_ message: String?) -> ()) {
        // 网络请求，操作models数据内容
        let tempPaginator = PaginatorModel.defaultPaginator()
        CouponProvider().fetchMyCouponList(withStatus: usageType.couponListParameterStatus(), tempPaginator.page!) { (items, paginator, msg) in
            if ((items?.count) != nil) {
                self.models.removeAll()
                self.models += items! as! Array
                self.paginator = paginator!
            }
            finishedCallback(msg)
        }
    }
    
    func loadNextPageBinding(finishedCallback : @escaping (_ message: String?) -> ()) {
        // 网络请求，操作models数据内容
        guard paginator.hasNextPage == true else {
            finishedCallback(nil)
            return
        }
        let page = paginator.page! + 1
        CouponProvider().fetchMyCouponList(withStatus: usageType.couponListParameterStatus(), page) { (items, paginator, msg) in
            if ((items?.count) != nil) {
                self.models += items! as! Array
                self.paginator = paginator!
            }
            finishedCallback(msg)
        }
    }
}

// MARK: - private methods
extension MyCouponViewModel {


}

