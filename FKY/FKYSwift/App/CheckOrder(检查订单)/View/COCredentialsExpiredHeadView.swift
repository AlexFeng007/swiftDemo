//
//  COCredentialsExpiredHeadView.swift
//  FKY
//
//  Created by 寒山 on 2020/1/8.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  资质过期提醒 检查订单

import UIKit

class COCredentialsExpiredHeadView: UIView {
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear//RGBColor(0xffffff)
        return view
    }()
    
    //tip
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: - UI
    
    fileprivate func setupView() {
        contentBgView.backgroundColor = RGBColor(0xF4F4F4)
        self.addSubview(contentBgView)
        contentBgView.addSubview(tipLabel)
        
        contentBgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        tipLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(contentBgView).offset(WH(14))
            make.right.equalTo(contentBgView).offset(WH(-10))
            make.top.equalTo(contentBgView).offset(WH(8))
            make.bottom.equalTo(contentBgView).offset(WH(-8))
        })
    }
    func configTipView(_ tipStr: String) {
        tipLabel.attributedText = COCredentialsExpiredHeadView.tipString(tipStr)
    }
    //高度
    static func  configTipViewHeight(_ tipStr: String) -> CGFloat {
        let contentSize = COCredentialsExpiredHeadView.tipString(tipStr).boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(24), height: WH(10000)), options: .usesLineFragmentOrigin, context: nil).size
        return contentSize.height + WH(16) + 1
    }
    //富文本
    static fileprivate func tipString(_ tispStr:String) -> (NSMutableAttributedString) {
        let tipTmpl = NSMutableAttributedString()
        var tipStr = NSAttributedString(string:tispStr)
        tipTmpl.append(tipStr)
        tipTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                             value: RGBColor(0x333333),
                             range: NSMakeRange(tipTmpl.length - tipStr.length, tipStr.length))
        tipTmpl.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12))], range: NSMakeRange(tipTmpl.length - tipStr.length, tipStr.length))
        
        tipStr = NSAttributedString(string:"点击去更新>>")
        tipTmpl.append(tipStr)
        tipTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                             value: RGBColor(0xFF2859),
                             range: NSMakeRange(tipTmpl.length - tipStr.length, tipStr.length))
        tipTmpl.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.systemFont(ofSize: WH(12)),
                             range: NSMakeRange(tipTmpl.length - tipStr.length, tipStr.length))
        return tipTmpl
    }
}
