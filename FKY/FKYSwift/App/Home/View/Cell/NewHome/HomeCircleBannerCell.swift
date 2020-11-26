//
//  HomeCircleBannerCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  首页之轮播cell

import UIKit

class HomeCircleBannerView: UIView {
    // MARK: - Property
    
    /// 轮播图item切换
    static let itemScrollSwitch:String = "HomeCircleBannerView-itemScrollSwitch"
    
    // closure
    fileprivate var callback: HomeCellActionCallback?
    
    // 
    fileprivate lazy var operation: HomePresenter = HomePresenter()
    
    // 轮播视图
    fileprivate lazy var viewBanner: FKYCirclePageView = {
        let view = FKYCirclePageView.init(frame: CGRect(x: WH(10), y: WH(0), width:SCREEN_WIDTH - WH(20), height: (SCREEN_WIDTH - 20)*110/355.0))
        view.backgroundColor = .clear
        view.autoScroll = true
        view.autoScrollTimeInterval = 2
        view.infiniteLoop = true
        view.infiniteLoopWhenOnlyOne = false
        view.maxSecitons = 1
        // 查看详情
        view.bannerDetailCallback = { [weak self] (index, content)  in
            guard let strongSelf = self else {
                return
            }
           // if let clouser = self?.callback {
            let action = HomeTemplateAction()
            action.actionType = .banner001_clickItem
            if let model  = (content as? HomeCircleBannerItemModel)  {
                if model.name != nil{
                    action.itemName = model.name!
                }
                action.actionParams = [HomeString.ACTION_KEY: model]
            }
            
            action.itemCode = ITEMCODE.HOME_BANNER_CLICK_CODE.rawValue
            action.itemPosition = String(index + 1)
            action.floorPosition = "1"
            action.floorName = "运营首页"
            action.floorCode = FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue
            action.sectionName = "轮播图"
            strongSelf.operation.onClickCellAction(action)
                //clouser(action)
            //}
        }
        return view
    }()
    
    // 数据源
    fileprivate var bannerModel: HomeCircleBannerModel?
    
    var bannerList:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = bg1
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        
        self.backgroundColor =  .clear

        self.addSubview(viewBanner)
        viewBanner.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(10))
            make.right.equalTo(self).offset(WH(-10))
            make.bottom.equalTo(self);
            make.height.equalTo((SCREEN_WIDTH - 20)*110/355.0)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(banner: HomeCircleBannerModel?) {
        // 保存
        bannerModel = banner
        // 展示
        if let model = banner, let list = model.banners, list.count > 0 {
            viewBanner.configDataSource(list)
            viewBanner.bannerModel = model
            showOrHideView(showFlag: true)
        }
        else {
            viewBanner.bannerModel = nil
            viewBanner.configDataSource(nil)
            showOrHideView(showFlag: false)
        }
    }
    func configIsVisible(_ isVisible:Bool){
        //viewBanner.configIsVisible(isVisible)
    }
  
    // MARK: - Private
    
    // 无数据时隐藏整个内容视图
    func showOrHideView(showFlag: Bool) {
        viewBanner.isHidden = !showFlag
    }
}

//MARK: - 事件响应
extension HomeCircleBannerView {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYCirclePageView.itemScrollSwitch {// 轮播图切换
            let index = userInfo[FKYUserParameterKey] as! Int
            guard index < bannerList.count else {
                return
            }
            let banner = bannerList[index]
            super.routerEvent(withName: HomeCircleBannerView.itemScrollSwitch, userInfo: [FKYUserParameterKey:["index":index,"banner":banner]])
        }else {
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}

extension HomeCircleBannerView: HomeCellInterface {
    static func calculateHeight(withModel model: HomeModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        if let m = model as? HomeCircleBannerModel {
            if let list = m.banners, list.count > 0 {
                // 有数据
                return (SCREEN_WIDTH - 20)*110/355.0
            }
            else {
                // 无数据
                return 0
            }
        }
        return 0
    }
    
    func bindOperation(_ callback: @escaping HomeCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: HomeModelInterface) {
        if let m = model as? HomeCircleBannerModel {
            configCell(banner: m)
        }
        else {
            configCell(banner: nil)
        }
    }
    
    func configData(banner:[FKYHomePageV3ItemModel]){
        bannerList = banner
        viewBanner.configDataSource(banner)
    }
    /*
    func showTestData(){
        viewBanner.showTestData()
        //viewBanner.bannerModel = model
        showOrHideView(showFlag: true)
    }
    */
}
