//
//  FKYCredentialsBankImageCell.swift
//  FKY
//
//  Created by airWen on 2017/7/16.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYCredentialsBankImageCell: UICollectionViewCell {
    //MARK: Property
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        return label
    }()
    
    fileprivate lazy var btnAddImage: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        button.setBackgroundImage( UIImage(named: "icon_add_image"), for: UIControl.State())
        return button
    }()
    
    fileprivate lazy var btnDeleteImage: UIButton = {
        let button = UIButton()
        button.setBackgroundImage( UIImage(named: "icon_delete26x26"), for: UIControl.State())
        button.isHidden = true;
        return button
    }()
    
    //MARK: Public Proeprty
    var addImageClosure : emptyClosure?
    var viewLargerImageClosure : ((_ image: UIImage, _ superView: UIImageView)->())?
    var deleteImageClosure : emptyClosure?
    var isCanEdit: Bool = true
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        //make.left.equalTo(self.contentView).offset(16)
        super.init(frame: frame)
        
        self.backgroundColor = bg1
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(16)
            make.top.equalTo(self.contentView.snp.top).offset(18)
        })
        
        btnAddImage.addTarget(self, action: #selector(onBtnAddImage(_:)), for: .touchUpInside)
        self.contentView.addSubview(btnAddImage)
        btnAddImage.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(self.titleLabel.snp.right).offset(WH(20))
        })
        
        btnDeleteImage.addTarget(self, action: #selector(onBtnDeleteImage(_:)), for: .touchUpInside)
        self.contentView.addSubview(btnDeleteImage)
        btnDeleteImage.snp.makeConstraints({ (make) in
            make.right.equalTo(self.btnAddImage.snp.right).offset(WH(5))
            make.top.equalTo(self.btnAddImage.snp.top).offset(WH(-5))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public
    func configCell(_ title: String?, imgUrl: String?) {
        titleLabel.text = title;
        if let imgUrl = imgUrl, imgUrl != "" {
            if let str = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                btnAddImage.sd_setImage(with: URL(string: str.smallImageUrlString()), for: UIControl.State(), placeholderImage: UIImage(named: "image_placeholder"))
                btnAddImage.imageView?.contentMode = .scaleAspectFill
            }
            btnAddImage.isHidden = false
            btnDeleteImage.isHidden = !isCanEdit
        } else {
            btnAddImage.isHidden = !isCanEdit
            btnAddImage.sd_setImage(with: URL(string: "".smallImageUrlString()), for: UIControl.State())
            btnDeleteImage.isHidden = true
        }
    }
    
    //MARK: User Action
    @objc func onBtnAddImage(_ sender: UIButton) {
        if let imageOfUpload =  sender.image(for: UIControl.State()) {
            if let viewLargerImageClosure = self.viewLargerImageClosure, let imageView = sender.imageView {
                viewLargerImageClosure(imageOfUpload, imageView)
            }
        }else{
            if let addImageClosure = self.addImageClosure {
                addImageClosure()
            }
        }
    }
    
    @objc func onBtnDeleteImage(_ sender: UIButton) {
        if let deleteImageClosure = self.deleteImageClosure {
            deleteImageClosure()
        }
    }
}
