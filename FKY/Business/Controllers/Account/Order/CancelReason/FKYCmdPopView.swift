//
//  FKYCmdPopView.swift
//  FKY
//
//  Created by My on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

@objc class FKYCmdPopView: UIView, UIGestureRecognizerDelegate {
    let colorAlpha = 0.6 //透明度
    //子view
    private var popSubView: UIView?
    //子view height
    private var popSubViewHeight: CGFloat = 0.0
    
    
    //frame 取mainsScreen
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FKYCmdPopView {
    
    //关闭弹窗
    @objc func hidePopView() {
        guard let _ = popSubView, self.superview != nil else {
            return
        }
        closePopView()
    }
    
    //展示弹窗
    @objc func showSubView(subView: UIView?, toVC: UIViewController?, subHeight: CGFloat) {
        guard let sub = subView, let vc = toVC else { return }
        
        popSubViewHeight = subHeight
        
        if self.superview == nil {
            vc.view.addSubview(self)
            vc.view.bringSubviewToFront(self)
        }
        
        if let lastSubView = popSubView {
            if lastSubView == sub {
                lastSubView.snp_updateConstraints { (make) in
                    make.height.equalTo(popSubViewHeight)
                }
            }else {
                lastSubView.removeFromSuperview()
                fkyAddPopsubView(sub)
            }
        }else {
            fkyAddPopsubView(sub)
        }
        
        if let popSub = popSubView {
            popSub.snp_updateConstraints { (make) in
                make.top.equalTo(self).offset(SCREEN_HEIGHT - popSubViewHeight)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.backgroundColor = RGBAColor(0x000000, alpha: 0.6)
                strongSelf.layoutIfNeeded()
            }
        })
    }
    
    //添加subview
    func fkyAddPopsubView(_ subView: UIView) {
        popSubView = subView
        addSubview(popSubView!)
        
        popSubView?.snp_remakeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(SCREEN_HEIGHT)
            make.height.equalTo(popSubViewHeight)
        })
        
        layoutIfNeeded()
    }
}


extension FKYCmdPopView {
    //加手势
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            if let strongSelf = self {
                strongSelf.closePopView()
            }
        }).disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    
    
    func closePopView() {
        if let subView = popSubView , subView.superview != nil {
            subView.endEditing(true)
            subView.snp_updateConstraints { (make) in
               make.top.equalToSuperview().offset(SCREEN_HEIGHT)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.backgroundColor = .clear
                strongSelf.layoutIfNeeded()
            }
        }) { [weak self](_) in
            if let strongSelf = self, strongSelf.superview != nil {
                strongSelf.removeFromSuperview()
            }
        }
    }
    
    //MARK - delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self)
        if let subView = popSubView {
            if subView.frame.contains(point) {
                return false
            }
        }
        return true
    }
}
