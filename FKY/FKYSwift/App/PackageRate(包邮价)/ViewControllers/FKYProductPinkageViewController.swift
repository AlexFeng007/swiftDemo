//
//  FKYProductPinkageViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/10/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYProductPinkageViewController: UIViewController {

    fileprivate var navBar: UIView?
    @objc dynamic var freeDeliveryType: Int = 0 // url 进入判断跳入那个tabindex   0 自营  1 MP
    var childVCsArray = [UIViewController]()
    var headHeight = WH(46) //记录头部的高度
    
    //底部
    fileprivate lazy var bgScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.bounces = false
        sv.isScrollEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = bg1
        sv.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight() + self.headHeight)
        return sv
    }()
    //药福利入口
    fileprivate lazy var headView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    //搜索框
    fileprivate lazy var searchbar : FSearchBar = {
        let searchbar = FSearchBar()
        searchbar.initProductPinkageSearchItem()
        searchbar.delegate = self
        searchbar.placeholder = "搜索商品名称"
        return searchbar
    }()
    
    //搜索框
    fileprivate lazy var topSearchbar : FSearchBar = {
        let searchbar = FSearchBar()
        searchbar.initProductPinkageSearchItem()
        searchbar.delegate = self
        searchbar.placeholder = "搜索商品名称"
        return searchbar
    }()
   
    public lazy var segmentedControl: HMSegmentedControl = {
        let sv = HMSegmentedControl()
        sv.backgroundColor = UIColor.white
        let normaltextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0x333333 ,alpha: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))] as! [String : Any]
        let selectedtextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0xFF2D5C,alpha: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))] as! [String : Any]
        sv.titleTextAttributes = normaltextAttr
        sv.selectedTitleTextAttributes = selectedtextAttr
        sv.selectionIndicatorColor =  RGBColor(0xFF2D5C)
        sv.selectionIndicatorHeight = 1
        sv.selectionStyle = .textWidthStripe
        sv.selectionIndicatorLocation = .down
        sv.sectionTitles = ["药城自营","精选商家"]
        sv.indexChangeBlock = { [weak self] index in
            guard let strongSelf = self else {
                return
            }
            strongSelf.recordScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
            if Int(index) < strongSelf.childVCsArray.count {
                if let vc = strongSelf.childVCsArray[Int(index)] as? FKYSelfShopPinkageViewController {
                    vc.updateContentOffY()
                    vc.shouldFirstLoadData()
                }else if let vc = strongSelf.childVCsArray[Int(index)] as? FKYMpShopPinkageViewController {
                    vc.updateContentOffY()
                    vc.shouldFirstLoadData()
                }
            }
        }
        return sv
    }()
    
    
    lazy var recordScrollView: UIScrollView = {
        let sv = UIScrollView(frame:CGRect.zero)
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .white
        sv.contentSize = CGSize(width: SCREEN_WIDTH * 2, height:0)
        return sv
    }()
    
    deinit {
        print("FKYProductPinkageViewController deinit~!@")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupChildVCs()
        setupData()
    }
    fileprivate func setupView() {
        view.backgroundColor = RGBColor(0xffffff)
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = bg1
        
        fky_setupTitleLabel("")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){[weak self] in
            // 返回
            if let strongSelf = self {
                FKYNavigator.shared().pop()
                strongSelf.add_NEW_BI(0, nil,nil)
            }
        }
        
        self.navBar?.addSubview(self.topSearchbar)
        topSearchbar.layer.cornerRadius = WH(4)
        topSearchbar.isHidden = true
        topSearchbar.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.navBar!)
                make.bottom.equalTo(strongSelf.navBar!.snp.bottom).offset(WH(-8))
                make.left.equalTo(strongSelf.navBar!.snp.left).offset(WH(43))
                make.right.equalTo(strongSelf.navBar!.snp.right).offset(-WH(43))
                make.height.equalTo(WH(32))
            }
        })
        
        view.addSubview(bgScrollView)
        bgScrollView.snp.makeConstraints { (make) in
            make.right.bottom.left.equalTo(view)
            make.top.equalTo(navBar!.snp.bottom)
        }
        bgScrollView.addSubview(recordScrollView)
        bgScrollView.addSubview(headView)
        bgScrollView.addSubview(segmentedControl)
        
        let topLine = UIView()
        topLine.backgroundColor = RGBColor(0xE5E5E5)
        headView.addSubview(topLine)
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        bgScrollView.addSubview(line)
    
        headView.addSubview(searchbar)
        searchbar.frame = CGRect(x: WH(16), y: WH(8), width: SCREEN_WIDTH - WH(32), height: WH(30))
//        searchbar.snp.makeConstraints({[weak self] (make) in
//            if let strongSelf = self {
//                make.center.equalTo(strongSelf.headView)
//                make.left.equalTo(strongSelf.headView).offset(WH(16))
//                make.right.equalTo(strongSelf.headView).offset(-WH(16))
//                make.height.equalTo(WH(30))
//            }
//        })
        
        headView.snp.makeConstraints { (make) in
            make.left.top.equalTo(bgScrollView)
            make.height.equalTo(WH(46))
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        segmentedControl.snp.makeConstraints ({ (make) in
            make.left.equalTo(bgScrollView.snp.left).offset(WH(60))
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(WH(47))
            make.width.equalTo(SCREEN_WIDTH - WH(120))
        })
        
        line.snp.makeConstraints ({ (make) in
            make.left.equalTo(bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(segmentedControl.snp.bottom);
            make.height.equalTo(0.5)
        })
        
        topLine.snp.makeConstraints ({ (make) in
            make.left.right.bottom.equalTo(headView)
            make.height.equalTo(0.5)
        })
        
        recordScrollView.snp.makeConstraints ({ (make) in
            make.left.equalTo(bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(line.snp.bottom)
            make.height.equalTo(SCREEN_HEIGHT - WH(48) - naviBarHeight())
        })
        
        view.layoutIfNeeded()
    }
}


extension FKYProductPinkageViewController: UIScrollViewDelegate {
    func setupChildVCs() -> Void {
        let selfVC = FKYSelfShopPinkageViewController()
        
        selfVC.view.frame = recordScrollView.bounds
        selfVC.scrollBlock = { [weak self] (scrollV) in
            if let strongSelf = self {
                strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
            }
        }
        selfVC.navTitleChange = { [weak self] (title) in
            if let strongSelf = self {
                strongSelf.fky_setupTitleLabel(title)
            }
        }
        let mpVC = FKYMpShopPinkageViewController()
        
        var inframe = recordScrollView.bounds
        inframe.origin.x += SCREEN_WIDTH
        mpVC.view.frame = inframe
        mpVC.scrollBlock = { [weak self] (scrollV) in
            if let strongSelf = self {
                strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
            }
        }
        
        addChild(selfVC)
        addChild(mpVC)
        
        recordScrollView.addSubview(selfVC.view)
        recordScrollView.addSubview(mpVC.view)
        
        
        childVCsArray.append(selfVC)
        childVCsArray.append(mpVC)
        
        self.setSwitchSegentIndex(self.freeDeliveryType)
    }
    
    fileprivate func setupData() {
        // showLoading()
        bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight() + self.headHeight)
        if let vc = self.childVCsArray[0] as? FKYSelfShopPinkageViewController {
            vc.shouldFirstLoadData()
        }else if let vc = self.childVCsArray[0] as? FKYMpShopPinkageViewController {
            vc.shouldFirstLoadData()
        }
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        //处理scrolview 的滑动
        if scrollView == recordScrollView {
            let index = scrollView.contentOffset.x / SCREEN_WIDTH
            if Int(index) >= 0 && Int(index) <= 2 {
                segmentedControl.setSelectedSegmentIndex(UInt(index), animated: true)
                recordScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
                if Int(index) < childVCsArray.count {
                    if let vc = childVCsArray[Int(index)] as? FKYSelfShopPinkageViewController {
                        vc.updateContentOffY()
                        vc.shouldFirstLoadData()
                    }else if let vc = childVCsArray[Int(index)] as? FKYMpShopPinkageViewController {
                        vc.updateContentOffY()
                        vc.shouldFirstLoadData()
                    }
                }
            }
        }
    }
}

extension FKYProductPinkageViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bgScrollView {
            changeScolllView()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == bgScrollView {
            changeScolllView()
        }
    }
    
    func changeScolllView() {
        let y = bgScrollView.contentOffset.y
        if y <= 0 {
            topSearchbar.isHidden = true
            bgScrollView.contentOffset.y = 0
            self.NavigationTitleLabel?.alpha = 1
            searchbar.layer.cornerRadius = WH(15)
            searchbar.frame = CGRect(x: WH(16), y: WH(8), width: SCREEN_WIDTH - WH(32), height: WH(30))
        }
        if Int(y) >= Int(self.headHeight) {
            bgScrollView.contentOffset.y = self.headHeight
            topSearchbar.isHidden = false
            self.NavigationTitleLabel?.alpha = 0
            searchbar.layer.cornerRadius = WH(4)
            searchbar.frame = CGRect(x: WH(43), y: WH(8), width: SCREEN_WIDTH - WH(86), height: WH(30))
        }else {
            topSearchbar.isHidden = true
            let contentProcess = bgScrollView.contentOffset.y/self.headHeight
            self.NavigationTitleLabel?.alpha = 1 -  contentProcess
            searchbar.layer.cornerRadius = WH(15) - WH(11)*contentProcess
            searchbar.frame = CGRect(x: WH(16) + WH(27)*contentProcess, y: WH(8), width: SCREEN_WIDTH - 2*(WH(16) + WH(27)*contentProcess), height: WH(30))
        }
    }
    // 处理两个ScrollView的滑动交互问题
    func updateScrollViewContentOffset(scrollV: UIScrollView) {
        let y = scrollV.contentOffset.y
        if y > 0 {
            if Int(self.bgScrollView.contentOffset.y) < Int(self.headHeight) {
                if Int(bgScrollView.contentOffset.y + y) >= Int(self.headHeight) {
                    bgScrollView.contentOffset.y = self.headHeight
                    scrollV.contentOffset.y = 0
                }else{
                    bgScrollView.contentOffset.y += y
                    scrollV.contentOffset.y = 0
                }
            }
        } else {
            if self.bgScrollView.contentOffset.y > 0 {
                bgScrollView.contentOffset.y += y
                scrollV.contentOffset.y = 0
            }
        }
        
    }
    //设置担保包邮列表选择
    func setSwitchSegentIndex(_ packetRebateType:Int){
        //0 自营  1 MP
        segmentedControl.setSelectedSegmentIndex(UInt(packetRebateType), animated: true)
        self.recordScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(packetRebateType), y: 0), animated: true)
        if packetRebateType < self.childVCsArray.count {
            if let vc = self.childVCsArray[packetRebateType] as? FKYSelfShopPinkageViewController {
                vc.updateContentOffY()
                vc.shouldFirstLoadData()
            }else if let vc = self.childVCsArray[packetRebateType] as? FKYMpShopPinkageViewController  {
                vc.updateContentOffY()
                vc.shouldFirstLoadData()
            }
        }
    }
}
//MARK:FSearchBarProtocol代理
extension FKYProductPinkageViewController : FSearchBarProtocol {
    func fsearchBar(_ searchBar: FSearchBar, search: String?) {
    }
    
    func fsearchBar(_ searchBar: FSearchBar, textDidChange: String?) {
        print("textChange\(String(describing: textDidChange))")
    }
    
    func fsearchBar(_ searchBar: FSearchBar, touches: String?) {
        //点击搜索框
        self.add_NEW_BI(1, nil,nil)
        FKYNavigator.shared().openScheme(FKY_Search.self, setProperty: { [weak self] (svc) in
            guard let strongSelf = self else {
                return
            }
            let searchVC = svc as! FKYSearchViewController
            searchVC.vcSourceType = .pilot
            searchVC.searchType = .packageRate
            searchVC.searchFromType = .fromCommon
            if strongSelf.segmentedControl.selectedSegmentIndex == 0{
                //自营
                searchVC.isSelfTag = true
            }else{
                //mp
                searchVC.isSelfTag = false
            }
        }, isModal: false, animated: true)
        
    }
}
//MARK:bi埋点相关
extension FKYProductPinkageViewController{
    func add_NEW_BI(_ biType:Int,_ prdModel:FKYPackageRateModel?,_ index:Int?){
        var sectionId:String?//
        var sectionName:String? //
        var sectionPosition:String? //
        var itemId:String? //
        var itemName:String? //
        var itemPosition:String? //

        if biType == 0 {
            sectionId = "S7801"
            sectionName = "单品包邮头部"
            sectionPosition = "0"
            itemId = "I7810"
            itemName = "返回"
            itemPosition = "1"
        }else if biType == 1 {
            if self.segmentedControl.selectedSegmentIndex == 0{
                sectionId = "S7806"
                sectionName = "药城自营"
                itemId = "I7822"
            }else{
                sectionId = "S7807"
                sectionName = "精选商家"
                itemId = "I7823"
            }
            sectionPosition = nil
            itemName = "搜索"
            itemPosition = nil
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: sectionId, sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
    }
}
