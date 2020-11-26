//
//  COGetRebateTipView.swift
//  FKY
//
//  Created by My on 2019/12/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class COGetRebateTipView: UIView {
    
    // 标题
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.text = ""
        lbl.textColor = RGBColor(0xE8772A)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFCF1)
        
        addSubview(lblTip)
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(10))
            make.right.equalTo(self).offset(-WH(10))
            make.centerY.equalToSuperview()
        }
    }
    
    func showTip(_ tipStr: String) {
        lblTip.text = "订单完成后可获返利金" + tipStr
    }
}
