//
//  FKYAddBankCardTipCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYAddBankCardTipCell: UITableViewCell {

    /// 提示cell
    lazy var tipLabel:UILabel = {
        let lb = UILabel()
        lb.text = "仅支持储蓄卡，不支持信用卡"
        lb.textColor = RGBColor(0xE8772A)
        lb.font = UIFont.systemFont(ofSize: WH(12))
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - UI
extension FKYAddBankCardTipCell{
    func setupUI(){
        self.selectionStyle = .none
        self.backgroundColor = RGBColor(0xFFFCF1)
        self.contentView.addSubview(self.tipLabel)
        
        self.tipLabel.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
            make.height.equalTo(WH(32))
        }
    }
}
