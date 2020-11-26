//
//  LiveEndNavView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveEndNavView: UIView {
    @objc var clickExitBlock: emptyClosure? //点击退出
    //消失按钮
    fileprivate lazy var dismissBtn : UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "btn_common_close"), for: [.normal])
        backBtn.backgroundColor = .clear
        _ = backBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickExitBlock {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        backBtn.isHidden = false
        return backBtn
    }()
    //提示
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xffffff)
        label.font = UIFont.systemFont(ofSize: WH(18))
        label.text = "直播已结束"
        label.sizeToFit()
        return label
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        self.backgroundColor =  RGBColor(0x363B47)
        self.addSubview(dismissBtn)
        self.addSubview(tipLabel)
        
        tipLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.snp.bottom).offset(WH(-12))
            make.centerX.equalTo(self)
        })
        
        dismissBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(WH(-10))
            make.centerY.equalTo(tipLabel.snp.centerY)
            make.height.width.equalTo(WH(40))
        })
        
    }
    
}
