//
//  FKYSearchActivityCell.swift
//  FKY
//
//  Created by 寒山 on 2019/6/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchActivityCell: UICollectionViewCell {
    fileprivate  lazy var contentBgView: UIView =  {
        let contentView = UIView()
        contentView.backgroundColor = RGBColor(0xF4F4F4)
        contentView.layer.masksToBounds = true
        //  contentView.layer.borderWidth = WH(1)
        // contentView.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        contentView.layer.cornerRadius = WH(15)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = t3.font
        label.textColor = RGBColor(0x333333)
        //        button.setTitleColor(RGBColor(0xFF2D5C), for: UIControlState())
        //        button.imageView!.contentMode = .scaleAspectFit
        //        button.imageEdgeInsets = UIEdgeInsetsMake(0, WH(-4), 0, 0)
        //        button.isEnabled = false
        return label
    }()
    fileprivate var img: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    fileprivate var rightArrowImg:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"search_found_right_Arrow");
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
        setupView()
    }
    func setupView() {
        contentView.addSubview(contentBgView)
        contentBgView.addSubview(titleLabel)
        contentBgView.addSubview(img)
        contentBgView.addSubview(rightArrowImg)
        contentBgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(contentView)
        })
        img.snp.makeConstraints({ (make) in
            make.left.equalTo(contentBgView).offset(WH(7))
            make.centerY.equalTo(contentBgView)
            make.width.height.equalTo(WH(16))
        })
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(img.snp.right).offset(WH(4))
            make.right.equalTo(rightArrowImg.snp_left)
            make.centerY.equalTo(contentView)
        })
        rightArrowImg.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-5))
            make.height.width.equalTo(WH(18))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func configCell(_ model:FKYSearchActivityModel) {
        if let strProductPicUrl = model.imgPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            img.sd_setImage(with: urlProductPic, placeholderImage: nil)
            //             titleButton.setImageFor(.normal, with: urlProductPic)
            //             titleButton.setImageFor(.disabled, with: urlProductPic)
        }
        
        titleLabel.text = model.name
    }
    @objc func configShopCell(_ imgPath:String,_ title:String) {
        contentBgView.backgroundColor = RGBColor(0xFFFFFF)
        if let strProductPicUrl = imgPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            img.sd_setImage(with: urlProductPic, placeholderImage: nil)
        }
        titleLabel.font = t7.font
        titleLabel.text = title
        img.snp.updateConstraints({ (make) in
            make.left.equalTo(contentBgView).offset(WH(13))
        })
    }
}
