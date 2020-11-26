//
//  FKYRebateDetailCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYRebateDetailCell: UITableViewCell {
    
    /// 数据对象
    var dataModel = FKYRebateSellerTypeModel()
    
    lazy var contianerView:FKYRebateDetailContainerView = {
        let view = FKYRebateDetailContainerView()
        return view
    }()
    
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
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - UI
extension FKYRebateDetailCell{
    
    func setupUI(){
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.contianerView)
        
        self.contianerView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(WH(-11))
            make.left.equalTo(self.contentView).offset(WH(16))
            make.right.equalTo(self.contentView).offset(WH(-16))
        }
    }
    
    /// 获取cell高度
    static func getCellHeight(_ data:FKYRebateSellerTypeModel) -> CGFloat{
        return FKYRebateDetailContainerView.getCellHeight(data)
    }
}


//MARK: - 数据刷新
extension FKYRebateDetailCell{
    func showData(data:FKYRebateSellerTypeModel){
        self.dataModel = data
        self.contianerView.showData(data: self.dataModel)
    }
}


