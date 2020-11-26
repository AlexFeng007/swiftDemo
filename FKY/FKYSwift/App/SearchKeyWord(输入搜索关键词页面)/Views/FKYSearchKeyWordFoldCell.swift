//
//  FKYSearchKeyWordFoldCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchKeyWordFoldCell: UICollectionViewCell {
    
    /// 折叠icon
    fileprivate var foldIcon:UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage(named:"")
        return imgv
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
extension FKYSearchKeyWordFoldCell{
    
    /// 是否折叠
    /// - Parameter isFold: true 当前展示折叠状态，箭头向下，false当前展示展开状态，箭头向上
    func configCell(isFold:Bool){
        let icon = isFold ? "search_down_Arrow":"search_up_Arrow"
        self.foldIcon.image = UIImage(named:icon)
    }
    
}

//MARK: - UI
extension FKYSearchKeyWordFoldCell{
    func setupUI(){
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.layer.cornerRadius = WH(15)
        self.layer.masksToBounds = true
        self.contentView.addSubview(self.foldIcon)
        
        self.foldIcon.snp_makeConstraints { (make) in
            /*
            make.center.equalToSuperview()
            make.width.height.equalTo(WH(18))
            make.left.equalToSuperview().offset(WH(6))
            make.right.equalToSuperview().offset(WH(-6))
            make.top.equalToSuperview().offset(WH(6))
            make.bottom.equalToSuperview().offset(WH(-6))
            */
            make.center.equalToSuperview()
            make.width.height.equalTo(WH(18))
        }
    }
    
    static func getItemSize(text:String) -> CGSize{
        return CGSize(width: WH(30), height: WH(30))
    }
}
