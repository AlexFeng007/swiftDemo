//
//  RITopTipView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]顶部文字提示视图

import UIKit

class RITopTipView: UIView {
    // MARK: - Property
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0xE8772A)
        lbl.textAlignment = .center
        lbl.text = "企业名称请与营业执照保持一致，否则卖家会拒绝为您发货"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFCF1)
        
        addSubview(lblTip)
        lblTip.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: WH(8), left: WH(10), bottom: WH(8), right: WH(10)))
        }
    }
    
    
    // MARK: - Public
    
    func configView(_ tip: String?) {
        lblTip.text = tip
    }
    
    // 计算高度
    func getContentHeight() -> CGFloat {
        // 文本内容高度...<默认高度16>
        var heightTxt = WH(16)
        if let txt = lblTip.text, txt.isEmpty == false {
            // 计算高度
            let size = txt.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(20), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12))], context: nil).size
            heightTxt = size.height
            // 最小高度
            if heightTxt <= WH(16) {
                heightTxt = WH(16)
            }
        }
        return heightTxt + WH(16)
    }
}
