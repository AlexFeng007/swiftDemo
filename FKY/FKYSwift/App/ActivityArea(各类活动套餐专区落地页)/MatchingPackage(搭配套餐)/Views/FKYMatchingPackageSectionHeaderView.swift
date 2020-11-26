//
//  FKYMatchingPackageSectionHeaderView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageSectionHeaderView: UITableViewHeaderFooterView {

    /// 容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 套餐名称
    lazy var packageName:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize: WH(14))
        return lb
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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

// MARK: - 数据显示
extension FKYMatchingPackageSectionHeaderView{
    
    /// 展示套餐名称
    func showPackageName(name:String){
        self.packageName.text = name
    }
}

// MARK: - UI
extension FKYMatchingPackageSectionHeaderView{
    
    func setupUI(){
        self.contentView.backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.packageName)
        
        self.containerView.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(0.3)// 防止下方出现一个细缝
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.height.equalTo(WH(30))
        }
        
        self.packageName.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(8))
            make.left.equalToSuperview().offset(WH(14))
            make.right.equalToSuperview().offset(WH(-14))
        }
        
        self.setCorner()
    }
    
    /// 设置圆角
    func setCorner(){
        self.contentView.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.001) {
            let borderLayer = CAShapeLayer()
            let borderPath = UIBezierPath(roundedRect: self.containerView.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: WH(4), height: WH(4)))
            borderLayer.path = borderPath.cgPath
            self.containerView.layer.mask = borderLayer
        }
        
    }
}
