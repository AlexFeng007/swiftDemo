//
//  FKYFKYNewProductRegisterProductInfoCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/8.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 重新选择按钮点击
let FKY_NewProductRegisterRechooseButtonClicked = "NewProductRegisterRechooseButtonClicked"
/// BI埋点事件
let FKY_NewProductRegisterInpuBI = "NewProductRegisterInpuBI"

class FKYNewProductRegisterProductInfoCell: UITableViewCell {
    
    /// 是否是第一个cell
    var isFirstCell = false
    /// 是否是最后一个cell
    var isLastCell = false
    /// cellModel
    var cellModel = FKYNewProductRegisterCellModel()
    
    /// 标品列表的cellModel
    var standarProductCellModel = FKYStandardProductCellModel()
    /// showType  1登记页样式  2 标品列表样式
    //    var showType = 1
    
    /// 容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 从左到右的完整分割线
    lazy var fullMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        view.isHidden = true
        return view
    }()
    
    /// 商品图片
    lazy var productImage:UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    /// 商品名称
    lazy var productNameLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = UIFont.boldSystemFont(ofSize: WH(16))
        lb.numberOfLines = 2
        return lb
    }()
    
    /// 规格
    lazy var specificationLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.numberOfLines = 1
        return lb
    }()
    
    /// 商家名称
    lazy var sellerNameLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x999999)
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.numberOfLines = 1
        return lb
    }()
    
    /// 是否选中按钮
    lazy var isSelectedButton:UIImageView = {
        let image = UIImageView()
//        bt.isUserInteractionEnabled = false
//        bt.setBackgroundImage(UIImage(named: "New_Product_Unselected"), for: .normal)
        image.image = UIImage(named:"New_Product_Unselected")
        return image
    }()
    
    ///重新选择容器视图
    lazy var rechooseContainerView:UIView = {
        let view = UIView()
        return view
    }()
    
    /// 重新选择文字
    lazy var rechooseLabel:UILabel = {
        let lb = UILabel()
        lb.text = "重新选择"
        lb.textColor = RGBColor(0x999999)
        lb.textAlignment = .right
        lb.font = UIFont.systemFont(ofSize: WH(13))
        return lb
    }()
    
    /// 重新选择icon
    lazy var rechooseIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon_arrow_middle")
        return image
    }()
    
    /// 重新选择按钮
    lazy var rechooseButton:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYNewProductRegisterProductInfoCell.rechooseButtonClicked), for: .touchUpInside)
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

//MARK: - 数据显示
extension FKYNewProductRegisterProductInfoCell {
    
    /// 显示cell信息
    func showCellData(cellModel:FKYNewProductRegisterCellModel) {
        self.rechooseContainerView.isHidden = false
        self.isSelectedButton.isHidden = true
        self.fullMarginLine.isHidden = true
        self.cellModel = cellModel
        self.isFirstCell = self.cellModel.isFirstCell
        self.isLastCell = self.cellModel.isLastCell
        if let strProductPicUrl = self.cellModel.productInfo.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImage.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "img_product_default"))
        }else{
            self.productImage.image = UIImage.init(named: "image_default_img")
        }
        self.productNameLabel.text = self.cellModel.productInfo.productName
//        self.productNameLabel.text = "啊多少分凯萨琳开房间啊牢房看见啊放假啊上飞机啊舒服啊多少分凯萨琳开房间啊牢房看见啊放假啊上飞机啊舒服啊多少分凯萨琳开房间啊牢房看见啊放假啊上飞机啊舒服啊多少分凯萨琳开房间啊牢房看见啊放假啊上飞机啊舒服"
        self.specificationLabel.text = self.cellModel.productInfo.spec
        self.sellerNameLabel.text = self.cellModel.productInfo.manufacturer
        self.productNameLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(self.productImage)
            make.left.equalTo(self.productImage.snp_right).offset(WH(13))
            make.right.equalTo(self.rechooseContainerView.snp_left)
        }
        self.addRoundedCorners()
    }
    
    /// 标品列表的显示方案
    func showStandarProduct(cellModel:FKYStandardProductCellModel){
        self.rechooseContainerView.isHidden = true
        self.isSelectedButton.isHidden = false
        self.fullMarginLine.isHidden = false
        self.standarProductCellModel = cellModel
        if let strProductPicUrl = self.standarProductCellModel.product.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImage.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "img_product_default"))
        }else{
            self.productImage.image = UIImage.init(named: "image_default_img")
        }
        self.productNameLabel.text = self.standarProductCellModel.product.productName
//        self.productNameLabel.text = "啊多少分凯萨琳开房间啊牢房看见啊放假啊上飞机啊舒服啊多少分凯萨琳开房间啊牢房看见啊放假啊上飞机啊舒服啊多少分凯萨琳开房间啊牢房看见啊放假啊上飞机啊舒服啊多少分凯萨琳开房间啊牢房看见啊放假啊上飞机啊舒服"
        self.specificationLabel.text = self.standarProductCellModel.product.spec
        self.sellerNameLabel.text = self.standarProductCellModel.product.manufacturer
        self.backgroundColor = RGBColor(0xFFFFFF)
        if self.standarProductCellModel.isSelected {
            
            self.isSelectedButton.image = UIImage(named: "New_Product_Selected")
        }else{
            self.isSelectedButton.image = UIImage(named: "New_Product_Unselected")
        }
        self.productNameLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(self.productImage)
            make.left.equalTo(self.productImage.snp_right).offset(WH(13))
            make.right.equalTo(self.isSelectedButton.snp_left)
        }
    }
}

//MARK: - 响应事件
extension FKYNewProductRegisterProductInfoCell {
    
    /// 重新选择按钮点击
    @objc func rechooseButtonClicked(){
        self.routerEvent(withName: FKY_NewProductRegisterRechooseButtonClicked, userInfo: [FKYUserParameterKey:""])
    }
}


//MARK: - UI
extension FKYNewProductRegisterProductInfoCell {
    func setupUI(){
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        self.contentView.addSubview(self.fullMarginLine)
        
        self.containerView.addSubview(self.productImage)
        self.containerView.addSubview(self.productNameLabel)
        self.containerView.addSubview(self.specificationLabel)
        self.containerView.addSubview(self.sellerNameLabel)
        self.containerView.addSubview(self.rechooseContainerView)
        self.containerView.addSubview(self.isSelectedButton)
        
        self.rechooseContainerView.addSubview(self.rechooseLabel)
        self.rechooseContainerView.addSubview(self.rechooseIcon)
        self.rechooseContainerView.addSubview(self.rechooseButton)
        
        self.containerView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(WH(10))
            make.right.equalTo(self.contentView).offset(WH(-10))
        }
        
        self.fullMarginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.productImage.snp_makeConstraints { (make) in
            make.top.equalTo(self.containerView).offset(WH(24))
            make.width.height.equalTo(WH(60))
            make.left.equalTo(self.containerView).offset(WH(13))
            make.bottom.lessThanOrEqualTo(self.containerView).offset(WH(-16))
        }
        
        self.productNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.productImage)
            make.left.equalTo(self.productImage.snp_right).offset(WH(13))
            make.right.equalTo(self.rechooseContainerView.snp_left)
        }
        
        self.specificationLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.productNameLabel.snp_bottom).offset(WH(5))
            make.left.right.equalTo(self.productNameLabel)
        }
        
        self.sellerNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.specificationLabel.snp_bottom).offset(WH(5))
            make.left.equalTo(self.productNameLabel)
            make.right.equalTo(self.containerView)
            make.bottom.lessThanOrEqualTo(self.containerView).offset(WH(-20))
        }
        
        self.isSelectedButton.snp_makeConstraints { (make) in
            make.width.height.equalTo(WH(26))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-27)
        }
        
        self.rechooseContainerView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.containerView)
            make.right.equalTo(self.containerView).offset(WH(-16))
            make.width.equalTo(WH(70))
        }
        
        self.rechooseLabel.snp_makeConstraints { (make) in
            make.left.bottom.top.equalToSuperview()
            make.right.equalTo(self.rechooseIcon.snp_left)
        }
        
        self.rechooseIcon.snp_makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalTo(WH(7))
            make.height.equalTo(WH(11))
            make.centerY.equalToSuperview()
        }
        
        self.rechooseButton.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    /// 显示圆角
    func addRoundedCorners(){
        var corner:UIRectCorner = UIRectCorner()
        if self.isFirstCell && !self.isLastCell {
            corner = [.topRight, .topLeft]
        }else if !self.isFirstCell && self.isLastCell {
            corner = [.bottomRight, .bottomLeft]
        }else if self.isFirstCell && self.isLastCell {
            corner = [.topLeft,.topRight, .bottomRight, .bottomLeft]
        }
        
        self.setNeedsLayout()
        self.layoutSubviews()
        self.productNameLabel.layoutIfNeeded()
        self.specificationLabel.layoutIfNeeded()
        self.sellerNameLabel.layoutIfNeeded()
        self.productNameLabel.sizeToFit()
        self.specificationLabel.sizeToFit()
        self.sellerNameLabel.sizeToFit()
        
        var height1:CGFloat = 0
        height1 += WH(24)
        height1 += self.productNameLabel.hd_height
        height1 += WH(5)
        height1 += self.specificationLabel.hd_height
        height1 += WH(5)
        height1 += self.sellerNameLabel.hd_height
        height1 += WH(20)
        
        var height2:CGFloat = 0
        height2 += WH(24)
        height2 += WH(60)
        height2 += WH(16)
        var rect = self.containerView.bounds
        rect.size.width = SCREEN_WIDTH - WH(20)
        rect.size.height = height1 > height2 ? height1:height2
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: WH(8) ,height: WH(8) ))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.containerView.bounds
        maskLayer.path = maskPath.cgPath
        self.containerView.layer.mask = maskLayer
    }
}


