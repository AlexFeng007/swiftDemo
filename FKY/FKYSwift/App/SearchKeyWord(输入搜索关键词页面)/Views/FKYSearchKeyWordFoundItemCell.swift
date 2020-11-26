//
//  FKYSearchKeyWordFoundItemCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchKeyWordFoundItemCell: UICollectionViewCell {
    
    /// 前面的活动icon
    fileprivate var titleIcon:UIImageView = UIImageView()
    
    /// 中间的活动文字
    fileprivate var titleDesLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .systemFont(ofSize:WH(14))
        lb.textAlignment = .center
        return lb
    }()
    
    /// 右边的右箭头
    fileprivate var rightArrowIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"search_found_right_Arrow")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 数据展示
extension FKYSearchKeyWordFoundItemCell{
    @objc func configCell(text:String){
        self.titleDesLabel.text = text
    }
    
    @objc func configCellWithFoundModel(foundModel:FKYSearchActivityModel){
        self.titleDesLabel.text = foundModel.name
        self.titleIcon.sd_setImage(with: URL(string: foundModel.imgPath))
    }
}

//MARK: - UI
extension FKYSearchKeyWordFoundItemCell{
    func setupUI(){
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.layer.cornerRadius = WH(15)
        self.layer.masksToBounds = true
        self.contentView.addSubview(self.titleIcon)
        self.contentView.addSubview(self.titleDesLabel)
        self.contentView.addSubview(self.rightArrowIcon)
        /*
        self.contentView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(167))
        }
        */
        self.titleIcon.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(WH(7))
            make.width.height.equalTo(WH(16))
            make.top.equalToSuperview().offset(WH(7))
            make.bottom.equalToSuperview().offset(WH(-7))
        }
        
        self.titleDesLabel.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleIcon.snp_right).offset(WH(4))
            make.right.equalTo(self.rightArrowIcon.snp_left)
            make.top.bottom.equalToSuperview()
        }
        
        self.rightArrowIcon.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-4))
            make.width.height.equalTo(WH(18))
        }
    }
    
    static func getItemSize(text:String) -> CGSize{
        return CGSize(width: WH(167), height: WH(30))
    }
}
