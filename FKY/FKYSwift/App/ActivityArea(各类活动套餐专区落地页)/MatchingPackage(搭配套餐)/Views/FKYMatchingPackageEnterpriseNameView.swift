
//
//  FKYMatchingPackageEnterpriseNameView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageEnterpriseNameView: UIView {

    /// 企业名称容器视图
    lazy var nameContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 企业名称
    lazy var enterpriseNameLB:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x333333)
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.backgroundColor = RGBColor(0xFFFFFF)
        return lb
    }()
    
    /// 下方的空行间隔
    lazy var emptyMarginView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - 数据显示
extension FKYMatchingPackageEnterpriseNameView{
    
    /// 展示店铺名称
    func showEnterpriseName(name:String){
        self.enterpriseNameLB.text = name
    }
}

//MARK: - UI
extension FKYMatchingPackageEnterpriseNameView{
    
    func setupUI(){
        self.addSubview(self.nameContainerView)
        self.nameContainerView.addSubview(self.enterpriseNameLB)
        self.addSubview(self.emptyMarginView)
        
        self.nameContainerView.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(WH(0))
            make.right.equalToSuperview().offset(WH(0))
            make.height.equalTo(WH(40))
        }
        
        self.enterpriseNameLB.snp_makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(WH(22))
            make.right.equalToSuperview().offset(WH(-22))
            //make.height.equalTo(WH(40))
        }
        
        self.emptyMarginView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.enterpriseNameLB.snp_bottom)
            make.height.equalTo(WH(23))
        }
        
    }
}
