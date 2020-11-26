//
//  FKYTogeterFlowIntrolTabCell.swift
//  FKY
//
//  Created by hui on 2018/10/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterFlowIntrolTabCell: UITableViewCell {
    fileprivate lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x000000)
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.text = "流程介绍"
        return label
    }()
    fileprivate lazy var introDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = t25.font
        label.numberOfLines = 0
        label.text = "活动认购结束后达不到总认购数，已认购订单将取消，支付金额将按原支付路径返还"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView() {
        self.backgroundColor = RGBColor(0xFAFAFA)
        let bgView = UIView()
        bgView.backgroundColor = RGBColor(0xFFFFFF)
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(WH(103))
        }
        contentView.addSubview(self.introDetailLabel)
        self.introDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(17))
            make.right.equalTo(contentView.snp.right).offset(-WH(12))
            make.top.equalTo(bgView.snp.bottom).offset(WH(13))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(13))
        }
        // 底部分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = bg7
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(0.5)
        })
        
        // 顶部分隔线
        let viewTopLine = UIView()
        viewTopLine.backgroundColor = bg7
        bgView.addSubview(viewTopLine)
        viewTopLine.snp.makeConstraints({ (make) in
            make.top.right.left.equalTo(bgView)
            make.height.equalTo(0.5)
        })
        
        bgView.addSubview(self.introductionLabel)
        self.introductionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(WH(17))
            make.right.equalTo(bgView.snp.right).offset(-WH(10))
            make.top.equalTo(self.snp.top).offset(WH(14))
            make.height.equalTo(WH(16))
        }
        let patternImg = UIImage.imageWithTwoColor(RGBColor(0xFF2D5C), RGBColor(0xffffff), size: CGSize.init(width: 4, height: 0.5))
        let spaceNum = (SCREEN_WIDTH - 2*WH(30) - 6*WH(15))/5.0 //数字之间的间隔
        let introlName = ["项目开始","客户认购","确认支付","认购结束","备货","发货"]
        for i in [1,2,3,4,5,6] {
            let numLabel = UILabel()
            numLabel.text = "\(i)"
            numLabel.font = t3.font
            numLabel.textAlignment = .center
            numLabel.textColor = RGBColor(0xFF2D5C)
            numLabel.backgroundColor = RGBColor(0xFFEEF1)
            numLabel.layer.masksToBounds = true
            numLabel.layer.cornerRadius = WH(15)/2.0
            numLabel.layer.borderColor = RGBColor(0xFF9DB3).cgColor
            numLabel.layer.borderWidth = 0.5

            let rightSpace = WH(30)+CGFloat((i-1)*Int(WH(15)+spaceNum))
            bgView.addSubview(numLabel)
            numLabel.snp.makeConstraints { (make) in
                make.left.equalTo(bgView.snp.left).offset(rightSpace)
               make.top.equalTo(self.introductionLabel.snp.bottom).offset(WH(17))
                make.height.width.equalTo(WH(15))
            }
            //间隔线
            if i < 6 {
                let  spaceLine = UIImageView()
                spaceLine.backgroundColor = UIColor.init(patternImage:patternImg)
                bgView.addSubview(spaceLine)
                spaceLine.snp.makeConstraints { (make) in
                    make.left.equalTo(numLabel.snp.right)
                    make.centerY.equalTo(numLabel.snp.centerY)
                    make.height.equalTo(0.5)
                    make.width.equalTo(spaceNum)
                }
            }
            
            //文描述
            let introlStrLabel = UILabel()
            introlStrLabel.text = introlName[i-1]
            introlStrLabel.textAlignment = .center
            introlStrLabel.font = t25.font
            introlStrLabel.textColor = RGBColor(0x666666)
            bgView.addSubview(introlStrLabel)
            introlStrLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(numLabel.snp.centerX)
                make.top.equalTo(numLabel.snp.bottom).offset(WH(11))
                make.height.equalTo(WH(11))
            }
            
        }
    }
}
extension FKYTogeterFlowIntrolTabCell {
    //计算高度
    static func configCellHeight() -> CGFloat {
        var cellH = WH(103+13+13)
        let contentStr = "活动认购结束后达不到总认购数，已认购订单将取消，支付金额将按原支付路径返还"
        let contentLabelH =  contentStr.boundingRect(with: CGSize(width: SCREEN_WIDTH-WH(17)-WH(12), height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t25.font], context: nil).height
        cellH =  cellH + ceil(contentLabelH)
        return cellH
    }
}
