//
//  FKYMatchingPackageContectEnterprise.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageContectEnterprise: UIView {

    /// 联系商家
    static let FKY_ContectEnterpriseAction = "ContectEnterpriseAction"
    
    /// 联系商家按钮
    lazy var contactButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("联系供应商", for: .normal)
        bt.setImage(UIImage(named:"ContectEnterprise_Icon"), for: .normal)
        bt.titleLabel?.font = .boldSystemFont(ofSize: WH(14))
        bt.addTarget(self, action: #selector(FKYMatchingPackageContectEnterprise.contactButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 响应事件
extension FKYMatchingPackageContectEnterprise {
    
    @objc func contactButtonClicked(){
        self.routerEvent(withName: FKYMatchingPackageContectEnterprise.FKY_ContectEnterpriseAction, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - UI
extension FKYMatchingPackageContectEnterprise {
    
    func setupUI(){
        self.addSubview(self.contactButton)
        var bottomMargin = WH(-7)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                bottomMargin = iPhoneX_SafeArea_BottomInset
            }
        }
        self.contactButton.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(20))
            make.right.equalToSuperview().offset(WH(-20))
            make.top.equalToSuperview().offset(WH(7))
            make.height.equalTo(WH(40))
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
    }
}
