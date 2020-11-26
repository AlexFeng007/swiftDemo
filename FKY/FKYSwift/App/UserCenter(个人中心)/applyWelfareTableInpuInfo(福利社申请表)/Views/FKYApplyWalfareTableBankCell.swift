//
//  FKYApplyWalfareTableBankCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYApplyWalfareTableBankCell: UITableViewCell {

    /// 银行名称lb
    lazy var bankNameLB:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.font = .systemFont(ofSize: WH(14))
        lb.textColor = RGBColor(0x333333)
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

//MARK: - 数据显示
extension FKYApplyWalfareTableBankCell {
    func configCell(text:String){
        self.bankNameLB.text = text
    }
}

//MARK: - UI
extension FKYApplyWalfareTableBankCell {
    func setupUI(){
        self.selectionStyle = .none
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.contentView.addSubview(self.bankNameLB)
        
        self.bankNameLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(30))
            make.right.equalToSuperview().offset(WH(-30))
            make.top.equalToSuperview().offset(WH(15))
            make.bottom.equalToSuperview().offset(WH(-15))
        }
    }
}
