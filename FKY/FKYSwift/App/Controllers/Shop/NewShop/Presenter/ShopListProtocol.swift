//
//  NewShopListProtocol.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

protocol ShopListContainerProtocol {
    func numberOfChildModelsInShopListContainer() -> Int
    func childShopListFloorModel(atIndex index: Int) -> ShopListModelInterface?
}

@objc protocol ShopListModelInterface: NSObjectProtocol {
    func floorCellIdentifier() -> String
    @objc optional
    func floorCellType() -> NSInteger
}

class ShopListTemplateAction: TemplateAction {
    var actionType: ShopListTemplateActionType = .unknow
    //var floorPosition: ShopListTemplateType = .unknow000
    var needRecord = true // 默认当前操作需要埋点
}

typealias ShopListCellActionCallback = (_ action: ShopListTemplateAction)->()

@objc protocol ShopListCellInterface: NSObjectProtocol {
    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat
    func bindModel(_ model: ShopListModelInterface)
    func bindOperation(_ callback: @escaping ShopListCellActionCallback)
}

protocol ShopListViewModelInterface : class {
    var floors : [ShopListModelInterface & ShopListContainerProtocol] {get set}
    var hasNextPage: Bool? { get }
    var didSelectCity: Bool? { get set }
    var shouldAutoLoading: Bool? { get set }
    var preLoadingRowFlag: Int? { get }
    
    func floorPosition(withTemplateType type: ShopListTemplateType) -> String
    func rowModel(atIndexPath indexPath: IndexPath) -> ShopListModelInterface
    func fetchUserLocation(finishedCallback: @escaping (_ location: String?) -> ())
    func loadCacheData(finishedCallback: @escaping () -> ())
    func loadDataBinding(finishedCallback : @escaping (_ message: String?, _ success: Bool) -> ())
    func loadNextPageBinding(finishedCallback : @escaping (_ message: String?, _ success: Bool) -> ())
}
