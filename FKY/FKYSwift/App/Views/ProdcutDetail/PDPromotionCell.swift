//
//  PDPromotionCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之促销cell...<包括：满减、满赠、返利、套餐、vip>

import UIKit
import YYText

class PDPromotionCell: UITableViewCell {
    //MARK: - Property
    
    // closure
    @objc var gotoShop: (()->())? // 进入店铺
    
    // 保存标签tag背景色
    fileprivate var tagColor: UIColor = RGBColor(0xFF2D5C)
    
    // 类型: 满减、满赠、返利、套餐、vip
    fileprivate lazy var lblType: UILabel! = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textColor = RGBColor(0xFFFFFF)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(18)/2.0
        return label
    }()
    
    // 内容
    fileprivate lazy var lblTitle: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .left
        return label
    }()
    
    // 箭头
    fileprivate lazy var imgviewArrow: UIImageView! = {
        let view = UIImageView.init()
        //view.image = UIImage.init(named: "img_pd_group_arrow")
        view.image = UIImage.init(named: "img_pd_arrow_gray")
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    // 分割线
    fileprivate lazy var bottomLine: UILabel! = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xE5E5E5)
        label.isHidden = true
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 解决当前cell点击后标签tag背景变为透明的问题
        lblType.backgroundColor = tagColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        // 解决当前cell点击后标签tag背景变为透明的问题
        lblType.backgroundColor = tagColor
    }
    
    
    //MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(imgviewArrow)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblType)
        contentView.addSubview(bottomLine)
        
        imgviewArrow.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(WH(-5))
            make.size.equalTo(CGSize.init(width: WH(20), height: WH(20)))
        }
        
        lblType.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(10))
            make.height.equalTo(WH(18))
            make.width.equalTo(WH(36))
        }
        
        lblTitle.snp.makeConstraints { (make) in
            //make.centerY.equalTo(contentView)
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(lblType.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.left).offset(WH(-10))
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    //MARK: - Public
    //单品包邮或者其他入口列表类型的cell
    @objc func configEntranceCell(_ model: FKYProductObject?, entranceType: NSNumber) {
        bottomLine.isHidden = true
        guard model != nil else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        // 默认隐藏
        lblType.isHidden = true
        lblTitle.isHidden = true
        imgviewArrow.isHidden = true
        lblType.backgroundColor = RGBColor(0xFF2D5C)
        lblType.textColor = RGBColor(0xFFFFFF)
        tagColor = RGBColor(0xFF2D5C)
        lblType.snp.updateConstraints { (make) in
            make.width.equalTo(WH(36))
        }
        if let model = model,let entranceInfoList = model.entranceInfos,entranceInfoList.isEmpty == false{
            let RegexSelected = NSPredicate.init(format:"entranceType == %@",entranceType)
            
            let tempArray :NSMutableArray = NSMutableArray.init(array: entranceInfoList)
            let selectedArray  = (tempArray).filtered(using: RegexSelected)
            if selectedArray.isEmpty == false{
                if  let entranceObject = selectedArray[0] as?  FKYProductEntranceInfoObject{
                    lblTitle.text = entranceObject.entranceDesc ?? ""
                    lblType.isHidden = false
                    lblTitle.isHidden = false
                    lblType.text = entranceObject.entranceName ?? ""
                    imgviewArrow.isHidden = false
                }
            }
        }
        guard let txt = lblType.text, txt.isEmpty == false else {
            return
        }
        // 更新宽度
        let width = getTypeWidth(txt)
        lblType.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }
        layoutIfNeeded()
    }
    @objc func configCell(_ model: FKYProductObject?, promotion: ProductPromotionInfo?, type: PDPromotionType) {
        bottomLine.isHidden = true
        guard model != nil else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        
        // 默认隐藏
        lblType.isHidden = true
        lblTitle.isHidden = true
        imgviewArrow.isHidden = true
        lblType.backgroundColor = RGBColor(0xFF2D5C)
        lblType.textColor = RGBColor(0xFFFFFF)
        tagColor = RGBColor(0xFF2D5C)
        lblType.snp.updateConstraints { (make) in
            make.width.equalTo(WH(36))
        }
        if type == .fullReduce || type == .fullGift {
            // MARK:满减 or 满赠
            guard let promotion = promotion, let type = promotion.promotionType, (type == "2" || type == "3" || type == "5" || type == "6") else {
                return
            }
            lblType.isHidden = false
            lblTitle.isHidden = false
            imgviewArrow.isHidden = false
            
            if let content = promotion.promotionDesc, content.isEmpty == false {
                lblTitle.text = content
            }
            else {
                lblTitle.text = nil
            }
            if type == "2" {
                // 单品满减
                imgviewArrow.isHidden = true
            }
            else {
                imgviewArrow.isHidden = false
            }
            let typeNum = (type as NSString).intValue
            if typeNum < 4 {
                lblType.text = "满减"
            }else if typeNum >= 4 && typeNum <= 8 {
                lblType.text = "满赠"
            }else {
                lblType.text = "换购"
            }
        }
        else if type == .vip {
            // MARK:vip
            if let dataModel = model {
                lblType.isHidden = false
                lblTitle.isHidden = false
                imgviewArrow.isHidden = false
                lblType.textColor = RGBColor(0xFFDEAE)
                lblType.text = "会员"
                let width = getTypeWidth(lblType.text!)
                lblType.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(width))
                tagColor = lblType.backgroundColor!
                if dataModel.vipModel.gmvGap.count > 0 {
                    let msgStr = NSMutableAttributedString.init(string:dataModel.vipModel.tips)
                    let gmvRange:NSRange = (dataModel.vipModel.tips as NSString).range(of:dataModel.vipModel.gmvGap)
                    msgStr.yy_setColor(RGBColor(0xFF2D5C), range: gmvRange)
                    lblTitle.attributedText = msgStr
                }
                else {
                    lblTitle.text = dataModel.vipModel.tips
                }
            }
        }
        else if type == .bounty {
            // MARK: 奖励金
            if let model = model, model.bonusTag == true, let bonusText = model.bonusText, bonusText.isEmpty == false {
                // 有奖励金信息
                lblType.text = "奖励金"
                lblTitle.text = bonusText
                lblType.isHidden = false
                lblTitle.isHidden = false
                imgviewArrow.isHidden = false
                lblType.snp.updateConstraints { (make) in
                    make.width.equalTo(WH(48))
                }
            }
            else {
                // 无奖励金信息
                lblType.isHidden = true
                lblTitle.isHidden = true
                imgviewArrow.isHidden = true
            }
        }
        else if type == .rebate {
            // MARK: 返利
            if let model = model,let info = model.rebateInfo ,let isRebate = info.isRebate, isRebate.intValue == 1, let rebateDesc = info.rebateDesc, rebateDesc.isEmpty == false {
                // 有返利信息
                lblType.text = "返利"
                lblTitle.text = rebateDesc
                lblType.isHidden = false
                lblTitle.isHidden = false
                //imgviewArrow.isHidden = false
                if info.ruleType == 2 {
                    // 2-多品...<可跳转返利专区>
                    imgviewArrow.isHidden = false
                }
                else {
                    // 1-单品...<不可跳转>
                    imgviewArrow.isHidden = true
                }
            }
            else {
                // 无返利信息
                lblType.isHidden = true
                lblTitle.isHidden = true
                imgviewArrow.isHidden = true
            }
        }
        else if type == .combo {
            // MARK: 套餐
            if model != nil {
                lblType.text = "套餐"
                lblTitle.text = "超值套餐：搭配买，价更优"
                lblType.isHidden = false
                lblTitle.isHidden = false
                imgviewArrow.isHidden = false
            }
            else {
                lblType.isHidden = true
                lblTitle.isHidden = true
                imgviewArrow.isHidden = true
            }
        }
        else if type == .protocolRebate {
            // MARK: 协议返利金
            if let model = model, let rebate = model.rebateProtocol, rebate.protocolRebate == true {
                // 有协议返利金
                lblType.text = "协议奖励金"
                lblTitle.text = rebate.desc ?? ""
                lblType.isHidden = false
                lblTitle.isHidden = false
                imgviewArrow.isHidden = false
            }
            else {
                // 无协议返利金
                lblType.isHidden = true
                lblTitle.isHidden = true
                imgviewArrow.isHidden = true
            }
        }
        else if type == .fullDiscount {
            // MARK:满折
            guard let obj = promotion, let type = obj.promotionType, (type == "15" || type == "16") else {
                return
            }
            
            lblType.isHidden = false
            lblTitle.isHidden = false
            imgviewArrow.isHidden = false
            
            if type == "16" {
                // 多品满折
                imgviewArrow.isHidden = false
            }
            else {
                // 单品满折
                imgviewArrow.isHidden = true
            }
            
            if let content = obj.promotionDesc, content.isEmpty == false {
                lblTitle.text = content
            }
            else {
                lblTitle.text = nil
            }
            
            lblType.text = "满折"
        }else if type == .slowPayOrHoldPrice {
            //MARK: 慢必赔or保价
            lblType.isHidden = false
            lblTitle.isHidden = false
            if let dataModel = model {
                if dataModel.slowPay == true {
                    lblType.text = dataModel.slowPayTag
                    lblTitle.text = dataModel.slowPayText
                    if let url =  dataModel.slowPayUrl ,url.count > 0 {
                        imgviewArrow.isHidden = false
                    }else {
                        imgviewArrow.isHidden = true
                    }
                }else if dataModel.holdPrice == true  {
                    lblType.text = dataModel.holdPriceTag
                    lblTitle.text = dataModel.holdPriceText
                    if let url =  dataModel.holdPriceUrl ,url.count > 0 {
                        imgviewArrow.isHidden = false
                    }else {
                        imgviewArrow.isHidden = true
                    }
                }
            }
        }
        
        guard let txt = lblType.text, txt.isEmpty == false else {
            return
        }
        // 更新宽度
        let width = getTypeWidth(txt)
        lblType.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }
        layoutIfNeeded()
        //渐变需根据标签宽度计算
        if type == .vip {
            // vip
            if let _ = model {
                lblType.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(width))
            }
        }
        
    }
    
    // 计算标签宽度
    fileprivate func getTypeWidth(_ txt: String) -> CGFloat {
        var width = COProductItemCell.calculateStringWidth(txt, UIFont.systemFont(ofSize: WH(12)), WH(18)) + WH(12)
        if width <= WH(36) {
            width = WH(36)
        }
        return width
    }
}

extension PDPromotionCell {
    //MARK:店铺中多品满折cell
    func configShopDetailPromotionDiscount(_ promotionModel:FKYfullReductionInfoVoModel) {
        bottomLine.isHidden = false
        lblType.isHidden = false
        lblTitle.isHidden = false
        imgviewArrow.isHidden = false
        
        if let content = promotionModel.promotionDesc, content.isEmpty == false {
            lblTitle.text = content
        }
        else {
            lblTitle.text = ""
        }
        lblType.text = "满折"
    }
}
