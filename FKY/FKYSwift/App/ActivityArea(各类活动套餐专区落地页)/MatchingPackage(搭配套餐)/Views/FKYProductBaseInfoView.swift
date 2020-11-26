//
//  FKYProductBaseInfoView.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  商品基本信息 名称 规格 厂家 有效期 购买规格 价格

import UIKit

class FKYProductBaseInfoView: UIView {

    /// 商品信息Model，为了考虑以后可能有多种不同的model传进来，这里直接用1 2 3 区分
    var productModel1:FKYProductModel = FKYProductModel()
    
    /// 商品名称
    lazy var nameLB: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(14))
        lb.numberOfLines = 2
        return lb
    }()

    /// 商品规格
    lazy var specsLB: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()

    /// 厂家
    lazy var factoryLB: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()

    /// 有效期
    lazy var validityTermLB: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()

    /// 价格优惠信息
    lazy var favorablePriceLB: UILabel = {
        let lb = UILabel()
        lb.text = ""
        return lb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 数据展示
extension FKYProductBaseInfoView {
    
    /// 展示商品信息
    func showProduct(product1:FKYProductModel){
        self.productModel1 = product1
        
        self.nameLB.text = self.productModel1.productName
        
        self.specsLB.text = self.productModel1.spec
        self.isHideSpaceLB(self.productModel1.spec.isEmpty)
        
        self.factoryLB.text = self.productModel1.factoryName
        self.isHideFactoryLB(self.productModel1.factoryName.isEmpty)
        
        if self.productModel1.expireDate.isEmpty == false{
            self.validityTermLB.text = "有效期：\(self.productModel1.expireDate)"
            self.isHideValidityTermLB(false)
        }else{
            self.validityTermLB.text = ""
            self.isHideValidityTermLB(false)
        }
        
        if self.productModel1.discountMoney > 0{
            let str1 = NSAttributedString.getAttributedStringWith(contentStr: "满\(self.productModel1.doorsill)\(self.productModel1.unitName)：", color: RGBColor(0x666666), font: .systemFont(ofSize: WH(12)))
            let str2 = NSAttributedString.getAttributedStringWith(contentStr: "￥", color: RGBColor(0xFF2D5C), font: .boldSystemFont(ofSize: WH(12)))
            let str3 = NSAttributedString.getAttributedStringWith(contentStr: String.init(format: "%.2f", self.productModel1.dinnerPrice) , color: RGBColor(0xFF2D5C), font: .boldSystemFont(ofSize: WH(18)))
            let str = NSMutableAttributedString()
            str.append(str1)
            str.append(str2)
            str.append(str3)
            self.favorablePriceLB.attributedText = str
            self.isHidefavorablePriceLB(false)
        }else{
            self.favorablePriceLB.attributedText = NSAttributedString.init(string: "")
            self.isHidefavorablePriceLB(true)
        }
    }
}

//MARK: - UI
extension FKYProductBaseInfoView {

    func setupUI() {
        self.addSubview(self.nameLB)
        self.addSubview(self.specsLB)
        self.addSubview(self.factoryLB)
        self.addSubview(self.validityTermLB)
        self.addSubview(self.favorablePriceLB)

        self.nameLB.snp_makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }

        self.specsLB.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.nameLB.snp_bottom).offset(WH(6))
        }

        self.factoryLB.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.specsLB.snp_bottom).offset(WH(12))
        }

        self.validityTermLB.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.factoryLB.snp_bottom).offset(WH(5))
        }

        self.favorablePriceLB.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.validityTermLB.snp_bottom).offset(WH(10))
            make.bottom.equalToSuperview().offset(WH(-2))
        }
        
    }

    /// 是否隐藏规格
    func isHideSpaceLB(_ isHide: Bool) {
        if isHide { // 隐藏
            self.specsLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.nameLB.snp_bottom).offset(WH(0))
            }
        } else {
            self.specsLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.nameLB.snp_bottom).offset(WH(6))
            }
        }
    }

    /// 是否隐藏厂家
    func isHideFactoryLB (_ isHide: Bool) {
        if isHide { // 隐藏
            self.factoryLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.specsLB.snp_bottom).offset(WH(0))
            }
        } else {
            self.factoryLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.specsLB.snp_bottom).offset(WH(12))
            }
        }
    }

    /// 是否隐藏有效期
    func isHideValidityTermLB(_ isHide: Bool) {
        if isHide { // 隐藏
            self.validityTermLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.factoryLB.snp_bottom).offset(WH(0))
            }
        } else {
            self.validityTermLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.factoryLB.snp_bottom).offset(WH(5))
            }
        }
    }

    /// 是否隐藏几个优惠信息
    func isHidefavorablePriceLB(_ isHide: Bool) {
        if isHide { // 隐藏
            self.favorablePriceLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.validityTermLB.snp_bottom).offset(WH(0))
            }
        } else {
            self.favorablePriceLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.validityTermLB.snp_bottom).offset(WH(10))
            }
        }
    }

}
