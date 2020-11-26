//
//  FKYOrderEmptyCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYOrderEmptyCell: UITableViewCell {
    lazy var emptyImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"Order_list_Empty")
        return imageView
    }()
    
    lazy var emptyLabel:UILabel = {
        let lb = UILabel()
        lb.text = "暂没有订单"
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.textColor = RGBColor(0x666666)
        lb.textAlignment = .center
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - UI
extension FKYOrderEmptyCell {
    func setupUI(){
        self.backgroundColor = .clear
        self.contentView.addSubview(self.emptyImageView)
        self.contentView.addSubview(self.emptyLabel)
        
        self.emptyImageView.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(WH(-20))
            make.width.height.equalTo(WH(100))
        }
        
        self.emptyLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.emptyImageView)
            make.top.equalTo(self.emptyImageView.snp_bottom).offset(WH(15))
        }
    }
}
