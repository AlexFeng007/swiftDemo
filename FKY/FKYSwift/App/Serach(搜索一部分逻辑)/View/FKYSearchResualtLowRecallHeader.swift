//
//  FKYSearchResualtLowRecallHeader.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchResualtLowRecallHeader: UITableViewCell {
    
    // icon
    fileprivate lazy var imgviewIcon: UIImageView = {
        let view = UIImageView()
        view.image =  UIImage.init(named: "image_search_empty")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.text = "— 非精准匹配，以下是相关搜索结果 —"
        lbl.numberOfLines = 2 // 最多3行
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - UI
extension FKYSearchResualtLowRecallHeader{
    /// 设置内容视图
    func setupView(){
        backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(self.lblTip)
        self.lblTip.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(WH(10))
            make.right.equalTo(self.contentView).offset(WH(-10))
        }
    }
    
}


//MARK: - 外部接口
extension FKYSearchResualtLowRecallHeader{
    /// 展示低分召回数据
    func showLowRecallData(_ isShow:Bool){
        if isShow == true{
            lblTip.isHidden = false
        }else{
            lblTip.isHidden = true
        }
    }
    
}
