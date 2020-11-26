//
//  LiveRedPacketTipView.swift
//  FKY
//
//  Created by yyc on 2020/8/28.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveRedPacketTipView: UIView {
    //背景
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = WH(13)
        return view
    }()
    //消失按钮
    fileprivate lazy var dismissBtn : UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "command_close"), for: [.normal])
        backBtn.backgroundColor = .clear
        _ = backBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        backBtn.isHidden = false
        return backBtn
    }()
    //提示
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(18))
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //知道了按钮
    fileprivate lazy var cancellLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBAColor(0xFFFFFF,alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: WH(15))
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(4)
        label.text = "知道了"
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss()
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    @objc var clickCopyActionBlock: ((String)->())? //点击复制
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor =  RGBAColor(0x000000, alpha: 0.32)
        self.addSubview(bgView)
        bgView.addSubview(dismissBtn)
        bgView.addSubview(tipLabel)
        bgView.addSubview(cancellLabel)
        
        bgView.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(300))
            make.height.equalTo(WH(180))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(WH(-25))
        })
        
        dismissBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(bgView).offset(WH(10))
            make.right.equalTo(bgView).offset(WH(-10))
            make.height.width.equalTo(WH(30))
        })
        tipLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(bgView).offset(WH(49))
            make.centerX.equalTo(bgView)
            make.width.equalTo(WH(251))
        })
        cancellLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(bgView.snp.bottom).offset(-WH(18))
            make.centerX.equalTo(bgView)
            make.width.equalTo(WH(240))
            make.height.equalTo(WH(42))
        })
    }
    func configTipView(_ tipStr:String){
        tipLabel.text = tipStr
    }
    //展示
    @objc func show() {
        self.isHidden = false
        self.alpha = 0
        bgView.alpha = 0
        bgView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 1
                strongSelf.bgView.alpha = 1
                
            }
        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.bgView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }) { (ret) in
        }
    }
    
    //消失
    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 0
                strongSelf.bgView.alpha = 0
                strongSelf.bgView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }) { [weak self] (ret) in
            if let strongSelf = self {
                if ret {
                    strongSelf.isHidden = true
                    //strongSelf.removeFromSuperview()
                }
            }
        }
    }
}
