//
//  CouponProductEmptyView.swift
//  FKY
//
//  Created by 寒山 on 2020/2/27.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class CouponProductEmptyView: UIView {
    
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
        lbl.textColor = RGBColor(0x999999)
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textAlignment = .left
        lbl.text = "很抱歉，没找到与“藿香真实换行情况”相关的商品，请重新搜索"
        lbl.numberOfLines = 3 // 最多3行
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = RGBColor(0xF4F4F4)
        
        addSubview(imgviewIcon)
        addSubview(lblTip)
        
        imgviewIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(20))
            make.left.equalTo(self).offset(WH(20))
            make.width.equalTo(WH(52))
            make.height.equalTo(WH(48))
        }
        
        lblTip.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.imgviewIcon).offset(-WH(2))
            make.left.equalTo(self.imgviewIcon.snp.right).offset(WH(20))
            make.right.equalTo(self).offset(-WH(10))
        }
    }
    func configView(_ keyword: String?) {

           if let txt = keyword, txt.isEmpty == false {
               lblTip.text = nil
               // 富文本
               let content = "很抱歉，没找到与“\(txt)”相关的商品"
               let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: content)
               let smallFont = UIFont.systemFont(ofSize: WH(14))
               let bigFont = UIFont.systemFont(ofSize: WH(14))
               let textColor = RGBColor(0x999999)
               let typeColor = RGBColor(0x333333)
               let range: NSRange = NSMakeRange(9, txt.count)
               attributedString.addAttribute(NSAttributedString.Key.font, value: smallFont, range: NSMakeRange(0, content.count))
               attributedString.addAttribute(NSAttributedString.Key.font, value: bigFont, range: range)
               attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, content.count))
               attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: typeColor, range: range)
               // 设置行间距
               let paragraphStyle = NSMutableParagraphStyle()
               paragraphStyle.lineSpacing = 3
               attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.count))
               lblTip.attributedText = attributedString
           }
           else {
               lblTip.attributedText = nil
               lblTip.text = "很抱歉，没找到相关的商品"
           }
       }
    
}
