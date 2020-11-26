//
//  CredentialsSubmitCollectionView.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/27.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class CredentialsSubmitCollectionView: UICollectionReusableView {
    
    fileprivate lazy var submitBtn: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.titleLabel?.font = btn16.title.font
        return button
    }()
    
    var submitClosure: emptyClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.submitBtn.addTarget(self, action: #selector(onSubmitButton(_:)), for: .touchUpInside)
        self.addSubview(self.submitBtn)
        self.submitBtn.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self).offset(WH(24))
            make.width.equalTo((SCREEN_WIDTH*0.9))
            make.height.equalTo((SCREEN_WIDTH*0.9*0.13))
        })
        
        self.backgroundColor = bg2
    }
    
    func configSubmitTtile(_ title: String, isCanSubmit: Bool) {
        submitBtn.setTitle(title, for: UIControl.State())
        if isCanSubmit {
            submitBtn.backgroundColor = RGBColor(0xFE403B)
            submitBtn.isUserInteractionEnabled = true
        }else{
            submitBtn.backgroundColor = RGBColor(0xD8D8D8)
            submitBtn.isUserInteractionEnabled = false
        }
    }
    
    //MARK: User Action
    @objc func onSubmitButton(_ sender: FKYCornerRadiusGradientButton) {
        if let submitClosure = self.submitClosure {
            submitClosure()
        }
    }
}
