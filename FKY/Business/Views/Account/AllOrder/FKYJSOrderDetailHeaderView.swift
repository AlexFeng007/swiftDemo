//
//  FKYJSOrderDetailHeaderView.swift
//  FKY
//
//  Created by mahui on 16/9/14.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation

import SnapKit

class FKYJSOrderDetailHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var icon : UIImageView?
    fileprivate var supply : UILabel?
    fileprivate var contact : UILabel?
    
    func setupView() -> () {
        icon = {
            let view = UIImageView()
            self.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(j1)
                make.top.equalTo(self.snp.top).offset(j1)
                make.width.equalTo(WH(20))
                make.height.equalTo(WH(20))
            })
            view.image = UIImage.init(named: "icon_account_shop_image") 
            return view
        }()
        
        supply = {
            let view = UILabel()
            self.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.icon!.snp.right).offset(j1)
                make.centerY.equalTo(self.icon!)
                make.width.equalTo(WH(200))
            })
            view.font = t7.font
            view.textColor = t7.color
            return view
        }()
        
        contact = {
            let view = UILabel()
            self.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(self.snp.right).offset(-j1)
                make.centerY.equalTo(self.icon!)
                make.width.equalTo(WH(120))
            })
            view.font = t25.font
            view.textColor = t25.color
            return view
        }()
        
        let line = UIView()
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(j1)
            make.right.equalTo(self).offset(-j1)
            make.bottom.equalTo(self)
            make.height.equalTo(WH(0.5))
        }
        line.backgroundColor = m2
    }
    
    @objc func configViewWithModel(_ model : FKYOrderModel) -> () {
        supply?.text = model.supplyName
        if model.qq != nil {
            //
        }
    }

}
