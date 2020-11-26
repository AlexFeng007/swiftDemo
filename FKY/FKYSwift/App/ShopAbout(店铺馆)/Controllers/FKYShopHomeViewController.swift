//
//  FKYShopHomeViewController.swift
//  FKY
//
//  Created by yyc on 2020/10/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopHomeViewController: UIViewController {
    
    fileprivate var navBar: UIView?
    //搜索
    fileprivate lazy var searchBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(RGBColor(0x999999), for: .normal)
        btn.setTitle("药品名/助记码/厂家/商家", for: .normal)
        btn.setImage(UIImage(named: "icon_home_searchbar_search_red"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(14))
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = WH(20)
        btn.clipsToBounds = true
        btn.layer.borderWidth = WH(1.5)
        btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        return btn
    }()
    fileprivate lazy var segmentedControl: HomeSegmentControllView = {
        let segment = HomeSegmentControllView()
        segment.setsectionTitles(["发现活动","关注店铺","商家促销"])
        segment.indexChangeBlock = {[weak self] selectIndex in
            if let strongSelf = self {
                strongSelf.selIndex = "\(selectIndex)"
                strongSelf.bgScrollView .setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(selectIndex), y: 0), animated: true)
                strongSelf.addShopHomeCommonBIWithView(2)
            }
        }
        return segment
    }()
    fileprivate lazy var bgScrollView: UIScrollView = {
        let scroll = UIScrollView()
        //let height = SCREEN_HEIGHT-naviBarHeight()-WH(17)-Height_TabBar-WH(40)
        scroll.contentSize = CGSize(width: SCREEN_WIDTH*3, height: 0)
        scroll.backgroundColor = RGBColor(0xF4F4F4)
        scroll.isPagingEnabled = true
        scroll.bounces = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        return scroll
    }()
    //发现活动
    fileprivate lazy var activityVC: FKYShopActivityViewController = {
        let vc = FKYShopActivityViewController()
        return vc
    }()
    //关注店铺
    fileprivate lazy var attentionVC: FKYShopAttentionViewController = {
        let vc = FKYShopAttentionViewController()
        return vc
    }()
    //商家促销
    fileprivate lazy var promotionVC: FKYShopPrdPromotionViewController = {
        let vc = FKYShopPrdPromotionViewController()
        return vc
    }()
    
    @objc dynamic var selIndex: String? //默认选择到第几个
    
    //请求工具类
    fileprivate var viewModel: FKYShopHomeViewModel = {
        let vm = FKYShopHomeViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTabTitleList()
        if let index = self.selIndex, index.count > 0 {
            segmentedControl.setSelectedSegmentIndex(Int(index) ?? 0)
            bgScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(Int(index) ?? 0), y: 0), animated: true)
        }
    }
    deinit {
    }
    
}
//MARK:ui相关
extension FKYShopHomeViewController {
    fileprivate func setupView(){
        self.view.backgroundColor = UIColor.white
        //导航设置
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_hiddedBottomLine(true)
        navBar!.backgroundColor = UIColor.white
        navBar?.addSubview(searchBtn)
        navBar?.snp.updateConstraints({ (make) in
            make.height.equalTo(naviBarHeight()+WH(17))
        })
        searchBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (btn) in
            if let strongSelf = self {
                FKYNavigator.shared().openScheme(FKY_NewSearch.self, setProperty: { (svc) in
                    let searchVC = svc as! FKYSearchInputKeyWordVC
                    searchVC.searchType = 1
                }, isModal: false, animated: true)
                strongSelf.addShopHomeCommonBIWithView(1)
            }
            
        }).disposed(by: disposeBag)
        searchBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(self.navBar!.snp.left).offset(WH(10))
            make.right.equalTo(self.navBar!.snp.right).offset(-WH(10))
            make.bottom.equalTo(self.navBar!.snp.bottom).offset(-WH(13))
            make.height.equalTo(WH(40))
        })
        //类型
        self.view.addSubview(self.segmentedControl)
        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(40))
        }
        self.view.addSubview(self.bgScrollView)
        self.bgScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        addChild(self.activityVC)
        bgScrollView.addSubview(self.activityVC.view)
        self.activityVC.view.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(self.bgScrollView)
        }
        
        addChild(self.attentionVC)
        bgScrollView.addSubview(self.attentionVC.view)
        self.attentionVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgScrollView)
            make.left.equalTo(self.activityVC.view.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(self.bgScrollView)
        }
        
        addChild(self.promotionVC)
        bgScrollView.addSubview(self.promotionVC.view)
        self.promotionVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgScrollView)
            make.left.equalTo(self.attentionVC.view.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(self.bgScrollView)
        }
    }
}
//MARK:UIScrollViewDelegate代理
extension FKYShopHomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(scrollView.contentOffset.x / pageWidth)
        selIndex = "\(page)"
        segmentedControl.setSelectedSegmentIndex(page)
    }
}
extension FKYShopHomeViewController {
    fileprivate func getTabTitleList() {
        self.viewModel.getShopHomeTabTitleList { [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            if success{
                strongSelf.segmentedControl.setsectionTitles(strongSelf.viewModel.tabTitleArr)
            } else {
                // 失败
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
}
//MARK:埋点相关
extension FKYShopHomeViewController {
    fileprivate func addShopHomeCommonBIWithView(_ type:Int) {
        var itemId:String?
        var itemName:String?
        var itemPosition :String?
        if type == 1 {
            //搜索框
            itemId = "I1000"
            itemName = "搜索框"
            itemPosition = "0"
        }else if type == 2 {
            //点击商品详情
            itemId = "I4001"
            if let index = Int(self.selIndex ?? "0") ,index < self.viewModel.tabTitleArr.count {
                itemName = self.viewModel.tabTitleArr[index]
                itemPosition = "\(index+1)"
            }
        }
    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent:nil , itemTitle: nil, extendParams: nil, viewController: self)
    }
}
