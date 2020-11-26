//
//  FKYFilterDrugInfoCollectionViewCell.swift
//  FKY
//
//  Created by 寒山 on 2018/7/2.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYFilterDrugInfoCollectionViewCell: UICollectionViewCell {
    
    fileprivate  lazy var contentBgView: UIView =  {
        let contentView = UIView()
        contentView.backgroundColor = RGBColor(0xF4F4F4)
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 4
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.fontTuple = t7
        label.textAlignment = .center
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configCell(_ factorysInfo: Any?, isSelected: Bool) {
        if let model = factorysInfo as? SerachFactorysInfoModel {
             titleLabel.text = model.factoryName
        }else if let model = factorysInfo as? SerachRankInfoModel {
            if let rankNum = model.rankCode,rankNum.count > 0 {
                titleLabel.text = "\(model.rankName ?? "")(\(model.rankCode ?? ""))"
            }else{
                titleLabel.text = model.rankName
            }
        }
        if isSelected {
            titleLabel.textColor = RGBColor(0xFF2D5C)
            contentBgView.backgroundColor = RGBColor(0xFFEDE7)
            contentBgView.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        }else {
            titleLabel.textColor = RGBColor(0x333333)
            contentBgView.backgroundColor = RGBColor(0xF4F4F4)
            contentBgView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
extension FKYFilterDrugInfoCollectionViewCell {
    func setupView() {
        contentView.addSubview(contentBgView);
        contentBgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(contentView)
        })
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.top.left.greaterThanOrEqualTo(contentView).offset(2)
            make.right.bottom.greaterThanOrEqualTo(contentView).offset(-2)
        })
     }
}
class FilterFactoryHeadView: UICollectionReusableView{
   
    var loadMoreAction: emptyClosure?
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.fontTuple = t7
        label.text = "生产厂家"
        label.sizeToFit()
       // label.backgroundColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var arrImg: UIImageView =  {
        let img = UIImageView()
        img.image = UIImage(named : "downIcon")
        return img
    }()
    
    fileprivate lazy var showLabel: UILabel =  {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = t11.font
        label.text = "展开全部"
        label.textAlignment = .right
        return label
    }()
    
    
    fileprivate lazy var showButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(FilterFactoryHeadView.showMoreAction), for: .touchUpInside)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func showMoreAction(){
        if let moreAction = self.loadMoreAction {
            moreAction()
        }
    }
    func setupView(){
       // self.backgroundColor = UIColor.green
        self.addSubview(titleLabel)
        self.addSubview(arrImg)
        self.addSubview(showLabel)
        self.addSubview(showButton)
        //showButton.frame = CGRect.init(x: SCREEN_WIDTH - 55 - WH(110) - WH(15), y: 10, width: WH(110), height: 30)
      //  titleLabel.frame = CGRect.init(x: WH(15), y: 10, width: SCREEN_WIDTH, height: 20)

        titleLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(16))
           // make.right.equalTo(showButton.snp.left).offset(-WH(10))
        })
        arrImg.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(WH(-16))
        })
        showLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(arrImg.snp.left).offset(WH(-1))
        })
        
        showButton.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(WH(-15))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(90))
        })
    }
    func configCell(_ title: String?,_ isSelected: Bool,_ hasMore: Bool) {
        titleLabel.text = title
        if hasMore == true{
            showButton.isHidden = false
            showLabel.isHidden  = false
            arrImg.isHidden = false
        }else{
            showButton.isHidden = true
            showLabel.isHidden  = true
            arrImg.isHidden = true
        }
        if isSelected {
            showLabel.text = "收起"
            arrImg.image = UIImage(named : "upIcon")
        }else {
            showLabel.text = "展开全部"
            arrImg.image = UIImage(named : "downIcon")
        }
    }
}
class FilterInfoHeadView:UIView {
    
    var closeViewAction: emptyClosure?
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.fontTuple = t14
        label.text = "筛选"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var closeButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear;
        button.addTarget(self, action: #selector(FilterInfoHeadView.closeAction), for: .touchUpInside)
        button .setImage(UIImage(named:"filter_close"), for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        self.addSubview(titleLabel)
        self.addSubview(closeButton)
       
        titleLabel.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
        })
        closeButton.snp.makeConstraints({ (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(self).offset(WH(-10))
            make.height.equalTo(WH(40))
            make.width.equalTo(WH(40))
        })
    }
    @objc func closeAction(){
        if let closeAction = self.closeViewAction {
            closeAction()
        }
    }
}
