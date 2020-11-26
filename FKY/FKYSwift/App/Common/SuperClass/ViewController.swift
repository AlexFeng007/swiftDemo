//
//  ViewController.swift
//  FKY
//
//  Created by Rabe on 13/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  swift基类

import UIKit

class ViewController: UIViewController {
    // MARK: - properties
    var navBar : UIView?
    var navBarHeight: CGFloat = 0
    
    // MARK: - life cycle
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationBarVisible() {
            self.navBar = {
                if let _ = self.NavigationBar {
                } else {
                    self.fky_setupNavBar()
                }
                return self.NavigationBar!
            }()
            
            navBarHeight = naviBarHeight()
            
            fky_setupLeftImage(navigationBarBackImage()) {
                FKYNavigator.shared().pop()
            }
            
            navBar!.backgroundColor = navigationBarColor()
            fky_setupTitleLabel(navigationBarTitle())
            NavigationTitleLabel!.fontTuple = navigationBarTitleFontTuple()
            fky_hiddedBottomLine(navigationBarBottomLineHidden())
            
            if navigationBarRightTitle().count > 0 {
                fky_setupRightTitle(navigationBarRightTitle(), callback: {
                    self.navigationBarRightAction()
                })
                NavigationBarRightImage?.setTitleColor(navigationBarRightTitleColor(), for: UIControl.State())
                NavigationBarRightImage?.titleLabel?.font = navigationBarRightTitleFont()
            } else if navigationBarRightImage().count > 0 {
                fky_setupRightImage(navigationBarRightImage(), callback: {
                    self.navigationBarRightAction()
                })
            }
        }
        
        self.view.backgroundColor = viewBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CurrentViewController.shared.item = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CurrentViewController.shared.item = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - ui
    
    /// 子类重写该方法定制 导航栏title
    public func navigationBarVisible() -> Bool {
        return true
    }
    
    /// 子类重写该方法定制 导航栏title
    public func navigationBarTitle() -> String {
        return ""
    }
    
    /// 子类重写该方法定制 导航栏右边title
    public func navigationBarRightTitle() -> String {
        return ""
    }
    
    /// 子类重写该方法定制 导航栏右边title颜色
    public func navigationBarRightTitleColor() -> UIColor {
        return RGBColor(0xfe5050)
    }
    
    /// 子类重写该方法定制 导航栏右边title字体
    public func navigationBarRightTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
    
    /// 子类重写该方法定制 导航栏右边按钮事件
    public func navigationBarRightAction() {
    }
    
    /// 子类重写该方法定制 导航栏右边image
    public func navigationBarRightImage() -> String {
        return ""
    }
    
    /// 子类重写该方法定制 导航栏返回按钮图片
    public func navigationBarBackImage() -> String {
        return "icon_back_new_red_normal"
    }
    
    /// 子类重写该方法定制 导航栏背景色
    public func navigationBarColor() -> UIColor {
        return bg1
    }
    
    /// 子类重写该方法定制 导航栏title样式
    public func navigationBarTitleFontTuple() -> labelTuple {
        return t14
    }
    
    /// 子类重写该方法定制 导航栏底部细线显示与否
    public func navigationBarBottomLineHidden() -> Bool {
        return false
    }
    
    /// 子类重写该方法定制 视图控制器背景色
    public func viewBackgroundColor() -> UIColor {
        return bg5
    }
    
    /// 子类调用该方法更新 导航栏title
    public func updateNavigationBarTitle(withTitle title: String) {
        fky_setupTitleLabel(title)
    }
}

// MARK: - delegates
extension ViewController {
    
}

// MARK: - action
extension ViewController {
    
}

// MARK: - data
extension ViewController {
    
}

// MARK: - private methods
extension ViewController {

}
