//
//  FKYJPBSearchEmptyView.swift
//  FKY
//
//  Created by 寒山 on 2019/11/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  聚宝盆专区搜索无结果时的空态视图

import UIKit

class FKYJPBSearchEmptyHeaderView: UICollectionReusableView {
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
    // 背景视图
    fileprivate lazy var viewSuggest: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x333333)
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textAlignment = .left
        lbl.text = "为您推荐："
        view.addSubview(lbl)
        lbl.snp.makeConstraints({ (make) in
            make.top.equalTo(view).offset(WH(5))
            make.left.equalTo(view).offset(WH(18))
        })
        
        let tiplbl = UILabel()
        tiplbl.backgroundColor = UIColor.clear
        tiplbl.textColor = RGBColor(0x999999)
        tiplbl.font = UIFont.systemFont(ofSize: WH(14))
        tiplbl.textAlignment = .left
        tiplbl.text = "对应自营店铺商品"
        view.addSubview(tiplbl)
        tiplbl.snp.makeConstraints({ (make) in
            make.centerY.equalTo(lbl.snp.centerY)
            make.left.equalTo(lbl.snp.right)
        })
        return view
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xF4F4F4)
    
        addSubview(imgviewIcon)
        addSubview(lblTip)
        addSubview(viewSuggest)
        
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
        
        viewSuggest.snp.makeConstraints { (make) in
            make.top.equalTo(imgviewIcon.snp.bottom).offset(WH(10))
            make.left.right.bottom.equalTo(self)
        }
    }
    // MARK: - Public
    
    func configView(_ keyword: String?) {
         
        if let txt = keyword, txt.isEmpty == false {
            lblTip.text = nil
            // 富文本
            let content = "很抱歉，此自营专区没找到与‘\(txt)’相关的商品"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: content)
            let smallFont = UIFont.systemFont(ofSize: WH(14))
            let bigFont = UIFont.systemFont(ofSize: WH(14))
            let textColor = RGBColor(0x999999)
            let typeColor = RGBColor(0x333333)
            let range: NSRange = NSMakeRange(14, txt.count)
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
            lblTip.text = "很抱歉，此自营专区没找到与搜索相关的商品"
        }
    }
    func visibleTipsView(_ isVisible:Bool){
         viewSuggest.isHidden = isVisible
    }
}
