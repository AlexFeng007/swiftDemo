//
//  FKYStationMsgCellType1.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYStationMsgCellType1: UITableViewCell {

    var item1:FKYStationMsgCellType1ItemView = FKYStationMsgCellType1ItemView()
    
    var item2:FKYStationMsgCellType1ItemView = FKYStationMsgCellType1ItemView()
    
    // cellModel
    var cellModel:FKYStationMsgCellModel = FKYStationMsgCellModel()
    
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

//MARK: - 数据显示
extension FKYStationMsgCellType1{
    func showTestData(){
        self.item1.showTestData()
        self.item2.showTestData()
    }
    
    func showCellData(cellModel:FKYStationMsgCellModel){
        self.cellModel = cellModel
        if self.cellModel.type1DataList.count > 0{
            self.item1.isHidden = false
            self.item1.showData(model: self.cellModel.type1DataList[0])
        }else{
            self.item1.isHidden = true
        }
        
        if self.cellModel.type1DataList.count > 1{
            self.item2.isHidden = false
            self.item2.showData(model: self.cellModel.type1DataList[1])
        }else{
            self.item2.isHidden = true
        }
    }
}

//MARK: - 事件响应
extension FKYStationMsgCellType1{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYStationMsgCellType1ItemView.itemClickAction {// item点击
            let item = userInfo[FKYUserParameterKey] as! FKYStationMsgCellType1ItemView
            if item == self.item1{
                let userInfo_t = [FKYUserParameterKey:["itemType":"1"]]
                super.routerEvent(withName: eventName, userInfo: userInfo_t)
                return
            }else if item == self.item2{
                let userInfo_t = [FKYUserParameterKey:["itemType":"2"]]
                super.routerEvent(withName: eventName, userInfo: userInfo_t)
                return
            }
        }
        super.routerEvent(withName: eventName, userInfo: userInfo)
    }
}

//MARK: - UI
extension FKYStationMsgCellType1{
    func setupUI(){
        self.selectionStyle = .none
        self.contentView.addSubview(self.item1)
        self.contentView.addSubview(self.item2)
        
        self.item1.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(29))
            make.bottom.equalToSuperview().offset(WH(-29))
            make.left.equalToSuperview().offset(WH(29))
            make.width.equalTo(WH(135))
            make.height.equalTo(WH(40))
        }
        
        self.item2.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(29))
            make.right.equalToSuperview().offset(WH(-29))
            make.bottom.equalToSuperview().offset(WH(-29))
            make.width.equalTo(WH(135))
            make.height.equalTo(WH(40))
        }
    }
}
