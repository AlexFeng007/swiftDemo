//
//  FKYMatchingPackageNoProductCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/29.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageNoProductCell: UITableViewCell {

    /// icon
    lazy var emptyIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"as_empty")
        return image
    }()
    
    /// 文描
    lazy var emptyText:UILabel = {
        let lb = UILabel()
        lb.text = "暂无套餐"
        lb.textColor = RGBColor(0x666666)
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: WH(14))
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
extension FKYMatchingPackageNoProductCell{
    
    func setupUI(){
        self.contentView.backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(self.emptyIcon)
        self.contentView.addSubview(self.emptyText)
        
        self.emptyIcon.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(WH(-15))
            make.width.height.equalTo(WH(100))
        }
        
        self.emptyText.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.emptyIcon.snp_bottom)
        }
    }
}
