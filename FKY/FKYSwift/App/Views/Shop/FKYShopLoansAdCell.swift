//
//  FKYShopLoansAdCell.swift
//  FKY
//
//  Created by Andy on 2018/10/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  药贷广告 - 连续滚动横幅

import UIKit

class FKYShopLoansAdCell: UICollectionReusableView {

    fileprivate func setupView() {
        self.backgroundColor = RGBColor(0xFFFCF1)
        
        let view = LMJScrollTextView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), textScrollModel: LMJTextScrollContinuous, direction: LMJTextScrollMoveLeft)
        self.addSubview(view!)
        view?.startScroll(withText: "【1药贷】上线，采药也能打白条啦！单体药店/个体诊所顾客至App【我的】→【1药贷】申请开通！", textColor: RGBColor(0xE8772A), font: UIFont.systemFont(ofSize: WH(12)))
        let gesture = UITapGestureRecognizer(target:self ,action: #selector(singleTap))
        view?.addGestureRecognizer(gesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func singleTap(){
        FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { vc in
            let viewController = vc as! FKYTabBarController
            viewController.index = 4
        })
    }
}
