//
//  FKYFKYAuditStatusCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYAuditStatusCell: UITableViewCell {

    ///审核状态图标
    lazy var statusIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "invoice_wait_icon")
        return image
    }()
    
    ///审核状态标题
    lazy var statusTitleLB:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(17))
        label.textColor = RGBColor(0xFFFFFF)
        label.text = "审核中"
        return label
    }()
    
    ///审核状态描述
    lazy var statusDesLB:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12.0))
        label.textColor = RGBColor(0xFFFFFF)
        label.numberOfLines = 2
        label.text = ""
        return label
    }()
    
    override  init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        setupView()
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

//MARK: - 刷新数据
extension FKYAuditStatusCell{
    func showData(cellData:FKYInvoiceCellModel){
        ///1审核中；2审核通过；3审核不通过
        self.statusDesLB.text = cellData.inputText
        if cellData.billStatus == 1{
            inAuditLayout()
            statusIcon.image = UIImage(named: "invoice_wait_icon")
            statusTitleLB.text = "审核中"
        }else if cellData.billStatus == 2{
            auditSuccessLayout()
            statusIcon.image = UIImage(named: "invoice_success_icon")
            statusTitleLB.text = "审核通过"
        }else if cellData.billStatus == 3{
            inAuditLayout()
            statusIcon.image = UIImage(named: "invoice_failure_icon")
            statusTitleLB.text = "审核不通过"
        }
    }
}

//MARK: - UI
extension FKYAuditStatusCell{
     func setupView(){
        self.selectionStyle = .none
        ///渐变背景
        let layer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: SCREEN_WIDTH, y: 0))
        bezier.addLine(to: CGPoint(x: SCREEN_WIDTH, y: WH(70)))
        bezier.addLine(to: CGPoint(x: 0, y: WH(70)))
        bezier.addLine(to: CGPoint(x: 0, y: 0))
        layer.path = bezier.cgPath
        layer.fillColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH).cgColor
        contentView.layer.addSublayer(layer)
        
        contentView.addSubview(statusIcon)
        contentView.addSubview(statusTitleLB)
        contentView.addSubview(statusDesLB)
    }
    
    ///审核中布局方案/审核失败布局方案
    func inAuditLayout(){
        statusIcon.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(9.0))
            make.top.equalTo(contentView).offset(WH(5.0))
            make.width.height.equalTo(WH(26.0))
        }
        
        statusTitleLB.snp_makeConstraints { (make) in
            make.centerY.equalTo(statusIcon)
            make.left.equalTo(statusIcon.snp_right).offset(WH(3.0))
            make.right.equalTo(contentView).offset(WH(-10))
        }
        
        statusDesLB.snp_makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(WH(-6))
            make.left.right.equalTo(statusTitleLB)
            make.top.equalTo(statusTitleLB.snp_bottom).offset(WH(4))
        }
    }
    
    ///审核成功
    func auditSuccessLayout(){
        statusIcon.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(9.0))
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(WH(26.0))
        }
        
        statusTitleLB.snp_makeConstraints { (make) in
            make.centerY.equalTo(statusIcon)
            make.left.equalTo(statusIcon.snp_right).offset(WH(3.0))
            make.right.equalTo(contentView).offset(WH(-10))
        }
        
        statusDesLB.snp_makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(WH(-6))
            make.left.right.equalTo(statusTitleLB)
            make.height.equalTo(0)
        }
    }
    
}

extension FKYAuditStatusCell{
    static func getCellHeight() -> CGFloat {
        return WH(70)
    }
}
