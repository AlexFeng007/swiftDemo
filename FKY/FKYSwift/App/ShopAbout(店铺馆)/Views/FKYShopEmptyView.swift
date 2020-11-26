//
//  FKYShopEmptyView.swift
//  FKY
//
//  Created by yyc on 2020/11/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopEmptyView: UIView {
    //MARK:ui属性
    //图标
    fileprivate var tipImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_empty_pic")
        return img
    }()
    
    //提示文字
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.fontTuple = t16
        label.text = "网络异常状态"
        return label
    }()
    
    // 重新加载按钮
    fileprivate lazy var fucntionBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.layer.cornerRadius = WH(13)
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = WH(1)
        btn.layer.borderColor = t73.color.cgColor
        btn.setTitle("重新加载", for: .normal)
        btn.setTitleColor(t73.color, for: .normal)
        btn.titleLabel?.font = t16.font
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickViewBlock {
                block(1)
            }
        }).disposed(by: disposeBag)
        return btn
    }()
    
    //业务属性
    var clickViewBlock : ((Int)->(Void))?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xf4f4f4)
        self.addSubview(tipImageView)
        tipImageView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(WH(90));
            make.width.equalTo(WH(103))
            make.height.equalTo(WH(106))
        })
        self.addSubview(tipLabel)
        tipLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(tipImageView.snp.bottom).offset(WH(14))
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(WH(20))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(10))
        })
        self.addSubview(fucntionBtn)
        fucntionBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(WH(10))
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(90))
        })
    }
}

