//
//  FKYNewProductRegisterSectionHeader.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/8.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYNewProductRegisterSectionHeader: UITableViewHeaderFooterView {
    
    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = UIFont.boldSystemFont(ofSize: WH(14))
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

//MARK: - 数据刷新
extension FKYNewProductRegisterSectionHeader{
    func showData(title:String){
        self.titleLabel.text = title
    }
}

//MARK: - UI
extension FKYNewProductRegisterSectionHeader{
    
    func setupUI(){
        
        self.backgroundColor = .clear
        
        contentView.addSubview(self.titleLabel)
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(26))
            make.bottom.equalToSuperview().offset(WH(-3))
        }
    }
}
