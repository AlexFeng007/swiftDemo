//
//  FKYShoppingMoneyRechargeTitleView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyRechargeTitleView: UIView {

    /// 关闭页面
    static let FKY_closeViewAction = "closeViewAction"
    
    /// 标题
    lazy var titleLB:UILabel = self.creatTitleLB()
    
    /// 关闭按钮
    lazy var closeBtn:UIButton = self.creatCloseBtn()
    
    /// 分割线
    lazy var marginLine:UIView = self.creatMarginLine()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 响应事件
extension FKYShoppingMoneyRechargeTitleView{
    
    @objc func closeBtnClicked(){
        self.routerEvent(withName: FKYShoppingMoneyRechargeTitleView.FKY_closeViewAction, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - UI
extension FKYShoppingMoneyRechargeTitleView{
    
    func setupUI(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.addSubview(self.titleLB)
        self.addSubview(self.closeBtn)
        self.addSubview(self.marginLine)
        
        self.titleLB.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.closeBtn.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(WH(30))
            make.right.equalToSuperview().offset(WH(-20))
        }
        
        self.marginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(WH(56))
            make.height.equalTo(0.5)
        }
        
    }
}

//MARK: - 属性对应的生成方法
extension FKYShoppingMoneyRechargeTitleView {
	func creatTitleLB() -> UILabel{
        let lb = UILabel()
        lb.text = "购物金充值"
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        lb.textAlignment = .center
        lb.textColor = RGBColor(0x000000)
        return lb
	}

	func creatCloseBtn() -> UIButton{
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"btn_pd_group_close"), for: .normal)
        bt.addTarget(self, action: #selector(FKYShoppingMoneyRechargeTitleView.closeBtnClicked), for: .touchUpInside)
        return bt
	}

	func creatMarginLine() -> UIView{
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
	}

}

