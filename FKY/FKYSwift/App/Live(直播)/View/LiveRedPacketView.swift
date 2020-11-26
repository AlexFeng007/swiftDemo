//
//  LiveRedPacketView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveRedPacketView: UIView {
    //红包背景
    fileprivate lazy var rpBgView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "live_rp_bg")
        view.isUserInteractionEnabled = true
        return view
    }()
    //消失按钮
    fileprivate lazy var dismissBtn : UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "live_room_close"), for: [.normal])
        //backBtn.alpha = 0.2
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
    //红包活动名
    fileprivate lazy var acctivityNameLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xffffff)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .center
        return label
    }()
    
    // 活动说明
    fileprivate lazy var acctivityDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBAColor(0xffffff,alpha: 1)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.backgroundColor = .clear
        label.text = "复制下面文字发送弹幕领取红包"
        label.textAlignment = .center
        return label
    }()
    //复制文字区域
    fileprivate lazy var copyTextBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFF2E7)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(5)
        return view
    }()
    
    // 活动复制文字
    fileprivate lazy var copyTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBAColor(0xE12016,alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //复制按钮
    fileprivate lazy var copyLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBAColor(0xFFFFFF,alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(16)
        label.layer.borderWidth = 1
        label.layer.borderColor = RGBColor(0xFFF2E7).cgColor
        label.text = "复制文字"
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.copyCommandAction()
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
        self.backgroundColor = RGBAColor(0x000000, alpha: 0.23)
        self.addSubview(rpBgView)
        rpBgView.addSubview(dismissBtn)
        rpBgView.addSubview(acctivityNameLabel)
        rpBgView.addSubview(acctivityDescLabel)
        rpBgView.addSubview(copyTextBgView)
        copyTextBgView.addSubview(copyTextLabel)
        rpBgView.addSubview(copyLabel)
        
        rpBgView.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(300))
            make.height.equalTo(WH(227))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(WH(-25))
        })
        
        dismissBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(rpBgView).offset(WH(3))
            make.right.equalTo(rpBgView).offset(WH(-8))
            make.height.width.equalTo(WH(30))
        })
        
        acctivityNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(rpBgView).offset(WH(10))
            make.centerX.equalTo(rpBgView)
            make.top.equalTo(rpBgView).offset(WH(27))
        })
        
        acctivityDescLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(rpBgView).offset(WH(10))
            make.centerX.equalTo(rpBgView)
            make.top.equalTo(acctivityNameLabel.snp.bottom).offset(WH(8))
        })
        
        copyTextBgView.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(210))
            make.height.equalTo(WH(57))
            make.centerX.equalTo(rpBgView)
            make.top.equalTo(rpBgView).offset(WH(95))
        })
        
        copyTextLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(copyTextBgView).offset(WH(-8))
            make.left.equalTo(copyTextBgView).offset(WH(8))
            make.top.equalTo(copyTextBgView).offset(WH(3))
            make.bottom.equalTo(copyTextBgView).offset(WH(-3))
        })
        
        copyLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(WH(108))
            make.height.equalTo(WH(32))
            make.centerX.equalTo(rpBgView)
            make.top.equalTo(copyTextBgView.snp.bottom).offset(WH(15))
        })
    }
    func configRpView(_ rpModel :LiveRoomRedPacketInfo?){
        if let model = rpModel {
            acctivityNameLabel.text = model.name
            copyTextLabel.text = model.redPacketPwd
        }
    }
    //展示
    @objc func show() {
        self.isHidden = false
        self.alpha = 0
        rpBgView.alpha = 0
        rpBgView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 1
                strongSelf.rpBgView.alpha = 1
                
            }
        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.rpBgView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }) { (ret) in
        }
    }
    
    //消失
    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 0
                strongSelf.rpBgView.alpha = 0
                strongSelf.rpBgView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
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
    //复制红包口令
    func copyCommandAction(){
        UIPasteboard.general.string = copyTextLabel.text
        self.makeToast("复制成功")
        self.perform(#selector(dismiss), with: nil, afterDelay: 0.3)
        if let block = self.clickCopyActionBlock {
            if let str = copyTextLabel.text,str.count > 0 {
                 block(str)
            }
        }
    }
}
