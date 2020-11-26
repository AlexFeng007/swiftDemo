//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

//滑动处理相关通知
let TABLELEAVETOP = "tableLeaveTop"
let TABLETOP = "tableTop"
class HomeController: ViewController {
    
    // MARK: - properties
    fileprivate lazy var viewModel: NewHomeViewModel = NewHomeViewModel()
    
    // MARK: - properties
    @objc var currectVC: UIViewController?
    
    //红包小浮窗
    fileprivate lazy var redBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "home_red_btn_pic"), for: [.normal])
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self ,let model = strongSelf.rpModel {
                strongSelf.showRedView(model)
                strongSelf.showRedBtn(false)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.right).offset(WH(60))
            make.bottom.equalTo(self.view.snp.bottom).offset(-WH(145))
        }
        return btn
    }()
    fileprivate var rpModel: RedPacketInfoModel? //
    
    // MARK: - life cycle
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化bi
        //FKYAnalyticsManager.sharedInstance.BI_OutViewController(self)
        //启动首页渲染埋点
        YWSpeedUpManager.sharedInstance().start(with: ModuleType.fkyHome)
        
        showToastWhenNoNetwork()
        // loadCacheData()
        setUpData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeController.loginStatuChanged(_:)), name: NSNotification.Name.FKYLogoutComplete, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIApplication.shared.setStatusBarStyle(.default, animated: true)
//        if #available(iOS 13.0, *) {
//            UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FKYItroductMaskView.setUpHomeShophWelcomePage()
        //
       // UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        if let app = UIApplication.shared.delegate as? AppDelegate, let compliance = app.complianceMaskView, compliance.superview != nil{
            //防止更新框覆盖合规页
            app.bringComplicanceMaskViewFront()
        }
        
        //请求红包接口
        self.getRedData()
        // 更新站点
        FKYAppDelegate!.requestSiteInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - ui
    fileprivate func setupView() {
//        DispatchQueue.main.async {
//            UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
//        }
        
        automaticallyAdjustsScrollViewInsets = false
        self.getHomeViewType()
    }
    
    //红包相关
    @objc func getRedData(){
        if let boolValue = UserDefaults.standard.value(forKey: "FKY_COMMAND_JUMPTOSHOP_KEY") as? Bool, boolValue == true {
            //当前需要跳转到口令活动页面
            return
        }
        if let boolValue = UserDefaults.standard.value(forKey: "FKY_COMMAND_LIVE_KEY") as? Bool, boolValue == true {
            //当前需要跳转到口令活动页面
            return
        }
        if let boolValue = UserDefaults.standard.value(forKey: "FKY_COMMAND_SMARTSTORE_KEY") as? Bool, boolValue == true {
            //当前需要跳转到口令活动页面
            return
        }
        //登录后请求常购清单相关
        if FKYLoginAPI.loginStatus() != .unlogin {
            self.showRpView()
        }else{
            //未登录隐藏浮层
            self.redBtn.isHidden = true
        }
    }
    
    fileprivate func showRpView() {
        //判断界面是否有红包的视图
        let window: UIWindow = UIApplication.shared.keyWindow!
        if let rootView = window.rootViewController?.view {
            for subView in rootView.subviews {
                if subView.tag == SHOW_REDPACKET_VIEW_TAG {
                    return
                }
            }
        }
        //请求红包
        RedPacketShowProvider.sharedInstance.checkRedPacketShowInfo(){ [weak self] (success, rpModel, msg) in
            if let strongSelf = self {
                if success {
                    if let model = rpModel {
                        strongSelf.rpModel = model
                        if strongSelf.getShowRedBtn() == true {
                            //显示小浮窗
                            strongSelf.redBtn.isHidden = false
                            strongSelf.view.bringSubviewToFront(strongSelf.redBtn)
                            strongSelf.showRedBtn(true)
                        }else{
                            //弹红包框
                            strongSelf.showRedView(model)
                            strongSelf.redBtn.isHidden = true
                            strongSelf.showRedBtn(false)
                        }
                    }
                }else{
                    //无红包隐藏小浮窗及初始化记录显示浮窗的本地bool值
                    UserDefaults.standard.set("", forKey: "HAS_RED_BTN")
                    UserDefaults.standard.synchronize()
                    strongSelf.redBtn.isHidden = true
                    strongSelf.showRedBtn(false)
                    strongSelf.rpModel = nil
                }
            }
        }
    }
    
    //判断是否显示红包
    func getShowRedBtn() -> Bool {
        if  let oldStr = UserDefaults.standard.value(forKey: "HAS_RED_BTN") as? String ,oldStr.count > 0 {
            let nowStr = (Date() as NSDate).string(withFormat: "yyyy-MM-dd")
            if oldStr == nowStr {
                return true
            }
        }
        return false
        
    }
    
    //隐藏或者显示小浮窗
    func showRedBtn(_ showBtn:Bool){
        if showBtn == true {
            //显示
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1.0, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.redBtn.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
                    make.right.equalTo(strongSelf.view.snp.right).offset(-WH(0))
                })
                strongSelf.view.layoutIfNeeded()
            }, completion: { (_) in
                //
            })
            
        }else{
            //隐藏
            UIView.animate(withDuration: 1.0, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.redBtn.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
                    make.right.equalTo(strongSelf.view.snp.right).offset(WH(60))
                })
                strongSelf.view.layoutIfNeeded()
            }, completion: { (_) in
                //
                //self.redBtn.isHidden = true
            })
        }
    }
    //显示红包弹框
    fileprivate func showRedView(_ rpModel: RedPacketInfoModel){
        // 显示红包
        let redPacketView: RedPacketView = RedPacketView.init(rpModel)
        redPacketView.show()
        //叉掉红包弹框
        redPacketView.hideRedPacketAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let nowStr = (Date() as NSDate).string(withFormat: "yyyy-MM-dd")
            UserDefaults.standard.set(nowStr, forKey: "HAS_RED_BTN")
            UserDefaults.standard.synchronize()
            strongSelf.view.bringSubviewToFront(strongSelf.redBtn)
            strongSelf.redBtn.isHidden = false
            strongSelf.showRedBtn(true)
        }
        //领取红包
        redPacketView.checkRedPacketAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showLoading()
            //显示红包详情
            RedPacketShowProvider.sharedInstance.checkRedPacketDrawInfo(){ (success,model, msg) in
                //更新显示浮窗的本地变量
                UserDefaults.standard.set("", forKey: "HAS_RED_BTN")
                UserDefaults.standard.synchronize()
                strongSelf.showRedBtn(false)
                strongSelf.dismissLoading()
                redPacketView.dismiss()
                if success {
                    FKYNavigator.shared().openScheme(FKY_RedPacket.self, setProperty: { (vc) in
                        let v = vc as! FKYRedPacketViewController
                        v.redPacketModel = model;
                    })
                }
            }
        }
    }
    
    override func navigationBarVisible() -> Bool {
        return false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - delegates
extension HomeController {
    
}

// MARK: - action
extension HomeController {
    func setUpData() {
        self.viewModel.fetchUserLocation(finishedCallback: { [weak self] (location) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupView()
        })
    }
    
    //刷新购物车数量
    func refreshCarNum() {
        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ (isSuccess) in
            // self.tableView.reloadData()
        }) { (reason) in
            self.toast(reason)
        }
    }
    
    //获取界面方案
    func getHomeViewType() {
        
        let baseInfoVC = FKYHomePageV3VC()
        self.view.addSubview(baseInfoVC.view)
        baseInfoVC.view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        self.addChild(baseInfoVC)
        self.currectVC =  baseInfoVC
    }
}

// MARK:
extension HomeController {
    //
}

// MARK: - private methods
extension HomeController {
    @objc fileprivate func loginStatuChanged(_ nty: Notification) {
        //登录后请求常购清单相关
        if self.currectVC != nil{
            if let HMVC = self.currectVC as? HomeMainOftenBuyController {
                HMVC.refreshDataForLoginChange()
            }else if let HomeVCV3 = self.currectVC as? FKYHomePageV3VC {
                HomeVCV3.refreshDataForLoginChange()
            }
        }
    }
    
    @objc fileprivate func checkCurrentNetworkStatus() {
        //showToastWhenNoNetwork()
    }
}
