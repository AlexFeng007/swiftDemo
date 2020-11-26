//
//  FKYTogeterNoDataCell.swift
//  FKY
//
//  Created by hui on 2018/10/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterNoDataCell: UITableViewCell {
    
    fileprivate lazy var iconImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "icon_often_none")
        img.contentMode = .scaleAspectFit
        return img
    }()
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = t24.font
        label.textColor = RGBColor(0x666666)
        return label
    }()
    fileprivate lazy var tipShopLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = t24.font
        label.textColor = RGBColor(0x333333)
        label.text = "先去看看自营店铺"
        return label
    }()
    // 进入店铺管
    fileprivate lazy var goShopDetailBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("进入店铺馆", for: .normal)
        btn.titleLabel?.font = t8.font
        btn.setTitleColor(RGBColor(0x000000), for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            FKYNavigator.shared().openScheme(FKY_ShopItem.self) { [weak self](vc) in
                if let strongSelf = self {
                    let v = vc as! FKYNewShopItemViewController
                    v.shopId = strongSelf.enterpriseId
                }
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    fileprivate var enterpriseId:String?//自营的id
    func setupView() {
        contentView.addSubview(self.iconImg)
        self.iconImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(WH(41))
            make.width.height.equalTo(WH(100))
        }
        contentView.addSubview(self.tipLabel)
        self.tipLabel.snp.makeConstraints { (make) in
            make.height.equalTo(WH(20))
            make.top.equalTo(self.iconImg.snp.bottom).offset(WH(15))
            make.left.equalTo(contentView.snp.left).offset(WH(20))
            make.right.equalTo(contentView.snp.right).offset(-WH(20))
        }
        contentView.addSubview(self.tipShopLabel)
        self.tipShopLabel.snp.makeConstraints { (make) in
            make.height.equalTo(WH(20))
            make.top.equalTo(self.tipLabel.snp.bottom).offset(WH(2))
            make.left.equalTo(contentView.snp.left).offset(WH(20))
            make.right.equalTo(contentView.snp.right).offset(-WH(20))
        }
        contentView.addSubview(self.goShopDetailBtn)
        self.goShopDetailBtn.snp.makeConstraints { (make) in
            make.height.equalTo(WH(24))
            make.top.equalTo(self.tipShopLabel.snp.bottom).offset(WH(9))
            make.width.equalTo(WH(78))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        // 底部分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = bg7
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(0.5)
        })
    }
    
    func configCell(_ tipStr : String ,_ enterpriseId:String?) {
        self.tipLabel.text = tipStr
        self.enterpriseId = enterpriseId
    }
}
