//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

class SegmentController: ViewController {
    // MARK: - properties
    var value: Int = 0
    var selectedIndex: Int {
        get {
            return value
        }
        set {
            value = newValue
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                if let strongSelf = self {
                     strongSelf.scrollView.contentOffset = CGPoint(x: SCREEN_WIDTH.multiple(strongSelf.value), y: 0)
                }
            }) { [weak self] (ret) in
                if let strongSelf = self {
                    strongSelf.addChildControllersWhenSliderStoped()
                    strongSelf.segmentValueChangedActionsWhenAnimationFinished()
                }
            }
        }
    }
    
    public lazy var segmentView: HMSegmentedControl! = {
        let sv: HMSegmentedControl = self.segmentControlInit()
        sv.frame = CGRect(x: 0, y: self.navBarHeight, width: self.view.bounds.size.width, height: self.segmentHeight())
        sv.sectionTitles = self.segmentTitles()
        sv.indexChangeBlock = { [weak self] (index) in
            if let strongSelf = self {
                strongSelf.segmentValueChanged(withIndex: index)
            }
        }
        return sv
    }()
    
    public lazy var scrollView: UIScrollView! = {
        let sv = UIScrollView(frame: .zero)
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = .white
        let titles: [String] = self.segmentTitles()
        sv.contentSize = CGSize(width: SCREEN_WIDTH.multiple(titles.count), height: SCREEN_HEIGHT - self.segmentHeight() - self.navBarHeight - self.scrollViewBottomOffset())
        return sv
    }()
    
    // MARK: - life cycle
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ___setupView()
        
        updateControllersInScrollView()
    }
    
    // MARK: - provide override method
    /// 子类重写该方法定制 segment title 数组
    public func segmentTitles() -> [String] {
        return [""]
    }
    
    /// 子类重写该方法定制 segment bar 高度
    public func segmentHeight() -> CGFloat {
        return WH(33)
    }
    
    /// 子类重写该方法定制 scrollView 距离底部偏移高度
    public func scrollViewBottomOffset() -> CGFloat {
        return 0
    }
    
    /// 子类重写该方法提供 segment content 内容视图控制器
    public func segmentChildViewControllers() -> [UIViewController]? {
        return nil
    }
    
    /// 子类重写该方法提供 segment 变化时自定义操作
    public func segmentValueChanged(withIndex index: Int) {
        selectedIndex = index;
    }
    
    /// 子类重写该方法提供 segment 变化时移动vc动画结束后操作
    public func segmentValueChangedActionsWhenAnimationFinished() {
        
    }
    
    public func segmentControlInit() -> HMSegmentedControl {
        let sv: HMSegmentedControl = HMSegmentedControl()
        return sv
    }
    
    // MARK: - ui

    func ___setupView() {
        view.addSubview(segmentView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-self.scrollViewBottomOffset())
        }
    }
    
    func updateControllersInScrollView() {
        if children.count > 0 {
            for (_, value) in scrollView.subviews.enumerated() {
                let subview = value as UIView
                subview.removeFromSuperview()
            }
            for (_, value) in children.enumerated() {
                let vc = value as UIViewController
                vc.removeFromParent()
            }
        }
        
        if let controllers = self.segmentChildViewControllers(), controllers.count > 0 {
            for (index, value) in controllers.enumerated() {
                if let vc = value as? HotSaleItemController{
                    vc.index = index
                    addChild(vc)
                }else if let vv = value as? UseCouponItemController{
                    addChild(vv)
                }else if let vvc = value as? MyCouponItemController{
                    addChild(vvc)  
                }
            }
            
            scrollView.contentSize = CGSize(width: SCREEN_WIDTH.multiple(controllers.count), height: SCREEN_HEIGHT - self.segmentHeight() - self.navBarHeight - self.scrollViewBottomOffset())
            
            guard children.count > selectedIndex else {
                return
            }
            let vc = children[selectedIndex]
            vc.view.frame = CGRect(x: SCREEN_WIDTH.multiple(selectedIndex), y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            scrollView.addSubview(vc.view)
        }
    }
}

// MARK: - delegates
extension SegmentController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / self.view.bounds.size.width
        segmentView.setSelectedSegmentIndex(UInt(index), animated: true)
        selectedIndex = Int(index)
        addChildControllersWhenSliderStoped()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}

// MARK: - action
extension SegmentController {
    
}

// MARK: - data
extension SegmentController {
    
}

// MARK: - private methods
extension SegmentController {
    fileprivate func addChildControllersWhenSliderStoped() {
        guard children.count > selectedIndex else {
            return
        }
        let vc = children[selectedIndex]
        guard vc.view.superview == nil else {
            return
        }
        vc.view.frame = CGRect(x: SCREEN_WIDTH.multiple(selectedIndex), y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
        scrollView.addSubview(vc.view)
    }
}

