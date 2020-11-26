//
//  LiveContentListViewController.swift
//  FKY
//
//  Created by 寒山 on 2020/8/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveContentListViewController: UIViewController {
    
    fileprivate var navBar: UIView?
    
    var childVCsArray = [UIViewController]()
    
    
    var headHeight = WH(0) //记录头部的高度
    fileprivate lazy var viewModel: LiveViewModel = {
        let viewModel = LiveViewModel()
        return viewModel
    }()
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
        sv.sectionTitles = ["直播列表","直播预告"]
        sv.indexChangeBlock = { [weak self] index in
            guard let strongSelf = self else {
                return
            }
            strongSelf.recordScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
            if Int(index) < strongSelf.childVCsArray.count {
                if let vc = strongSelf.childVCsArray[Int(index)] as? LivingListViewController {
                    vc.updateContentOffY()
                    vc.shouldFirstLoadData()
                }else if let vc = strongSelf.childVCsArray[Int(index)] as? LiveNoticeViewController  {
                    vc.updateContentOffY()
                    vc.shouldFirstLoadData()
                }else if let vc = strongSelf.childVCsArray[Int(index)] as? ShortVideoViewController  {
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
        print("LiveContentListViewController deinit~!@")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupChildVCs()
        setupData()
        getLiveTypeInfo()
    }
    fileprivate func setupView() {
        view.backgroundColor = RGBColor(0xF4F4F4)
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = bg1
        
        fky_setupTitleLabel("直播")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        
        view.addSubview(bgScrollView)
        bgScrollView.snp.makeConstraints { (make) in
            make.right.bottom.left.equalTo(view)
            make.top.equalTo(navBar!.snp.bottom)
        }
        //bgScrollView.addSubview(headView)
        bgScrollView.addSubview(segmentedControl)
        bgScrollView.addSubview(recordScrollView)
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        bgScrollView.addSubview(line)
//        headView.snp.makeConstraints { (make) in
//            make.left.top.equalTo(bgScrollView)
//            make.height.equalTo(WH(120))
//            make.width.equalTo(SCREEN_WIDTH)
//        }
        
        
        segmentedControl.snp.makeConstraints ({ (make) in
            make.left.equalTo(bgScrollView.snp.left).offset(WH(60))
           // make.right.equalTo(bgScrollView.snp.right).offset(-WH(15))
            make.top.equalTo(bgScrollView)
            make.height.equalTo(WH(47))
            make.width.equalTo(SCREEN_WIDTH - WH(120))
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
            make.height.equalTo(SCREEN_HEIGHT - WH(48) - naviBarHeight())
        })
        
        view.layoutIfNeeded()
    }
}


extension LiveContentListViewController: UIScrollViewDelegate {
    func setupChildVCs() -> Void {
        let liveVC = LivingListViewController()
        
        liveVC.view.frame = recordScrollView.bounds
        liveVC.scrollBlock = { [weak self] (scrollV) in
            if let strongSelf = self {
                strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
            }
        }
        let noticeVC = LiveNoticeViewController()
        
        var inframe = recordScrollView.bounds
        inframe.origin.x += SCREEN_WIDTH
        noticeVC .view.frame = inframe
        noticeVC .scrollBlock = { [weak self] (scrollV) in
            if let strongSelf = self {
                strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
            }
        }
        
//       let shortVideoVC = ShortVideoViewController()
//
//        inframe = recordScrollView.bounds
//        inframe.origin.x += 2*SCREEN_WIDTH
//        shortVideoVC.view.frame = inframe
//        shortVideoVC.scrollBlock = { [weak self] (scrollV) in
//            if let strongSelf = self {
//                strongSelf.updateScrollViewContentOffset(scrollV: scrollV)
//            }
//        }
        addChild(liveVC)
        addChild(noticeVC)
        //addChild(shortVideoVC)
        
        recordScrollView.addSubview(liveVC.view)
        recordScrollView.addSubview(noticeVC.view)
        //recordScrollView.addSubview(shortVideoVC.view)
        
        
        childVCsArray.append(liveVC)
        childVCsArray.append(noticeVC)
        //childVCsArray.append(shortVideoVC)
        
    }
    
    fileprivate func setupData() {
        // showLoading()
        bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - naviBarHeight() + self.headHeight)
        if let vc = self.childVCsArray[0] as? LivingListViewController {
            vc.shouldFirstLoadData()
        }else if let vc = self.childVCsArray[1] as? LiveNoticeViewController {
            vc.shouldFirstLoadData()
        }else if let vc = self.childVCsArray[2] as? ShortVideoViewController {
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
                    if let vc = childVCsArray[Int(index)] as? LivingListViewController {
                        // vc.updateContentOffY()
                        vc.shouldFirstLoadData()
                    }else if let vc = childVCsArray[Int(index)] as? LiveNoticeViewController {
                        //vc.updateContentOffY()
                        vc.shouldFirstLoadData()
                    }else if let vc = childVCsArray[Int(index)] as? ShortVideoViewController {
                        //vc.updateContentOffY()
                        vc.shouldFirstLoadData()
                    }
                }
            }
        }
    }
}
//MARK: - 网络请求
extension LiveContentListViewController{
    //获取直播信息
    func getLiveTypeInfo(){
        viewModel.setLiveType{ [weak self] (success,msg, index) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            
            if success{
                if index == 0 || index == 1{
                    strongSelf.setSwitchSegentIndex(index)
                }
            } else {
                // 失败
               // strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
}

extension LiveContentListViewController{
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
    //设置直播列表选择
    func setSwitchSegentIndex(_ liveListType:Int){
        //0 显示在直播tab  1 显示在预告tab
        segmentedControl.setSelectedSegmentIndex(UInt(liveListType), animated: true)
        self.recordScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(liveListType), y: 0), animated: true)
        if liveListType < self.childVCsArray.count {
            if let vc = self.childVCsArray[liveListType] as? LivingListViewController {
                vc.updateContentOffY()
                vc.shouldFirstLoadData()
            }else if let vc = self.childVCsArray[liveListType] as? LiveNoticeViewController  {
                vc.updateContentOffY()
                vc.shouldFirstLoadData()
            }else if let vc = self.childVCsArray[liveListType] as? ShortVideoViewController  {
                vc.updateContentOffY()
                vc.shouldFirstLoadData()
            }
        }
    }
}

