//
//  ZJPaySuccessViewController.swift
//  FKY
//
//  Created by Rabe on 13/12/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  中金支付提交订单成功页

import Foundation
import UIKit

class ZJPaySuccessViewController: UIViewController {
  
  // MARK: - Properties
  var navBar : UIView?

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navBar = {
      if let _ = self.NavigationBar {
      } else {
        self.fky_setupNavBar()
      }
      return self.NavigationBar!
    }()
    
    self.fky_setupLeftImage("icon_back_new_red_normal") {
      FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
        let v = vc as! FKY_TabBarController
        v.index = 3
      }, isModal: false)
    }
    
    self.navBar!.backgroundColor = bg1
    self.fky_setupTitleLabel("中金支付")
    self.NavigationTitleLabel!.fontTuple = t14
    self.fky_hiddedBottomLine(false)
    self.setupView()
    self.bindViewModel()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Action
  
  // MARK: - UI
  
  func setupView() -> () {
    self.view.backgroundColor = .white
    
    // -----------------------
    // 绿色成功勾勾图片
    // -----------------------
    let imageView = UIImageView(image: UIImage(named: "icon_account_register_success"))
    view.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.centerX.equalTo(view)
      make.top.equalTo((navBar?.snp.bottom)!).offset(WH(90))
      make.size.equalTo(CGSize(width: WH(40), height: WH(40)))
    }
    
    // -----------------------
    // 成功文描
    // -----------------------
    let successLabel = UILabel(frame: .zero)
    successLabel.text = "提交订单成功"
    successLabel.font = UIFont.systemFont(ofSize: 13.0)
    successLabel.textColor = RGBColor(0x343434)
    view.addSubview(successLabel)
    successLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(view)
      make.top.equalTo(imageView.snp.bottom).offset(WH(5))
    }
    
    // -----------------------
    // 主要文描
    // -----------------------
    let tipLabel = UILabel(frame: .zero)
    tipLabel.text = "请至PC端进行在线支付"
    tipLabel.font = UIFont.systemFont(ofSize: 14.0)
    tipLabel.textColor = RGBColor(0xfe5050)
    view.addSubview(tipLabel)
    tipLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(view)
      make.top.equalTo(successLabel.snp.bottom).offset(WH(10))
    }
    
    // -----------------------
    // 我的订单按钮
    // -----------------------
    let button = UIButton()
    button.setTitle("我的订单", for: .normal)
    button.setTitleColor(RGBColor(0xe60012), for: .normal)
    button.backgroundColor = .white
    button.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
    button.layer.borderWidth = 1
    button.layer.borderColor = RGBColor(0xfe5050).cgColor
    _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
        guard let strongSelf = self else {
            return
        }
      FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
        let v = vc as! FKY_TabBarController
        v.index = 4
        FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
        }, isModal: false)
      }, isModal: false)
    }, onError: nil, onCompleted: nil, onDisposed: nil)
    view.addSubview(button)
    button.snp.makeConstraints { (make) in
      make.centerX.equalTo(view)
      make.top.equalTo(tipLabel.snp.bottom).offset(WH(30))
      make.size.equalTo(CGSize(width: WH(154), height: WH(42)))
    }
  }
}

// MARK: - Private Method
extension ZJPaySuccessViewController {
    func bindViewModel() {
        //
    }
}
