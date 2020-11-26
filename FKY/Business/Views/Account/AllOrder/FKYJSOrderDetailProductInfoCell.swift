//
//  FKYJSOrderDetailProductInfoCell.swift
//  FKY
//
//  Created by mahui on 16/9/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit

class FKYJSOrderDetailProductInfoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var icon : UIImageView?
    fileprivate var name : UILabel?
    fileprivate var price : UILabel?
    fileprivate var spe : UILabel?
    fileprivate var supply : UILabel?
    fileprivate var count : UILabel?
    
    fileprivate func setupView() -> () {
        icon = {
           let view = UIImageView()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(j1)
                make.centerY.equalTo(self.contentView)
                make.height.width.equalTo(h3)
            })
            return view
        }()
        name = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.icon!.snp.right).offset(j1)
                make.top.equalTo(self.contentView.snp.top).offset(h2)
                make.height.equalTo(h8)
                make.width.equalTo(FKYWHWith2ptWH(200))
            })
            view.font = UIFont.boldSystemFont(ofSize: FKYWHWith2ptWH(14))
            return view
        }()
        price = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView.snp.right).offset(-j1)
                make.centerY.equalTo(self.name!)
            })
            view.font = t19.font
            view.textColor = t19.color
            return view
        }()
        spe = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.name!)
                make.top.equalTo(self.name!.snp.bottom)
                make.height.equalTo(h9)
                make.width.equalTo(self.name!)
            })
            view.font = t9.font
            view.textColor = t9.color
            return view
        }()
        count = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(self.price!.snp.right)
                make.centerY.equalTo(self.spe!)

            })
            view.font = t9.font
            view.textColor = t9.color
            return view
        }()
        supply = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.name!)
                make.top.equalTo(self.spe!.snp.bottom)
                make.height.equalTo(h5)
                make.width.equalTo(self.name!)
            })
            view.font = t11.font
            view.textColor = t11.color
            return view
        }()
        
        let line = UIView()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(j1)
            make.right.equalTo(self.contentView).offset(-j1)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(lineHeight)
        }
        line.backgroundColor = m2
        
    }
    
    @objc func configCell(_ productModel:FKYOrderProductModel, batchModel : FKYBatchModel) -> () {
        icon?.sd_setImage(with: URL.init(string: productModel.productPicUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "image_default_img"))
        name?.text = productModel.productName
        price?.text = String.init(format: "¥ %.2f", productModel.productPrice.floatValue) as String
        spe?.text = productModel.spec
        supply?.text = productModel.factoryName
        count?.text = String.init(format: "x %@", productModel.quantity) as String
    }
}
