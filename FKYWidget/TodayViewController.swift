//
//  TodayViewController.swift
//  FKYWidget
//
//  Created by 夏志勇 on 2019/7/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import NotificationCenter

// key
let keyForWidget = "mall"

//
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let SCREEN_SIZE = UIScreen.main.bounds.size
let IS_IPHONEXS_MAX = SCREEN_SIZE.equalTo(CGSize(width: 414, height: 896))
let IS_IPHONEXR = SCREEN_SIZE.equalTo(CGSize(width: 414, height: 896))
let IS_IPHONEX = SCREEN_SIZE.equalTo(CGSize(width: 375, height: 812))
let IS_IPHONE6 = SCREEN_SIZE.equalTo(CGSize(width: 375, height: 667))
let IS_IPHONE6PLUS = SCREEN_SIZE.equalTo(CGSize(width: 414, height: 736))
let IS_IPHONE5 = SCREEN_SIZE.equalTo(CGSize(width: 320, height: 568))
let IS_IPHONE4 = SCREEN_SIZE.equalTo(CGSize(width: 320, height: 480))
let IS_IPAD = UI_USER_INTERFACE_IDIOM() == .pad
let IS_RETINA = UIScreen.main.scale >= 2.0

//
func RGBColor(_ rgbValue: UInt) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0, blue: CGFloat(rgbValue & 0x0000FF)/255.0, alpha: 1.0)
}

//
func WH(_ length: CGFloat) -> CGFloat {
    if IS_IPHONE6 || IS_IPHONEX {
        return length
    }
    else if (IS_IPHONE5 || IS_IPHONE4) {
        return length * (320.0 / 375.0)
    }
    else if (IS_IPHONE6PLUS || IS_IPHONEXR || IS_IPHONEXS_MAX) {
        return length * (414.0 / 375.0)
    }
    else if (IS_IPAD) {
        if IS_RETINA {
            return length * (768.0 / 375.0)
        }
        else {
            return length * (384.0 / 375.0)
        }
    }
    return length
}


/*
 注意:
 折叠状态下: 高度固定为110, 即使设置折叠状态的高度, 也不会起作用
 展开状态下: 如果设置高度小于110，那么default = 110
 展开状态下: 如果设置高度大于最大的616，那么default = 616
 (5s,6s是110~528, plus是110~616)
 */


class TodayViewController: UIViewController, NCWidgetProviding {
    // MARK: - Property
    
    fileprivate lazy var btnHome: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 0
        btn.backgroundColor = .clear
//        btn.setTitleColor(RGBColor(0x666666), for: .normal)
//        btn.setTitleColor(UIColor.gray, for: .highlighted)
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//        btn.titleLabel?.textAlignment = .center
//        btn.setTitle("首页", for: .normal)
        btn.setImage(UIImage(named: "image_widget_home"), for: .normal)
//        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 15, right: 0)
//        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: -35, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: -WH(20), left: 0, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var lblHome: UILabel = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .center
        lbl.text = "首页"
        return lbl
    }()
    
    fileprivate lazy var btnSearch: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 1
        btn.backgroundColor = .clear
//        btn.setTitleColor(RGBColor(0x666666), for: .normal)
//        btn.setTitleColor(UIColor.gray, for: .highlighted)
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//        btn.titleLabel?.textAlignment = .center
//        btn.setTitle("搜索", for: .normal)
        btn.setImage(UIImage(named: "image_widget_search"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: -WH(20), left: 0, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var lblSearch: UILabel = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .center
        lbl.text = "搜索"
        return lbl
    }()
    
    fileprivate lazy var btnCart: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 2
        btn.backgroundColor = .clear
//        btn.setTitleColor(RGBColor(0x666666), for: .normal)
//        btn.setTitleColor(UIColor.gray, for: .highlighted)
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//        btn.titleLabel?.textAlignment = .center
//        btn.setTitle("购物车", for: .normal)
        btn.setImage(UIImage(named: "image_widget_cart"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: -WH(20), left: 0, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var lblCart: UILabel = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .center
        lbl.text = "购物车"
        return lbl
    }()
    
    fileprivate lazy var btnOrder: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 3
        btn.backgroundColor = .clear
//        btn.setTitleColor(RGBColor(0x666666), for: .normal)
//        btn.setTitleColor(UIColor.gray, for: .highlighted)
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//        btn.titleLabel?.textAlignment = .center
//        btn.setTitle("我的订单", for: .normal)
        btn.setImage(UIImage(named: "image_widget_order"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: -WH(20), left: 0, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var lblOrder: UILabel = {
        let lbl = UILabel.init(frame: CGRect.zero)
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .center
        lbl.text = "我的订单"
        return lbl
    }()
    
    fileprivate lazy var btnShop: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 4
        btn.backgroundColor = .clear
//        btn.setTitleColor(RGBColor(0x666666), for: .normal)
//        btn.setTitleColor(UIColor.gray, for: .highlighted)
//        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//        btn.titleLabel?.textAlignment = .center
//        btn.setTitle("店铺", for: .normal)
        btn.setImage(UIImage(named: "image_widget_shop"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: -WH(20), left: 0, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var lblShop: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .center
        lbl.text = "店铺"
        return lbl
    }()
    
//    fileprivate lazy var lblTitle: UILabel = {
//        let lbl = UILabel.init()
//        lbl.backgroundColor = .clear
//        lbl.text = "1药城：海量品种，厂家直供"
//        lbl.textColor = .darkGray
//        lbl.textAlignment = .center
//        lbl.font = UIFont.boldSystemFont(ofSize:15)
//        return lbl
//    }()
    
    
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        // 设置不可折叠...<iOS10>
        if #available(iOS 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
        }
        else {
            // Fallback on earlier versions
        }
        
        // 设置widget隐藏or显示
        //NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.111.fangkuaiyi.widget")
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // test
//        let userDef = UserDefaults.init(suiteName: "group.yaocheng.com")
//        let title: String? = userDef?.object(forKey: "widget_title") as? String
//        lblTitle.text = title ?? "1药城：海量品种，厂家直供"
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // 展开/折叠
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if #available(iOS 10.0, *) {
            if activeDisplayMode == .compact {
                self.preferredContentSize = CGSize.init(width: screenWidth, height: 110)
            }
            else {
                self.preferredContentSize = CGSize.init(width: screenWidth, height: 160)
            }
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    // 取消缩进
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}


// MARK: - UI
extension TodayViewController {
    //
    fileprivate func setupView() {
        view.addSubview(btnHome)
        view.addSubview(btnSearch)
        view.addSubview(btnCart)
        view.addSubview(btnOrder)
        //view.addSubview(btnShop)
        
        view.addSubview(lblHome)
        view.addSubview(lblSearch)
        view.addSubview(lblCart)
        view.addSubview(lblOrder)
        //view.addSubview(lblShop)
        
//        view.addSubview(lblTitle)
        
        let marginY: CGFloat = 20
        let itemWidth = (screenWidth - 8 * 2 - 20 * 5) / 4
        
        btnHome.frame = CGRect.init(x: 20, y: marginY, width: itemWidth, height: itemWidth)
        btnSearch.frame = CGRect.init(x: btnHome.frame.origin.x + btnHome.frame.size.width + 20, y: marginY, width: itemWidth, height: itemWidth)
        btnCart.frame = CGRect.init(x: btnSearch.frame.origin.x + btnSearch.frame.size.width + 20, y: marginY, width: itemWidth, height: itemWidth)
        btnOrder.frame = CGRect.init(x: btnCart.frame.origin.x + btnCart.frame.size.width + 20, y: marginY, width: itemWidth, height: itemWidth)
        //btnShop.frame = CGRect.init(x: btnOrder.frame.origin.x + btnOrder.frame.size.width + 20, y: marginY, width: itemWidth, height: itemWidth)
        
        lblHome.frame = CGRect.init(x: btnHome.frame.origin.x, y: marginY + itemWidth - WH(20), width: itemWidth, height: WH(20))
        lblSearch.frame = CGRect.init(x: btnSearch.frame.origin.x, y: marginY + itemWidth - WH(20), width: itemWidth, height: WH(20))
        lblCart.frame = CGRect.init(x: btnCart.frame.origin.x, y: marginY + itemWidth - WH(20), width: itemWidth, height: WH(20))
        lblOrder.frame = CGRect.init(x: btnOrder.frame.origin.x, y: marginY + itemWidth - WH(20), width: itemWidth, height: WH(20))
        //lblShop.frame = CGRect.init(x: btnShop.frame.origin.x, y: marginY + itemWidth - WH(20), width: itemWidth, height: WH(20))
        
//        lblTitle.frame = CGRect.init(x: 0, y: btnSearch.frame.origin.y + itemWidth + 40, width: screenWidth - 8 * 2 , height: 20)
    }
}


// MARK: - Action
extension TodayViewController {
    // 打开app，跳转指定界面
    @objc func openContainingApp(_ sender : UIButton) {
        let tag = sender.tag
        let url = URL.init(string: String.init(format: "fkywidget://%@?tag=%ld", keyForWidget, tag))
        guard let urlFinal = url else {
            print("url error")
            return
        }
        // fkywidget://mall?tag=0
        // fkywidget://mall?tag=0&key=1
        self.extensionContext?.open(urlFinal, completionHandler: { (success) in
            if success {
                print("open url success")
            }
            else {
                print("open url fail")
            }
        })
    }
}


