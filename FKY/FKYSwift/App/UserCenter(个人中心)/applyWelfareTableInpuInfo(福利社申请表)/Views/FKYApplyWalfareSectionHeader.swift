//
//  FKYApplyWalfareSectionHeader.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  分区头部视图

import UIKit

class FKYApplyWalfareSectionHeader: UITableViewHeaderFooterView {

    /// cellModel
    var sectionModel = FKYApplyWalfareTableSectionModel()
    
    /// 文描内容
    lazy var titleDesLB:UILabel = {
        let lb  = UILabel()
        lb.text = "暂无提示"
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize:WH(14))
        lb.numberOfLines = 0
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
extension FKYApplyWalfareSectionHeader{
    func configCell(sectionModel:FKYApplyWalfareTableSectionModel){
        self.sectionModel = sectionModel
        self.titleDesLB.text = self.sectionModel.sectionHeaderText
    }
}

// MARK: - UI
extension FKYApplyWalfareSectionHeader{
    func setupUI(){
        
        self.backgroundColor = RGBColor(0xF4F4F4)
        
        self.addSubview(self.titleDesLB)
        
        self.titleDesLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(14))
            make.right.equalToSuperview().offset(WH(-14))
            make.top.equalToSuperview().offset(WH(15))
            make.bottom.equalToSuperview().offset(WH(-9))
        }
        
    }
}
