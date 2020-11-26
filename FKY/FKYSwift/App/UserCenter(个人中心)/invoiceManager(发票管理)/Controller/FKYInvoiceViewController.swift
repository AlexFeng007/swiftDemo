//
//  FKYInvoiceViewController.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

enum InvoiceType {
    case normal//普票
    case special//专票
}

class FKYInvoiceViewController: UIViewController {

    ///
    var testModel = FKYInvoiceViewModel()
    
    ///普通发票vc
    lazy var nromalInvoiceVC = FKYNormalInvoiceVC()
    ///专票VC
    lazy var specialInvoiceVC = FKYSpecialInvoiceVC()
    
    /// 导航栏
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = .white
        return self.NavigationBar
    }()
    
    ///切换视图按钮
    var switchViewTypeView:FKYSwitchInvoiceTypeView = {
        let view = FKYSwitchInvoiceTypeView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

//MARK: - view事件回调
extension FKYInvoiceViewController{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_switchInvoiceTypeView{//切换到
            let type = userInfo[FKYUserParameterKey] as! InvoiceType
            if type == .normal{//跳转到普票VC
                switchToNormalVC()
            }else if type == .special{//跳转到专票VC
                switchTospecialVC()
            }
        }
    }
}

//MARK: - UI
extension FKYInvoiceViewController{
    func setupView(){
        
        self.addChild(self.nromalInvoiceVC)
        self.addChild(self.specialInvoiceVC)
        
        setupNavBar()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(switchViewTypeView)
        
        switchViewTypeView.snp_makeConstraints { (make) in
            make.top.equalTo(navBar!.snp_bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(WH(44.0))
        }
        switchToNormalVC()
    }
    
    fileprivate func setupNavBar() {
        self.fky_setupTitleLabel("发票管理")
        self.fky_hiddedBottomLine(true)
        self.NavigationTitleLabel!.fontTuple = (color:RGBColor(0x000000),font:UIFont.boldSystemFont(ofSize: WH(18)))
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        // 导航栏分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        self.navBar!.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self.navBar!)
            make.height.equalTo(0.5)
        })
    }
    
    func switchToNormalVC() {
        self.specialInvoiceVC.view.removeFromSuperview()
        self.view.addSubview(self.nromalInvoiceVC.view)
        self.nromalInvoiceVC.view.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(switchViewTypeView.snp_bottom)
        }
    }
    
    func switchTospecialVC(){
        self.nromalInvoiceVC.view.removeFromSuperview()
        self.view.addSubview(self.specialInvoiceVC.view)
        self.specialInvoiceVC.view.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(switchViewTypeView.snp_bottom)
        }
    }
}
