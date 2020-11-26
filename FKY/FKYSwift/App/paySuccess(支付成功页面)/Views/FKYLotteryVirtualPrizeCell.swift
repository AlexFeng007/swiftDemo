//
//  FKYLotteryVirtualPrizeCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 虚拟奖品cell 目前包含优惠券

import UIKit

class FKYLotteryVirtualPrizeCell: UITableViewCell {
    
    /// 优惠券中奖界面
    lazy var virtualPrizeView: FKYLotteryVirtualPrizeView =  FKYLotteryVirtualPrizeView()
    
    /// 活动规则按钮
    lazy var activityRulesBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("活动规则", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        bt.setTitleColor(RGBColor(0x7A5221), for: .normal)
        bt.backgroundColor = RGBColor(0xFEFAE9)
        bt.addTarget(self, action: #selector(FKYLotteryVirtualPrizeCell.activityRulerBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 与苹果无关文描
    lazy var desLB:UILabel = {
        let lb = UILabel()
        lb.text = "本活动与苹果公司无关"
        lb.textColor = RGBColor(0xBA842C)
        lb.font = UIFont.systemFont(ofSize: WH(12))
        lb.textAlignment = .center
        return lb
    }()
    
    /// cell数据
    var cellData = FKYOrderPayStatusCellModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

//MARK: - 数据展示
extension FKYLotteryVirtualPrizeCell{
    func configCellData(cellData:FKYOrderPayStatusCellModel){
        self.cellData = cellData
        self.virtualPrizeView.configViewData(viewData: self.cellData.drawResultModel.couponDto)
    }
}

//MARK: - 响应事件
extension FKYLotteryVirtualPrizeCell{
    
    /// 活动规则按钮点击
    @objc func activityRulerBtnClicked(){
        self.routerEvent(withName: FKY_activityRulerBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - UI
extension FKYLotteryVirtualPrizeCell{
    
    func setupUI(){
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.activityRulesBtn)
        self.contentView.addSubview(self.virtualPrizeView)
        self.contentView.addSubview(self.desLB)
        
        self.activityRulesBtn.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(WH(77))
            make.height.equalTo(WH(30))
        }
        
        self.virtualPrizeView.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(52))
            make.bottom.equalTo(self.desLB.snp_top).offset(WH(-10))
            make.left.equalToSuperview().offset(WH(9))
            make.right.equalToSuperview().offset(WH(-9))
        }
        
        self.desLB.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(-5))
            make.height.equalTo(WH(20))
        }
        
        //切部分圆角
        self.activityRulesBtn.layoutIfNeeded()
        let borderLayer = CAShapeLayer()
        let borderPath = UIBezierPath(roundedRect: self.activityRulesBtn.bounds, byRoundingCorners: [.topRight , .bottomRight], cornerRadii: CGSize(width: WH(33)/2.0, height: WH(33)/2.0))
        borderLayer.path = borderPath.cgPath
        self.activityRulesBtn.layer.mask = borderLayer
    }
}

//----------------------------------- 优惠券中奖界面 --------------------------------

/// 立即使用按钮点击事件
let FKY_useButtonClicked = "useButtonClicked"

/// 去我的优惠券查看按钮点击事件
let FKY_checkCouponBtnClicked = "checkCouponBtnClicked"

// MARK: - 优惠券中奖界面单独封装成一个view，防止后面要做动画或者拿到其他地方用
class FKYLotteryVirtualPrizeView: UIView {
    
    ///优惠券数据对象
    var viewData = FKYDrawPrizeCouponModel()
    
    /// 背景图片
    lazy var backgroundImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"prize_backgroundImg")
        return image
    }()
    
    /// 优惠券背景图
    lazy var couponBackgorundImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"couponBackgorundImage")
        image.isUserInteractionEnabled = true
        return image
    }()
    
    /// 券类型 标签
    lazy var couponTypeLB:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: WH(10))
        lb.textColor = RGBColor(0xFF832C)
        lb.textAlignment = .center
        lb.layer.borderWidth = 1
        lb.layer.borderColor = RGBColor(0xFF832C).cgColor
        return lb
    }()
    
    /// 券使用条件 满多少减多少
    lazy var useCondition:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x666666)
        lb.font = UIFont.systemFont(ofSize: WH(12))
        return lb
    }()
    
    /// 券有效期
    lazy var couponExpiryDateLB:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0x999999)
        lb.font = UIFont.systemFont(ofSize:WH(12))
        return lb
    }()
    
    /// 人民币标识
    lazy var RMBTag:UILabel = {
        let lb = UILabel()
        lb.text = "￥"
        lb.textColor = RGBColor(0xFF832C)
        lb.font = UIFont.boldSystemFont(ofSize: WH(12))
        lb.textAlignment = .left
        return lb
    }()
    
    /// 券金额
    lazy var couponDenominationsLB:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = RGBColor(0xFF832C)
        lb.font = UIFont.boldSystemFont(ofSize: WH(28))
        lb.textAlignment = .left
        return lb
    }()
    
    /// 立即使用按钮
    lazy var useButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("", for: .normal)
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(10))
        bt.addTarget(self, action: #selector(FKYLotteryVirtualPrizeView.useButtonClicked), for: .touchUpInside)
        bt.backgroundColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF6827), RGBColor(0xFFAD63), WH(60))
        return bt
    }()
    
    /// 中奖结果文描
    lazy var lotteryResult:UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        lb.numberOfLines = 2
        return lb
    }()
    
    /// 查看优惠券按钮
    lazy var checkCouponButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("去\"我的优惠券\"中查看", for: .normal)
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(14))
        bt.setImage(UIImage(named:"icon_arrow_middle"), for: .normal)
        
        bt.addTarget(self, action: #selector(FKYLotteryVirtualPrizeView.checkCouponBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension FKYLotteryVirtualPrizeView{
    func setupUI(){
        self.addSubview(self.backgroundImage)
        self.addSubview(self.couponBackgorundImage)
        self.couponBackgorundImage.addSubview(self.couponTypeLB)
        self.couponBackgorundImage.addSubview(self.useCondition)
        self.couponBackgorundImage.addSubview(self.couponExpiryDateLB)
        self.couponBackgorundImage.addSubview(self.RMBTag)
        self.couponBackgorundImage.addSubview(self.couponDenominationsLB)
        self.couponBackgorundImage.addSubview(self.useButton)
        self.addSubview(self.lotteryResult)
        self.addSubview(self.checkCouponButton)
        
        self.backgroundImage.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        self.couponBackgorundImage.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(WH(66))
            make.width.equalTo(WH(240))
            make.height.equalTo(WH(80))
        }
        
        self.couponTypeLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(21))
            make.bottom.equalTo(self.useCondition.snp_top).offset(WH(-5))
        }
        
        self.useCondition.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(WH(21))
            make.right.equalTo(self.RMBTag.snp_left)
        }
        
        self.couponExpiryDateLB.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.useCondition)
            make.top.equalTo(self.useCondition.snp_bottom).offset(WH(5))
        }
        
        self.RMBTag.snp_makeConstraints { (make) in
            make.left.equalTo(self.couponBackgorundImage.snp_right).offset(WH(-86))
            make.width.equalTo(WH(15))
            make.bottom.equalTo(self.couponDenominationsLB).offset(WH(-5))
        }
        
        self.couponDenominationsLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.RMBTag.snp_right).offset(WH(0))
            make.bottom.equalTo(self.couponBackgorundImage.snp_centerY).offset(WH(0))
            make.right.equalToSuperview()
        }
        
        self.useButton.layer.cornerRadius = WH(24/2.0)
        self.useButton.layer.masksToBounds = true
        self.useButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.RMBTag).offset(WH(0))
            make.top.equalTo(self.couponBackgorundImage.snp_centerY).offset(WH(0))
            make.height.equalTo(WH(24))
            make.width.equalTo(WH(60))
        }
        
        self.lotteryResult.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.couponBackgorundImage.snp_bottom).offset(WH(34))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        self.checkCouponButton.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.lotteryResult.snp_bottom).offset(WH(7))
            make.bottom.equalToSuperview().offset(WH(-24))
        }
        
        self.checkCouponButton.layoutIfNeeded()
        self.checkCouponButton.layoutButton(style: .Right, imageTitleSpace: 5)
    }
    
    /// 不显示立即使用按钮布局
    func hiddenUseButton(){
        self.couponDenominationsLB.snp_remakeConstraints { (make) in
            make.left.equalTo(self.RMBTag.snp_right).offset(WH(0))
            make.centerY.right.equalToSuperview()
        }
    }
    
    /// 显示立即使用按钮布局
    func showUseButton(){
        self.couponDenominationsLB.snp_remakeConstraints { (make) in
            make.left.equalTo(self.RMBTag.snp_right).offset(WH(0))
            make.bottom.equalTo(self.couponBackgorundImage.snp_centerY).offset(WH(0))
        }
    }
}

// MARK: - 数据展示
extension FKYLotteryVirtualPrizeView{
    func configViewData(viewData:FKYDrawPrizeCouponModel){
        self.viewData = viewData
        self.configCouponBtnData()
        self.useCondition.text = "满\(self.viewData.limitprice)可用"
        
        if self.viewData.begindate.isEmpty == false && self.viewData.endDate.isEmpty == false {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "YYYY.MM.dd"
            let beginDate = self.stringToDate(self.viewData.begindate)
            let beginStr = self.dateToString(beginDate,dateFormat:"YYYY.MM.dd")
            
            dateformatter.dateFormat = "MM.dd"
            let endDate = self.stringToDate(self.viewData.endDate)
            let endStr = self.dateToString(endDate,dateFormat:"MM.dd")
            self.couponExpiryDateLB.text = beginStr + "-" + endStr
        }else{
            self.couponExpiryDateLB.text = ""
        }
        
        
        self.couponDenominationsLB.text = self.viewData.denomination
        
        self.lotteryResult.text = "恭喜您\n抽中满\(self.viewData.limitprice)减\(self.viewData.denomination)优惠券"
    }
    
    /// 配置优惠券按钮的展示状态
    func configCouponBtnData(){
        // 0-店铺券 1-平台券
        if self.viewData.tempType == "0" {
            self.couponTypeLB.text = "店铺券  "
            self.useButton.setTitle("立即使用", for: .normal)
        }else if self.viewData.tempType == "1"{
            self.couponTypeLB.text = "平台券  "
            self.useButton.setTitle("可用商家", for: .normal)
        }
        
        if self.viewData.tempType == "1", self.viewData.isLimitShop == "0"{
            /// 平台券 不限制商家 不展示按钮
            self.useButton.isHidden = true
            self.hiddenUseButton()
        }else if self.viewData.tempType == "1", self.viewData.isLimitShop == "1"{
            /// 平台券 限制商家  展示按钮
            self.useButton.isHidden = false
            self.showUseButton()
        }else if self.viewData.tempType == "0", self.viewData.isLimitProduct == "0"{
            /// 店铺券 不限制商品 不展示按钮
            self.useButton.isHidden = true
            self.hiddenUseButton()
        }else if self.viewData.tempType == "0", self.viewData.isLimitProduct == "1"{
            /// 店铺券 限制商品 展示按钮
            self.useButton.isHidden = false
            self.showUseButton()
        }
    }
}

// MARK: - 响应事件
extension FKYLotteryVirtualPrizeView{
    
    /// 立即使用按钮点击
    @objc func useButtonClicked(){
        self.routerEvent(withName: FKY_useButtonClicked, userInfo: [FKYUserParameterKey:""])
    }
    
    /// 查看优惠券按钮
    @objc func checkCouponBtnClicked(){
        self.routerEvent(withName: FKY_checkCouponBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
}

// MARK: - 私有方法
extension FKYLotteryVirtualPrizeView{
    //字符串 -> 日期
    func stringToDate(_ string:String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date ?? Date()
    }
    
    //日期 -> 字符串
    func dateToString(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
}
