//
//  FKYCommandEnterTreasuryTipView.swift
//  FKY
//
//  Created by 寒山 on 2020/11/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  一键入库提示页面，未开通或者开通未运行

import UIKit

class FKYCommandEnterTreasuryTipView: UIView {
    
    //关闭或确认
    var operateClosure: ((Int, String?) -> ())? //0 关闭 1、申请开通 2、了解更多
    var commandInfoModel: FKYCommandEnterTreasuryModel?
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.layer.cornerRadius = WH(14)
        view.layer.masksToBounds = true
        return view
    }()
    //标题内容
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        //imageView.image = UIImage(named: "smart_store_tips_bg")
        return imageView
    }()
    
    //立即申请
    lazy var accessBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = RGBColor(0x6764FF)
        // btn.setTitle("查看详情", for: .normal)
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.titleLabel?.font = t2.font
        btn.layer.cornerRadius = WH(4)
        btn.layer.masksToBounds = true
        
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.removeFromSuperview()
            strongSelf.operateClosure?(1, strongSelf.commandInfoModel?.jumpUrl)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //关闭按钮
    fileprivate lazy var closeButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_secnd_cps"), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.removeFromSuperview()
            strongSelf.operateClosure?(0, "")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension FKYCommandEnterTreasuryTipView {
    
    func setUpViews() {
 
        backgroundColor = RGBAColor(0x000000, alpha: 0.6)
        addSubview(contentView)
        addSubview(closeButton)
        contentView.addSubview(bgImageView)
        contentView.addSubview(accessBtn)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width:WH(300), height: WH(361)))
        }
        
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        accessBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(-18))
            make.size.equalTo(CGSize(width: WH(300 - 60), height: WH(42)))
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.bottom).offset(WH(28))
           // make.size.equalTo(CGSize(width: WH(42), height: WH(42)))
        }
        
    }
    
    //展示动画
    func animateShow(_ commandModel: FKYCommandEnterTreasuryModel?) {
        
        if let model = commandModel{
            self.commandInfoModel = model
            //checkDetailBtn.setTitle(model.moreButtonText, for: .normal)
            accessBtn.setTitle(model.buttonText, for: .normal)
            if let strPicUrl = model.backgroundUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlPic = URL(string: strPicUrl) {
                self.bgImageView.sd_setImage(with: urlPic , placeholderImage: nil)
            }
            contentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
}
