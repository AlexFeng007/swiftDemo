//
//  FKYLotteryNoPrizeCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYLotteryNoPrizeCell: UITableViewCell {

    /// 未中奖view
    lazy var noPrizeView:FKYLotteryNoPrizeView = FKYLotteryNoPrizeView()
    
    /// 活动规则按钮
    lazy var activityRulesBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("活动规则", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        bt.setTitleColor(RGBColor(0x7A5221), for: .normal)
        bt.backgroundColor = RGBColor(0xFEFAE9)
        bt.addTarget(self, action: #selector(FKYLotteryNoPrizeCell.activityRulerBtnClicked), for: .touchUpInside)
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
extension FKYLotteryNoPrizeCell{
    
    /// 活动规则按钮点击
    @objc func activityRulerBtnClicked(){
        self.routerEvent(withName: FKY_activityRulerBtnClicked, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - UI
extension FKYLotteryNoPrizeCell{
    
    func setupUI(){
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.activityRulesBtn)
        self.contentView.addSubview(self.noPrizeView)
        self.contentView.addSubview(self.desLB)
        
        self.activityRulesBtn.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(WH(77))
            make.height.equalTo(WH(30))
        }
        
        self.noPrizeView.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(57))
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

//----------------------------------- 未中奖界面 --------------------------------
// MARK: -未中奖界面单独封装成一个view，防止后面要做动画或者拿到其他地方用
class FKYLotteryNoPrizeView:UIView{
    
    /// 未中奖图标
    lazy var emptyImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"no_Prize_Icon")
        return image
    }()
    
    /// 未中奖文描
    lazy var emptyDes:UILabel = {
        let lb = UILabel()
        lb.text = "很遗憾，您没有抽到奖品"
        lb.textAlignment = .center
        lb.textColor = RGBColor(0x666666)
        lb.font = UIFont.systemFont(ofSize:WH(14))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FKYLotteryNoPrizeView{
    
    func setupUI(){
        self.addSubview(self.emptyImage)
        self.addSubview(self.emptyDes)
        
        self.emptyImage.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(WH(100))
        }
        
        self.emptyDes.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.emptyImage.snp_bottom).offset(WH(15))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.bottom.equalToSuperview().offset(WH(-20))
        }
        
    }
}
