//
//  CredentialsCompleteViewController.swift
//  FKY
//
//  Created by yangyouyong on 2016/12/4.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  （填写基本信息之）提交成功

import UIKit

class CredentialsCompleteViewController: UIViewController {
    //MARK: Property
    fileprivate var navBar: UIView?
    
    fileprivate lazy var completeView: CredentialsCompleteView = {
        let cpView = CredentialsCompleteView()
        return cpView
    }()
    
    fileprivate lazy var homeBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = WH(2)
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = RGBColor(0xFF394E).cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0xFF394E), for: UIControl.State())
        btn.setTitle("浏览首页", for: UIControl.State())
        return btn
    }()
    
    fileprivate lazy var credentialsBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = WH(2)
        btn.layer.masksToBounds = true
        btn.backgroundColor = RGBColor(0xFF394E)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(UIColor.white, for: UIControl.State())
        btn.setTitle("查看资料", for: UIControl.State())
        return btn
    }()
    
    //MARK: Private Method
    fileprivate func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar?.backgroundColor = bg1
        self.fky_setupTitleLabel("提交成功")
        self.NavigationTitleLabel!.fontTuple = t14
        self.fky_hiddedBottomLine(false)
        self.NavigationBarLeftImage?.isHidden = true
        
        self.view.addSubview(homeBtn)
        let width: CGFloat = (SCREEN_WIDTH - WH(16)*2 - WH(24))/2
        homeBtn.addTarget(self, action: #selector(onHomeBtn(_:)), for: .touchUpInside)
        homeBtn.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(22))
            make.leading.equalTo(self.view.snp.leading).offset(WH(16))
            make.width.equalTo(width)
            make.height.equalTo(WH(44))
        })
        
        self.view.addSubview(credentialsBtn)
        credentialsBtn.addTarget(self, action: #selector(onCredentialsBtn(_:)), for: .touchUpInside)
        credentialsBtn.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(22))
            make.trailing.equalTo(self.view.snp.trailing).offset(-WH(16))
            make.width.equalTo(width)
            make.height.equalTo(WH(44))
        })
        
        view.addSubview(completeView)
        completeView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(homeBtn.snp.top).offset(WH(-22))
        })
        
        view.backgroundColor = bg1
    }
    
    //MARK: Life Cycle
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: User Action
    @objc func onCredentialsBtn(_ sender: UIButton) {
        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
            let v = vc as! FKY_TabBarController
            v.index = 4
            let vc = QualificationBaseInfoController()
            FKYNavigator.shared().topNavigationController.pushViewController(vc, animated: true, snapshotFirst: false)
            }, isModal: false)
    }
    
    @objc func onHomeBtn(_ sender: UIButton) {
        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
            let v = vc as! FKY_TabBarController
            v.index = 0
            }, isModal: false)
    }
}
