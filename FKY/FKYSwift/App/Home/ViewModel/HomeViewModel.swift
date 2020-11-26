//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

class HomeViewModel: HomeViewModelInterface {
    // MARK: - properties
    fileprivate var pageId = 1
    fileprivate var pageSize = 1
    fileprivate var logic: HomeLogic?
    fileprivate var floorIndexMap = [HomeTemplateType: String]()
    
    /// 初始化配置
    internal var shouldAutoLoading: Bool? = true
    internal var didSelectCity: Bool? = false
    internal var floors: [HomeContainerProtocol & HomeModelInterface] = [HomeContainerProtocol & HomeModelInterface]() {
        didSet {
            DispatchQueue.global().async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                for (index, value) in strongSelf.floors.enumerated() {
                    if let templateModel = value as? HomeTemplateModel {
                        strongSelf.floorIndexMap[templateModel.type] = "\(index+1)"
                    }
                }
            }
        }
    }
    
    internal var preLoadingRowFlag: Int? {
        get {
            return floors.count - pageSize
        }
    }
    
    internal var hasNextPage: Bool? {
        get {
            return pageId < pageSize
        }
    }
    
    // 当前是否正在进行刷新操作
    internal var isRefresh: Bool = false
    
    // MARK: - life cycle
    init() {
        logic = HomeLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? HomeLogic
        
        // notification...<每次从后台到前台时，若首页存在秒杀专区楼层，则需要刷新首页>
//        NotificationCenter.default.addObserver(self, selector: #selector(checkSecondKillFloorStatus), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
}

extension HomeViewModel {
    func floorPosition(withTemplateType type: HomeTemplateType) -> String {
        return floorIndexMap[type] ?? "0"
    }
    
    func rowModel(atIndexPath indexPath: IndexPath) -> HomeModelInterface {
        guard floors.count > indexPath.section else {
            return HomeMarginModel()
        }
        let floorModel: HomeContainerProtocol & HomeModelInterface = floors[indexPath.section]
        let rowModel: HomeModelInterface? = floorModel.childFloorModel(atIndex: indexPath.row)
        return rowModel ?? HomeMarginModel()
    }
    
    // 获取用户站点
    func fetchUserLocation(finishedCallback: @escaping (String?) -> ()) {
        if FKYLoginAPI.loginStatus() == .loginComplete {
            let userModel = FKYLoginService.currentUser()
            if userModel?.substationName != nil, didSelectCity == false {
                let m = FKYLocationModel()
                m?.substationCode = userModel?.substationCode
                m?.substationName = userModel?.substationName
                m?.isCommon = 0
                m?.showIndex = 1
                FKYLocationService().setCurrentLocation(m)
                finishedCallback(m?.substationName)
            } else {
                finishedCallback(FKYLocationService().currentLocationName())
            }
        } else {
            var stationname = "默认"
            if FKYLocationService().currentLoaction == nil {
                let model = FKYLocationModel.default()
                stationname = (model?.substationName)!
            } else {
                stationname = FKYLocationService().currentLocationName()
            }
            finishedCallback(stationname)
        }
    }
    
    // 读缓存
    func loadCacheData(finishedCallback: @escaping () -> ()) {
        logic?.fetchHomeTemplateCacheData({ [weak self] (templates, pageId, pageSize) in
            // 无缓存
            guard templates != nil else {
                finishedCallback()
                return
            }
            // 有缓存
            self?.pageId = pageId
            self?.pageSize = pageSize
            self?.floors = templates as! [HomeContainerProtocol & HomeModelInterface]
            finishedCallback()
        })
    }
    
    // 请求首页的第1页数据
    func loadDataBinding(finishedCallback : @escaping (_ message: String?, _ success: Bool) -> ()) {
        pageId = 1
        pageSize = 1
        isRefresh = true
        logic?.fetchHomeTemplateData(withPage: 1) { [weak self] (templates, pageId, pageSize, message) in
            self?.shouldAutoLoading = true
            self?.isRefresh = false
            // 接口失败
            guard templates != nil else {
                finishedCallback(message, false)
                return
            }
            // 接口成功
            self?.pageId = 1
            self?.pageSize = pageSize
            self?.floors = templates as! [HomeContainerProtocol & HomeModelInterface]

            finishedCallback(nil, true)
        }
    }
    
    // 请求首页的非第1页数据
    func loadNextPageBinding(finishedCallback : @escaping (_ message: String?,  _ success: Bool) -> ()) {
        guard hasNextPage! == true else {
            // 无更多数据，不需要再继续请求下一页的接口，直接返回
            finishedCallback(nil, false)
            return
        }
        guard isRefresh == false else {
            // 用户已开始下拉刷新，不需要再继续请求下一页的接口，直接返回
            finishedCallback(nil, false)
            return
        }
        logic?.fetchHomeTemplateData(withPage: (pageId + 1)) { [weak self] (templates, pageId, pageSize, message) in
            self?.shouldAutoLoading = true
            // 接口失败
            guard templates != nil else {
                finishedCallback(message, false)
                return
            }
            // 重复请求
            guard pageId != self?.pageId else {
                finishedCallback(nil, false)
                return
            }
            // 加载下一页（耗时可能较长）时，用户手动刷新（耗时可能较短），之前老的无用请求没有cancel，可能导致数据源混乱
            guard self?.isRefresh == false else {
                finishedCallback(nil, false)
                return
            }
            // 接口成功
            self?.pageId = pageId
            self?.pageSize = pageSize
            let arr: [HomeContainerProtocol & HomeModelInterface] = templates as! [HomeContainerProtocol & HomeModelInterface]
            self?.floors = (self?.floors)! + arr
            finishedCallback(nil, true)
        }
    }
}

// MARK: - private methods
extension HomeViewModel {
    // 暂不使用
    @objc fileprivate func checkSecondKillFloorStatus() {
        var hasSecondKill = false
        for index in 0...floors.count {
            let floorModel: HomeContainerProtocol & HomeModelInterface = floors[index]
            if floorModel.floorType!() == 16 {
                hasSecondKill = true
                break
            }
        }
        if hasSecondKill {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: FKYHomeSecondKillCountOver), object: self, userInfo: nil)
        }
    }
}
