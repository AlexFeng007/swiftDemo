//
//  FKYLotteryView.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 开始抽奖事件
let FKY_startLottery = "startLottery"

/// 转盘已经停止转动
let FKY_turntableIsStoped = "turntableIsStoped"

class FKYLotteryView: UIView {
    
    /// 转盘因为异常情况停止转动
    static let FKY_turntableIsStopedWithError = "turntableIsStopedWithError"
    
    /// 最外层转盘宽高
    let turntableWidth1 = WH(340)
    
    /// 第二层转盘宽高
    let turntableWidth2 = WH(307)
    
    /// 中间指针宽高
    let turntableWidth3 = WH(142)
    
    /// 开始按钮宽高
    let startButtonWidth = WH(80)
    
    /// 是否正在转动
    var isRotate = false
    
    /// 奖品list
    var prizeList:[FKYPrizeModel] = []
    
    /// 最外层框背景
    lazy var backgroundImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"turntableWidth1")
        return image
    }()
    
    /// 第二层转盘背景
    lazy var turntable2ImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"turntable2")
        return image
    }()
    
    /// 中间指针
    lazy var turntable3ImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"turntable3Image")
        return image
    }()
    
    /// 开始文描
    lazy var startLB:UILabel = {
        let lb = UILabel()
        lb.text = "开始"
        lb.textColor = RGBColor(0x7A5221)
        lb.font = UIFont.boldSystemFont(ofSize: WH(24))
        lb.textAlignment = .center
        return lb
    }()
    
    /// 剩余机会次数
    lazy var leftChanceLB:UILabel = {
        let lb = UILabel()
        lb.text = "还剩00000次"
        lb.textColor = RGBColor(0xB16D18)
        lb.font = UIFont.systemFont(ofSize: WH(12))
        lb.textAlignment = .center
        return lb
    }()
    
    /// 开始抽奖按钮
    lazy var startLotteryBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYLotteryView.startLotteryAction), for: .touchUpInside)
        return bt
    }()
    
    /// 添加进来的奖品View
    lazy var prizeViewList:[AwardView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - UI
extension FKYLotteryView {
    
    func setupUI(){
        
        self.backgroundColor = .clear
        
        self.addSubview(self.backgroundImage)
        self.addSubview(self.turntable2ImageView)
        self.addSubview(self.turntable3ImageView)
        self.addSubview(self.startLB)
        self.addSubview(self.leftChanceLB)
        self.addSubview(self.startLotteryBtn)
        
        self.backgroundImage.snp_makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        self.turntable2ImageView.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(self.turntableWidth2)
        }
        
        self.turntable3ImageView.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(WH(-10))
            make.width.height.equalTo(self.turntableWidth3)
        }
        
        self.startLB.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.turntable3ImageView).offset(WH(57))
        }

        self.leftChanceLB.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.startLB.snp_bottom).offset(WH(0))
        }

        self.startLotteryBtn.snp_makeConstraints { (make) in
            make.center.equalTo(self.turntable3ImageView)
            make.width.height.equalTo(WH(self.startButtonWidth))
        }
    }
    
    /// 添加奖品view
    func addPrizeView(){
        for view in self.prizeViewList {
            view.removeFromSuperview()
        }
        self.setNeedsDisplay()
        self.turntable2ImageView.layoutIfNeeded()
        self.prizeViewList.removeAll()
        for index in 0..<self.prizeList.count {
            let frame = CGRect(x: 0,y: 0,width: WH(130),height: self.turntableWidth2 / 2 + WH(20))
            let awardView = AwardView(frame: frame)
            awardView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.83);
            awardView.center = CGPoint(x: self.turntableWidth2 / 2,y: self.turntableWidth2 / 2)
            self.turntable2ImageView.addSubview(awardView)
            awardView.set(baseAngle: 270 * .pi / 180, radius: WH(162))
            let angle:CGFloat = CGFloat(Double.pi) * 2.0 / CGFloat(self.prizeList.count) * CGFloat(index)
            let circleAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            circleAnimation.duration = 0.0001
            circleAnimation.repeatCount = 1
            circleAnimation.toValue = angle
            circleAnimation.isRemovedOnCompletion = false
            circleAnimation.fillMode = CAMediaTimingFillMode.forwards
            awardView.layer.add(circleAnimation, forKey: "rotation")
            awardView.configData(prizeModel: self.prizeList[index])
            self.prizeViewList.append(awardView)
        }
    }
}

//MARK: - 数据显示
extension FKYLotteryView {
    
    /// 展示转盘里面的商品列表
    func configData(drawModel:FKYDrawModel){
        self.prizeList.removeAll()
        self.prizeList = drawModel.prizeInfo
        self.leftChanceLB.text = "还剩\(drawModel.prizeCount)次"
        self.addPrizeView()
        if Int( drawModel.prizeCount ) ?? 0 < 1 {
            self.isCanDraw(isCan: false)
        }else{
            self.isCanDraw(isCan: true)
        }
    }
}
//MARK: - 响应事件
extension FKYLotteryView {
    
    /// 开始抽奖
    @objc func startLotteryAction(){
        self.routerEvent(withName: FKY_startLottery, userInfo: [FKYUserParameterKey:""])
        self.startRotat()
    }
}


//MARK: - 私有方法
extension FKYLotteryView {
    
    /// 开始转圈 -开始后会无限转圈
    func startRotat(){
        
        guard self.isRotate == false else {
            return
        }
        
        self.isRotate = true
        self.isCanDraw(isCan: false)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi * 2.0
        rotationAnimation.duration = 0.6
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.isRemovedOnCompletion = true
        self.turntable2ImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 抽奖成功后停止转圈  - 停止转圈后会先转6圈，然后再慢慢停到指定地方
    /// stopIndex 停到第几个格子（顺时针方向，从0开始）
    func stopWithSuccess(stopIndex:Int = 0) {
        self.turntable2ImageView.layer.removeAllAnimations()
        let singenAngen = Double.pi * 2 / Double(self.prizeList.count)
        
        let toAngen = Double(stopIndex) * singenAngen
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = NSNumber(floatLiteral: (Double.pi * 12 - toAngen))
        rotationAnimation.duration = 1*6 + 0.5 / 6 * Double(stopIndex)
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        rotationAnimation.isCumulative = true
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.delegate = self
        self.turntable2ImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 直接停止 -会立即停止并恢复到初始状态
    func stopRotatNow(){
        self.turntable2ImageView.layer.removeAllAnimations()
        self.isRotate = false
        self.routerEvent(withName: FKYLotteryView.FKY_turntableIsStopedWithError, userInfo: [FKYUserParameterKey:""])
        self.isRotate = false
    }
    
    /// 是否可以抽奖
    func isCanDraw(isCan:Bool){
        if isCan == true {
            self.startLB.textColor = RGBColor(0x7A5221)
            self.leftChanceLB.textColor = RGBColor(0xB16D18)
            self.startLotteryBtn.isUserInteractionEnabled = true
        }else{
            self.startLB.textColor = RGBColor(0xBA842C)
            self.leftChanceLB.textColor = RGBColor(0xB16D18)
            self.startLotteryBtn.isUserInteractionEnabled = false
        }
    }
}

//MARK: - 动画代理
extension FKYLotteryView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.routerEvent(withName: FKY_turntableIsStoped, userInfo: [FKYUserParameterKey:""])
        self.isRotate = false
    }
}
