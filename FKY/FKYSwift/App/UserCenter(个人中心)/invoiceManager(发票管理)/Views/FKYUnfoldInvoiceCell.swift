//
//  FKYUnfoldInvoiceCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 展开cell
let FKY_unfoldInvoiceCell = "unfoldInvoiceCell"

class FKYUnfoldInvoiceCell: UITableViewCell {
    
    ///展开按钮
    lazy var unfoldBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("填写其他信息", for: .normal)
        btn.setTitleColor(RGBColor(0x999999), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.addTarget(self, action: #selector(unfoldInvoice), for: .touchUpInside)
        return btn
    }()
    
    ///展开icon
    lazy var unfoldIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "downIcon")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

//MARK: - 事件响应
extension FKYUnfoldInvoiceCell{
    @objc func unfoldInvoice(){
        self.routerEvent(withName: FKY_unfoldInvoiceCell, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - 刷新数据
extension FKYUnfoldInvoiceCell{
    func showData(cellData:FKYInvoiceCellModel){
        
    }
}

//MARK: - UI
extension FKYUnfoldInvoiceCell{
    func setupView(){
        self.selectionStyle = .none
        
        self.contentView.addSubview(unfoldBtn)
        self.contentView.addSubview(unfoldIcon)
        
        unfoldBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(WH(146))
        }
        
        unfoldIcon.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(unfoldBtn.snp_right).offset(WH(3))
            make.width.equalTo(WH(7))
            make.height.equalTo(WH(3))
        }
    }
    
    
}

extension FKYUnfoldInvoiceCell{
    ///获取行高
    static func getCellHeight() -> CGFloat{
        return WH(38.0)
    }
}
