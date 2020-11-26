//
//  FKYShoppingMoneyMenberDesView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/11.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyMenberDesView: UIView {

    /// 标题
    lazy var desTitleLabel:UILabel = {
        let lb = UILabel()
        lb.text = "会员赠送说明"
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize: WH(14))
        return lb
    }()
    
    /// 底部描述
    lazy var desSubLB:UILabel = {
        let lb = UILabel()
        let str = "1.非会员用户每月15日前（含15日）充值，本月享受会员权益；每月15日后充值，本月和下月均享受会员权益！\n2.会员用户充值可延长会员权益到下月底，下个月已经是会员的用户，权益不会叠加。"
        var tempStr:NSMutableAttributedString = NSMutableAttributedString.init(string: str, attributes: nil)
        var paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = WH(4)
        tempStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: str.count))
        //lb.text = "1.非会员用户每月15日前（含15日）充值，本月享受会员权益；每月15日后充值，本月和下月均享受会员权益！\n2.会员用户充值可延长会员权益到下月底，下个月已经是会员的用户，权益不会叠加。"
        lb.attributedText = tempStr
        lb.textColor = RGBColor(0x999990)
        lb.font = .systemFont(ofSize: WH(12))
        lb.numberOfLines = 0
        return lb
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
extension FKYShoppingMoneyMenberDesView{
    func setupUI(){
        self.addSubview(self.desTitleLabel)
        self.addSubview(self.desSubLB)
        
        self.desTitleLabel.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(23))
            make.right.equalToSuperview().offset(WH(-23))
            make.top.equalToSuperview().offset(WH(10))
        }
        
        self.desSubLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(23))
            make.right.equalToSuperview().offset(WH(-23))
            make.top.equalTo(self.desTitleLabel.snp_bottom).offset(WH(5))
            make.bottom.equalToSuperview().offset(WH(-10))
        }
    }
}
