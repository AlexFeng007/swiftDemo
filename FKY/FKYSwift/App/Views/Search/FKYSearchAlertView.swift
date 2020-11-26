//
//  FKYSearchAlertView.swift
//  FKY
//
//  Created by mahui on 16/8/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift

@objc
public enum FKYSearchBarAlertViewselectedState : Int {
    case product
    case shop
}

@objc
protocol FKYSearchBarAlertViewDelegate {
    @objc optional func searchBarAlertViewSelectIndex(_ alertView : FKYSearchBarAlertView, state : FKYSearchBarAlertViewselectedState)
}

typealias AlertViewAppear = ()->Void
typealias AlertViewDismiss = ()->Void


class FKYSearchBarAlertView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc var alertViewAppear : AlertViewAppear?
    @objc var alertViewDismiss : AlertViewDismiss?
    @objc weak var delegate : FKYSearchBarAlertViewDelegate?
    var isAppear : Bool?
    
    func setupView() -> () {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage.init(named: "icon_search_alert")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        let line = UIView.init()
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(j1)
            make.right.equalTo(self.snp.right).offset(-j1)
            make.bottom.equalTo(self.snp.bottom).offset(-h11)
            make.height.equalTo(FKYWHWith2ptWH(0.5));
        }
        line.backgroundColor = m4
        
        let product = UIButton.init(type: UIButton.ButtonType.system)
        self.addSubview(product)
        product.snp.makeConstraints { (make) in
            make.bottom.equalTo(line.snp.top);
            make.left.right.equalTo(self);
            make.height.equalTo(h11);
        }
        product.setTitle("商品", for: UIControl.State())
        product.titleLabel!.font = tx1.defaultStyle.font
        product.setTitleColor(tx1.defaultStyle.color, for: UIControl.State())
        _ = product.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.selectedIndex(.product)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let shop = UIButton.init(type: UIButton.ButtonType.system)
        self.addSubview(shop)
        shop.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(h11);
        }
        shop.setTitle("店铺", for: UIControl.State())
        shop.titleLabel!.font = tx1.defaultStyle.font
        shop.setTitleColor(tx1.defaultStyle.color, for: UIControl.State())
        _ = shop.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.selectedIndex(.shop)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    @objc func selectedIndex(_ state : FKYSearchBarAlertViewselectedState) -> () {
        if let delegate = self.delegate {
            delegate.searchBarAlertViewSelectIndex!(self, state:state)
        }
    }
    
}
