//
//  FKYFKYFKYNewProductRegisterUploadImageCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/8.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 删除按钮点击
let FKY_NewProductRegisterDeleteButtonClicked = "NewProductRegisterDeleteButtonClicked"
/// 选择图片按钮点击
let FKY_NewProductRegisterSelectImageButtonClicked = "NewProductRegisterSelectImageButtonClicked"

class FKYNewProductRegisterUploadImageCell: UITableViewCell {

    
    /// cellModel
    var cellModel = FKYNewProductRegisterCellModel()
    /// 是否是第一个cell
    var isFirstCell = false
    /// 是否是最后一个cell
    var isLastCell = false
    
    /// 容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 上方标题lb
    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x666666)
        lb.font = UIFont.boldSystemFont(ofSize: WH(13))
        return lb
    }()
    
    /// 保存已经创建的image
    lazy var imageViewList:[FKYSelectImageView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: - 事件响应
extension FKYNewProductRegisterUploadImageCell{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_NewProductRegisterDeleteButtonClicked{// 拦截删除图片
            let image = userInfo[FKYUserParameterKey] as! UploadImageModel
            let param = ["cellModel":self.cellModel,
                         "imageModel":image]
            super.routerEvent(withName: eventName, userInfo: [FKYUserParameterKey:param])
        }else if eventName == FKY_NewProductRegisterSelectImageButtonClicked{
            let image = userInfo[FKYUserParameterKey] as! UploadImageModel
            let param = ["cellModel":self.cellModel,
                         "imageModel":image]
            super.routerEvent(withName: eventName, userInfo: [FKYUserParameterKey:param])
        }else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}

//MARK: - 显示数据
extension FKYNewProductRegisterUploadImageCell{
    
    func showCellData(cellModel:FKYNewProductRegisterCellModel){
        self.cellModel = cellModel
        self.isFirstCell = self.cellModel.isFirstCell
        self.isLastCell = self.cellModel.isLastCell
        self.titleLabel.text = self.cellModel.titleTexxt
        self.addUploadListImageView()
        self.addRoundedCorners()
    }
}

//MARK: - UI
extension FKYNewProductRegisterUploadImageCell{
    
    func setupUI(){
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.titleLabel)
        
        self.containerView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(WH(10))
            make.right.equalTo(self.contentView).offset(WH(-10))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(11))
            make.left.equalToSuperview().offset(WH(16))
            make.right.equalToSuperview().offset(WH(-16))
        }
    }
    
    /// 添加上传图片列表
    func addUploadListImageView(){
        for image in self.imageViewList {
            image.removeFromSuperview()
        }
        self.imageViewList.removeAll()
        var lastImageView = FKYSelectImageView()
        for (index,imageModel) in self.cellModel.uploadImageList.enumerated() {
            let imageView = FKYSelectImageView()
            self.containerView.addSubview(imageView)
            if index == 0 && index != self.cellModel.uploadImageList.count - 1{//第一个
                imageView.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(16))
                    make.top.equalTo(self.titleLabel.snp_bottom).offset(WH(10))
                    make.bottom.equalToSuperview().offset(WH(-13))
                }
            }else if index == self.cellModel.uploadImageList.count - 1 && index != 0{// 最后一个
                imageView.snp_remakeConstraints { (make) in
                    make.left.equalTo(lastImageView.snp_right).offset(WH(16))
                    make.top.equalTo(self.titleLabel.snp_bottom).offset(WH(10))
                    make.bottom.equalToSuperview().offset(WH(-13))
                }
            }else if index == 0 && index == self.cellModel.uploadImageList.count - 1{// 既是第一个也是最后一个
                imageView.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(16))
                    make.top.equalTo(self.titleLabel.snp_bottom).offset(WH(10))
                    make.bottom.equalToSuperview().offset(WH(-13))
                }
            }else{// 中间的
                imageView.snp_remakeConstraints { (make) in
                    make.left.equalTo(lastImageView.snp_right).offset(WH(16))
                    make.top.equalTo(self.titleLabel.snp_bottom).offset(WH(10))
                    make.bottom.equalToSuperview().offset(WH(-13))
                }
            }
            lastImageView = imageView
            self.imageViewList.append(imageView)
            imageView.showImage(image: imageModel)
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
        self.layoutIfNeeded()
        
        
        var rect = self.containerView.bounds
        var height:CGFloat = 0
        height += WH(11)
        self.titleLabel.sizeToFit()
        height += self.titleLabel.hd_height
        height += WH(10)
        height += WH(69)
        height += WH(13)
        rect.size.width = SCREEN_WIDTH - WH(20)
        rect.size.height = height
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: WH(8) ,height: WH(8)))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.containerView.bounds
        maskLayer.path = maskPath.cgPath
        self.containerView.layer.mask = maskLayer
    }
}


//MARK: - 选择image的单个视图
class FKYSelectImageView: UIView {
    
    /// 当前显示的image
    var currentImage = UploadImageModel()
    
    /// 边框图标
    var borderImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"New_Product_Register_Border_icon_imaginary_line")
        // 实线New_Product_Register_Border_icon_full_line
        return image
    }()
    
    /// 商品图标
    var productImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"")
        return image
    }()
    
    /// 选择图片图标
    lazy var selectImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"New_Product_Register_Select_Image")
        return image
    }()
    
    /// 删除图片按钮
    lazy var deleteButton:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"New_Product_Register_Deleta_Image"), for: .normal)
        bt.addTarget(self, action: #selector(FKYSelectImageView.deleteButtonClicked), for: .touchUpInside)
        bt.setEnlargeEdgeWith(top: 10, right: 10, bottom: 10, left: 10)
        return bt
    }()
    
    /// 选择图片按钮
    lazy var selectImageButton:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:""), for: .normal)
        bt.addTarget(self, action: #selector(FKYSelectImageView.selectImageButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 显示数据
extension FKYSelectImageView {
    
    func showImage(image:UploadImageModel){
        self.currentImage = image
//        self.productImageView.image = self.currentImage.image
        
        if self.currentImage.isHaveImage {
            self.haveImageShowType()
            self.productImageView.sd_setImage(with: URL(string: self.currentImage.imageUrl))
        }else{
            self.haveNoImageShowType()
        }
    }
}

//MARK: - UI
extension FKYSelectImageView {
    
    func setupUI(){
        
        self.addSubview(self.borderImageView)
        self.addSubview(self.productImageView)
        self.addSubview(self.selectImageView)
        self.addSubview(self.deleteButton)
        self.addSubview(self.selectImageButton)
        
        self.borderImageView.snp_makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.height.equalTo(WH(62))
        }
        
        self.deleteButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.borderImageView.snp_right)
            make.centerY.equalTo(self.borderImageView.snp_top)
            make.top.right.equalToSuperview()
            make.width.height.equalTo(WH(14))
        }
        
        self.productImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.borderImageView)
            make.width.height.equalTo(WH(51))
        }
        
        self.selectImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.borderImageView)
            make.width.height.equalTo(WH(17))
        }
        
        self.selectImageButton.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.borderImageView)
        }
    }
    
    /// 有图片的显示方案
    func haveImageShowType(){
        self.borderImageView.image = UIImage(named: "New_Product_Register_Border_icon_full_line")
        self.selectImageView.isHidden = true
        self.deleteButton.isHidden = false
        self.productImageView.isHidden = false
    }
    
    /// 没有图片的显示方案
    func haveNoImageShowType(){
        self.borderImageView.image = UIImage(named: "New_Product_Register_Border_icon_imaginary_line")
        self.selectImageView.isHidden = false
        self.deleteButton.isHidden = true
        self.productImageView.isHidden = false
    }
}

//MARK: - 响应事件
extension FKYSelectImageView {
    
    /// 删除按钮点击
    @objc func deleteButtonClicked(){
        self.routerEvent(withName: FKY_NewProductRegisterDeleteButtonClicked, userInfo: [FKYUserParameterKey:self.currentImage])
    }
    
    /// 选择图片按钮点击
    @objc func selectImageButtonClicked(){
        self.routerEvent(withName: FKY_NewProductRegisterSelectImageButtonClicked, userInfo: [FKYUserParameterKey:self.currentImage])
    }
}
