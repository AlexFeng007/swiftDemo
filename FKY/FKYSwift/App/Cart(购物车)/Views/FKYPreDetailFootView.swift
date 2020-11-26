//
//  FKYPreDetailFootView.swift
//  FKY
//
//  Created by yyc on 2019/12/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYPreDetailFootView: UIView {
    //总计金额
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font =  t17.font
        label.textColor = t73.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .right
        return label
    }()
    //
    fileprivate lazy var totalDesLabel : UILabel = {
        let label = UILabel()
        label.text = "合计："
        label.font =  t61.font
        label.textColor = t48.color
        label.textAlignment = .right
        return label
    }()
    //可用券
    fileprivate lazy var canUseNumLabel : UILabel = {
        let label = UILabel()
        label.fontTuple =  t8
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //顶部分隔线
    fileprivate lazy var topLine : UIView = {
        let view = UIView()
        view.backgroundColor = t11.color
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = UIColor.white
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-WH(13))
            make.right.equalTo(self.snp.right).offset(-WH(15))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH/2.0)
            make.height.equalTo(WH(14))
        })
        self.addSubview(totalDesLabel)
        totalDesLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.right.equalTo(priceLabel.snp.left)
            make.width.equalTo(WH(40))
        })
        self.addSubview(canUseNumLabel)
        canUseNumLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.right.equalTo(totalDesLabel.snp.left).offset(-WH(12))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH/2.0-WH(50))
        })
        self.addSubview(topLine)
        topLine.snp.makeConstraints({ (make) in
            make.bottom.equalTo(priceLabel.snp.top).offset(-WH(7))
            make.right.equalTo(self.snp.right).offset(-WH(5))
            make.left.equalTo(self.snp.left).offset(WH(5))
            make.height.equalTo(WH(1))
        })
        
    }
    
}
extension FKYPreDetailFootView {
    func configPreDetailFootViewData(_ desModel :CartMerchantInfoModel) {
        if let num = desModel.canUseCouponMoney {
            canUseNumLabel.text = String.init(format: "可用券商品¥%.2f",num.doubleValue)
        }else{
             canUseNumLabel.text = ""
        }
        if desModel.desTotalAmount > 0 {
            priceLabel.text = String.init(format: "¥%.2f",desModel.desTotalAmount)
        }else{
            priceLabel.text = ""
           
        }
    }
}
