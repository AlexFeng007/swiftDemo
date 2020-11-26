//
//  FKYHomePageSpreadView.swift
//  FKY
//
//  Created by yyc on 2020/11/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageSpreadView: UIView {
    
    var clickTipView : ((Int)->Void)? //点击视图
    //logo图片
    fileprivate lazy var logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named:"home_spread_pic")
        return imgView
    }()
    
    //提示文字
    fileprivate lazy var tipLabel: UILabel! = {
        let lbl = UILabel()
        lbl.font = t21.font
        lbl.textColor = t34.color
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        lbl.lineBreakMode = .byTruncatingMiddle
        return lbl
    }()
    // 叉叉
    fileprivate lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        //
        btn.setImage(UIImage(named:"home_spread_cancel_pic"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTipView {
                block(0)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RGBAColor(0x000000, alpha: 0.6385)
        self.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.clickTipView {
                    block(1)
                }
            }
        })
        self.addSubview(logoImageView)
        logoImageView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp.left).offset(WH(16))
            make.width.equalTo(WH(28))
            make.height.equalTo(WH(28))
        })
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self.snp.right)
            make.width.equalTo(WH(36))
            make.height.equalTo(WH(42))
        })
        
        self.addSubview(tipLabel)
        tipLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(logoImageView.snp.right).offset(WH(8))
            make.centerY.equalTo(self)
            make.right.equalTo(self.cancelBtn.snp.left).offset(-WH(5))
        })
        
        let mStr = "0"
        let endStr = "立即申请"
        let contentStr = "药店助手0成本拥有，立即申请"
        let mRange = (contentStr as NSString).range(of: mStr)
        let eRange = (contentStr as NSString).range(of: endStr)
        let attribute: NSMutableAttributedString = NSMutableAttributedString.init(string: contentStr)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xE8C544), range: mRange)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xE8C544), range: eRange)
        tipLabel.attributedText = attribute
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
