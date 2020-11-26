//
//  ShopCoupleProductHeadView.swift
//  FKY
//
//  Created by 寒山 on 2019/11/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ShopCoupleProductHeadView: UIView {
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = RGBColor(0xFF2D5C);
        label.textAlignment = .center
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBColor(0xFFEDE7)
        self.titleLabel.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
            make.left.equalTo(self).offset(WH(13))
            make.right.equalTo(self).offset(WH(-13))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("RIImageCCell layoutSubviews")
    }
    func configView(_ title: String?) {
        //self.titleLabel.text = title! + "优惠券可用商"
        self.titleLabel.text = title!
    }
}
