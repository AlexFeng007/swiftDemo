//
//  FKYStationMsgSectionHeader.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYStationMsgSectionHeader: UITableViewHeaderFooterView {
    lazy var margin1:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x999999)
        return view
    }()
    
    lazy var margin2:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x999999)
        return view
    }()
    
    lazy var tipLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x999999)
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize:WH(12))
        return lb
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier:reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 数据显示
extension FKYStationMsgSectionHeader{
    func showTestData(){
        self.tipLB.text = "一周前的消息"
    }
}

//MARK: - UI
extension FKYStationMsgSectionHeader{
    func setupUI(){
        self.addSubview(self.margin1)
        self.addSubview(self.margin2)
        self.addSubview(self.tipLB)
        
        self.margin1.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.tipLB.snp_left).offset(WH(-10))
            make.left.greaterThanOrEqualToSuperview().offset(WH(10))
            make.width.equalTo(WH(30))
            make.height.equalTo(WH(2))
        }
        
        self.tipLB.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.margin2.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(WH(-10))
            make.left.equalTo(self.tipLB.snp_right).offset(WH(10))
            make.width.equalTo(WH(30))
            make.height.equalTo(WH(2))
        }
        
    }
}
