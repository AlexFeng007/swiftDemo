//
//  FKYSwitchInvoiceTypeView.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit


//MARK: - 响应事件列表

///切换视图
let FKY_switchInvoiceTypeView = "switchInvoiceTypeView"

class FKYSwitchInvoiceTypeView: UIView {

    typealias switchViewType = (_ switchToView:InvoiceType)->()
    
    var switchViewBlock:switchViewType?
    
    ///普通发票
    lazy var normalFPBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: WH(15.0))
        btn.setTitle("普通发票", for: .normal)
        btn.addTarget(self, action: #selector(switchToNormalInvoiceView), for: .touchUpInside)
        return btn
    }()
    
    ///专用发票
    lazy var specialFPBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: WH(15.0))
        btn.setTitle("专用发票", for: .normal)
        btn.addTarget(self, action: #selector(switchToSpecialInvoiceView), for: .touchUpInside)
        return btn
    }()
    
    ///标线1
    let markLine1:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFF2D5C)
        return view
    }()
    
    ///标线2
    let markLine2:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    ///当前页面类型
    var viewType:InvoiceType = .normal
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 响应事件
extension FKYSwitchInvoiceTypeView{
    ///切换到普通发票界面
    @objc func switchToNormalInvoiceView(){
        self.routerEvent(withName: FKY_switchInvoiceTypeView, userInfo: [FKYUserParameterKey:InvoiceType.normal])
        updataViewStatus(.normal)
    }
    
    ///切换到专用发票界面
    @objc func switchToSpecialInvoiceView(){
        self.routerEvent(withName: FKY_switchInvoiceTypeView, userInfo: [FKYUserParameterKey:InvoiceType.special])
        self.updataViewStatus(.special)
    }
}

//MARK: - 私有方法
extension FKYSwitchInvoiceTypeView{
    
    //更新状态
    func updataViewStatus(_ viewType:InvoiceType){
        switch viewType {
        case .normal:
            normalFPBtn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
            markLine1.backgroundColor = RGBColor(0xFF2D5C)
            specialFPBtn.setTitleColor(RGBColor(0x333333), for: .normal)
            markLine2.backgroundColor = .clear
            
        case .special:
            normalFPBtn.setTitleColor(RGBColor(0x333333), for: .normal)
            markLine1.backgroundColor = .clear
            specialFPBtn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
            markLine2.backgroundColor = RGBColor(0xFF2D5C)
        }
    }
}

//MARK: - UI
extension FKYSwitchInvoiceTypeView{
    func setupView(){
        
        self.addSubview(normalFPBtn)
        self.addSubview(markLine1)
        self.addSubview(specialFPBtn)
        self.addSubview(markLine2)
        
        normalFPBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(93.0))
        }
        
        markLine1.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(WH(-2))
            make.left.right.equalTo(normalFPBtn)
            make.height.equalTo(WH(1.0))
        }
        
        specialFPBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(WH(-93.0))
        }
        
        markLine2.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(WH(-2))
            make.left.right.equalTo(specialFPBtn)
            make.height.equalTo(WH(1.0))
        }
    }
}
