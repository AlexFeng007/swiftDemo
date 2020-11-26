

//
//  FKYSelectBankTitleView.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 关闭银行选择界面
let FKY_dismissSelectBankVC = "dismissSelectBankVC"

class FKYSelectBankTitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 关闭按钮
    lazy var closeBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named: "icon_account_close"), for: .normal)
        bt.addTarget(self, action: #selector(dissMiss), for: .touchUpInside)
        bt.setEnlargeEdgeWith(top: 10, right: 10, bottom: 10, left: 10)
        return bt
    }()
    
    /// 标题
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: WH(17))
        lb.textColor = .black
        lb.text = "选择银行"
        return lb
    }()
    
    ///分割线
    lazy var marginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
}

//MARK: - 私有方法
extension FKYSelectBankTitleView {
    @objc func dissMiss(){
        self.routerEvent(withName: FKY_dismissSelectBankVC, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - UI
extension FKYSelectBankTitleView {
    func setupView(){
        self.addSubview(closeBtn)
        self.addSubview(titleLB)
        self.addSubview(marginLine)
        
        self.backgroundColor = .white
        
        closeBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(15))
            make.width.height.equalTo(WH(24))
        }
        
        titleLB.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        marginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}
