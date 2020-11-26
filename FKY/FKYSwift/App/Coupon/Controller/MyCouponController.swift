//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

class MyCouponController: SegmentController {
    // MARK: - properties

    // MARK: - life cycle
    
    // MARK: - override
    /// 子类重写该方法定制 segment title 数组
    override func segmentTitles() -> [String] {
        return ["可用", "已用", "过期"]
    }
    
    /// 子类重写该方法定制 segment bar 高度
    override func segmentHeight() -> CGFloat {
        return WH(33)
    }
    
    /// 子类重写该方法提供 segment content 内容视图控制器
    override func segmentChildViewControllers() -> [UIViewController] {
        var controllers = [UIViewController]()
        for (index, _) in self.segmentTitles().enumerated() {
            let vc = MyCouponItemController()
            vc.type = CouponItemUsageType.couponListType(withIndex: index)
            controllers.append(vc)
        }
        return controllers
    }
    
    override func segmentControlInit() -> HMSegmentedControl {
        let sv: HMSegmentedControl = HMSegmentedControl()
        sv.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor : RGBColor(0x979797),
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(13))]
        sv.selectedTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor : RGBColor(0xf75f5d),
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(13))]
        sv.selectionIndicatorColor = RGBColor(0xf75f5d)
        sv.selectionIndicatorHeight = 3
        sv.selectionStyle = .textWidthStripe
        sv.selectionIndicatorLocation = .down
        sv.isVerticalDividerEnabled = true
        sv.verticalDividerColor = RGBColor(0xc8c8c8)
        sv.verticalDividerWidth = 0.5
        sv.borderType = .bottom
        sv.borderColor = RGBColor(0xe8e8e8)
        sv.borderWidth = 0.5
        return sv
    }
    
    /// 子类重写该方法定制 导航栏title
    override func navigationBarTitle() -> String {
        return "我的优惠券"
    }
    
    /// 子类重写该方法定制 导航栏底部细线显示与否
    override func navigationBarBottomLineHidden() -> Bool {
        return true
    }

    
    // MARK: - ui
    
}

// MARK: - delegates
extension MyCouponController {
    
}

// MARK: - action
extension MyCouponController {
    
}

// MARK: - data
extension MyCouponController {
    
}

// MARK: - private methods
extension MyCouponController {

}
