//
//  TodayViewController.swift
//  FKYWidget
//
//  Created by 夏志勇 on 2019/7/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import NotificationCenter

//
let keyForWidget = "mall"

//
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

/*
 注意:
 折叠状态下: 高度固定为110, 即使设置折叠状态的高度, 也不会起作用
 展开状态下: 如果设置高度小于110，那么default = 110
 展开状态下: 如果设置高度大于最大的616，那么default = 616
 (5s,6s是110~528, plus是110~616)
 */


class TodayViewController: UIViewController, NCWidgetProviding {
    // MARK: - Property
    
//    fileprivate lazy var imgviewIcon: UIImageView = {
//        let view = UIImageView.init()
//        view.image = UIImage.init(named: "icon")
//        return view
//    }()
    
    fileprivate lazy var btnHome: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 0
        btn.backgroundColor = .lightGray
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("首页", for: .normal)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var btnShop: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 1
        btn.backgroundColor = .lightGray
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("店铺", for: .normal)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var btnCart: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 2
        btn.backgroundColor = .lightGray
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("进货单", for: .normal)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var btnOrder: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 3
        btn.backgroundColor = .lightGray
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("订单", for: .normal)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var btnSearch: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.tag = 4
        btn.backgroundColor = .lightGray
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("搜索", for: .normal)
        btn.addTarget(self, action: #selector(openContainingApp(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel.init()
        lbl.backgroundColor = .clear
        lbl.text = "1药城：海量品种，厂家直供"
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize:15)
        return lbl
    }()
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        // 设置可折叠...<iOS10>
        if #available(iOS 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
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
        let userDef = UserDefaults.init(suiteName: "group.yaocheng.com")
        let title: String? = userDef?.object(forKey: "widget_title") as? String
        lblTitle.text = title ?? "1药城：海量品种，厂家直供"
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
        //view.addSubview(imgviewIcon)
        view.addSubview(btnHome)
        view.addSubview(btnShop)
        view.addSubview(btnCart)
        view.addSubview(btnOrder)
        view.addSubview(btnSearch)
        view.addSubview(lblTitle)
        
        let itemWidth = (screenWidth - 8 * 2 - 20 * 6) / 5
        //imgviewIcon.frame = CGRect.init(x: 20, y: 20, width: itemWidth, height: itemWidth);
        btnHome.frame = CGRect.init(x: 20, y: 30, width: itemWidth, height: itemWidth)
        btnShop.frame = CGRect.init(x: btnHome.frame.origin.x + btnHome.frame.size.width + 20, y: 30, width: itemWidth, height: itemWidth)
        btnCart.frame = CGRect.init(x: btnShop.frame.origin.x + btnShop.frame.size.width + 20, y: 30, width: itemWidth, height: itemWidth)
        btnOrder.frame = CGRect.init(x: btnCart.frame.origin.x + btnCart.frame.size.width + 20, y: 30, width: itemWidth, height: itemWidth)
        btnSearch.frame = CGRect.init(x: btnOrder.frame.origin.x + btnOrder.frame.size.width + 20, y: 30, width: itemWidth, height: itemWidth)
        
        lblTitle.frame = CGRect.init(x: 0, y: btnSearch.frame.origin.y + itemWidth + 40, width: screenWidth - 8 * 2 , height: 20)
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


