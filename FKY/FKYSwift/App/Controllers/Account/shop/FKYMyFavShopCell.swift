//
//  FKYMyFavShopCell.swift
//  FKY
//
//  Created by zhangxuewen on 2018/5/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYMyFavShopCell: UITableViewCell {
    
    fileprivate var logo: UIImageView?
    fileprivate var name: UILabel?
    fileprivate var more: UIImageView?//右侧指示箭头
    fileprivate var line: UIView?//分割线
    
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
                make.height.equalTo(45)
                make.width.equalTo(45)
                make.centerY.equalTo(self.contentView)
            })
            return img
        }()
        
        name = {
            let lab = UILabel()
            lab.fontTuple = t9
            
            self.contentView.addSubview(lab)
            lab.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.contentView)
                make.right.equalTo(self.snp.right).offset(-10)
                make.left.equalTo(self.logo!.snp.right).offset(15)
                make.height.equalTo(15)
            })
            return lab
        }()
        
        
        more = {
            let view = UIImageView()
            view.image=UIImage.init(named: "icon_cart_gray_arrow_right")
            self.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.contentView)
                make.right.equalTo(contentView.snp.right).offset(-10)
            })
            return view
        }()
        
        line = {
            let v = UIView()
            contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.right.equalTo(contentView).offset(-WH(0.01))
                make.left.equalTo(contentView).offset(WH(10))
                make.bottom.equalTo(contentView)
                make.height.equalTo(1)
            })
            v.backgroundColor = m1
            return v
        }()
    }
    
    func config(_ model : FKYMyFavShopModel , isLastPos :Bool) -> () {
        self.logo!.sd_setImage(with: URL.init(string: model.logo!.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!),
                               placeholderImage: UIImage.init(named: "image_default_img"))
        self.name?.text = model.shopName
        if(isLastPos){
            self.line?.snp.updateConstraints({ (make) in
                make.right.equalTo(contentView).offset(-WH(0.01))
                make.left.equalTo(contentView).offset(WH(0.01))
                make.bottom.equalTo(contentView)
                make.height.equalTo(1)
            })
        }
    }
}

