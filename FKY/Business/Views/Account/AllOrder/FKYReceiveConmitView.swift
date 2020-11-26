//
//  FKYReceiveConmitView.swift
//  FKY
//
//  Created by mahui on 16/9/19.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  mp确认收货界面底部操作栏

import Foundation
import SnapKit

import RxSwift

typealias CancleCallBack = ()->()
typealias ConmitCallBack = ()->()


class FKYReceiveConmitView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc var cancleCallBack : CancleCallBack?
    @objc var conmitCallBack : ConmitCallBack?
    
    fileprivate func setupView() -> () {
        let btn = UIButton()
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(j8)
            make.centerY.equalTo(self)
            make.height.equalTo(btn17.size.height)
            make.width.equalTo(btn17.size.width)
        }
        btn.setTitle("取消", for: UIControl.State())
        btn.setTitleColor(btn17.title.color, for: UIControl.State())
        btn.titleLabel?.font = btn17.title.font
        btn.layer.borderWidth = btn17.border.width
        btn.layer.borderColor = btn17.border.color.cgColor
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
               return
            }
            if strongSelf.cancleCallBack != nil {
                strongSelf.cancleCallBack!()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let conmit = UIButton()
        self.addSubview(conmit)
        conmit.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-j8)
            make.centerY.equalTo(self)
            make.height.equalTo(btn1.size.height)
            make.width.equalTo(btn1.size.width)
        }
        conmit.setTitle("确定", for: UIControl.State())
        conmit.setTitleColor(btn1.title.color, for: UIControl.State())
        conmit.titleLabel?.font = btn1.title.font
        conmit.backgroundColor = btn1.defaultStyle.color
        _ = conmit.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
               return
            }
            if strongSelf.conmitCallBack != nil {
                strongSelf.conmitCallBack!()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        // 顶底分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xebedec)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}
