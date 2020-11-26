//
//  COOfflinePayTipCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  线下支付详情之线下转账说明cell

import UIKit

class COOfflinePayTipCell: UITableViewCell {
    // MARK: - Property
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "线下转账说明"
        return lbl
    }()
    
    // 内容
    fileprivate lazy var lblContent: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "1. 汇款时请备注订单号，用于保证订单及时核销。此订单号务必填写正确，请勿增加其他文字说明；\n2.订单号需填写在电汇凭证的【汇款用途】、【附言】、【摘要】等栏内（因不同银行备注不同，最好在所有可填备注的地方均填写）；\n3.请按照订单实际金额转账，请勿多转账或少转账。"
        lbl.attributedText = lbl.text!.fky_getAttributedStringWithLineSpace(WH(3))
        return lbl
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblContent)
        
        lblTitle.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(25)) // 12
            make.left.equalTo(contentView).offset(WH(15))
            make.height.equalTo(WH(20))
        }
        lblContent.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            make.right.equalTo(contentView).offset(-WH(15))
            make.bottom.equalTo(contentView).offset(-WH(15))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(6))
        }
        
        // 上分隔线
        let viewLineTop = UIView()
        viewLineTop.backgroundColor = RGBColor(0xE5E5E5)
        self.addSubview(viewLineTop)
        viewLineTop.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(10))
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    func configView() {
        //
    }
}
