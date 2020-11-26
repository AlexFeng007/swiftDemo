//
//  COShareStockTipView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/5/30.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  检查订单界面之底部共享库存提示视图

import UIKit

class COShareStockTipView: UIView {
    // MARK: - Property
    
    // 标题
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.text = ""
        lbl.textColor = RGBColor(0xE8772A)
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFCF1)
        
        addSubview(lblTip)
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(10))
            make.right.equalTo(self).offset(-WH(10))
            //make.top.bottom.equalTo(self)
            make.top.equalTo(self).offset(WH(6))
            make.bottom.equalTo(self).offset(-WH(6))
        }
    }
    
    
    // MARK: - Public
    
    func setTitle(_ title: String?) {
        lblTip.text = title
    }
    
    func changeTitleAligment() {
        lblTip.textAlignment = .left
    }
    
    
    // MARK: - Class
    
    // 计算高度...<设置上、下限>
    class func calculateTxtHeight(_ title: String) -> CGFloat {
        let size = title.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(20), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12))], context: nil).size
        var height = size.height + 2
        // 最小一行高度
        if height < WH(16) {
            height = WH(16)
        }
        // 最多4行高度
        if height > WH(60) {
            height = WH(60)
        }
        
        return height + WH(16)
    }
}
