//
//  FKYDiscountPackageCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  套餐优惠入口 优惠套餐入口

import UIKit

/// 优惠套餐推广入口点击事件
let FKY_goInDiscountPackage = "goInDiscountPackage"

class FKYDiscountPackageCell: UITableViewCell {

    /// 展示的Model
    var cellModel:FKYDiscountPackageModel = FKYDiscountPackageModel()
    
    /// 入口图片按钮
    lazy var ImageButton:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYDiscountPackageCell.discountPakageBtnClicked), for: .touchUpInside)
        //bt.layer.cornerRadius = WH(8)
        //bt.layer.masksToBounds = true
        //bt.setBackgroundImage(UIImage(named: "710_176"), for: .normal)
        return bt
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

/// 数据展示
extension FKYDiscountPackageCell {
    
    @objc func configEntryImage(ImageUrl:String){
        self.ImageButton.sd_setBackgroundImage(with: URL(string: ImageUrl), for: .normal)
    }
    
    @objc func configEntryWithModel(model:FKYDiscountPackageModel){
        self.cellModel = model
        self.ImageButton.sd_setBackgroundImage(with: URL(string: model.imgPath), for: .normal)
    }
}

//MARK: - 事件响应
extension FKYDiscountPackageCell{
    @objc func discountPakageBtnClicked() {
        self.routerEvent(withName: FKY_goInDiscountPackage, userInfo: [FKYUserParameterKey:self.cellModel])
    }
}

//MARK: - UI
extension FKYDiscountPackageCell {
    func setupUI(){
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.ImageButton)
        //self.backgroundColor = RGBColor(0xF2F2F2)
        self.backgroundColor = .clear
        
        self.ImageButton.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.equalToSuperview().offset(WH(10))
            make.bottom.equalToSuperview().offset(WH(-10))
            make.height.equalTo(176.0*SCREEN_WIDTH/710.0)
        }
    }
}
