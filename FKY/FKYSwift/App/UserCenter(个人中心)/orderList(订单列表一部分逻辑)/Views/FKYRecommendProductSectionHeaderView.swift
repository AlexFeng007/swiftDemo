//
//  FKYRecommendProductSectionHeaderView.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/23.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYRecommendProductSectionHeaderView: UIView {

    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.text = "为您推荐"
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.textColor = RGBColor(0x666666)
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var leftMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x999999)
        return view
    }()
    
    
    lazy var rightMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x999999)
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

//MARK: - UI
extension FKYRecommendProductSectionHeaderView{
    
    func setupUI(){
        self.addSubview(self.leftMarginLine)
        self.addSubview(self.titleLabel)
        self.addSubview(self.rightMarginLine)
        
        self.leftMarginLine.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.titleLabel.snp_left).offset(WH(-10))
            make.height.equalTo(1)
            make.width.equalTo(WH(14))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.rightMarginLine.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleLabel.snp_right).offset(WH(10))
            make.width.height.equalTo(self.leftMarginLine)
        }
    }
}
