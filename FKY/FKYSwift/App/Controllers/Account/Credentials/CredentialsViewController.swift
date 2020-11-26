//
//  CredentialsViewController.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/25.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  资质管理

import UIKit

@objc
class CredentialsViewController: UIViewController, FKY_CredentialsController {
    // MARK:- Property
    var needJumpToDrugScope: Int = 0
    
    @objc dynamic var credentialsStatus:NSInteger = 0
    @objc dynamic var quicklyRegiterStatus:NSInteger = 0
    fileprivate var navBar: UIView?
    fileprivate var emptyView : StaticView?
    var fromType: String = ""
    
    
    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = RGBColor(0xffffff)
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UI
    func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar?.backgroundColor = bg1
        self.fky_setupTitleLabel("资质管理")
        self.fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        self.fky_hiddedBottomLine(false)
        
        self.emptyView = {
            let v = StaticView()
            self.view.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.top.equalTo(self.navBar!.snp.bottom)
                make.left.right.bottom.equalTo(self.view)
            })
            v.configView("icon_search_empty", title: "暂无结果", btnTitle: "去首页逛逛")
            v.actionBlock = {
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 0
                })
            }
            v.isHidden = true
            return v
        }()
    }
    
    // MARK: - Request
    func requestData() -> () {
        showLoading()
        let service = CredentialsBaseInfoProvider()
        service.zzStatus { [weak self] (statusCode) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            
            if let code = statusCode {
                strongSelf.credentialsStatus = code.intValue
            }
            else {
                strongSelf.credentialsStatus = -2
            }
            
            strongSelf.emptyView?.isHidden = false
            if strongSelf.credentialsStatus == -2 {
                strongSelf.emptyView?.isHidden = false
                return
            }
            else {
                strongSelf.emptyView?.isHidden = true
            }
            
            /*
             statusCode = [-1、11、12、13、14] 用户注册未提交任何资料，需继续进入界面填写界面
             statusCode = [其它] 用户注册后提交了资料，进入资料查看界面
             */
            
            
            // MARK: 快速注册流程去掉了 start 3.5.1, before 3.5.0(include 3.5.0)接口返回statusCode为-1的时候，跳转到快速注册页，after 3.5.1，快速注册和基本资料页合并
            if (strongSelf.credentialsStatus == -1 || strongSelf.credentialsStatus == 11 || strongSelf.credentialsStatus == 12 || strongSelf.credentialsStatus == 13 || strongSelf.credentialsStatus == 14) {
                // 填写基本信息...<企业>
                let baseInfoVC = RITextController()
                strongSelf.view.addSubview(baseInfoVC.view)
                baseInfoVC.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(strongSelf.view)
                })
                strongSelf.addChild(baseInfoVC)
            }
            else {
                // 基本资料 or 原资料...<默认进入基本资料界面>
                let baseInfoVC = QualificationBaseInfoController()
                baseInfoVC.fromType = strongSelf.fromType as NSString
                baseInfoVC.needJumpToDrugScope = (strongSelf.needJumpToDrugScope == 1 ? true : false)
                strongSelf.view.addSubview(baseInfoVC.view)
                baseInfoVC.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(strongSelf.view)
                })
                strongSelf.addChild(baseInfoVC)
            }
        }
    }
}
