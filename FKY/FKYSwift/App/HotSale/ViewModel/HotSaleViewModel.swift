//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

class HotSaleViewModel: HotSaleViewModelInterface {
    var segmentIndex: Int?
    var type: HotSaleType?
    
    // MARK: - properties
    /// 初始化配置
    var hasNextPage: Bool = false
    lazy var models: [HotSaleModel] = [HotSaleModel]()
    
    fileprivate var headerModel: HotSaleHeaderModel?
    
    // MARK: - life cycle
    init(withHeaderModel header: HotSaleHeaderModel, type: HotSaleType, segIndex: Int) {
        self.headerModel = header
        self.type = type
        self.segmentIndex = segIndex
    }
}

extension HotSaleViewModel {
    func loadDataBinding(finishedCallback : @escaping (_ message: String?) -> ()) {
        if type == .week {
            HotSaleProvider().fetchWeekHotSaleListData(withCatgoryCode: headerModel?.catgoryCode, { [weak self] (items, msg) in
                if items != nil {
                    self?.models.removeAll()
                    self?.models = items as! [HotSaleModel]
                }
                finishedCallback(msg)
            })
        } else {
            HotSaleProvider().fetchAreaHotSaleListData(withCatgoryCode: headerModel?.catgoryCode, { [weak self] (items, msg) in
                if items != nil {
                    self?.models.removeAll()
                    self?.models = items as! [HotSaleModel]
                }
                finishedCallback(msg)
            })
        }
    }

    func loadNextPageBinding(finishedCallback : @escaping (_ message: String?) -> ()) {
        guard hasNextPage else {
            return
        }
        
        // 本期不做分页功能
        finishedCallback(nil)
    }
    
}

// MARK: - private methods
extension HotSaleViewModel {
    
    
}

