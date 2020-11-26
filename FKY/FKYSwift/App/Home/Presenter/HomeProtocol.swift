//
//  HomeProtocol.swift
//  FKY
//
//  Created by Rabe on 07/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

protocol HomeTemplateValidationProtocol {
    var isValid: Bool? {get}
}

protocol HomeViewOperation: HomeSearchBarOperation {
    func onTableViewRefreshAction()
    func onTableViewLoadNextPageAction()
    func onClickCellAction(_ action: HomeTemplateAction)
}

protocol HomeContainerProtocol {
    func numberOfChildModelsInContainer() -> Int
    func childFloorModel(atIndex index: Int) -> HomeModelInterface?
}

@objc protocol HomeModelInterface: NSObjectProtocol {
    func floorIdentifier() -> String
    @objc optional
    func floorType() -> NSInteger
}

protocol HomeViewInterface : class {
    var viewModel: HomeViewModelInterface? {get set}
    var operation: HomeViewOperation? {get set}
    
    func updateUserLocation(_ location: String?)
    func toast(_ msg: String?)
    func showLoading()
    func hideLoading()
    func updateTableviewCell(_ cell: UITableViewCell?, _ indexPath: IndexPath?, _ data: Any?)
    func resetHomePageStatus()
    func updateEmptyDataShowStatus()
    func updateHomePageContent()
    func hideLoadMoreFooterWhenRequestFail()
}

typealias HomeCellActionCallback = (_ action: HomeTemplateAction)->()

@objc protocol HomeCellInterface: NSObjectProtocol {
    static func calculateHeight(withModel model: HomeModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat
    func bindModel(_ model: HomeModelInterface)
    func bindOperation(_ callback: @escaping HomeCellActionCallback)
}

protocol HomeViewModelInterface : class {
    var floors : [HomeModelInterface & HomeContainerProtocol] {get set}
    var hasNextPage: Bool? { get }
    var didSelectCity: Bool? { get set }
    var shouldAutoLoading: Bool? { get set }
    var preLoadingRowFlag: Int? { get }
    
    func floorPosition(withTemplateType type: HomeTemplateType) -> String
    func rowModel(atIndexPath indexPath: IndexPath) -> HomeModelInterface
    func fetchUserLocation(finishedCallback: @escaping (_ location: String?) -> ())
    func loadCacheData(finishedCallback: @escaping () -> ())
    func loadDataBinding(finishedCallback : @escaping (_ message: String?, _ success: Bool) -> ())
    func loadNextPageBinding(finishedCallback : @escaping (_ message: String?, _ success: Bool) -> ())
}
