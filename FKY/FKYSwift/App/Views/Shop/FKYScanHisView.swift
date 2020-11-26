//
//  FKYScanHisView.swift
//  FKY
//
//  Created by hui on 2018/9/4.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

typealias clickType = (Int)->()

class FKYScanHisView: UIView {
    
    fileprivate lazy var lookLabel : UILabel = {
        let label = UILabel()
        label.text = "前往上一次浏览的位置"
        label.font = t24.font
        label.textColor = t34.color
        return label
    }()
    
    fileprivate lazy var deletBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"groupDelet"), for: .normal)
        return btn
    }()
    
    var clickBt:clickType?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView()  {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        self.backgroundColor = RGBAColor(0x000000, alpha: 0.7)
        addSubview(self.lookLabel)
        self.lookLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp.left).offset(WH(22))
        }
        addSubview(self.deletBtn)
        self.deletBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.lookLabel.snp.right).offset(0)
            make.height.width.equalTo(WH(36))
        }
        _=self.deletBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let blcok = strongSelf.clickBt {
                blcok(2)
            }
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    @objc func handleTap(){
        if let blcok = self.clickBt {
            blcok(1)
        }
    }
    
}
