//
//  HomeFucListCell.swift
//  FKY
//
//  Created by 寒山 on 2019/7/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class HomeFucListCell: UITableViewCell {
    
    var iconData:HomeFucButtonModel?
    
    public lazy var iconView: HomeFucButtonView = {
        let view = HomeFucButtonView ()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor =  UIColor.clear
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView);
            make.bottom.equalTo(contentView).offset(-WH(10))
        }
    }
    func configContent(_ model :HomeFucButtonModel){
        // for content  in list  {
        //if content.type == .navigation014 {
        self.iconData = model
        self.iconView.configCell(fucBtModel: self.iconData)
        // }
        //  }
    }
}
extension HomeFucListCell {
    static func getHomeFucListeCellHeight(_ cellModel:HomeNavFucCellModel) -> CGFloat {
        if let model = cellModel.model ,let itemsCount = model.navigations, itemsCount.count > 0{
            if  itemsCount.count <= 5 {
                //一行
                return WH(15) + HOME_NAV_ITEM_H + WH(10) + WH(10)
            }else if itemsCount.count <= 10 {
                //两行
                return WH(15+13) + HOME_NAV_ITEM_H*2 + WH(10) + WH(10)
            }else {
                //两行有分页
                return WH(15+13) + HOME_NAV_ITEM_H*2 + WH(13) + WH(10) + WH(10)
            }
        }
        return  WH(0)
    }
}
