//
//  RebateInfoController.swift
//  FKY
//
//  Created by 寒山 on 2019/2/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  返利金详情

import UIKit

let YFL_TIP_H = WH(97)

class RebateInfoController: UIViewController {
    
    fileprivate lazy var viewModel: RebateDetailProvider = {
        let vm = RebateDetailProvider()
        return vm
    }()
    fileprivate var navBar: UIView?
    
    var childVCsArray = [UIViewController]()
    
    var rebateDetailListModel = FKYRebateDetailViewModel()
    var headHeight = WH(210) //记录头部的高度
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
    
    lazy var myRebateView: FKYMyRebateView = {
        let rebateView = FKYMyRebateView()
        rebateView.myRebateViewClicked = { [weak self](type) in
            if let strongSelf = self {
                if (type == .FKYRebateRecordTypeAvaliable) {
                    //                    FKYNavigator.shared().openScheme(FKY_FKYRebateDetailViewController.self, setProperty: { (svc) in
                    //                        let RCDVC = svc as! FKYRebateDetailViewController
                    //                        RCDVC.dataArray = strongSelf.viewModel.dataArray
                    //                    }, isModal: false, animated: true)
                    FKYNavigator.shared().openScheme(FKY_FKYRebateDetailVC.self, setProperty: { (svc) in
                        //                        let RCDVC = svc as! FKYRebateDetailViewController
                        //                        RCDVC.dataArray = strongSelf.viewModel.dataArray
                    }, isModal: false, animated: true)
                    return 
                }
                FKYNavigator.shared().openScheme(FKY_RebateDetailController.self, setProperty: { (svc) in
                    let rdv = svc as! RebateDetailController
                    rdv.rebateRecordType = type
                }, isModal: false, animated: true)
            }
        }
        return rebateView
    }()
    //药福利入口
    fileprivate lazy var yflView : FKYYflTipView = {
        let view = FKYYflTipView()
        view.configTipData()
        view.clickYflView = {
            FKYNavigator.shared()?.openScheme(FKY_FKYYflIntroDetailViewController.self, setProperty: { (vc) in
                
            })
        }
        return view
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
        sv.sectionTitles = ["全部记录","收入记录","支出记录"]
        sv.indexChangeBlock = { [weak self] index in
            guard let strongSelf = self else {
                return
            }
            strongSelf.recordScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
            if index < strongSelf.childVCsArray.count {
                let vc: DelayRebateDetailController = strongSelf.childVCsArray[index] as! DelayRebateDetailController
                vc.updateContentOffY()
                vc.shouldFirstLoadData()
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
        sv.contentSize = CGSize(width: SCREEN_WIDTH * 3, height:0)
        return sv
    }()
    
    deinit {
        print("RebateInfoController deinit~!@")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupChildVCs()
        setupData()
        self.requestRebateDetailList()
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
        self.fky_setupRightImage("") {
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                let controller = vc as! FKY_Web
                controller.urlPath = "https://m.yaoex.com/web/h5/maps/index.html?pageId=100921&type=release"
            })
        }
        fky_setupTitleLabel("我的余额")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        self.NavigationBarRightImage!.setTitle("使用帮助", for: UIControl.State())
        self.NavigationBarRightImage!.isHidden = false
        self.NavigationBarRightImage!.fontTuple = t36
        
        view.addSubview(bgScrollView)
        bgScrollView.snp.makeConstraints { (make) in
            make.right.bottom.left.equalTo(view)
            make.top.equalTo(navBar!.snp.bottom)
        }
        bgScrollView.addSubview(myRebateView)
        bgScrollView.addSubview(yflView)
        bgScrollView.addSubview(segmentedControl)
        bgScrollView.addSubview(recordScrollView)
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        bgScrollView.addSubview(line)
        myRebateView.snp.makeConstraints { (make) in
            make.left.equalTo(bgScrollView)
            make.height.equalTo(WH(210))
            make.top.equalTo(bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
        }
        yflView.snp.makeConstraints { (make) in
            make.left.equalTo(bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(0)
            make.top.equalTo(myRebateView.snp.bottom)
        }
        
        segmentedControl.snp.makeConstraints ({ (make) in
            make.left.equalTo(WH(15))
            make.right.equalTo(yflView.snp.right).offset(-WH(15))
            make.height.equalTo(WH(44))
            make.top.equalTo(yflView.snp.bottom)
        })
        
        line.snp.makeConstraints ({ (make) in
            make.left.equalTo(bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(segmentedControl.snp.bottom);
            make.height.equalTo(1)
        })
        
        recordScrollView.snp.makeConstraints ({ (make) in
            make.left.equalTo(bgScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(line.snp.bottom)
            make.height.equalTo(SCREEN_HEIGHT - WH(45) - naviBarHeight())
        })
        
        view.layoutIfNeeded()
    }
    fileprivate func updateYflViewLayout(_ model:FKYMyRebateModel?){
        if let desModel = model,desModel.drugWelfareFlag == 1 {
            //显示
            yflView.isHidden = false
            self.headHeight = WH(210) + YFL_TIP_H
            yflView.snp.updateConstraints { (make) in
                make.height.equalTo(YFL_TIP_H)
            }
            bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight() + self.headHeight)
        }else {
            //隐藏
            yflView.isHidden = true
            self.headHeight = WH(210)
            yflView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight() + self.headHeight)
        }
    }
}


extension RebateInfoController: UIScrollViewDelegate {
    func setupChildVCs() -> Void {
        let allVC = DelayRebateDetailController()
        allVC.scrollBlock = { [weak self] (scrollV) in
            if let strongSelf = self {
                strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
            }
        }
        allVC.rebateRecordType = .FKYRebateRecordTypeAll
        allVC.view.frame = recordScrollView.bounds
        
        let inVC = DelayRebateDetailController()
        inVC.scrollBlock = { [weak self] (scrollV) in
            if let strongSelf = self {
                strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
            }
        }
        inVC.rebateRecordType = .FKYRebateRecordTypeIn
        
        var inframe = recordScrollView.bounds
        inframe.origin.x += SCREEN_WIDTH
        inVC.view.frame = inframe
        
        let outVC = DelayRebateDetailController()
        outVC.scrollBlock = { [weak self] (scrollV) in
            if let strongSelf = self {
                strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
            }
        }
        outVC.rebateRecordType = .FKYRebateRecordTypeOut
        
        var outframe = recordScrollView.bounds
        outframe.origin.x += SCREEN_WIDTH * 2
        outVC.view.frame = outframe
        
        addChild(allVC)
        addChild(inVC)
        addChild(outVC)
        recordScrollView.addSubview(allVC.view)
        recordScrollView.addSubview(inVC.view)
        recordScrollView.addSubview(outVC.view)
        
        childVCsArray.append(allVC)
        childVCsArray.append(inVC)
        childVCsArray.append(outVC)
    }
    
    fileprivate func setupData() {
        showLoading()
        viewModel.requestMyRebate { [weak self](success, msg, model) in
            self?.dismissLoading()
            guard success else {
                self?.toast(msg)
                return
            }
            self?.myRebateView.configData(model)
            self?.updateYflViewLayout(model)
        }
        viewModel.getRabteDetailInfo{_,_ in
        }
        let vc: DelayRebateDetailController = childVCsArray[0] as! DelayRebateDetailController
        vc.shouldFirstLoadData()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        //处理scrolview 的滑动
        if scrollView == recordScrollView {
            let index = scrollView.contentOffset.x / SCREEN_WIDTH
            if Int(index) >= 0 && Int(index) <= 2 {
                segmentedControl.setSelectedSegmentIndex(UInt(index), animated: true)
                recordScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
                if Int(index) < childVCsArray.count {
                    let vc: DelayRebateDetailController = childVCsArray[Int(index)] as! DelayRebateDetailController
                    vc.shouldFirstLoadData()
                }
            }
        }
    }
}
//MARK: - 网络请求
extension RebateInfoController{
    func requestRebateDetailList(){
        self.rebateDetailListModel.requestRebateInfo {[weak self,weak rebateDetailListModel] (isSuccess, msg) in
            if let strongSelf = self {
                guard isSuccess else{
                    strongSelf.toast(msg)
                    return
                }
                guard let strongRebateDetailListModel = rebateDetailListModel else {
                    return
                }
                strongSelf.myRebateView.balanceView.showTopTipWithType(type: strongRebateDetailListModel.isShareRebate)
            }
        }
    }
}

extension RebateInfoController {
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
            bgScrollView.contentOffset.y = 0
        }
        if Int(y) >= Int(self.headHeight) {
            bgScrollView.contentOffset.y = self.headHeight
        }else {
            //
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
}
