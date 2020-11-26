//
//  CartSwitchViewController.swift
//  FKY
//
//  Created by 寒山 on 2019/12/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  一起购购物车和普通购物车容器

import UIKit

class CartSwitchViewController: UIViewController ,FKY_ShopCart{
    var canBack:Bool = false   // 判断是否显示返回btn
    var typeIndex:Int = 0 // 默认选中的购物车类型索引
    //视图容器
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    //一起购
    fileprivate lazy var cartGroupController: YQGCartViewController = {
        let yqgVC = YQGCartViewController()
        yqgVC.canBack = self.canBack
        yqgVC.switchBlock = {[weak self] in
            if let stongSelf = self{
                stongSelf.showNormalCart()
            }
        }
        return yqgVC
    }()
    fileprivate lazy var cartController: CartViewController  = {
        let cartVC =  CartViewController()
        cartVC.canBack = self.canBack
        cartVC.switchBlock = {[weak self] in
            if let stongSelf = self{
                stongSelf.showGroupCart()
            }
        }
        return cartVC
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.typeIndex == 1{
            // 默认选中一起购购物车...<不需要刷新>
            return
        }
        self.setupRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.updateCartViews(false)
        if self.typeIndex == 1{
            // 默认选中一起购购物车
            self.updateCartViews(true)
            self.showGroupCart()
        }
        // Do any additional setup after loading the view.
    }
    func setupView(){
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        
        self.viewContent.addSubview(self.cartController.view)
        self.cartController.view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.viewContent)
        })
        
        self.cartController.view.isHidden = false
        self.addChild(self.cartController)
        
        self.viewContent.addSubview(self.cartGroupController.view)
        self.cartGroupController.view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.viewContent)
        })
        self.cartGroupController.view.isHidden = true
        self.addChild(self.cartGroupController)
    }
}
extension CartSwitchViewController{
    func showGroupCart(){
        self.cartController.view.isHidden = true
        self.cartGroupController.view.isHidden = false
        self.cartController.resetTypeIndex()
        self.cartGroupController.resetTypeIndex()
    }
    // 一起购购物车显示or隐藏
    func updateCartViews(_ showGroup:Bool?){
        if showGroup == true{
            self.cartController.showTypeView(true)
        }else{
            //        // 隐藏一起购购物车
            self.cartController.showTypeView(false)
            self.showNormalCart()
        }
    }
    func showNormalCart(){
        self.cartController.view.isHidden = false
        self.cartGroupController.view.isHidden = true
        
        self.cartController.resetTypeIndex()
        self.cartGroupController.resetTypeIndex()
    }
}

extension CartSwitchViewController{
    func setupRequest(){
        // 未登录
        if FKYLoginAPI.loginStatus() == .unlogin {
            // 清空数据内容
            self.updateCartViews(false)
            self.cartController.resetForUnLogin()
            return;
        }
        
        // 请求一起购购物车中商品数量
        self.requestCartNumberForGroup()
    }
    // 获取一起购购物车中商品数量
    func requestCartNumberForGroup(){
        let parameters = [ "fromwhere": "2" ] as [String : Any]
        FKYRequestService.sharedInstance()?.requestForProductNumberInCart(withParam: parameters, completionBlock: {[weak self]  (success, error, response, model) in
            guard let selfStrong = self else {
                return
            }
            guard success else {
                // 失败
                return
            }
            // 请求成功
            var hasProduct = false
            if let data = response as? NSDictionary {
                if let count = data["count"]{
                    if (count as AnyObject).intValue > 0{
                        hasProduct = true
                    }
                }
                // 更新UI
                selfStrong.updateCartViews(hasProduct)
                return
            }
        })
    }
}
