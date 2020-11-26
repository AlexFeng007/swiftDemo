//
//  FKYHomePageNaviItem.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageNaviItem: UICollectionViewCell {
    /// itemIcon
    var itemIcon:UIImageView = UIImageView()
    
    /// itemTitle
    lazy var itemName:UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: WH(12))
        lb.textColor = RGBColor(0x333333)
        lb.textAlignment = .center
        return lb
    }()
    
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FKYHomePageNaviItem{
    /*
    func showTestData(){
        self.itemIcon.image = UIImage(named:"icon_wx")
        self.itemName.text = "测试数据"
    }
    
    func showTestText(text:String){
        self.itemIcon.image = UIImage(named:"icon_wx")
        self.itemName.text = text
    }
    */
    
    func configItemData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        self.itemIcon.sd_setImage(with: URL(string: itemModel.imgPath))
        self.itemName.text = self.itemModel.name
    }
    
    /// 配置展示样式
    /// - Parameter type: 1有背景图  2无背景图
    func configDisplayStyle(type:Int){
        if type == 1 {
            itemName.textColor = RGBColor(0xFFFFFF)
        }else if type == 2{
            itemName.textColor = RGBColor(0x333333)
        }else{
            itemName.textColor = RGBColor(0x333333)
        }
        
    }
}

//MARK: - 私有方法
extension FKYHomePageNaviItem{
    func getIconHeight() -> CGFloat{
        return WH(44)
    }
}

//MARK: - UI
extension FKYHomePageNaviItem{
    func setupUI(){
        self.backgroundColor = .clear
        itemIcon.backgroundColor = .clear
        
        //self.itemIcon.layer.cornerRadius = self.getIconHeight()/2.0
        self.contentView.addSubview(self.itemIcon)
        self.contentView.addSubview(self.itemName)
        
        self.itemIcon.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(WH(0))
            make.width.height.equalTo(self.getIconHeight())
        }
        
        self.itemName.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(0))
            make.top.equalTo(self.itemIcon.snp_bottom).offset(WH(6))
        }
    }
}
