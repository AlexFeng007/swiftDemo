//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

protocol CouponModelInterface {
    
}

protocol MyCouponViewInterface {
    var viewModel: MyCouponViewModelInterface? {get set}
    var operation: MyCouponViewOperation? {get set}
    func toast(_ msg: String?) -> Void
    func showLoading() -> Void
    func hideLoading() -> Void
}

protocol MyCouponViewModelInterface {
    var hasNextPage: Bool? { get }
    var usageType: CouponItemUsageType { get set }
    var models: [CouponModel] {get}
    mutating func loadDataBinding(finishedCallback : @escaping (_ message: String?) -> ())
    func loadNextPageBinding(finishedCallback : @escaping (_ message: String?) -> ())
}

class MyCouponPresenter {
    // MARK: - properties
    var view: MyCouponViewInterface?
    var viewModel: MyCouponViewModelInterface?
}

// MARK: - delegates
extension MyCouponPresenter: MyCouponViewOperation {
    func onTableViewRefreshAction() {
        self.viewModel?.loadDataBinding(finishedCallback: {[weak self] (msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view?.hideLoading()
            strongSelf.view?.viewModel = strongSelf.viewModel
            strongSelf.view?.operation = strongSelf
            strongSelf.view?.toast(msg)
        })
    }
    
    func onTableViewLoadNextPageAction() {
        self.viewModel?.loadNextPageBinding(finishedCallback: {[weak self] (msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view?.viewModel = strongSelf.viewModel
            strongSelf.view?.operation = strongSelf
            strongSelf.view?.toast(msg)
        })
    }
}

extension MyCouponPresenter {
    
    func adapter<VM: MyCouponViewModelInterface, V: MyCouponViewInterface>(viewModel: VM,  view: V) {
        
        self.view = view;
        self.viewModel = viewModel
        
        self.view?.showLoading()
        onTableViewRefreshAction()
    }
}
