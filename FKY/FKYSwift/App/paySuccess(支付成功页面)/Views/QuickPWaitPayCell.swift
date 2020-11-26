//
//  QuickPWaitPayCell.swift
//  FKY
//
//  Created by 寒山 on 2020/7/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class QuickPWaitPayCell: UITableViewCell {
    
    /// 订单支付状态icon
    lazy var statusIcon: UIImageView = self.creatStatusIcon()
    /// 订单支付状态文描  -支付成功 -待支付
    lazy var orderStatusLabel: UILabel = self.creatOrderStatusLabel()
    /// 订单支付金额
    lazy var orderStatusMoney: UILabel = self.creatOrderStatusMoney()
    ///背景图片
    lazy var backgroundImage: UIImageView = self.creatBackgroundImage()
    
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
//MARK: - 属性对应的生成方法
extension QuickPWaitPayCell {
    func creatStatusIcon() -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: "order_status_no_pay")
        return image
    }
    
    func creatOrderStatusLabel() -> UILabel {
        let lb = UILabel()
        lb.textColor = RGBColor(0x061B49)
        lb.font = UIFont.systemFont(ofSize: WH(17))
        lb.numberOfLines = 1
        lb.text = "正在支付中"
        return lb
    }
    
    func creatOrderStatusMoney() -> UILabel {
        let lb = UILabel()
        lb.textColor = RGBColor(0x061B49)
        lb.font = UIFont.boldSystemFont(ofSize: WH(20))
        lb.numberOfLines = 1
        lb.text = ""
        return lb
    }
    
    func creatBackgroundImage() -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: "Order_PayStatus_Background_Image")
        return image
    }
}

// MARK: - UI
extension QuickPWaitPayCell {
    
    func setupUI() {
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.backgroundImage)
        self.contentView.addSubview(self.statusIcon)
        self.contentView.addSubview(self.orderStatusLabel)
        self.contentView.addSubview(self.orderStatusMoney)
        
        self.statusIcon.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(22))
            make.centerY.equalTo(self.orderStatusLabel.snp_bottom)
            make.width.height.equalTo(WH(26))
        }
        self.orderStatusLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.statusIcon.snp_right).offset(WH(7))
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalToSuperview().offset(WH(16))
        }
        self.orderStatusMoney.snp_makeConstraints { (make) in
            make.left.equalTo(self.orderStatusLabel)
            make.right.equalToSuperview().offset(WH(-21))
            make.top.equalTo(self.orderStatusLabel.snp_bottom).offset(WH(6))
        }
        
        self.backgroundImage.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self.contentView)
        }
    }
    func configCellData(_ times:Int,_ orderMoney:String) {
        self.orderStatusMoney.text = String(format: "¥%@", orderMoney)
        self.orderStatusLabel.text = "正在支付中  \(times)S"
    }
}

