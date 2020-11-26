//
//  RDVTabBarItemExtension.swift
//  FKY
//
//  Created by Rabe on 12/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import RDVTabBarController.RDVTabBarItem

extension RDVTabBarItem {
    
    fileprivate struct AssociatedKeys {
        static var redPointKey = "redPointKey"
    }
    
    // MARK: - properties
    var redPoint: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.redPointKey) as? UIView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.redPointKey,
                    newValue as UIView?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    // MARK: - life cycle
    @objc func setupRedpoint() {
        if redPoint == nil {
            let rp = UIView()
            rp.backgroundColor = RGBColor(0xff2d5c)
            rp.layer.cornerRadius = 4

            addSubview(rp)
            rp.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: WH(8), height: WH(8)))
                if #available(iOS 11, *) {
                    let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                    if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                        make.top.equalTo(self).offset(WH(9))
                    } else {
                        make.top.equalTo(self).offset(WH(3))
                    }
                } else {
                    make.top.equalTo(self).offset(WH(3))
                }
                
                make.centerX.equalTo(self).offset(WH(10))
            }
            
            redPoint = rp
        }
    }
    
    // MARK: - delegates
    
    // MARK: - action
    @objc func updateRedpointVisiblity(withCount count: Int) {
        redPoint?.isHidden = count <= 0
    }
    
    // MARK: - data
    
    // MARK: - ui
    
    // MARK: - private methods
    
}
