//
//  ShopBannerListCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  店铺内banner

import UIKit

class ShopBannerListCell: UITableViewCell {
    
    // MARK: - Property
    // closure
    fileprivate var callback: HomeCellActionCallback?
    var clickBannerItem:((Int,HomeCircleBannerItemModel)->(Void))?//点击banner
    //
    fileprivate lazy var operation: HomePresenter = HomePresenter()
    
    //选中的的背景
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 轮播视图
    fileprivate lazy var viewBanner: FKYCirclePageView = {
        let view = FKYCirclePageView.init(frame: CGRect(x: WH(10), y: WH(9), width:SCREEN_WIDTH - WH(20), height: (SCREEN_WIDTH - 20)*110/355.0))
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
            if let block = strongSelf.clickBannerItem, let itemModel =  content as? HomeCircleBannerItemModel {
                block(index, itemModel)
            }
            // if let clouser = self?.callback {
            //            let action = HomeTemplateAction()
            //            action.actionType = .banner001_clickItem
            //            if let model  = (content as? HomeCircleBannerItemModel)  {
            //                if model.name != nil{
            //                    action.itemName = model.name!
            //                }
            //                action.actionParams = [HomeString.ACTION_KEY: model]
            //            }
            
            //            action.itemCode = ITEMCODE.HOME_BANNER_CLICK_CODE.rawValue
            //            action.itemPosition = String(index + 1)
            //            action.floorPosition = "1"
            //            action.floorName = "运营首页"
            //            action.floorCode = FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue
            //            action.sectionName = "轮播图"
            //strongSelf.operation.onClickCellAction(action)
            //clouser(action)
            //}
        }
        return view
    }()
    
    // 数据源
    fileprivate var bannerModel: HomeCircleBannerModel?
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        
        self.backgroundColor = RGBColor(0xF4F4F4)
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo((SCREEN_WIDTH - 20)*110/355.0 + WH(9))
            make.left.right.top.equalTo(self.contentView)
        }
        
        bgView.addSubview(viewBanner)
        viewBanner.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(WH(10))
            make.right.equalTo(bgView).offset(WH(-10))
            make.top.equalTo(bgView).offset(WH(9));
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

extension ShopBannerListCell {
    static func calculateHeight(withModel model: HomeCircleBannerModel) -> CGFloat {
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
    static func  getCellContentHeight(_ hasNavList:Bool) -> CGFloat{
        if hasNavList == false{
            return (SCREEN_WIDTH - 20)*110/355.0 + WH(19)
        }
        return (SCREEN_WIDTH - 20)*110/355.0 + WH(9)
    }
}
