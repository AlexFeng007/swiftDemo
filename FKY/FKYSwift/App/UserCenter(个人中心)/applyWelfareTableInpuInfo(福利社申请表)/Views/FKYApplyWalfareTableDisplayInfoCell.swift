//
//  FKYApplyWalfareTableDisplayInfoCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  信息展示cell

import UIKit

class FKYApplyWalfareTableDisplayInfoCell: UITableViewCell {


    /// cellModel
    var cellModel = FKYApplyWalfareTableCellModel()
    
    
    /// title文描
    lazy var titleDesLB:UILabel = {
        let lb = UILabel()
        lb.text = "客户经理："
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize:WH(13))
        return lb
    }()
    
    /// title内容
    lazy var titleValueLB:UILabel = {
        let lb = UILabel()
        lb.text = "暂无"
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize:WH(13))
        return lb
    }()
    
    /// 第二个title文描
    lazy var title2DesLB:UILabel = {
        let lb = UILabel()
        lb.text = "联系电话："
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize:WH(13))
        return lb
    }()
    
    /// 第二个title内容
    lazy var title2ValueLB:UILabel = {
        let lb = UILabel()
        lb.text = "*** **** ****"
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize:WH(13))
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
extension FKYApplyWalfareTableDisplayInfoCell{
    
    func configCell(cellModel:FKYApplyWalfareTableCellModel){
        self.cellModel = cellModel
        self.titleDesLB.text = self.cellModel.inputTitle1
        self.title2DesLB.text = self.cellModel.inputTitle2
        self.titleValueLB.text = self.cellModel.inputText1
        self.title2ValueLB.text = self.cellModel.inputText2
    }
}

//MARK: - UI
extension FKYApplyWalfareTableDisplayInfoCell{
    
    func setupUI(){
        self.selectionStyle = .none
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.contentView.addSubview(self.titleDesLB)
        self.contentView.addSubview(self.titleValueLB)
        self.contentView.addSubview(self.title2DesLB)
        self.contentView.addSubview(self.title2ValueLB)
        
        self.titleDesLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.titleDesLB.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.title2DesLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.title2DesLB.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        self.titleDesLB.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(15))
            make.bottom.equalToSuperview().offset(WH(-15))
            make.left.equalToSuperview().offset(WH(15))
        }
        
        self.titleValueLB.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleDesLB).offset(WH(0))
            make.bottom.equalTo(self.titleDesLB).offset(WH(0))
            make.left.equalTo(self.titleDesLB.snp_right)
            make.width.equalTo(WH(100))
        }
        
        self.title2DesLB.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleDesLB).offset(WH(0))
            make.bottom.equalTo(self.titleDesLB).offset(WH(0))
            make.left.equalTo(self.titleValueLB.snp_right)
            //make.width.equalTo(WH(115))
        }
        
        self.title2ValueLB.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleDesLB).offset(WH(0))
            make.bottom.equalTo(self.titleDesLB).offset(WH(0))
            make.left.equalTo(self.title2DesLB.snp_right)
            make.right.equalToSuperview().offset(WH(-15))
        }
    }
}
