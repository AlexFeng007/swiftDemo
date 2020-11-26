//
//  FKYRetailView.swift
//  FKY
//
//  Created by hui on 2019/2/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//  搜索/商详之建议零售价&毛利

import UIKit

//建议零售价和毛利
class FKYRetailView: UIView {
    // MARK: - Property
    
    //建议零售价背景view
    fileprivate lazy var bgRetailView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFEDE7)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(9)
        return view
    }()
    //建议零售价数字
    fileprivate lazy var retailPriceNumLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //毛利背景view
    fileprivate lazy var bgProfitView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFEDE7)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(9)
        return view
    }()
    //毛利数字
    fileprivate lazy var profitNumLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    // MARK: - UI
    
    fileprivate func setupView() {
        //零售价
        addSubview(bgRetailView)
        bgRetailView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self).offset(WH(6))
            make.height.equalTo(WH(18))
            make.width.lessThanOrEqualTo(WH(60+80))
            make.width.greaterThanOrEqualTo(WH(80))
        }
        bgRetailView.addSubview(retailPriceNumLabel)
        retailPriceNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgRetailView.snp.left).offset(WH(6))
            make.right.equalTo(bgRetailView.snp.right).offset(-WH(6))
            make.top.equalTo(bgRetailView)
            make.height.equalTo(bgRetailView.snp.height)
        }
        
        //毛利
        addSubview(bgProfitView)
        bgProfitView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(6))
            make.left.equalTo(bgRetailView.snp.right).offset(WH(7))
            make.height.equalTo(bgRetailView.snp.height)
            make.width.lessThanOrEqualTo(WH(40+50))
            make.width.greaterThanOrEqualTo(WH(50))
        }
        bgProfitView.addSubview(profitNumLabel)
        profitNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgProfitView.snp.left).offset(WH(6))
            make.right.equalTo(bgProfitView.snp.right).offset(-WH(6))
            make.top.equalTo(bgProfitView)
            make.height.equalTo(bgRetailView.snp.height)
        }
    }
    
    
    // MARK: - Public
    
    func configRetailViewData(_ shopPrice: Float?, _ retailPrice: Float?) {
        if shopPrice != nil && retailPrice != nil {
            bgRetailView.isHidden = false
            bgProfitView.isHidden = false
            retailPriceNumLabel.text = String.init(format: "零售价 ¥%.2f", retailPrice!)
            profitNumLabel.text = String.init(format: "毛利%d%@", lroundf((retailPrice!-shopPrice!)/retailPrice!*100), "%")
        }
        else {
           bgRetailView.isHidden = true
           bgProfitView.isHidden = true
        }
    }
}
