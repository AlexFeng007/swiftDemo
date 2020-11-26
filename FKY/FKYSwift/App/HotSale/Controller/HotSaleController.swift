//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

class HotSaleController: SegmentController, FKY_HotSale {
    // MARK: - properties
    var isWeekRankMode: Bool = true
    fileprivate var curType: HotSaleType = .week {
        didSet {
            self.updateNavigationTitle(withType: curType)
            self.fetchData()
        }
    }
    fileprivate var headerModels: [HotSaleHeaderModel]?
    fileprivate var bottomHeight: CGFloat {
        get {
            var h = CGFloat(54)
            if #available(iOS 11, *) {
                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                if (insets?.bottom)! > CGFloat.init(0) {
                    h += (insets?.bottom)!
                }
            }
            return h
        }
    }
    fileprivate lazy var bottomView: HotSaleBottomView! = {
        let view = HotSaleBottomView.init(withSelectType: self.isWeekRankMode ? .week : .local)
        view.operation = self
        return view
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(bottomView)

        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(bottomHeight)
        }
        
        curType = isWeekRankMode ? .week : .local
    }

    
    // MARK: - override
    
    /// 子类重写该方法定制 segment bar 高度
    override func segmentHeight() -> CGFloat {
        return WH(38)
    }
    
    /// 子类重写该方法定制 scrollView 距离底部偏移高度
    override func scrollViewBottomOffset() -> CGFloat {
        return bottomHeight
    }
    
    /// 子类重写该方法提供 segment content 内容视图控制器
    override func segmentChildViewControllers() -> [UIViewController] {
        var controllers = [UIViewController]()
        if headerModels != nil {
            for (index, _) in (self.headerModels?.enumerated())! {
                let vc = HotSaleItemController()
                vc.type = curType
                vc.headerModel = headerModels![index]
                controllers.append(vc)
            }
        }
        return controllers
    }
    
    override func segmentControlInit() -> HMSegmentedControl {
        let sv: HMSegmentedControl = HMSegmentedControl()
        sv.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor : RGBColor(0x333333),
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))]
        sv.selectedTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor : RGBColor(0xff2d5c),
             NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(15))]
        sv.selectionIndicatorColor = RGBColor(0xff2d5c)
        sv.selectionIndicatorHeight = 3
        sv.selectionStyle = .textWidthStripe
        sv.selectionIndicatorLocation = .down
        sv.segmentEdgeInset = UIEdgeInsets(top: 0, left: WH(13), bottom: 0, right: WH(35))
        return sv
    }
    
    /// 子类重写该方法定制 导航栏title
    override func navigationBarTitle() -> String {
        return curType == .week ? "本周热销榜" : "区域热销榜"
    }
    
    // MARK: - ui
    
}

// MARK: - delegates
extension HotSaleController: HotSaleBottomViewOperation {
    func bottomView(_ view: HotSaleBottomView, didTapButtonWith type: HotSaleType) {
        // 每次切换大tab时，均需要把小tab索引重置为0，否则会导致数组越界crash
        selectedIndex = 0;
        // 切换大tab
        curType = type
    }
}

// MARK: - action
extension HotSaleController {
    
}

// MARK: - data
extension HotSaleController {
    func fetchData() {
        showLoading()
        HotSaleProvider().fetchHotSaleHeaderData(withType: curType) { [weak self] (items, message) in
            self?.dismissLoading()
            guard items != nil else {
                self?.toast(message ?? "服务器异常")
                return
            }
            var titles = Array<String>.init()
            for (_, value) in (items?.enumerated())! {
                let hm = value as! HotSaleHeaderModel
                titles.append(hm.catgoryName ?? "")
            }
            self?.headerModels = (items as! [HotSaleHeaderModel])
            self?.segmentView.sectionTitles = titles
            self?.segmentView.selectedSegmentIndex = 0
            self?.updateControllersInScrollView()
        }
    }
}

// MARK: - private methods
extension HotSaleController {
    fileprivate func updateNavigationTitle(withType type: HotSaleType) {
        let title = type == .week ? "本周热销榜" : "区域热销榜"
        updateNavigationBarTitle(withTitle: title)
    }
}
