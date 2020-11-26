//
//  PDGroupTipView.swift
//  FKY
//
//  Created by 夏志勇 on 2017/12/19.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详(搭配 or 固定)套餐之套餐说明视图...<section header>

import UIKit

class PDGroupTipView: UIView {
    // MARK: - Property
    
    // 下划线...<不显示>
    fileprivate lazy var viewLine: UIView! = {
        let viewWhite = UIView()
        viewWhite.backgroundColor = RGBColor(0xDFDFDF)
        return viewWhite
    }()
    
    // 标题imgview...<不显示>
    fileprivate lazy var imgviewTip: UIImageView! = {
        let imgview = UIImageView.init(image: UIImage.init(named: "img_pd_group_tip"))
        return imgview
    }()
    
    // 标题lbl
    fileprivate lazy var lblTip: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0xE8772A)
        lbl.textAlignment = .center
        //lbl.numberOfLines = 0
        lbl.numberOfLines = 5 // 最大只显示5行~!@
//        lbl.minimumScaleFactor = 0.8
//        lbl.adjustsFontSizeToFitWidth = true
        //lbl.text = "1.与其他解热镇痛药并用，有增加肾毒性的危险。\n2.与其他药物同时使用可能会发生，详情请咨询医师或药师。"
        return lbl
    }()
    
    // 当前视图高度...<默认高度>
    var tipHeight: CGFloat = WH(35)
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
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
        self.backgroundColor = RGBColor(0xFFFCF1)

        self.addSubview(self.viewLine)
        self.addSubview(self.imgviewTip)
        self.addSubview(self.lblTip)
        
        self.viewLine.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(self)
            make.height.equalTo(WH(1))
        }
        self.imgviewTip.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(10))
            make.left.equalTo(self).offset(WH(10))
            make.size.equalTo(CGSize.init(width: 50, height: 11))
        }
        self.lblTip.snp.makeConstraints { (make) in
//            make.top.equalTo(self).offset(WH(5))
//            make.bottom.equalTo(self).offset(WH(-5))
//            make.left.equalTo(self.imgviewTip.snp.right).offset(WH(10))
//            make.right.equalTo(self).offset(WH(-10))
            make.edges.equalTo(UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10)))
        }
        
        self.viewLine.isHidden = true
        self.imgviewTip.isHidden = true
    }

    
    // MARK: - Public
    
    func configView(_ tip: NSString?, showFlag show: Bool) {
        if show {
            // 显示
            self.viewLine.isHidden = true
            self.imgviewTip.isHidden = true
            self.lblTip.isHidden = false
            
            // 高度自适应
            if let str = tip, str.length > 0 {
                // 有说明
                let content = getFinalTipContent(str as String)
                let final = "套餐说明：" + content
                self.lblTip.text = final

                // 计算高度
                let size = final.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - 2 * WH(10), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12))], context: nil).size
                let height = size.height + WH(20) + 2
                self.tipHeight = (height > WH(96) ? WH(96) : height)
            }
            else {
                // 无说明
                self.lblTip.text = "套餐说明：暂无"
                self.tipHeight = WH(35)
            }
            
            // 套餐说明：局部加粗
            let att = NSMutableAttributedString.init(string: self.lblTip.text!)
            att.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12)), NSAttributedString.Key.foregroundColor:RGBColor(0xE8772A)], range: NSMakeRange(0, att.length))
            att.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(12))], range: NSMakeRange(0, 5))
            self.lblTip.attributedText = att
        }
        else {
            // 隐藏
            self.viewLine.isHidden = true
            self.imgviewTip.isHidden = true
            self.lblTip.isHidden = true
            self.tipHeight = CGFloat.leastNormalMagnitude // 不能直接为0, 0.01可以
        }
        
        self.viewLine.isHidden = true
        self.imgviewTip.isHidden = true
    }
    
    
    // MARK: - Private
    
    // 替换字符串中的殊字符
    func getFinalTipContent(_ conten: String) -> String {
        var str = conten
        str = str.replacingOccurrences(of: "<br/>", with: "\n")
        return str
    }
}
