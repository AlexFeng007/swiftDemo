//
//  OftenBuySellerCell.swift
//  FKY
//
//  Created by 路海涛 on 2017/4/21.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  常购商家之商家cell

import UIKit

class OftenBuySellerCell: UITableViewCell {

    fileprivate var logo: UIImageView?
    fileprivate var name: UILabel?
    fileprivate var count: UILabel?
    fileprivate var top: UIView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() -> () {
        logo = {
            let img = UIImageView()
            img.backgroundColor = UIColor.blue
            self.contentView.addSubview(img)
            img.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(15)
                make.height.equalTo(60)
                make.width.equalTo(110)
                make.centerY.equalTo(self.contentView).offset(5)
            })
            return img
        }()

        name = {
            let lab = UILabel()
            lab.fontTuple = t9

            self.contentView.addSubview(lab)
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.top).offset(24)
                make.right.equalTo(self.snp.right).offset(-10)
                make.left.equalTo(self.logo!.snp.right).offset(24)
                make.height.equalTo(15)
            })
            return lab
        }()

        count = {
            let lab = UILabel()
            lab.fontTuple = t20
            self.contentView.addSubview(lab)
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.name!.snp.bottom).offset(8)
                make.right.equalTo(self.contentView.snp.right).offset(-10)
                make.left.equalTo(self.logo!.snp.right).offset(24)
                make.height.equalTo(15)
            })
            return lab
        }()

        top = {
            let view = UIView()
            view.backgroundColor = bg2
            self.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(self.contentView)
                make.height.equalTo(10)
            })
            return view
        }()
    }

    func config(_ model: OftenBuySellerModel) -> () {
        self.logo!.sd_setImage(with: URL.init(string: model.logo!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
                                     placeholderImage: UIImage.init(named: "image_default_img"))
        self.name?.text = model.shopName
        let str = String(format: "%.2f", Double(model.orderSamount!)!)
        self.count?.text = "最低发货金额：¥\(str)"
    }
}
