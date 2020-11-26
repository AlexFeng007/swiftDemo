//
//  PDRecommendTitleView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之同品热卖cell中的标题视图

import UIKit

class PDRecommendTitleView: UIView {
    // MARK: - Property
    
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel(frame: CGRect.zero)
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(17))
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0x333333)
        lbl.text = "同品热卖"
        return lbl
    }()
    
    // 标题
    var title: String! = "同品热卖" {
        didSet {
            if let t = title, t.isEmpty == false {
                lblTitle.text = t
            }
            else {
                lblTitle.text = "同品热卖"
            }
        }
    }
    
    
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
        
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: WH(10), left: WH(20), bottom: WH(0), right: WH(20)))
        }
    }
}
