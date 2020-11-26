//
//  CurrentViewController.swift
//  FKY
//
//  Created by Rabe on 19/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class CurrentViewController {
    // 单例
    static let shared = CurrentViewController.init()
    private init(){}
    
    var item: UIViewController?
}
