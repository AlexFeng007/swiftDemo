//
//  FKYWebViewController.swift
//  FKY
//
//  Created by 路海涛 on 2017/5/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  首页（H5）...<其它H5页面(如分类)的基类~!@>

import UIKit
import WebKit
import SwiftyJSON
import MJRefresh


@objc
class FKYWebViewController: UIViewController,
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler,
FKYJSProtocol{

    dynamic var url: String?
    dynamic var isNav: Bool = false
    dynamic var webTitle: String?
    
    // 是否显示下拉刷新
    dynamic var showPullReload: Bool = false
    
    fileprivate lazy var viewStatusBarBack: UIView = {
        let view: UIView = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        return view;
    }()
    
    internal fileprivate(set) lazy var wkweb: WKWebView = {[weak self] in
        let w = UIWebView()
        var s = w.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        s = s! + "FKYIOS"
        let dic:Dictionary<String,AnyObject> = ["UserAgent":s! as AnyObject];
        UserDefaults.standard.register(defaults: dic)
        
        let config = WKWebViewConfiguration.init()
        config.preferences = WKPreferences.init()
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = true;
        config.preferences.javaScriptCanOpenWindowsAutomatically = false;
        config.processPool = WKProcessPool.init()
        config.userContentController = WKUserContentController.init()
        config.userContentController.add(self!, name: "FKYNative")
        config.userContentController.add(self!, name: "native")
        let web = WKWebView.init(frame: CGRect.zero, configuration: config)
        web.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        web.scrollView.showsVerticalScrollIndicator = false
        web.scrollView.showsHorizontalScrollIndicator = false
        web.navigationDelegate = self!
        web.uiDelegate = self!
        return web
    }()
    
    fileprivate lazy var notNetView: FKYNetworkEmpty = {
        let net = FKYNetworkEmpty()
        net.reload = {[weak self] () in
            if let strURL = self!.url, let urlObj = URL.init(string: strURL) {
               self!.wkweb.load(URLRequest.init(url: urlObj))
            }
        }
        return net;
    }()
    
    fileprivate lazy var jsBridge: FKYJSBridge = {
        let jsBridge = FKYJSBridge()
        jsBridge.delegate = self;
        return jsBridge
    }()
    fileprivate var navBar:UIView?
    fileprivate weak var topNavBarContrait: NSLayoutConstraint?
    fileprivate var isRunLogin:UIView?
    fileprivate var isWebViewLoadFinished:Bool = false
    fileprivate var isRunLoginJS:Bool = false
    
    var isStretchStatusBar:Bool = false {
        didSet {
            if let topNavBarContrait = self.topNavBarContrait {
                if isStretchStatusBar {
                    topNavBarContrait.constant = 0.0
                }else{
                    self.topNavBarContrait?.constant = UIApplication.shared.statusBarFrame.height
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNav {
            self.navBar = {
                if let _ = self.NavigationBar {
                }else{
                    self.fky_setupNavBar()
                }
                return self.NavigationBar!
            }()
            self.fky_setupLeftImage("icon_back_red_normal") {
                FKYNavigator.shared().pop()
            }
            self.navBar!.backgroundColor = bg1
            self.fky_setupTitleLabel(self.webTitle)
            self.NavigationTitleLabel!.fontTuple = t14
        }
        
        steupUI()

//        var defaultUrl = "http://m.yaoex.com/experimental_index.html" // 防止劫持 测试期间可以打开，技术主管决定
//        if self.url?.count > 7 { //http://xxx
//            defaultUrl = self.url!
//        }else{
//            self.url = defaultUrl;
//        }
        if let strURL = self.url, strURL.count > 7, let URL = URL.init(string: strURL) {
            self.wkweb.load(URLRequest.init(url: URL))
        }
        
        // 显示下拉刷新
        if self.showPullReload {
            self.wkweb.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                // 下拉刷新
                self?.wkweb.reload()
                self?.wkweb.scrollView.mj_header.endRefreshing()
            })
            let header = self.wkweb.scrollView.mj_header as! MJRefreshNormalHeader
            header.lastUpdatedTimeLabel.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: NSNotification.Name.FKYLoginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name.FKYLogoutComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateHome), name: NSNotification.Name.FKYTabBarTouchUpdateHome, object: nil)
    }

    fileprivate func steupUI(){
        if #available(iOS 11.0, *) {
            self.wkweb.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.edgesForExtendedLayout = .all
        self.view.addSubview(wkweb)
        if isNav {
            wkweb.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(self.view)
                make.top.equalTo(self.navBar!.snp.bottom)
            })
        } else {
            self.view.addSubview(viewStatusBarBack)
            viewStatusBarBack.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(self.view)
            })
            let contraint: NSLayoutConstraint = NSLayoutConstraint.init(item: viewStatusBarBack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
            self.view.addConstraint(contraint)
            self.topNavBarContrait = contraint
            
            if self.isStretchStatusBar {
                self.topNavBarContrait?.constant = 0.0
            }else {
                self.topNavBarContrait?.constant = UIApplication.shared.statusBarFrame.height
            }
            
            wkweb.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(self.view)
                make.top.equalTo(self.viewStatusBarBack.snp.bottom)
            })
        }
        
        notNetView.isHidden = true
        self.view.addSubview(notNetView)
        self.view.sendSubview(toBack: notNetView)
        notNetView.snp.makeConstraints({ (make) in
            make.top.left.right.bottom.equalTo(self.view)
        })
    }

    // 登录之后通知js 同时token注入localStorage
    func login() -> () {
        let token : String = "localStorage.setItem('token', '\(FKYEnvironmentation().token)')"
        self.calljs(token)
        let city : String = "localStorage.setItem('city_id', '\(FKYEnvironmentation().station)')"
        self.calljs(city)
        let strStationName = FKYEnvironmentation().stationName
        if let urlEncodeStationName = strStationName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let stationName : String = "localStorage.setItem('stationName', '\(urlEncodeStationName)')"
            self.calljs(stationName)
        }else{
            let stationName : String = "localStorage.setItem('stationName', '\(strStationName)')"
            self.calljs(stationName)
        }
        let dic:Dictionary <String , AnyObject> = [
            "part":"home" as AnyObject,
            "method":"login" as AnyObject,
            "data":FKYEnvironmentation().token as AnyObject,
            "time":"" as AnyObject
        ];
        let json = JSON(dic)
        let call:String = "window.FKYNativeCall(\(json))"
        self.calljs(call)
    }
    
    func updateHome() {
        if .loginComplete == FKYLoginAPI.loginStatus() {
            let service = CredentialsBaseInfoProvider()
            service.zzStatus {[weak self](statusCode) in
                if let lastMarkStatus = UserDefaults.standard.object(forKey: "FKYMarkAuditStatusForHomeWebPage") as? NSNumber {
                    if lastMarkStatus != statusCode {
                        self!.wkweb.reload()
                        UserDefaults.standard.set(statusCode, forKey: "FKYMarkAuditStatusForHomeWebPage")
                        UserDefaults.standard.synchronize()
                    }
                }else {
                    self!.wkweb.reload()
                    UserDefaults.standard.set(statusCode, forKey: "FKYMarkAuditStatusForHomeWebPage")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }

    // 登出之后通知js 不清空localStorage
    func logout() -> () {
        let dic:Dictionary <String , AnyObject> = [
            "part":"home" as AnyObject,
            "method":"logout" as AnyObject,
            "data":"" as AnyObject,
            "time":"" as AnyObject
        ];
        let json = JSON(dic)
        let call:String = "window.FKYNativeCall(\(json))"
        self.calljs(call)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 埋点...<开始>
        YWSpeedUpManager.sharedInstance().start(with: ModuleType.fkyBrowser)
        //print("<url(start):>" + (webView.url?.absoluteString)!)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.view.bringSubview(toFront: self.notNetView)
        self.notNetView.show()
        // 埋点...<结束>
        WUMonitor.shared().saveWebLoadingError(webView.url?.absoluteString, error: error)
         YWSpeedUpManager.sharedInstance().addBrowserString(webView.url?.absoluteString, endAndUpdateWith: ModuleType.fkyBrowser)
        //print("<url(fial):>" + (webView.url?.absoluteString)!)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        WUMonitor.shared().saveWebLoadingError(webView.url?.absoluteString, error: error)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.notNetView.hide()
        self.view.sendSubview(toBack: self.notNetView)
        // 埋点...<结束>
        YWSpeedUpManager.sharedInstance().addBrowserString(webView.url?.absoluteString, endAndUpdateWith: ModuleType.fkyBrowser)
        //print("<url(finish):>" + (webView.url?.absoluteString)!)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        print(message.body)
        let dic:Dictionary = message.body as! Dictionary<String,AnyObject>
        print(dic)
        self.jsBridge.catagate(dic)
    }

    func ClearCache() {
        let dateFrom: Date = Date.init(timeIntervalSince1970: 0)
        if #available(iOS 9.0, *) {
            let websiteDataTypes: NSSet = WKWebsiteDataStore.allWebsiteDataTypes() as NSSet
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom) {
                print("清空缓存完成")
            }
        }
    }
    
    // MARK: FKYJSProtocol
    func calljs(_ js:String) -> () {
        self.wkweb.evaluateJavaScript(js, completionHandler: { (result, error) in
            guard result != nil && error != nil else {
                return
            }
            print("evaluateJavaScript js=%@ result=%@ error=%@",js ,result! ,error!)
        })
    }
}
