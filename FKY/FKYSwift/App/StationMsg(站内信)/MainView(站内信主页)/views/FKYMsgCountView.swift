//
//  FKYMsgCountView.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMsgCountView: UIView {
    lazy var countLb:UILabel = {
        let lb = UILabel()
        //lb.text = "9"
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = .systemFont(ofSize:WH(10))
        lb.textAlignment = .center
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - 数据展示
extension FKYMsgCountView {
    func showCount(count:Int,_ height:CGFloat){
        var str = "\(count)"
        if count <= 0 {
            str = ""
        }else if count > 99 {
            str = " 99+ "
        }
        self.countLb.text = str
        //self.layoutCorner()
        self.layoutCorner(height: height)
    }
    
    func configTextColor(color:UIColor){
        countLb.textColor = color
    }
    
    func showText(_ text:String,_ height:CGFloat){
        self.countLb.text = "\(text) "
        //self.countLb.text = "9"
        self.layoutCorner(height: height)
    }
}

//MARK: - UI
extension FKYMsgCountView{
    func setupUI(){
        self.backgroundColor = RGBColor(0xFF2D5C)
        self.addSubview(self.countLb)
        
        self.countLb.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            //make.width.equalTo(0)
        }
    }
    func layoutCorner(height:CGFloat){
        self.countLb.sizeToFit()
        var width = self.countLb.frame.size.width
        if width < height {
            width = height
        }
        //self.layer.cornerRadius = WH(self.countLb.hd_height/2.0)
        self.layer.cornerRadius = height/2.0
        self.layer.masksToBounds = true
        self.countLb.snp_remakeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.width.equalTo(width)
        }
    }
}
