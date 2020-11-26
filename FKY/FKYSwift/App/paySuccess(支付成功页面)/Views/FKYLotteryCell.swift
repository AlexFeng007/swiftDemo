//
//  FKYLotteryCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 活动规则按钮
let FKY_activityRulerBtnClicked = "activityRulerBtnClicked"

class FKYLotteryCell: UITableViewCell {

    /// 抽奖view
    lazy var lotteryView = FKYLotteryView()
    
    /// 活动规则按钮
    lazy var activityRulesBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("活动规则", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        bt.setTitleColor(RGBColor(0x7A5221), for: .normal)
        bt.backgroundColor = RGBColor(0xFEFAE9)
        bt.addTarget(self, action: #selector(FKYLotteryCell.activityRulerBtnClicked), for: .touchUpInside)
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

//MARK: - 响应事件
extension FKYLotteryCell{
    
    /// 活动规则按钮点击
    @objc func activityRulerBtnClicked(){
        self.routerEvent(withName: FKY_activityRulerBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
    
    /// 停到第几格 可理解为中了几等奖
    func stopWithSuccess(stopIndex:Int = 0) {
        self.lotteryView.stopWithSuccess(stopIndex: stopIndex)
    }
    
    /// 其他异常情况，立即停止转动
    func stopRotatNow(){
        self.lotteryView.stopRotatNow()
    }
}

//MARK: - 数据刷新
extension FKYLotteryCell{
    func configCellData(cellData:FKYOrderPayStatusCellModel){
        self.lotteryView.configData(drawModel: cellData.drawModel)
    }
}

//MARK: - UI
extension FKYLotteryCell{
    
    func setupUI(){
        
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.lotteryView)
        self.contentView.addSubview(self.activityRulesBtn)
        self.contentView.addSubview(self.desLB)
        
        self.lotteryView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(18))
            make.right.equalToSuperview().offset(WH(-18))
            make.top.equalToSuperview().offset(WH(19))
            make.bottom.equalTo(self.desLB.snp_top).offset(WH(-10))
            make.height.width.equalTo(WH(340))
        }
        
        self.activityRulesBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.lotteryView)
            make.left.equalToSuperview()
            make.width.equalTo(WH(77))
            make.height.equalTo(WH(30))
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
