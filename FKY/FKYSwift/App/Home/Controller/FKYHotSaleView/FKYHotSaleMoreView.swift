//
//  FKYHotSaleMoreView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)热销商品之查看更多视图

import UIKit
import RxSwift

class FKYHotSaleMoreView: UIView {
    // MARK: - Property
    
    // closure
    var seeMoreCallback: (()->())? // 查看更多
    
    fileprivate lazy var btnMore: UIButton! = {
        let view = UIButton.init(type: .custom)
        view.backgroundColor = UIColor.clear
        view.setTitle("更多热销商品 >", for: .normal)
        view.setTitleColor(RGBColor(0x666666), for: .normal)
        view.setTitleColor(RGBColor(0x666666).withAlphaComponent(0.6), for: .highlighted)
        view.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        view.titleLabel?.textAlignment = .center
        view.rx.tap.bind(onNext: { [weak self] in
            if let closure = self?.seeMoreCallback {
                closure()
            }
        }).disposed(by: disposeBag)
        return view
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.white
        
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.right.top.equalTo(self)
            make.left.equalTo(self).offset(WH(10))
            make.height.equalTo(0.5)
        }
        
        addSubview(btnMore)
        btnMore.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
