//
//  FKYHomePageV3SellerTagModule.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  商家打标组件

import UIKit

class FKYHomePageV3SellerTagModule: UIView {

    
//    var sellerType:UILabel = UILabel()
    
//    var sellerTypeName:UILabel = UILabel()
    
    var tagImageView:UIImageView =  {
        let imagev = UIImageView()
        return imagev
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomePageV3SellerTagModule{
    // 0 普通店铺 1 旗舰店 2 加盟店 3 自营店
    func showTag(titleText:String = "",subTitle:String,tagType:Int){
        var image = UIImage(named: "")
        if tagType == 0 {
            image = UIImage(named: "mp_shop_icon")
        }else if tagType == 1 {
            image = FKYSelfTagManager.shareInstance.tagNameForMpImage(tagName: subTitle, colorType: .orange) ?? UIImage(named: "")
        }else if tagType == 2{
            image = FKYSelfTagManager.shareInstance.tagNameForMpImage(tagName: subTitle, colorType: .purple) ?? UIImage(named: "")
        }else if tagType == 3{
            image = FKYSelfTagManager.shareInstance.tagNameImage(tagName: subTitle, colorType: .blue) ?? UIImage(named: "")
        }
        tagImageView.image = image
    }
    
    /*
    func showTestColor(){
        configColor(typeColor: RGBColor(0xFF7327))
    }
    
    func showTestText(){
        showText(type: " 自营", typeName: "华北仓 ")
    }
    
    func showText(type:String,typeName:String){
        sellerType.text = " \(type)"
        sellerTypeName.text = " \(typeName)"
    }
    */
}

//MARK: - UI
extension FKYHomePageV3SellerTagModule{
    func setupUI(){
        /*
        addSubview(sellerType)
        addSubview(sellerTypeName)
        */
        addSubview(tagImageView)
        
        tagImageView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        /*
        sellerType.font = .boldSystemFont(ofSize: WH(10))
        sellerType.adjustsFontSizeToFitWidth = true
        sellerType.minimumScaleFactor = 0.5
        sellerType.textAlignment = .center
        
        sellerTypeName.font = .boldSystemFont(ofSize: WH(10))
        sellerTypeName.adjustsFontSizeToFitWidth = true
        sellerTypeName.minimumScaleFactor = 0.5
        sellerTypeName.textAlignment = .center
        
        sellerType.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(0))
            make.bottom.equalToSuperview().offset(WH(-0))
            make.left.equalToSuperview()
            make.right.equalTo(sellerTypeName.snp_left)
        }
        
        sellerTypeName.snp_makeConstraints { (make) in
            make.left.equalTo(sellerType.snp_right)
            make.top.equalToSuperview().offset(WH(0))
            make.bottom.equalToSuperview().offset(WH(-0))
            make.right.equalToSuperview()
        }
        */
    }
    /*
    /// 配置圆角
    func configCorner(borderColor:UIColor){
//        self.layoutIfNeeded()
//        sellerType.layoutIfNeeded()
//        sellerTypeName.layoutIfNeeded()
        sellerType.sizeToFit()
        sellerTypeName.sizeToFit()
        sellerType.setMutiRoundingCorners( sellerType.hd_height/2.0, [.topLeft,.bottomLeft])
        sellerTypeName.cornerViewWithColor(byRoundingCorners: [.topRight,.bottomRight], radii: sellerTypeName.hd_height/2.0, borderColor.cgColor, 1, UIColor.clear.cgColor)
    }
    
    
    func configColor(typeColor:UIColor){
        configColor(textColor: RGBColor(0xFFFFFF), bgColor: typeColor)
    }
    
    func configColor(textColor:UIColor,bgColor:UIColor){
        configColor(typeTextColor: textColor, typeBgColor: bgColor, typeNameTextColor: bgColor, typeNameBorderColor: bgColor, TypeNameBgColor: RGBColor(0xFFFFFF))
    }
    
    func configColor(typeTextColor:UIColor,typeBgColor:UIColor,typeNameTextColor:UIColor,typeNameBorderColor:UIColor,TypeNameBgColor:UIColor){
        sellerType.textColor = typeTextColor
        sellerType.backgroundColor = typeBgColor
        sellerTypeName.textColor = typeNameTextColor
//        sellerTypeName.layer.borderColor = typeNameBorderColor.cgColor
        configCorner(borderColor: typeNameBorderColor)
        sellerTypeName.backgroundColor = TypeNameBgColor
    }
    
    */
}
