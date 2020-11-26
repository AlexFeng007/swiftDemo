//
//  FKYTipSurpriseView.swift
//  FKY
//
//  Created by yyc on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYTipSurpriseView: UIView {
    var clickTipView : ((Int)->Void)? //点击视图
    //提示文字
    fileprivate lazy var tipLabel: UILabel! = {
        let lbl = UILabel()
        lbl.fontTuple = t73
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        lbl.lineBreakMode = .byTruncatingMiddle
        return lbl
    }()
    // 叉叉
    fileprivate lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        //
        btn.setImage(UIImage(named:"home_cancel_pic"), for: .normal)
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
    //向下的图片
    fileprivate lazy var downImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named:"home_down_pic")
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RGBColor(0xFFEDE7)
        self.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.clickTipView {
                    block(1)
                }
            }
        })
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints({ (make) in
            make.top.left.equalTo(self)
            make.width.equalTo(WH(25))
            make.height.equalTo(WH(23))
        })
        self.addSubview(downImageView)
        downImageView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-WH(12))
            make.right.equalTo(self.snp.right).offset(-WH(23))
            make.width.equalTo(WH(14))
            make.height.equalTo(WH(16))
        })
        self.addSubview(tipLabel)
        tipLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(cancelBtn.snp.right).offset(-WH(2))
            make.centerY.equalTo(self)
            make.right.equalTo(self.downImageView.snp.left).offset(-WH(5))
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FKYTipSurpriseView {
    func configTipStr(_ tipStr:String) {
        tipLabel.text = tipStr
    }
}
