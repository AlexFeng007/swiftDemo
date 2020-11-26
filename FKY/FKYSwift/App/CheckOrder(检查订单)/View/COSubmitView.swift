//
//  COSubmitView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  提交视图

import UIKit

class COSubmitView: UIView {
    // MARK: - Property
    
    // 提交订单回调
    var submitOrder: (()->())?
    
//    // 数量
//    fileprivate lazy var lblNumber: UILabel = {
//        let lbl = UILabel()
//        lbl.backgroundColor = .clear
//        lbl.font = UIFont.systemFont(ofSize: WH(12))
//        lbl.textColor = RGBColor(0x666666)
//        lbl.textAlignment = .left
//        //lbl.text = "6件商品"
//        return lbl
//    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(16))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.text = "实付金额:"
        return lbl
    }()
    
    // 金额
    fileprivate lazy var lblMoney: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(18))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .left
        //lbl.text = "¥ 1407.50"
        return lbl
    }()
    
    // 提交订单btn
    fileprivate lazy var btnSubmit: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("提交订单", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(16))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.submitOrder else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
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
//        backgroundColor = RGBColor(0xF4F4F4)
        backgroundColor = .white
        
        addSubview(btnSubmit)
        addSubview(lblTitle)
        addSubview(lblMoney)
//        addSubview(lblNumber)
        
        btnSubmit.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-WH(10))
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(116))
        }
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
//            make.bottom.equalTo(self).offset(-WH(10))
//            make.height.equalTo(WH(22))
            make.centerY.equalTo(btnSubmit)
        }
        lblMoney.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblTitle)
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            //make.right.equalTo(btnSubmit.snp.left).offset(-WH(10))
//            make.height.equalTo(WH(22))
        }
//        lblNumber.snp.makeConstraints { (make) in
//            make.left.equalTo(lblTitle)
//            make.bottom.equalTo(lblTitle.snp.top).offset(-WH(2))
//            make.height.equalTo(WH(16))
//        }
        
        // 上分隔线
        let viewLineTop = UIView()
        viewLineTop.backgroundColor = RGBColor(0xE5E5E5)
        self.addSubview(viewLineTop)
        viewLineTop.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(0.8)
        }
    }
    
    
    // MARK: - Public
    
    func configView(amount: String?, number: Int) {
//        lblNumber.text = "\(number)" + "件商品"
        var text = "¥ 0.00"
        if let amount = amount, amount.isEmpty == false {
            text = amount
        }
        
        let priceMutableStr = NSMutableAttributedString.init(string: text)
        if text.hasPrefix("¥") {
            priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(14))], range: NSMakeRange(0, 1))
        }
        lblMoney.attributedText = priceMutableStr
    }
}
