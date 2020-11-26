//
//  FKYHomePageV3ProductDesModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageV3ProductDesModel: UIView {

    /// 商品名称
    lazy var productName:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(14))
        lb.numberOfLines = 2
        return lb
    }()
    
    /// 商品描述
    lazy var productDes:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFF6247)
        lb.font = .boldSystemFont(ofSize: WH(11))
        lb.numberOfLines = 0
        return lb
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
extension FKYHomePageV3ProductDesModel{
    func showTestData(){
        productName.text = "阿斯利康 酒石酸美托洛尔片 25mg"
        productDes.text  = "“药材好,药才好”道地药造好药"
    }
    
    func showText(title:String,subTitle:String){
        productName.text = title
        productDes.text = subTitle
//        let contentSize = (productName.text ?? "").boundingRect(with: CGSize(width: WH(172 - 18), height: WH(35)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14))], context: nil).size
//        productName.snp_remakeConstraints { (make) in
//            make.left.top.right.equalToSuperview()
//            make.height.equalTo(contentSize.height + 1)
//        }
    }
}

//MARK: - UI
extension FKYHomePageV3ProductDesModel{
    func setupUI(){
        addSubview(productName)
        addSubview(productDes)
        
        productName.snp_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        
        productDes.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(-10))
            make.top.equalTo(productName.snp_bottom).offset(WH(6))
        }
    }
    @objc
    static func getContentHeight(title:String,subTitle:String) -> CGFloat{
        let contentSize = title.boundingRect(with: CGSize(width: WH(172 - 18), height: WH(35)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14))], context: nil).size
        return contentSize.height + 1 + WH(6) + WH(10) + WH(12)
    }
}
