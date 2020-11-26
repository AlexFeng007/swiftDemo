//
//  UIViewController+NavigationBar.swift
//
//  Created by yangyouyong on 15/12/19.
//  Copyright © 2015年 yang. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift

extension UIViewController {
    fileprivate struct AssociatedKeys {
        static var NavigationBar = "fky_navigationBar"
        static var NavigationBarTitleLabel = "fky_navigationBarTitleLabel"
        static var NavigationBarBottomTitleLabel = "fky_navigationBarBottomTitleLabel"
        static var NavigationBarBottomLine = "fky_navigationBarBottomLine"
        static var NavigationBarLeftImage = "fky_navigationBarLeftImage"
        static var NavigationBarRightImage = "fky_navigationBarRightImage"
    }
    
    // MARK: Properties
    // MARK:
    var NavigationBar: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.NavigationBar) as? UIView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.NavigationBar,
                    newValue as UIView?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    var NavigationTitleLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.NavigationBarTitleLabel) as? UILabel
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.NavigationBarTitleLabel,
                    newValue as UILabel?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    var NavigationBottomTitleLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.NavigationBarBottomTitleLabel) as? UILabel
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.NavigationBarBottomTitleLabel,
                    newValue as UILabel?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    var NavigationBottomLine: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.NavigationBarBottomLine) as? UIView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.NavigationBarBottomLine,
                    newValue as UIView?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    var NavigationBarLeftImage: UIButton? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.NavigationBarLeftImage) as? UIButton
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.NavigationBarLeftImage,
                    newValue as UIButton?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    var NavigationBarRightImage: UIButton? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.NavigationBarRightImage) as? UIButton
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.NavigationBarRightImage,
                    newValue as UIButton?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    // MARK: Funcs
    // MARK:
    
    func fky_setupNavBar() {
        if let _ = self.NavigationBar {
            
        }else{
            self.createNavigationBar()
        }
    }
    
    func fky_setupTitleLabel() {
        if let _ = self.NavigationTitleLabel {
            
        } else {
            self.createNavigationBarTitleLabel()
        }
    }
    func fky_setUpNavigationBarBottomTitle(_ title: String?, _ textColor:UIColor = .black ,_ textFont:UIFont=UIFont.systemFont(ofSize: WH(10))) {
        if let _ = self.NavigationBottomTitleLabel {
            
        } else {
            self.createNavigationBarBottomTitleLabel(textColor,textFont)
        }
        if title == nil{
            self.NavigationBottomTitleLabel!.text = nil
            if let _ = self.NavigationTitleLabel {
                
            } else {
                self.createNavigationBarTitleLabel()
            }
            self.NavigationTitleLabel!.snp.remakeConstraints { (make) -> Void in
                make.left.equalTo(self.NavigationBar!).offset(WH(46))
                make.right.equalTo(self.NavigationBar!).offset(WH(-46))
                make.height.equalTo(44)
                make.bottom.equalTo(self.NavigationBar!).offset(WH(0))
            }
        }else{
            self.NavigationBottomTitleLabel!.text = title
            if let _ = self.NavigationTitleLabel {
                
            } else {
                self.createNavigationBarTitleLabel()
            }
            self.NavigationTitleLabel!.snp.remakeConstraints { (make) -> Void in
                make.left.equalTo(self.NavigationBar!).offset(WH(46))
                make.right.equalTo(self.NavigationBar!).offset(WH(-46))
                make.height.equalTo(29)
                make.bottom.equalTo(self.NavigationBar!).offset(WH(-15))
            }
        }
    }
    
    func fky_setupTitleLabel(_ title: String?) {
        if let _ = self.NavigationTitleLabel {
            
        } else {
            self.createNavigationBarTitleLabel()
        }
        self.NavigationTitleLabel!.text = title
    }
    
    func fky_hiddedBottomLine(_ hidden:Bool){
        if let _ = self.NavigationBottomLine {
        } else {
            self.createNavigationBarBottomLine()
        }
        self.NavigationBottomLine!.isHidden = hidden
    }
    
    func fky_setupLeftImage(_ named:String,callback:@escaping ()->()){
        if let _ = self.NavigationBarLeftImage {
        } else {
            self.createNavigationBarLeftImage()
        }
        self.NavigationBarLeftImage!.setImage(UIImage(named: named), for: UIControl.State())
        _ = self.NavigationBarLeftImage?.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            callback()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    func fky_setupRightTitle(_ title:String,callback:@escaping ()->()){
        if let _ = self.NavigationBarRightImage {
        } else {
            self.createNavigationBarRightImage()
        }
        self.NavigationBarRightImage!.setTitle(title, for: UIControl.State())
        _ = self.NavigationBarRightImage?.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            callback()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    func fky_setRightTitleColor(color:UIColor){
        guard let rightBtn = self.NavigationBarRightImage else{
            return
        }
        rightBtn.setTitleColor(color, for: .normal)
    }
    
    func fky_setupRightImage(_ named:String?,callback:@escaping ()->()){
        if let _ = self.NavigationBarRightImage {
        } else {
            self.createNavigationBarRightImage()
        }
        if named != nil {
            self.NavigationBarRightImage!.setImage(UIImage(named: named!), for: UIControl.State())
        }
        _ = self.NavigationBarRightImage?.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            callback()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    

    // MARK: Private Funcs
    // MARK:
    
    fileprivate func createNavigationBar() {
        let nvBar = UIView()
        nvBar.backgroundColor = RGBColor(0xDF4138)
        self.view.addSubview(nvBar)
        nvBar.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(naviBarHeight())
        }
        self.NavigationBar = nvBar
    }
    
    fileprivate func createNavigationBarTitleLabel() {
        self.fky_setupNavBar()
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: WH(18))
        self.NavigationBar!.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.NavigationBar!).offset(WH(46))
            make.right.equalTo(self.NavigationBar!).offset(WH(-46))
            make.height.equalTo(44)
            make.bottom.equalTo(self.NavigationBar!).offset(WH(0))
//            make.centerX.equalTo(self.NavigationBar!.snp.centerX)
//            if #available(iOS 11, *) {
//                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
//                if (insets?.bottom)! > CGFloat.init(0) {
//                    // iPhone X系统
//                    make.bottom.equalTo(self.NavigationBar!).offset(WH(-10))
//                } else {
//                    make.centerY.equalTo(self.NavigationBar!.snp.centerY).offset(WH(10))
//                }
//            } else {
//                make.centerY.equalTo(self.NavigationBar!.snp.centerY).offset(WH(10))
//            }
        }
        self.NavigationTitleLabel = titleLabel
    }
    fileprivate func createNavigationBarBottomTitleLabel(_ textColor:UIColor = .black ,_ textFont:UIFont=UIFont.systemFont(ofSize: WH(10))) {
        self.fky_setupNavBar()
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
//        titleLabel.textColor = UIColor.black
        titleLabel.textColor = textColor
        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.systemFont(ofSize: WH(10))
        titleLabel.font = textFont
        self.NavigationBar!.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.NavigationBar!).offset(WH(46))
            make.right.equalTo(self.NavigationBar!).offset(WH(-46))
            make.height.equalTo(WH(14))
            make.bottom.equalTo(self.NavigationBar!).offset(WH(-3))
        }
        self.NavigationBottomTitleLabel = titleLabel
    }
    fileprivate func createNavigationBarBottomLine() {
        self.fky_setupNavBar()
        let line = UIView()
        line.backgroundColor = m2
        line.isHidden = true
        self.NavigationBar!.addSubview(line)
        line.snp.makeConstraints { (make) -> Void in
            make.bottom.left.right.equalTo(self.NavigationBar!)
            make.height.equalTo(WH(1))
        }
        self.NavigationBottomLine = line
    }
    
    fileprivate func createNavigationBarLeftImage() {
        self.fky_setupNavBar()
        let btn = UIButton()
        self.NavigationBar!.addSubview(btn)
        btn.snp.makeConstraints { (make) -> Void in
            make.bottom.left.equalTo(self.NavigationBar!)
//            make.width.height.equalTo(WH(44))
            make.height.equalTo(WH(44))
            make.width.equalTo(WH(52))
        }
        self.NavigationBarLeftImage = btn
    }
    
    fileprivate func createNavigationBarRightImage() {
        self.fky_setupNavBar()
        let btn = UIButton()
        self.NavigationBar!.addSubview(btn)
        btn.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.NavigationBar!).offset(WH(-5))
            make.right.equalTo(self.NavigationBar!).offset(-WH(10))
        }
        self.NavigationBarRightImage = btn
    }
}

//无数据判断
extension UIViewController {
    func showEmptyNoDataCustomView(_ bgView :UIView,_ img : String,_ title:String,_ isHideBtn:Bool,callback:@escaping ()->()) -> UIView{
        let bg = UIView()
        bg.backgroundColor = bg1
        bgView.addSubview(bg)
        bg.snp.makeConstraints { (make) in
            make.edges.equalTo(bgView)
        }
        let imageView = UIImageView.init(image: UIImage.init(named: img))
        bg.addSubview(imageView)
        
        let titleLabel = UILabel()
        let attributes = [ NSAttributedString.Key.font: FontConfig.font14, NSAttributedString.Key.foregroundColor: ColorConfig.color999999]
        titleLabel.attributedText = NSAttributedString.init(string: title, attributes: attributes)
        titleLabel.textAlignment = .center
        bg.addSubview(titleLabel)
        
        var topOffy : CGFloat
        if isHideBtn {
            topOffy = WH(15+20)
        }else{
            topOffy = WH(15+20+20+28)
        }
        imageView.snp.makeConstraints ({ (make) in
            make.centerY.equalTo(bg.snp.centerY).offset(-topOffy)
            make.centerX.equalTo(bg)
        })
        
        titleLabel.snp.makeConstraints ({ (make) in
            make.top.equalTo(imageView.snp.bottom).offset(WH(15))
            make.height.equalTo(WH(20))
            make.centerX.equalTo(bg)
        })
        
        if !isHideBtn {
            let button = UIButton()
            button.setTitle(HomeString.EMPTY_PAGE_BUTTON_TITLE, for: .normal)
            button.setBackgroundImage(UIImage.init(named: HomeString.EMPTY_PAGE_BUTTON_BG), for: .normal)
            button.setTitleColor(ColorConfig.color333333, for: .normal)
            button.setTitleColor(ColorConfig.color999999, for: .highlighted)
            button.titleLabel?.font = FontConfig.font14
            _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
                callback()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            bg.addSubview(button)
            button.snp.makeConstraints ({ (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(WH(20))
                make.centerX.equalTo(bg)
                make.size.equalTo(CGSize(width: WH(86), height: WH(28)))
            })
        }
        
        return bg
    }
}
