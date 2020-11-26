//
//  FKYCommandView.swift
//  FKY
//
//  Created by My on 2019/10/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYCommandView: UIView {
    //关闭或确认
    var operateClosure: ((Bool, String?) -> ())?
    var commandShareId: String?//口令
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF);
        view.layer.cornerRadius = WH(13)
        view.layer.masksToBounds = true
        return view
    }()
    
    //标题内容
    lazy var titleLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = t36.font
        label.textColor = RGBColor(0x333333)
        label.text = "查收专属于您的优惠"
        return label
    }()
    
    //查看详情
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = RGBColor(0xFF2D5C)
        btn.setTitle("查看详情", for: .normal)
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.titleLabel?.font = t2.font
        btn.layer.cornerRadius = WH(4)
        btn.layer.masksToBounds = true
        
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.removeFromSuperview()
            strongSelf.operateClosure?(true, strongSelf.commandShareId)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //关闭
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "command_close"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.removeFromSuperview()
            strongSelf.operateClosure?(false, nil)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension FKYCommandView {
    
    func setUpViews() {
        backgroundColor = RGBAColor(0x000000, alpha: 0.6)
        addSubview(contentView)
        contentView.addSubview(closeBtn)
        contentView.addSubview(titleLable)
        contentView.addSubview(confirmBtn)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WH(300), height: WH(163)))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.top.equalToSuperview().offset(WH(10))
            make.size.equalTo(CGSize(width: WH(20), height: WH(20)))
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(30))
            make.right.equalToSuperview().offset(WH(-30))
            make.bottom.equalTo(contentView).offset(WH(-20))
            make.height.equalTo(WH(42))
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.bottom.equalTo(confirmBtn.snp_top).offset(WH(-33))
            make.left.right.equalToSuperview();
        }
    }
    
    //展示动画
    func animateShow(_ command: String?) {
        commandShareId = command
        contentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
