//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

enum HotSaleType: Int {
    case local = 12 // 区域热搜
    case week = 13 // 本周热销
}

protocol HotSaleViewInterface {
    var viewModel: HotSaleViewModelInterface? {get set}
    var operation: HotSaleViewOperation? {get set}
    
    func toast(_ msg: String?) -> Void
    func showLoading() -> Void
    func hideLoading() -> Void
    func updateHotSaleContent()
}

protocol HotSaleViewModelInterface {
    var segmentIndex: Int? {get set}
    var type: HotSaleType? {get set}
    var models: [HotSaleModel] { get set }
    var hasNextPage: Bool { get }
    mutating func loadDataBinding(finishedCallback : @escaping (_ message: String?) -> ())
    func loadNextPageBinding(finishedCallback : @escaping (_ message: String?) -> ())
}


class HotSalePresenter {
    // MARK: - properties
    var view: HotSaleViewInterface?
    var viewModel: HotSaleViewModelInterface?
}

// MARK: - delegates
extension HotSalePresenter: HotSaleViewOperation {
    //
    func onClickRowProduct(withAction action: TemplateAction) {
        let params: Dictionary<String, Any> = action.actionParams
        let model = params[HomeString.ACTION_KEY] as! HotSaleModel
        
        // 埋点处理
        let sectionCode = action.sectionCode
        let itemCode = action.itemCode
        let itemPosition = action.itemPosition
        let viewController = CurrentViewController.shared.item
        //FKYAnalyticsManager.sharedInstance.BI_Record(floorCode: nil, floorPosition: nil,floorName: nil, sectionCode: sectionCode, sectionPosition: nil, sectionName: nil, itemCode: itemCode, itemPosition: itemPosition, itemName: nil,extendParams:nil, viewController: viewController)
        
        FKYNavigator.shared().openScheme(FKY_SearchResult.self) { (vc) in
            let v = vc as! FKYSearchResultVC
            v.spuCode = model.spuCode
            v.searchResultType = ""
        }
    }

    //
    func onTableViewRefreshAction() {
        DispatchQueue.global().async {
            self.viewModel?.loadDataBinding(finishedCallback: {[weak self] (msg) in
                DispatchQueue.main.async {
                    self?.view?.hideLoading()
                    self?.view?.viewModel = self?.viewModel
                    self?.view?.operation = self
                    self?.view?.toast(msg)
                    self?.view?.updateHotSaleContent()
                };
            })
        }
    }

    //
    func onTableViewLoadNextPageAction() {
        DispatchQueue.global().async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel?.loadNextPageBinding(finishedCallback: {  [weak self](msg) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.view?.viewModel = strongSelf.viewModel
                    strongSelf.view?.operation = self
                    strongSelf.view?.toast(msg)
                    strongSelf.view?.updateHotSaleContent()
                };
            })
        }
    }
}

extension HotSalePresenter {
    
    func adapter<VM: HotSaleViewModelInterface, V: HotSaleViewInterface>(viewModel: VM,  view: V) {
        
        self.view = view;
        self.viewModel = viewModel
        
        self.view?.showLoading()
        onTableViewRefreshAction()
    }
}

