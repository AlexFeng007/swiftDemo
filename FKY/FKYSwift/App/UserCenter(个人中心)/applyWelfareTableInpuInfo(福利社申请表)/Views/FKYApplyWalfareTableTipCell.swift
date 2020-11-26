//
//  FKYApplyWalfareTableTipCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 温馨提醒：客户经理会在24小时内联系您，请耐心等候

import UIKit

class FKYApplyWalfareTableTipCell: UITableViewCell {

    /// 提示 LB
    lazy var tipLabel:UILabel = {
        let lb = UILabel()
        lb.text = "温馨提醒：客户经理会在24小时内联系您，请耐心等候"
        lb.textColor = RGBColor(0xE8772A)
        //lb.textAlignment = .center
        lb.font = .systemFont(ofSize: WH(12))
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK - UI
extension FKYApplyWalfareTableTipCell {
    
    func setupUI(){
        self.selectionStyle = .none
        self.backgroundColor = RGBColor(0xFFFCF1)
        self.contentView.addSubview(self.tipLabel)
        
        self.tipLabel.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(15))
            make.bottom.equalToSuperview().offset(WH(-10))
            make.left.equalToSuperview().offset(WH(15))
            make.right.equalToSuperview().offset(WH(-15))
        }
    }
}
