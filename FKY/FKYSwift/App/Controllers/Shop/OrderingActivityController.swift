//
//  OrderingActivityController.swift
//  FKY
//
//  Created by mahui on 2016/12/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation

let url:String = "https://m.yaoex.com/blob/activity_rules.html"

class OrderingActivityController: UIViewController,UIWebViewDelegate {
    
    fileprivate var webView:UIWebView?
    fileprivate var navBar:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.fky_setupTitleLabel("活动时间")
        self.NavigationTitleLabel!.fontTuple = t14
        
        self.webView = {
            let view = UIWebView.init()
            self.view.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(self.view)
                make.top.equalTo((self.navBar?.snp.bottom)!)
            })
            view.delegate = self
            let request = URLRequest.init(url: URL.init(string: url)!)
            view.loadRequest(request)
            return view
        }()
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.showLoading()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.dismissLoading()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        WUMonitor.shared().saveWebLoadingError(webView.request?.url?.absoluteString, error: error)
    }
}
