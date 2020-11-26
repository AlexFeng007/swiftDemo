//
//  FKYSearchKeyWordBuyRecCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchKeyWordBuyRecCell: UICollectionViewCell {
    
    var cellModel:FKYSearchSellerFoundModel = FKYSearchSellerFoundModel()
    
    /// 店铺名称
    var shopName:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .systemFont(ofSize: WH(14))
        return lb
    }()
    
    /// 购买记录
    var buyRec:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()
    
    /// 容器视图
    var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.layer.cornerRadius = WH(6)
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK：- 数据展示
extension FKYSearchKeyWordBuyRecCell{
    func configCell(_ cellModel_t:FKYSearchSellerFoundModel){
        self.cellModel = cellModel_t
        self.shopName.text = self.cellModel.supply_name
        self.buyRec.text = "近3个月您曾购买过\(self.cellModel.count)次"
    }
}

//MARK：- UI
extension FKYSearchKeyWordBuyRecCell{
    
    func setupUI(){
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.shopName)
        self.containerView.addSubview(self.buyRec)
        
        self.containerView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            /*
            make.height.equalTo(WH(48))
            make.width.equalTo(WH(165)
            */
        }
        
        self.shopName.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(7))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        self.buyRec.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.shopName)
            make.top.equalTo(self.shopName.snp_bottom)
            make.bottom.equalToSuperview().offset(WH(-9))
        }
    }
    
    static func getItemSize(text:String) -> CGSize{
        return CGSize(width: WH(165), height: WH(48))
    }
}
