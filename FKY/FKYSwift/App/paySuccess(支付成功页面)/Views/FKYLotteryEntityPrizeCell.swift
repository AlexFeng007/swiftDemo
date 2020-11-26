//
//  FKYLotteryEntityPrizeCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//实物奖品cell 目前包含各种实物奖品

import UIKit

class FKYLotteryEntityPrizeCell: UITableViewCell {

    /// 实体奖品view
    lazy var entityPrizeView:FKYLotteryEntityPrizeView = FKYLotteryEntityPrizeView()
    
    /// 活动规则按钮
    lazy var activityRulesBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("活动规则", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        bt.setTitleColor(RGBColor(0x7A5221), for: .normal)
        bt.backgroundColor = RGBColor(0xFEFAE9)
        bt.addTarget(self, action: #selector(FKYLotteryEntityPrizeCell.activityRulerBtnClicked), for: .touchUpInside)
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

//MARK: - 数据显示
extension FKYLotteryEntityPrizeCell{
    func configCellData(cellData:FKYOrderPayStatusCellModel){
        self.entityPrizeView.configViewData(viewData: cellData.drawResultModel)
    }
}

//MARK: - UI
extension FKYLotteryEntityPrizeCell{
    
    func setupUI(){
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.activityRulesBtn)
        self.contentView.addSubview(self.entityPrizeView)
        self.contentView.addSubview(self.desLB)
        
        self.activityRulesBtn.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(WH(77))
            make.height.equalTo(WH(30))
        }
        
        self.entityPrizeView.snp_makeConstraints { (make) in
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

//MARK: - 响应事件
extension FKYLotteryEntityPrizeCell{
    
    /// 活动规则按钮点击
    @objc func activityRulerBtnClicked(){
        self.routerEvent(withName: FKY_activityRulerBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
}



//----------------------------------- 实体奖中奖界面 --------------------------------
// MARK: - 实体奖中奖界面单独封装成一个view，防止后面要做动画或者拿到其他地方用
class FKYLotteryEntityPrizeView: UIView {
    
    /// 中奖结果
    var drawResult:FKYDrawResultModel = FKYDrawResultModel()
    
    /// 背景图片
    lazy var backgroundImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"prize_backgroundImg")
        return image
    }()
    
    /// 实物奖品图片
    lazy var prizeImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"DSJ")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    /// 中奖结果文描
    lazy var lotteryResult:UILabel = {
        let lb = UILabel()
        lb.text = "抱歉\n未知中奖结果"
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        lb.numberOfLines = 2
        return lb
    }()
    
    /// 奖品发放文描
    lazy var lotteryGrantDes:UILabel = {
        let lb = UILabel()
        lb.text = "奖品于活动结束后发放，请耐心等待"
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.numberOfLines = 1
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 数据显示
extension FKYLotteryEntityPrizeView{
    func configViewData(viewData:FKYDrawResultModel){
        self.drawResult = viewData
        self.prizeImage.sd_setImage(with: URL(string: self.drawResult.prisePic))
        self.lotteryResult.text = "恭喜您\n抽中\(self.drawResult.priseName)"
    }
}

//MARK: - UI
extension FKYLotteryEntityPrizeView{
    
    func setupUI(){
        self.addSubview(self.backgroundImage)
        self.addSubview(self.prizeImage)
        self.addSubview(self.lotteryResult)
        self.addSubview(self.lotteryGrantDes)
        
        self.backgroundImage.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        self.prizeImage.snp_makeConstraints { (make) in
            make.height.equalTo(WH(157))
            make.width.equalTo(WH(157))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(WH(20))
        }
        
        self.lotteryResult.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.prizeImage.snp_bottom).offset(WH(5))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        self.lotteryGrantDes.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.lotteryResult.snp_bottom).offset(WH(7))
            make.bottom.equalToSuperview().offset(WH(-24))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
        }
    }
}
