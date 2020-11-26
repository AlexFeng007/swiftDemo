//
//  HomeShopCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/8/25.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit

class HomeShopCell: UICollectionViewCell {

    fileprivate var img: UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.img = {
            let iv = UIImageView()
            self.contentView.addSubview(iv)
            iv.snp.makeConstraints({ (make) in
                make.left.equalTo(WH(5))
                make.bottom.equalTo(-WH(5))
                make.width.equalTo(WH(180))
                make.height.equalTo(WH(90))
            })
            return iv
        }()
        self.backgroundColor = bg1
    }
    
    func configCell(_ shopModel: HomeBannerModel?, left:Bool) {
        if let model = shopModel {
            self.img!.sd_setImage(with: URL(string: model.imgUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, placeholderImage: UIImage(named: "image_placeholder_rect"))
        } else {
            self.img!.image = nil
        }
        if left {
            self.img!.snp.updateConstraints({ (make) in
                make.left.equalTo(WH(5))
            })
        } else {
            self.img!.snp.updateConstraints({ (make) in
                make.left.equalTo(WH(2.5))
            })
        }
    }
}
