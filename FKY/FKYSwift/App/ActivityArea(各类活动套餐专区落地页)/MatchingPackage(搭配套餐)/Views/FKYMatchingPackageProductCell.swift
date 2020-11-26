//
//  FKYMatchingPackageProductCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageProductCell: UITableViewCell {

    /// 选中按钮点击
    static let FKY_ProductSelectAction = "ProductSelectAction"
    
    /// 当前商品的model
    var productModel:FKYProductModel = FKYProductModel()
    
    /// 容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 上方分割线
    lazy var topMargin:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /// 下方分割线
    lazy var bottomMargin:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /// 是否选中按钮
    lazy var selectStatusBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"img_pd_select_normal"), for: .normal)
        bt.setBackgroundImage(UIImage(named:"img_pd_select_select"), for: .selected)
        bt.addTarget(self, action: #selector(FKYMatchingPackageProductCell.selectBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商品图片
    lazy var productImage:UIImageView = UIImageView()
    
    /// 商品基本信息
    lazy var productBaseInfoView:FKYProductBaseInfoView = FKYProductBaseInfoView()
    
    /// 购买商品数量
    lazy var productQuantityView:FKYSelectItemQuantityView = FKYSelectItemQuantityView()
    
    /// 限购提示
    lazy var restrictionsTipsLb:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = .systemFont(ofSize: WH(12))
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

//MARK: - 数据展示
extension FKYMatchingPackageProductCell {
    
    /// 展示cell数据
    func showData(cellModel:FKYMatchingPackageCellModel){
        //self.topMargin.isHidden = !cellModel.isShowTopMargin
        self.bottomMargin.isHidden = !cellModel.isShowBottomMargin
        self.showProductData(product: cellModel.cellData)
        
    }
    
    /// 展示商品信息
    func showProductData(product:FKYProductModel){
        self.productModel = product
        /// 主品就隐藏
        self.isHideSelectedBtn(self.productModel.isMainProduct == 1 )
        
        if self.productModel.maxBuyNum>0{/// 有限购数量
            self.restrictionsTipsLb.text = "每次限购\(self.productModel.maxBuyNum)\(self.productModel.unitName)"
            self.isHideRestrictionsTipsLb(false)
        }else{
            self.restrictionsTipsLb.text = ""
            self.isHideRestrictionsTipsLb(true)
        }
        
        self.selectStatusBtn.isSelected = self.productModel.isSelected
        self.productImage.sd_setImage(with: URL(string: self.productModel.filePath), placeholderImage: UIImage(named:"img_product_default"))
        self.productBaseInfoView.showProduct(product1: self.productModel)
        self.productQuantityView.showProductInfo(product: self.productModel)
    }
}

//MARK: - 事件响应
extension FKYMatchingPackageProductCell {
    
    /// 选中按钮点击
    @objc func selectBtnClicked(){
        self.productModel.isSelected = !self.productModel.isSelected
        self.routerEvent(withName: FKYMatchingPackageProductCell.FKY_ProductSelectAction, userInfo: [FKYUserParameterKey:""])
    }
}


//MARK: - UI
extension FKYMatchingPackageProductCell {
    
    func setupUI(){
        
        self.topMargin.isHidden = true
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.topMargin)
        self.containerView.addSubview(self.bottomMargin)
        self.containerView.addSubview(self.selectStatusBtn)
        self.containerView.addSubview(self.productImage)
        self.containerView.addSubview(self.productBaseInfoView)
        self.containerView.addSubview(self.productQuantityView)
        self.containerView.addSubview(self.restrictionsTipsLb)
        
        self.selectStatusBtn.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.productImage.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        self.containerView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.bottom.equalToSuperview()
        }
        
        self.topMargin.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(WH(16))
            make.right.equalToSuperview().offset(WH(-16))
            make.height.equalTo(0.5)
        }
        
        self.bottomMargin.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(WH(16))
            make.right.equalToSuperview().offset(WH(-16))
            make.height.equalTo(0.5)
        }
        
        self.selectStatusBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.productImage)
            make.left.equalToSuperview().offset(WH(11))
            make.height.width.equalTo(WH(24))
        }
        
        self.productImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.selectStatusBtn.snp_right).offset(WH(18))
            make.top.equalToSuperview().offset(WH(24))
            make.height.width.equalTo(WH(73))
        }
        
        self.productBaseInfoView.snp_makeConstraints { (make) in
            make.left.equalTo(self.productImage.snp_right).offset(WH(18))
            make.top.equalToSuperview().offset(WH(14))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        self.productQuantityView.snp_makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.productImage.snp_bottom).offset(WH(18))
            make.top.greaterThanOrEqualTo(self.productBaseInfoView.snp_bottom).offset(WH(18))
            make.left.equalToSuperview().offset(WH(32))
            make.right.equalToSuperview().offset(WH(-32))
            make.height.equalTo(WH(40))
            //make.bottom.equalTo(self.restrictionsTipsLb.snp_top).offset(WH(-8))
        }
        
        self.restrictionsTipsLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.productQuantityView.snp_bottom)
            make.left.equalToSuperview().offset(WH(17))
            make.right.equalToSuperview().offset(WH(-17))
            make.bottom.equalToSuperview().offset(WH(-10))
        }
    }
    
    /// 是否隐藏下方的提示
    func isHideRestrictionsTipsLb(_ isHide:Bool){
        if isHide {
            self.restrictionsTipsLb.snp_updateConstraints { (make) in
                //make.bottom.equalToSuperview().offset(WH(0))
                make.bottom.equalToSuperview().offset(WH(-10))
            }
        }else{
            self.restrictionsTipsLb.snp_updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(WH(-10))
            }
        }
    }
    
    /// 是否隐藏选中按钮
    func isHideSelectedBtn(_ isHide:Bool){
        if isHide {
            self.selectStatusBtn.snp_updateConstraints { (make) in
                make.left.equalToSuperview().offset(WH(0))
                make.height.width.equalTo(WH(0))
            }
        }else{
            self.selectStatusBtn.snp_updateConstraints { (make) in
                make.left.equalToSuperview().offset(WH(11))
                make.height.width.equalTo(WH(24))
            }
        }
    }
}
