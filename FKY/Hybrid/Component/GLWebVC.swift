//
//
//  GLWebVC
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//  工程web容器实现类

import UIKit
import SwiftyJSON
import MJRefresh

enum FKYBarColorStyle: String {
    case redStyle = "0xf54b41"
    case whiteStyle = "0xffffff"
}

enum FKYBarTitleStyle: String {
    case redStyle = "0xffffff"
    case whiteStyle = "0x333333"
}

enum FKYBarBackStyle: String {
    case redStyle = "white"
    case whiteStyle = "red"
}

// KVO之加载进度key
let progressKey = "estimatedProgress"
// 加载进度条高度
let progressHeight: CGFloat = 3.0


class GLWebVC: GLViewController, FKY_Web, FKYNavigationControllerDragBackDelegate {
    // MARK: - properties
    internal var barStyle: FKYWebBarStyle = .barStyleNotVisible // 导航栏风格，默认不展示
    internal var isShutDown: Bool = false // 点击返回按钮，是否直接关闭webView，默认否
    internal var fromFuson: Bool = false  // 默认不是从复星金融支付跳转来的
    internal var pushType: Int = 0 //
    fileprivate var viewAppearOnce = false // 视图控制器是否完成第一次appear
    fileprivate var loadUrlSuccessOnce = false // 第一次加载url时是否成功标记
    fileprivate var errorDelegate: GLErrorVCDelegate? // 错误页面代理
    fileprivate var isFirstAppear = false // 判断页面是否第一次进入
    var pageType = "" //记录当前的pageCode
    
    // 加载进度条
    var progresslayer = CALayer()
    
    //查看电子发票需要的数据
    @objc var isLookInvocie = 0 //ture表示查看电子pdf格式电子发票
    @objc var orderId:String? //订单号
    @objc var orderTotalNum:String? //订单金额
    @objc var isLookRcPDF = 0 //ture表示查看退换货证明pdf格式
    public lazy var header: MJRefreshNormalHeader! = {
        let wk = self.webView as! WKWebView
        wk.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self,weak wk] in
            // 下拉刷新
            self?.reloadPage()
            wk?.scrollView.mj_header.endRefreshing()
        })
        let header = wk.scrollView.mj_header as! MJRefreshNormalHeader
        header.lastUpdatedTimeLabel.isHidden = true
        return header
    }()
    
    // MARK: - life cycle
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GLCookieSyncManager.shared()?.updateCookieName("pushId", value: FKYPush.sharedInstance()?.pushID ?? "")
        setupNotification()
        loadUrl()
        setupLoadingProgress()
        
        // 订单评价界面(杀掉中间控制器后，防止侧滑一半显示问题)
        if self.pushType != 0 {
            FKYNavigator.shared().topNavigationController.dragBackDelegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstAppear == true {
            interactiveDelegate.evaluateJs("viewWillAppear()")
        }
        isFirstAppear = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let ret = ((navigationController?.viewControllers.count)! - 1) > 0
        if !viewAppearOnce && ret {
            viewAppearOnce = true
        } else {
            interactiveDelegate.evaluateJs("nativeBack()")
        }
        
        header.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    
    deinit {
        print("GLWebVC deinit")
        GLCookieSyncManager.shared()?.updateCookieName("pushId", value: "")
        if self.webViewEngine != nil{
            self.webViewEngine.denitAddScript()
        }
    }
    // MARK: - ui
    fileprivate func setupNavigationBar() {
        // 不展示本地导航栏
        guard barStyle != .barStyleNotVisible else {
            return
        }
        
        // 展示本地导航栏
        var barColorStyle: FKYBarColorStyle = .whiteStyle // 导航栏背景色风格
        var barTitleStyle: FKYBarTitleStyle = .whiteStyle // 导航栏标题风格
        var barBackStyle: FKYBarBackStyle = .whiteStyle   // 导航栏返回按钮风格
        if barStyle == .barStyleRed {
            barColorStyle = .redStyle
            barTitleStyle = .redStyle
            barBackStyle = .redStyle
        }
        // 通过gl方式显示导航栏
        webViewEngine.evaluateJavaScript("document.title") { [weak self] (title, error) in
            if let strongSelf = self {
                var navTitle = ""
                var urlStr = ""
                if strongSelf.isLookInvocie != 0 {
                    //
                    navTitle = "发票详情"
                    //分享数据
                    urlStr = "gl://setupNavigation?param={\"bar\":{\"color\":\"\(barColorStyle.rawValue)\"},\"left\":{\"imgUrl\":\"\(barBackStyle.rawValue)\",\"hasBack\":true,\"isShutdown\":\(strongSelf.isShutDown)}, \"middle\":{\"title\":\"\(navTitle)\",\"color\":\"\(barTitleStyle.rawValue)\"},\"isShow\":\(true),\"right\":[{\"imgUrl\":\"https://m.yaoex.com/web/h5/maps/images/common/share.png\",\"buttonName\":\"\",\"callid\":\(9998),\"isLookInvoice\":\(strongSelf.isLookInvocie)}]}"
                }else if strongSelf.isLookRcPDF != 0{
                    //
                    navTitle = "退货证明"
                    //分享数据
                    urlStr = "gl://setupNavigation?param={\"bar\":{\"color\":\"\(barColorStyle.rawValue)\"},\"left\":{\"imgUrl\":\"\(barBackStyle.rawValue)\",\"hasBack\":true,\"isShutdown\":\(strongSelf.isShutDown)}, \"middle\":{\"title\":\"\(navTitle)\",\"color\":\"\(barTitleStyle.rawValue)\"},\"isShow\":\(true),\"right\":[{\"imgUrl\":\"https://m.yaoex.com/web/h5/maps/images/common/share.png\",\"buttonName\":\"\",\"callid\":\(9998),\"isLookRcPDF\":\(strongSelf.isLookRcPDF)}]}"
                }
                else {
                    //
                    if let titleStr = strongSelf.title {
                        navTitle = titleStr
                    }else if let titleStr = title as? String {
                        navTitle = titleStr
                    }
                    urlStr = "gl://setupNavigation?param={\"bar\":{\"color\":\"\(barColorStyle.rawValue)\"},\"left\":{\"imgUrl\":\"\(barBackStyle.rawValue)\",\"hasBack\":true,\"isShutdown\":\(strongSelf.isShutDown)}, \"middle\":{\"title\":\"\(navTitle)\",\"color\":\"\(barTitleStyle.rawValue)\"},\"isShow\":\(true)}"
                }
                if let url = URL.init(string: urlStr.urlEncodingUTF8()) {
                    let request = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 20.0)
                    strongSelf.webViewEngine.load(request)
                }
            }
        }
    }
    
    // 设置加载进度条相关
    fileprivate func setupLoadingProgress() {
        // 添加属性监听...<KVO监听WKWebView的"estimatedProgress"属性>
        webView.rx
            .observeWeakly(NSNumber.self, progressKey)
            .subscribe(onNext: { [weak self](process) in
                // 注意： number 为 Int? 类型
                if let selfStrong = self{
                    selfStrong.observeProgressChange(process?.floatValue ?? 1.0)
                }
            })
            .disposed(by: disposeBag)
        // 加入视图
        progresslayer.frame = CGRect.init(x: 0, y: getLoadingProgressPositonY(), width: SCREEN_WIDTH * 0.1, height: progressHeight)
        progresslayer.backgroundColor = RGBColor(0xFF2D5C).cgColor
        view.layer.addSublayer(progresslayer)
    }
}

// MARK: - override
extension GLWebVC {
    // MARK: 重载父类加载策略
    override func loadUrl() {
        // 去除url前后可能的空格
        optimizeUrl()
        
        if (hybridUrl != nil), hybridUrl.count > 0 {
            if GLHybridEnvironment.shared().openLocalWeb {
                localUrl = hybridUrl
            } else {
                urlPath = hybridUrl
            }
        }
        
        if (urlPath != nil), urlPath.count > 0, let url = URL.init(string: urlPath.urlEncodingUTF8()) {
            // 加载url链接
            let request = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 20.0)
            webViewEngine.load(request)
        }
        else if (htmlString != nil), htmlString.count > 0 {
            // 加载html内容
            webViewEngine.loadHTMLString(htmlString, baseURL: nil)
        }
        else {
            // 加载本地文件或错误页面
            loadErrorPage()
        }
    }
    //监听进度条的改变
    func observeProgressChange(_ processValue:Float){
        progresslayer.opacity = 1
        let value = processValue
        progresslayer.frame = CGRect.init(x: 0, y: getLoadingProgressPositonY(), width: (SCREEN_WIDTH * CGFloat(value)), height: progressHeight)
        if value == 1 {
            // 加载完成
            //weak var weakself = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 隐藏
                strongSelf.progresslayer.opacity = 0
            })
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 重置
                strongSelf.progresslayer.frame = CGRect.init(x: 0, y: strongSelf.getLoadingProgressPositonY(), width: 0, height: progressHeight);
            })
        }
    }
}

// MARK: - delegates
extension GLWebVC: WKNavigationDelegate {
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if webView.url?.absoluteString != nil {
            endRecording(webViewBrowser: (webView.url?.absoluteString)!)
        }
        webViewdidFailNavigation(navigation, withError: error)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startRecording()
        errorDelegate?.parentVC(self, didStartProvisionalNavigation: navigation)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadUrlSuccessOnce = true
        setupNavigationBar()
        if webView.url?.absoluteString != nil {
            endRecording(webViewBrowser: (webView.url?.absoluteString)!)
        }
        errorDelegate?.parentVC(self, didFinish: navigation)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if webView.url?.absoluteString != nil {
            endRecording(webViewBrowser: (webView.url?.absoluteString)!)
        }
        webViewdidFailNavigation(navigation, withError: error)
    }
}

// MARK: - action
extension GLWebVC {
    
}

// MARK: - notification
extension GLWebVC {
    // MARK: 监听登录状态变化
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(GLWebVC.loginStatuChanged(n:)), name: NSNotification.Name(rawValue: "GLCookiesDidChangedNotification"
        ), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GLWebVC.networkStatuChanged(n:)), name: NSNotification.Name.FKYNetworkingReachabilityDidChange, object: nil)
    }
    
    @objc fileprivate func loginStatuChanged(n: Notification) {
        // 通知h5登录信息改变了，需要重新获取登录信息
        interactiveDelegate.evaluateJs(GLCookieSyncManager.shared().documentCookieJavaScript() as String?)
        interactiveDelegate.evaluateJs("userStatusChange()")
    }
    
    @objc fileprivate func networkStatuChanged(n: Notification) {
        // 通知h5网络状态改变了
        let userinfo = n.userInfo as NSDictionary?
        let status = userinfo?.object(forKey: FKYNetworkingReachabilityNotificationStatusItem) as? NSNumber
        interactiveDelegate.evaluateJs("networkStatusChange\(status?.intValue ?? 0)")
    }
}

// MARK: - data
extension GLWebVC {
    // 获取加载进度度的Y轴位置
    fileprivate func getLoadingProgressPositonY() -> CGFloat {
        // 适配iPhoneX
        var top: CGFloat = WH(20) + WH(44)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X [88]
                top = iPhoneX_SafeArea_TopInset
            }
        }
        
        if barStyle != .barStyleNotVisible {
            // 展示本地导航栏
            return top
        }
        else {
            // 不展示本地导航栏
            if top == WH(64) {
                return WH(20)
            }
            else {
                return WH(44)
            }
        }
    }
}

// MARK: - private methods
@objc
extension GLWebVC {
    // MARK: URL优化
    fileprivate func optimizeUrl() {
        if (hybridUrl != nil), hybridUrl.count > 0 {
            hybridUrl = hybridUrl.trimmingCharacters(in: .whitespaces)
        }
        if (urlPath != nil), urlPath.count > 0 {
            urlPath = urlPath.trimmingCharacters(in: .whitespaces)
        }
        if (localUrl != nil), localUrl.count > 0 {
            localUrl = localUrl.trimmingCharacters(in: .whitespaces)
        }
        //        if (htmlString != nil), htmlString.count > 0 {
        //            htmlString = htmlString.trimmingCharacters(in: .whitespaces)
        //        }
    }
    
    // MARK: 加载本地失败备选页面
    fileprivate func loadErrorPage() {
        let vc = GLErrorVC.init()
        vc.urlPath = urlPath
        vc.parent = self
        errorDelegate = vc
        addChild(vc)
        view.addSubview(vc.view)
    }
    
    // MARK: 页面加载失败错误策略
    func webViewdidFailNavigation(_ navigation: WKNavigation!, withError error: Error) {
        errorDelegate?.parentVC(self, didFailProvisionalNavigation: navigation, withError: error)
        if !loadUrlSuccessOnce {
            loadErrorPage()
            loadUrlSuccessOnce = true
        }
    }
    
    /*
     1. 修改密码 https://m.yaoex.com/change_psw.html
     2. gl://getAppCookie?callid=1&param=%7B%7D
     */
    
    // MARK: 重定向加载策略
    
    func webView(_ webView: WKWebView, redirectFileURLForNavigationAction navigationAction: WKNavigationAction) -> Bool {
        // 重定向的url为空，不可继续(在当前页面)加载
        guard let abs = navigationAction.request.url?.absoluteString, abs.isEmpty == false else {
            return true
        }
        
        //let abs = navigationAction.request.url?.absoluteString
        print("redirect url:" + abs)
        
        // 针对H5子界面加载后无本地导航栏的处理...<当前只处理pdf，后续根据具体业务需求可能会新增其它类型>
        if let url = webView.url?.absoluteString, url.isEmpty == false {
            if url != abs {
                // 当前页面url与重定向url不相同时，走下面判断逻辑。
                if abs.hasPrefix("http") || abs.hasPrefix("https") {
                    // 只针对http/https
                    if abs.contains("pdf") {
                        // 目前只针对pdf，后续可以新增其它未知类型~!@
                        FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                            let controller = vc as! FKY_Web
                            controller.urlPath = abs
                            controller.barStyle = FKYWebBarStyle.barStyleWhite
                            // 通过url参数来判断是否显示本地导航栏
                            if let u = URL.init(string: abs) as NSURL? {
                                // https://m.yaoex.com/product.html?enterpriseId=180417&productId=110451
                                // http://p8.maiyaole.com/fky/pdf/protocol/rebate/10000004_1570776129745.pdf?appNeedTitle=1&appTitle=药方云
                                if let param = u.parameters() as? [String:String] {
                                    if let appNeedTitle = param["appNeedTitle"] {
                                        let needTitle = NSInteger(appNeedTitle)
                                        if needTitle == 1 {
                                            controller.barStyle = .barStyleWhite
                                        }
                                    }
                                    if let appFinishAlways = param["appFinishAlways"] {
                                        let finishAlways = NSInteger(appFinishAlways)
                                        if finishAlways == 1 {
                                            controller.isShutDown = true
                                        }
                                    }
                                    if let appTitle = param["appTitle"], appTitle.isEmpty == false {
                                        controller.title = appTitle
                                    }
                                }
                            }
                        })
                        return true
                    }
                }
            }
        }
        
        // 兼容老规则fky://跳转
        if abs.hasPrefix("fky://") {
            let str = (abs as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)
            if let strURL = str, let url = URL(string: strURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            return true
        }
        
        //        if abs.hasPrefix("weixin://") || abs.hasPrefix("alipay://") {
        //            let str = (abs as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        //            if let strURL = str, let url = URL(string: strURL) {
        //                if #available(iOS 10.0, *) {
        //                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //                } else {
        //                    UIApplication.shared.openURL(url)
        //                }
        //            }
        //            return true
        //        }
        //
        // 兼容老规则url拦截首页跳转，避免进入老版H5首页
        // http://m.yaoex.com/tryindex.html & https://m.yaoex.com/tryindex.html
        if abs.contains("m.yaoex.com/tryindex.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    // 跳转原生首页
                    FKYNavigator.shared().openScheme(FKY_TabBarController.self) { (vc) in
                        let v = vc as! FKY_TabBarController
                        v.index = 0
                    }
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转商品详情
        if abs.contains("m.yaoex.com/product.html") {
            let paramString = abs.components(separatedBy: "?").last
            let params = paramString?.components(separatedBy: "&")
            var productid = ""
            var enterpriseid = ""
            for (_, value) in (params?.enumerated())! {
                if value.hasPrefix("product") {
                    productid = value.components(separatedBy: "=").last!
                }
                if value.hasPrefix("enterprise") {
                    enterpriseid = value.components(separatedBy: "=").last!
                }
            }
            if productid.count > 0, enterpriseid.count > 0 {
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (viewController) in
                            let vc = viewController as! FKY_ProdutionDetail
                            vc.productionId = productid
                            vc.vendorId = enterpriseid
                        })
                    }
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转登录
        if abs.contains("m.yaoex.com/login.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if FKYLoginAPI.checkLoginExistByModelStyle() == false {
                        FKYNavigator.shared().openScheme(FKY_Login.self, setProperty: nil, isModal: true, animated: true)
                    }
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转店铺馆详情...<带商家id>
        if abs.contains("m.yaoex.com/shop.html?enterpriseId") {
            let enterpriseId = abs.components(separatedBy: "=").last
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    // 跳转前移除当前H5...<修复返回到H5时白屏bug>
                    //self.navigationController?.popViewController(animated: true)
                    // 跳转店铺详情
                    FKYNavigator.shared().openScheme(FKY_ShopItem.self, setProperty: { vc in
                        let viewController = vc as! FKYNewShopItemViewController
                        if let _ = enterpriseId {
                            viewController.shopId = enterpriseId
                        }
                    })
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转店铺馆列表...<不带商家id>
        if abs.contains("m.yaoex.com/shop.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    //self.navigationController?.popViewController(animated: true)
                    FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                        let v = vc as! FKY_TabBarController
                        v.index = 2
                    })
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转个人中心 AccountViewController
        if abs.contains("m.yaoex.com/account.html") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { vc in
                        let viewController = vc as! FKYTabBarController
                        viewController.index = 4
                    })
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转订单列表 FKYAllOrderViewController
        if abs.contains("m.yaoex.com/allorder.html") {
            DispatchQueue.global().async {[weak self] in
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    if strongSelf.fromFuson {
                        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { vc in
                            let viewController = vc as! FKYTabBarController
                            viewController.index = 4
                            FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { vc in
                                let viewController = vc as! FKYAllOrderViewController
                                viewController.status = "0"
                            })
                        })
                    }
                    else {
                        FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { vc in
                            let viewController = vc as! FKYAllOrderViewController
                            viewController.status = "0"
                        })
                    }
                }
            }
            return true
        }
        
        // 兼容老规则url拦截跳转订单详情...<带订单id> FKYOrderDetailViewController
        if abs.contains("m.yaoex.com/orderdetail.html?orderId") {
            let orderId = abs.components(separatedBy: "=").last
            DispatchQueue.global().async {[weak self] in
                //
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    if strongSelf.fromFuson {
                        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { vc in
                            let viewController = vc as! FKYTabBarController
                            viewController.index = 4
                            FKYNavigator.shared().openScheme(FKY_OrderDetailController.self, setProperty: { vc in
                                let viewController = vc as! FKYOrderDetailViewController
                                let model = FKYOrderModel()
                                if let _ = orderId {
                                    model?.orderId = orderId
                                    viewController.orderModel = model
                                }
                            })
                        })
                    }
                    else {
                        FKYNavigator.shared().openScheme(FKY_OrderDetailController.self, setProperty: { vc in
                            let viewController = vc as! FKYOrderDetailViewController
                            let model = FKYOrderModel()
                            if let _ = orderId {
                                model?.orderId = orderId
                                viewController.orderModel = model
                            }
                        })
                    }
                }
            }
            return true
        }
        if abs.contains("lu.10010.wiki/Shopping/Payment/WeiXinH5") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    let str = (abs as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)
                    if let strURL = str, let url = URL(string: strURL) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
            return true
        }
        self.resetPageCodeType(abs)
        
        return false
    }
    
    // MARK: 页面加载耗时统计埋点
    func startRecording() {
        YWSpeedUpManager.sharedInstance().start(with: ModuleType.fkyBrowser)
    }
    
    func endRecording(webViewBrowser absoluteString: String) {
        YWSpeedUpManager.sharedInstance().addBrowserString(absoluteString, endAndUpdateWith: ModuleType.fkyBrowser)
    }
}

// MARK: - FKYNavigationControllerDragBackDelegate
extension GLWebVC {
    func dragBackShouldStart(in navigationController: FKYNavigationController!) -> Bool {
        FKYNavigator.shared().pop()
        return false
    }
}
//MARK:重置页面类型
extension GLWebVC {
    func resetPageCodeType(_ url:String) {
        if url.hasPrefix("http") || url.hasPrefix("https") || url.hasPrefix("fky://") {
            if url.contains("m.yaoex.com/web/h5/maps"){
                var pageStr = ""
                if let u = URL.init(string: url) as NSURL? {
                    if let param = u.parameters() as? [String:String] {
                        if let pageId = param["pageId"] {
                            pageStr =  pageId
                        }
                    }
                }
                self.pageType = "maps|\(pageStr)"
            }else if url.contains("m.yaoex.com/h5/vipArea") {
                self.pageType = "vipSection"
            }else if url.contains("m.yaoex.com/h5/rebate") {
                self.pageType = "rebate"
            }else {
                self.pageType = ""
            }
        }
    }
}
