//
//  FKYCarProductGroupHeaderTableViewCell.swift
//  FKY
//
//  Created by 曾维灿 on 2019/12/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYCarProductGroupHeaderTableViewCell: UITableViewCell {

    
    
    ///全选按钮
    lazy var selectButton:UIButton = {
        let bt = UIButton()
        bt.hd_width = WH(26.0)
        bt.hd_height = WH(26.0)
        bt.setBackgroundImage(UIImage.init(named: "img_pd_select_normal"), for: UIControl.State.normal)
        bt.addTarget(self, action: #selector(FKYCarProductGroupHeaderTableViewCell.userClickedSelecteButton), for: UIControl.Event.touchUpInside)
        return bt
    }()
    
    ///标签  满减/套餐等
    lazy var tagLabel:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = UIColor.white
        lb.backgroundColor = RGBColor(0xFF2D5C)
        lb.font = UIFont.systemFont(ofSize: WH(10.0))
        lb.textAlignment = NSTextAlignment.center
        return lb
    }()
    
    
    ///头部文描
    lazy var headerTextLB:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: WH(12.0))
        return lb
    }()
    
    ///向右箭头
    lazy var rightArrowIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage.init(named: "img_pd_arrow_gray")
        return image
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: -页面响应事件
extension FKYCarProductGroupHeaderTableViewCell{
    @objc func userClickedSelecteButton(){
        print("点击全选按钮")
    }
}



//MARK: -显示数据
extension FKYCarProductGroupHeaderTableViewCell{
    @objc func showData(){
        
    }
}
