//
//  FKYCenterContentTextView.swift
//  FKY
//
//  Created by airWen on 2017/7/20.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYCenterContentTextView: UITextView {
    //MARK: Custom Public Method
    func centerTextContainerView() {
        if (self.textInputView.frame.height < frame.height) {
                let center: CGPoint  = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5);
                self.textInputView.center = center;
            } else {
                self.textInputView.frame = CGRect(x: 0, y: 0, width: self.textInputView.frame.size.width, height: self.textInputView.frame.size.height)
            }
//        if let viewTextontainer: UIView = subviews.first {
//            if (viewTextontainer.frame.height < frame.height) {
//                let center: CGPoint  = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5);
//                viewTextontainer.center = center;
//            } else {
//                viewTextontainer.frame = CGRect(x: 0, y: 0, width: viewTextontainer.frame.size.width, height: viewTextontainer.frame.size.height)
//            }
//        }
    }
    
    //MARK: Override Property
    override var frame: CGRect {
        didSet {
            if !frame.equalTo(CGRect.zero) {
                centerTextContainerView()
            }
        }
    }
    
    override var text: String! {
        didSet {
            if let contentText = text, contentText != "" {
                centerTextContainerView()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !frame.equalTo(CGRect.zero) {
            centerTextContainerView()
        }
    }
}
