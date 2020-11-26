//
//  HomeSpaceContentCell.swift
//  FKY
//
//  Created by 寒山 on 2019/7/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class HomeSpaceContentCell: UITableViewCell {

    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear//RGBColor(0xffffff)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(contentView);
        })
    
    }

}
