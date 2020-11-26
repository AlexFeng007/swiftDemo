//
//  LiveErrorView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveErrorView: UIView {
    var refrshStateBlock: emptyClosure? //刷新直播
    //tips
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xF5EFFF)
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.textAlignment = .center
        label.text = "啊哦，出了点小问题，加载失败了～"
        return label
    }()
    
    // 刷新按钮
    fileprivate lazy var refreshView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear//RGBAColor(0x000000,alpha: 0.2)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(13)
        view.layer.borderWidth = 1
        view.layer.borderColor = RGBColor(0xF5EFFF).cgColor
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.refrshStateBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //主播头像
    fileprivate lazy var refershImageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "live_refersh_icon")
        return view
    }()
    
    
    // 观众数
    fileprivate lazy var refreshTipsLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xF5EFFF)
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.textAlignment = .left
        label.text = "刷新"
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
        self.backgroundColor = .clear
        self.addSubview(tipsLabel)
        self.addSubview(refreshView)
        refreshView.addSubview(refershImageView)
        refreshView.addSubview(refreshTipsLabel)
        
        tipsLabel.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(WH(13))
        })
        refreshView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(tipsLabel.snp.bottom).offset(WH(26))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(73))
        })
        refershImageView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(refreshView)
            make.left.equalTo(refreshView).offset(WH(12))
            make.height.equalTo(WH(13))
            make.width.equalTo(WH(13))
        })
        
        refreshTipsLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(refreshView)
            make.left.equalTo(refershImageView.snp.right).offset(WH(9))
        })
    }
    
}
