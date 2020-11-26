//
//  FKYCategoryWebViewController.swift
//  FKY
//
//  Created by airWen on 2017/6/30.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  分类(H5)

import UIKit

@objc(FKYCategoryWebViewController)

class FKYCategoryWebViewController: GLWebVC {
    //
    @objc var categoryId: String = ""  {
        didSet {
            if categoryId != "" {
                let token : String = "localStorage.setItem('categoryId', '\(categoryId)')"
                interactiveDelegate.evaluateJs(token)
                reloadPage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive), name: UIApplication.willResignActiveNotification, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func appResignActive() {
        let token : String = "localStorage.setItem('categoryId', '')"
        interactiveDelegate.evaluateJs(token)
        reloadPage()
    }
}
