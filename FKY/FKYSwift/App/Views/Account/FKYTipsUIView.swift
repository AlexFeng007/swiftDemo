//
//  FKYTipsUIView.swift
//  FKY
//
//  Created by airWen on 2017/7/14.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

@objc
class FKYTipsUIView: UIView {
    //
    fileprivate var egdeMargin: CGFloat = 8
    
    //MARK: Property
    fileprivate lazy var lblTips: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = RGBColor(0xFFA920)
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = RGBColor(0xFFF7EA)
        
        self.addSubview(lblTips)
        lblTips.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.snp.leading).offset(WH(10))
            make.trailing.equalTo(self.snp.trailing).offset(-WH(10))
            make.centerY.equalTo(self.snp.centerY)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    override var intrinsicContentSize : CGSize {
        if let text = lblTips.text, text != "" {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = lblTips.lineBreakMode
            let attrs = [NSAttributedString.Key.font.rawValue: lblTips.font, NSAttributedString.Key.paragraphStyle: paragraphStyle] as! [String : Any]
            let contentHeight: CGFloat = text.heightForFontAndWidth(lblTips.font, width: (SCREEN_WIDTH - WH(10) * 2), attributes: attrs as [String : AnyObject])
            return CGSize(width: SCREEN_WIDTH, height: contentHeight + egdeMargin*2)
        }
        else {
            return CGSize.zero
        }
    }
    
    //MARK: Public
    @objc func setTipsContent(_ content: String, numberOfLines: Int) {
        lblTips.numberOfLines = numberOfLines
        lblTips.text = content
    }
    
    //MARK: Public
    @objc func setTipsContent(_ content: String, numberOfLines: Int, backgroundColor: UIColor, textColor: UIColor, egdeMargin: CGFloat) {
        lblTips.numberOfLines = numberOfLines
        lblTips.text = content
        self.backgroundColor = backgroundColor
        lblTips.textColor = textColor
        self.egdeMargin = egdeMargin
        self.invalidateIntrinsicContentSize()
    }
    
    //MARK: Public
    @objc func setTipsContent(_ content: String, font: UIFont, numberOfLines: Int, backgroundColor: UIColor, textColor: UIColor, egdeMargin: CGFloat) {
        lblTips.font = font
        lblTips.numberOfLines = numberOfLines
        lblTips.text = content
        self.backgroundColor = backgroundColor
        lblTips.textColor = textColor
        self.egdeMargin = egdeMargin
        self.invalidateIntrinsicContentSize()
    }
}
