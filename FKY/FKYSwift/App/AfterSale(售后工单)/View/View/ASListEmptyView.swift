//
//  ASListEmptyView.swift
//  FKY
//
//  Created by 寒山 on 2019/5/8.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ASListEmptyView: UIView {

    
    fileprivate var logo: UIImageView?
    var tip: UILabel?
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect.null)
        self.backgroundColor = bg1
        setupView()
    }
    
    func setupView() {
        logo = {
            let img = UIImageView()
            self.addSubview(img)
            img.image = UIImage.init(named: "as_empty")
            img.contentMode = .scaleAspectFit
            img.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.top).offset(WH(108))
                make.centerX.equalTo(self.snp.centerX)
                make.height.width.equalTo(WH(100))
            })
            return img
        }()
        
        tip = {
            let lab = UILabel()
            self.addSubview(lab)
            lab.textAlignment = .center
            lab.contentMode = .scaleAspectFit
            lab.text = "暂无已申请的记录"
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.logo!.snp.bottom).offset(WH(15))
                make.left.right.equalTo(self)
            })
            lab.fontTuple = t16
            return lab
        }()
    }
}
