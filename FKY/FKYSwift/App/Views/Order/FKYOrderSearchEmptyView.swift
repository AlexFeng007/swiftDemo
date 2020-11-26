//
//  FKYOrderSearchEmptyView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYOrderSearchEmptyView: UIView {

    
    fileprivate var logo: UIImageView?
    var tip: UILabel?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
        setupView()
    }
    
    func setupView() {
        logo = {
            let img = UIImageView()
            self.addSubview(img)
            img.image = UIImage.init(named: "searchEmpty_icon")
            img.contentMode = .scaleAspectFit
            img.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.top).offset(WH(166))
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(WH(88))
                 make.height.equalTo(WH(80))
            })
            return img
        }()
        
        tip = {
            let lab = UILabel()
            self.addSubview(lab)
            lab.textAlignment = .center
            lab.contentMode = .scaleAspectFit
            lab.text = "暂无相关的订单"
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.logo!.snp.bottom).offset(WH(21))
                make.left.right.equalTo(self)
            })
            lab.fontTuple = t16
            return lab
        }()
    }

}
