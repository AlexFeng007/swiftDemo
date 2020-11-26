//
//  FKYBandingBankCardErrorVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/8.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  绑定银行卡失败

import UIKit

class FKYBandingBankCardErrorVC: UIViewController {

    /// 错误提示View
    lazy var errorView = FKYBandingBankErrorView()
    
    /// 错误提示内容 外部传入
    var errorText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimation()
    }

}
//MARK: - 事件响应
extension FKYBandingBankCardErrorVC{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_knowButtonClicked{// 知道了按钮点击
            self.dismissVerificationView()
        }else if eventName == FKY_closeVerificationView{// 关闭按钮
            self.dismissVerificationView()
        }
    }
}
//MARK: - UI
extension FKYBandingBankCardErrorVC{
    
    func setupUI(){
        
        self.view.addSubview(self.errorView)
        self.view.backgroundColor = .white
        self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0)
        self.errorView.frame = CGRect(x: (SCREEN_WIDTH-WH(342)) / 2.0, y: (SCREEN_HEIGHT - WH(240)) / 2.0, width: WH(342), height: WH(240))
    }
    func showErrorForBank(){
       self.errorView.showError(error: "失败原因" + errorText)
    }
    func showTipsForCommon(_ tips:String,_ title:String){
        self.errorView.showTipsForCommon(tips,title)
    }
    /// 开始动画
    func startAnimation(){
        UIView.animate(withDuration: 0.1, animations: {
            self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5)
        }) { (isFinished) in
            if isFinished {
                
            }
        }
    }
    
    /// 结束动画
    func dismissVerificationView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0)
            self.errorView.removeFromSuperview()
        }) { (isFinished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
