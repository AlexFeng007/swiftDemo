//
//  LiveListEmptyView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveListEmptyView: UIView {
    
    fileprivate var logo: UIImageView?
    var tip: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect.null)
        self.backgroundColor = RGBColor(0xF4F4F4)
        setupView()
    }
    
    func setupView() {
        logo = {
            let img = UIImageView()
            self.addSubview(img)
            img.image = UIImage.init(named: "live_list_empty_icon")
            img.contentMode = .scaleAspectFit
            img.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.top).offset(WH(134))
                make.centerX.equalTo(self.snp.centerX)
                make.height.equalTo(WH(83))
                make.width.equalTo(WH(74))
            })
            return img
        }()
        
        tip = {
            let lab = UILabel()
            self.addSubview(lab)
            lab.textAlignment = .center
            lab.contentMode = .scaleAspectFit
            lab.text = "暂无直播内容"
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.logo!.snp.bottom).offset(WH(15))
                make.left.right.equalTo(self)
            })
            lab.fontTuple = t16
            return lab
        }()
    }
    func configTips(_ tips:String){
        tip!.text = tips
    }
}
