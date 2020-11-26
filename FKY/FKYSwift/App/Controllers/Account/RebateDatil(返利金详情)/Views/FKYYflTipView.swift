//
//  FKYYflTipView.swift
//  FKY
//
//  Created by yyc on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYYflTipView: UIView {
    //背景view
    fileprivate lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFEDD7)
        view.layer.cornerRadius = WH(8)
        view.layer.masksToBounds = true
        view.bk_(whenTapped:  { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickYflView {
                block()
            }
        })
        return view
    }()
    //返利金描述
    fileprivate lazy var rebateLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x3B3030)
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.8
        return lb
    }()
    //提示
    fileprivate lazy var tipLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x856D6D)
        lb.text = "加入福利社立即领取"
        lb.font = t7.font
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.8
        return lb
    }()
    // 领取按钮
    fileprivate lazy var getBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = RGBColor(0xFF2C5C)
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.setTitle("点击领取>", for: .normal)
        btn.titleLabel?.font = t28.font
        btn.layer.cornerRadius = WH(8.5)
        btn.layer.masksToBounds = true
        btn.isUserInteractionEnabled = false
//        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
//            guard let strongSelf = self else {
//                return
//            }
//            if let block = strongSelf.clickYflView {
//                block()
//            }
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //
    fileprivate lazy var tipImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "yfl_tip_pic")
        return iv
    }()
    
    var clickYflView :(()->Void)? //点击领取
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension FKYYflTipView {
    fileprivate func setupUI() {
        self.backgroundColor = RGBColor(0xF2F2F2)
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.right.equalTo(self.snp.right).offset(-WH(10))
            make.left.equalTo(self.snp.left).offset(WH(10))
            make.bottom.equalTo(self.snp.bottom).offset(-WH(9))
        }
        bgView.addSubview(tipImgView)
        tipImgView.snp.makeConstraints { (make) in
            make.right.equalTo(bgView.snp.right).offset(-WH(6))
            make.centerY.equalTo(bgView)
            make.height.equalTo(WH(80))
            make.width.equalTo(WH(83))
        }
        bgView.addSubview(rebateLabel)
        rebateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(WH(16))
            make.top.equalTo(bgView.snp.top).offset(WH(21))
            make.right.equalTo(tipImgView.snp.left).offset(-WH(5))
        }
        bgView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rebateLabel.snp.left)
            make.bottom.equalTo(bgView.snp.bottom).offset(-WH(19))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(195))
        }
        bgView.addSubview(getBtn)
        getBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(tipLabel.snp.centerY)
            make.left.equalTo(tipLabel.snp.right).offset(WH(5))
            make.width.equalTo(WH(60))
            make.height.equalTo(WH(17))
        }
    }
    func configTipData() {
        let moneyStr = "返利金"
        let contentStr = "您有一笔\(moneyStr)待领取"
        let moneyRange = (contentStr as NSString).range(of: moneyStr)
        let attribute: NSMutableAttributedString = NSMutableAttributedString.init(string: contentStr)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFF2C5C), range: moneyRange)
        rebateLabel.attributedText = attribute
    }
}
