//
//  NewShopListViewController.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/20.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  店铺馆...<最新>

import UIKit

protocol NewShoplistItemProtocol {
    var scrollBlock: ((CGFloat)->())? {get set}
    var bgScrollOffset: CGFloat {get set}
    //var tableView: UITableView{get}
    
    func resetContentOffset()
    func currentOffset() -> CGFloat
}

extension NewShoplistItemProtocol {
    func resetContentOffset() {
        //tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    func currentOffset() -> CGFloat {
        return 0
        //return self.tableView.contentOffset.y
    }
}

class NewShopListViewController: UIViewController {
    
    fileprivate var navBar: UIView?
    
    fileprivate lazy var bgImageView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var searchBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(RGBColor(0x999999), for: .normal)
        btn.setTitle("药品名/拼音缩写/厂家名/供应商", for: .normal)
        btn.setImage(UIImage(named: "shopList_search_icon"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        return btn
    }()
    
    fileprivate var segmentedControl: HMSegmentedControl! = {
        // 先使用占位数组进行初始化
        let segment = HMSegmentedControl.init(sectionTitles: ["品种汇", "精选店", "中药材"])
        // 设置背景色
        segment?.backgroundColor = UIColor.clear
        // 设置滚动条高度
        segment?.selectionIndicatorHeight = 1
        // 设置滚动条颜色
        segment?.selectionIndicatorColor = UIColor.white
        // 设置滚动条样式
        segment?.selectionStyle = HMSegmentedControlSelectionStyle.textWidthStripe
        // 设置滚动条位置
        segment?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        // 设置未选中的字体大小和颜色
        segment?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white.withAlphaComponent(0.7),
                                        NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(15))]
        // 设置选中的字体大小和颜色
        segment?.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                                NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(15))]
        // 设置分段选中索引
        segment?.setSelectedSegmentIndex(0, animated: true)
        return segment
    }()
    
    fileprivate lazy var bgScrollView: UIScrollView = {
        let scroll = UIScrollView()
        let height = SCREEN_HEIGHT-navBarH-Height_TabBar-44
        scroll.contentSize = CGSize(width: SCREEN_WIDTH*3, height: height)
        scroll.isPagingEnabled = true
        scroll.bounces = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        return scroll
    }()
    
    fileprivate lazy var logic: ShopListLogic = { [weak self] in
        let service = ShopListLogic.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as! ShopListLogic
        return service
    }()
    
    fileprivate var isSearchBtnHidden: Bool = false
    
    @objc dynamic var selIndex: String? //默认选择到第几个
    
    fileprivate let vcs = [NewShopListItemVC1(),FKYShopListViewController(),FKYMedicineViewController()]
    
    //MARK: Life Style
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        logic.fetchShopListTitleData {[weak self] (titles, msg) in
            guard let strongSelf = self else {
                return
            }
            guard msg == nil else {
                strongSelf.toast(msg)
                return
            }
            if let arr = titles, arr.count == 3 {
                strongSelf.segmentedControl.sectionTitles = arr
            }
        }
        
        if let index = self.selIndex, index.count > 0 {
            segmentedControl.setSelectedSegmentIndex(UInt(index) ?? 0, animated: true)
            bgScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(Int(index) ?? 0), y: 0), animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 刚开始进入品种汇埋点
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.SHOPLIST_SEGMENT_CLICK_CODE.rawValue, itemPosition: "1", itemName: "华中自营", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self.vcs[0])
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
    }
    
    //MARK: Private
    
    fileprivate func setupView() {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        
        let finalSize = CGSize(width: SCREEN_WIDTH, height: navBarH)
        let layer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: finalSize.height))
        bezier.addLine(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: finalSize.height))
        bezier.addLine(to: CGPoint(x: 0, y: finalSize.height))
        layer.path = bezier.cgPath
        layer.fillColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH).cgColor
        view.layer.addSublayer(layer)
        
        view.addSubview(bgImageView)
        bgImageView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: navBarH+44)
        bgImageView.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH)
        
        navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_hiddedBottomLine(true)
        navBar!.backgroundColor = UIColor.clear
        
        navBar?.addSubview(searchBtn)
        searchBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (btn) in
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.HOME_SEARCH_CLICK_CODE.rawValue, itemPosition: "0", itemName: "搜索框", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self?.vcs[0])
            /*
            FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { (svc) in
                let searchVC = svc as! FKYSearchViewController
                searchVC.vcSourceType = .common
                searchVC.searchType = .prodcut
                searchVC.searchFromType = .fromShop
                searchVC.fromePage = 3
            }, isModal: false, animated: true)
            */
            FKYNavigator.shared().openScheme(FKY_NewSearch.self, setProperty: { (svc) in
                let searchVC = svc as! FKYSearchInputKeyWordVC
                //searchVC.vcSourceType = .common
                searchVC.searchType = 1
                //searchVC.searchFromType = .fromShop
                //searchVC.fromePage = 3
            }, isModal: false, animated: true)
        }).disposed(by: disposeBag)
        searchBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(self.navBar!.snp.left).offset(WH(17))
            make.right.equalTo(self.navBar!.snp.right).offset(-WH(17))
            make.bottom.equalTo(self.navBar!.snp.bottom).offset(-6)
            make.height.equalTo(32)
        })
        
        view.addSubview(segmentedControl)
        segmentedControl.indexChangeBlock = { [weak self] (index: Int) -> () in
            self?.selIndex = "\(index)"
            self?.bgScrollView .setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
            if index < (self?.vcs.count)! {
                let vc = self?.vcs[index]
                if let desVC = vc as? NewShopListItemVC1 {
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.SHOPLIST_SEGMENT_CLICK_CODE.rawValue, itemPosition: "1", itemName: "华中自营", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self?.vcs[0])
                    
                    self?.viewWillShow(desVC.currentOffset(), desVC.bgScrollOffset)
                }else if let desVC = vc as? FKYShopListViewController{
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.SHOPLIST_SEGMENT_CLICK_CODE.rawValue, itemPosition: "2", itemName: "所有店铺", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self?.vcs[0])
                    
                    self?.viewWillShow(desVC.currentOffset(), desVC.bgScrollOffset)
                }else if let desVC = vc as? FKYMedicineViewController {
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: ITEMCODE.SHOPLIST_SEGMENT_CLICK_CODE.rawValue, itemPosition: "3", itemName: "商家热销", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self?.vcs[0])
                    
                    self?.viewWillShow(desVC.currentOffset(), desVC.bgScrollOffset)
                }
            }
        }
        segmentedControl.frame = CGRect(x: 0, y: navBarH, width: SCREEN_WIDTH, height: 44)
        
        view.addSubview(bgScrollView)
        bgScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        for i in 0...2 {
            let vc = self.vcs[i]
            if let desVC = vc as? FKYMedicineViewController {
                desVC.scrollBlock = {[weak self] (y) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.animationWithScroll(y, desVC)
                }
            } else if let desVC = vc as? NewShopListItemVC1 {
                desVC.scrollBlock = {[weak self] (y) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.animationWithScroll(y, desVC)
                }
            } else if let desVC = vc as? FKYShopListViewController {
                desVC.scrollBlock = {[weak self] (y) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.animationWithScroll(y, desVC)
                }
            }
            addChild(vc)
            bgScrollView.addSubview(vc.view)
        }
        for i in 0...2 {
            switch i {
            case 0:
                vcs[i].view.snp.makeConstraints { (make) in
                    make.top.left.equalTo(self.bgScrollView)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(self.bgScrollView)
                    make.right.equalTo(vcs[i+1].view.snp.left);
                }
            case 1:
                vcs[i].view.snp.makeConstraints { (make) in
                    make.top.equalTo(self.bgScrollView)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(self.bgScrollView)
                    make.right.equalTo(vcs[i+1].view.snp.left);
                }
            case 2:
                vcs[i].view.snp.makeConstraints { (make) in
                    make.top.right.equalTo(self.bgScrollView)
                    make.height.equalTo(self.bgScrollView)
                    make.width.equalTo(SCREEN_WIDTH)
                }
                bgScrollView.snp.makeConstraints { (make) in
                    make.right.equalTo(vcs[i].view)
                }
            default:
                break
            }
        }
    }
    
    func viewWillShow(_ y: CGFloat, _ offset: CGFloat) {
        if y > 0, isSearchBtnHidden == false {
            UIView.animate(withDuration: 0.25) {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.searchBtn.alpha = (offset-44)/44
                strongSelf.segmentedControl.frame = CGRect(x: 0, y: navBarH-offset, width: SCREEN_WIDTH, height: 44)
                strongSelf.bgImageView.frame = CGRect(x: 0, y: -offset, width: SCREEN_WIDTH, height: navBarH+44)
                strongSelf.navBar?.backgroundColor = RGBColor(0xFF2D5C).withAlphaComponent(1-(offset-44)/44)
            }
        }
    }
    
    func animationWithScroll(_ y: CGFloat, _ vc: UIViewController) {
        let minY = navBarH-44
        let maxY = navBarH
        var frame = segmentedControl.frame
        
        let bgMinY: CGFloat = -44
        let bgMaxY: CGFloat = 0
        var bgImageFrame = bgImageView.frame
        if y >= 44 { // 滑动速度过快
            searchBtn.alpha = 0
            isSearchBtnHidden = true
            segmentedControl.frame = CGRect(x: 0, y: navBarH-44, width: SCREEN_WIDTH, height: 44)
            navBar?.backgroundColor = RGBColor(0xFF2D5C)
            bgImageView.frame = CGRect(x: 0, y: -44, width: SCREEN_WIDTH, height: navBarH+44)
            if let desVC = vc as? FKYMedicineViewController {
                desVC.bgScrollOffset = 44
            } else if let desVC = vc as? NewShopListItemVC1 {
                desVC.bgScrollOffset = 44
            }else if let desVC = vc as? FKYShopListViewController{
                desVC.bgScrollOffset = 44
            }
        }
        else {
            if y > 0 {
                if frame.origin.y <= minY {
                    frame.origin.y = minY
                    bgImageFrame.origin.y = bgMinY
                    searchBtn.alpha = 0
                    navBar?.backgroundColor = RGBColor(0xFF2D5C)
                    isSearchBtnHidden = true
                    if let desVC = vc as? FKYMedicineViewController {
                        desVC.bgScrollOffset = 44
                    } else if let desVC = vc as? NewShopListItemVC1 {
                        desVC.bgScrollOffset = 44
                    }else if let desVC = vc as? FKYShopListViewController{
                        desVC.bgScrollOffset = 44
                    }
                } else {
                    frame.origin.y = frame.origin.y - y
                    bgImageFrame.origin.y = bgImageFrame.origin.y - y
                    if let desVC = vc as? FKYMedicineViewController {
                        desVC.bgScrollOffset += y
                        desVC.resetContentOffset()
                    } else if let desVC = vc as? NewShopListItemVC1 {
                        desVC.bgScrollOffset += y
                        desVC.resetContentOffset()
                    }else if let desVC = vc as? FKYShopListViewController{
                        desVC.bgScrollOffset += y
                        desVC.resetContentOffset()
                    }
                    searchBtn.alpha = (frame.origin.y-minY)/44
                    navBar?.backgroundColor = RGBColor(0xFF2D5C).withAlphaComponent(1-(frame.origin.y-minY)/44)
                    isSearchBtnHidden = false
                }
            }
            else {
                if frame.origin.y >= maxY {
                    frame.origin.y = maxY
                    bgImageFrame.origin.y = bgMaxY
                    searchBtn.alpha = 1
                    navBar?.backgroundColor = UIColor.clear
                    isSearchBtnHidden = false
                    if let desVC = vc as? FKYMedicineViewController {
                        desVC.bgScrollOffset = 0
                    } else if let desVC = vc as? NewShopListItemVC1 {
                        desVC.bgScrollOffset = 0
                    }else if let desVC = vc as? FKYShopListViewController{
                        desVC.bgScrollOffset = 0
                    }
                } else {
                    frame.origin.y = frame.origin.y - y
                    bgImageFrame.origin.y = bgImageFrame.origin.y - y
                    if let desVC = vc as? FKYMedicineViewController {
                        desVC.bgScrollOffset += y
                        desVC.resetContentOffset()
                    } else if let desVC = vc as? NewShopListItemVC1 {
                        desVC.bgScrollOffset += y
                        desVC.resetContentOffset()
                    }else if let desVC = vc as? FKYShopListViewController{
                        desVC.bgScrollOffset += y
                        desVC.resetContentOffset()
                    }
                    searchBtn.alpha = (frame.origin.y-minY)/44
                    navBar?.backgroundColor = RGBColor(0xFF2D5C).withAlphaComponent(1-(frame.origin.y-minY)/44)
                    isSearchBtnHidden = false
                }
            }
            segmentedControl.frame = frame
            bgImageView.frame = bgImageFrame
        }
    }
}

extension NewShopListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(scrollView.contentOffset.x / pageWidth)
        selIndex = "\(page)"
        segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
        if page < vcs.count {
            let vc = vcs[page]
            if let desVC = vc as? FKYMedicineViewController {
                viewWillShow(desVC.currentOffset(), desVC.bgScrollOffset)
            } else if let desVC = vc as? NewShopListItemVC1 {
                viewWillShow(desVC.currentOffset(), desVC.bgScrollOffset)
            }else if let desVC = vc as? FKYShopListViewController{
                viewWillShow(desVC.currentOffset(), desVC.bgScrollOffset)
            }
        }
    }
}
