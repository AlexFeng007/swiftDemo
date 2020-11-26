//
//  COPayInfoView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/23.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  选择在线支付方式之订单支付信息视图view

import UIKit

class COPayInfoView: UIView {
    // MARK: - Property
    
    // 渐变背景视图
    //    fileprivate lazy var imgviewBg: UIImageView = {
    //        let colorLeft = RGBColor(0xFF5A9B)
    //        let colorRight = RGBColor(0xFF2D5C)
    //        let img = UIImage.gradientColorImage(fromColors: [colorLeft, colorRight], gradientType: .leftToRight, imgSize: CGSize.init(width: SCREEN_WIDTH, height: WH(72)))
    //
    //        let view = UIImageView()
    //        view.image = img
    //        return view
    //    }()
    
    //    // 标题
    //    fileprivate lazy var lblTitle: UILabel = {
    //        let lbl = UILabel()
    //        lbl.backgroundColor = .clear
    //        lbl.font = UIFont.systemFont(ofSize: WH(14))
    //        lbl.textColor = RGBColor(0xFFFFFF)
    //        lbl.textAlignment = .left
    //        lbl.text = "还需支付:"
    //        return lbl
    //    }()
    
    // 金额
    fileprivate lazy var lblMoney: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(30))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        //lbl.text = "￥12345.67"
        return lbl
    }()
    
    // 数量
    lazy var lblTime: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x676767)
        lbl.textAlignment = .left
        //lbl.text = "付款剩余22:27:57"
        return lbl
    }()
    
    // 定时器
    fileprivate var timer: Timer!
    // 剩余时间
    fileprivate var count: Int = 0
    
    /// 金额下方的提示文描
    fileprivate var tipsLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x676767)
        lb.text = "热销品种库消耗过快，为了您的商品顺利出库，请尽快支付哦"
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: WH(12))
        lb.numberOfLines = 0
        return lb
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("COPayInfoView deinit~!@")
        stopCount()
    }
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xF4F4F4)
        
        // addSubview(imgviewBg)
        // addSubview(lblTitle)
        addSubview(lblMoney)
        addSubview(lblTime)
        self.addSubview(self.tipsLB)
    
        lblTime.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(WH(20))
            make.height.equalTo(WH(13))
        }
        lblMoney.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(lblTime.snp.bottom).offset(WH(11))
            make.height.equalTo(WH(40))
        }
        self.tipsLB.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.lblMoney.snp_bottom).offset(WH(7))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            //make.bottom.equalToSuperview().offset(WH(-24))
        }
    }
    
    /// 是否隐藏提示文描
    func isHideTipsLB(_ ishide:Bool){
        if ishide {
            self.tipsLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.lblMoney.snp_bottom).offset(WH(0))
            }
            self.tipsLB.text = ""
        }else{
            self.tipsLB.snp_updateConstraints { (make) in
                make.top.equalTo(self.lblMoney.snp_bottom).offset(WH(11))
            }
            self.tipsLB.text = "热销品种库消耗过快，为了您的商品顺利出库，请尽快支付哦"
        }
    }
    
    
    // MARK: - Public
    
    /// 从购物金充值界面进来的不显示倒计时，显示 还需支付文描 也不展示提示文描
    func needPayDes(){
        self.lblTime.text = "还需支付"
    }
    // time:订单失效时间戳...<需取手机当前时间来计算时间间隔>
    // count:订单失效时间间隔...<直接拿时间间隔进行倒计时显示>
    func configView(money: String?, time: String?, count: String?) {
        // 金额
        if let amount = money, amount.isEmpty == false, let value = Float(amount), value > 0 {
            lblMoney.text = String(format: "￥%.2f", value)
            if let priceStr = lblMoney.text,priceStr.contains("￥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(18))], range: NSMakeRange(0, 1))
                lblMoney.attributedText = priceMutableStr
            }
        }
        else {
            lblMoney.text = nil
        }
        
        // 倒计时...<订单入口>
        if let time = count, time.isEmpty == false, let value = TimeInterval(time), value > 0 {
            showTimeCountDown(Int(value))
            return
        }
        
        // 倒计时...<购物车/检查订单入口>
        if let time = time, time.isEmpty == false, let value = TimeInterval(time), value > 0 {
            let endSecond: TimeInterval = value / 1000 // 毫秒转秒
            let currentSecond = getCurrentTime()
            let secondLeft = endSecond - currentSecond - 1 // 减1s
            guard secondLeft > 0 else {
                lblTime.text = nil
                return
            }
            showTimeCountDown(Int(secondLeft))
            return
        }
        
        // 两者均无，不显示
        lblTime.text = nil
    }
    
    
    // MARK: - Private
    
    fileprivate func getCurrentTime() -> TimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    fileprivate func showTimeCountDown(_ timeInterval: Int) {
        count = timeInterval
        beginCount()
    }
}


// MARK: - Count Down

extension COPayInfoView {
    // 开始倒计时
    fileprivate func beginCount() {
        // 取消timer
        stopCount()
        
        // 先显示最大时间间隔
        showCountDownContent(count)
        
        // 启动timer...<0s后启动>
        let date = NSDate.init(timeIntervalSinceNow: 0.0)
        timer = Timer.init(fireAt: date as Date, interval: 1.0, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    // 停止倒计时
    func stopCount() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    // 倒计时操作
    @objc fileprivate func showTimeCount() {
        count = count - 1
        let timeInterval: Int = count
       // print("count:\(count)")
        
        // 倒计时结束
        guard timeInterval > 0 else {
            count = 0
            stopCount()
            lblTime.text = nil
            return
        }
        
        // 显示内容
        showCountDownContent(timeInterval)
    }
    
    // 显示倒计时内容
    func showCountDownContent(_ timeInterval: Int) {
        // 转成时分秒
        let hour = Int(timeInterval / 3600)
        let min = Int(timeInterval % 3600 / 60)
        let sec = Int(timeInterval % 3600 % 60)
        
        var hourString = "\(hour)"
        var minString = "\(min)"
        var secString = "\(sec)"
        if hour < 10 {
            hourString = "0" + "\(hour)"
        }
        if min < 10 {
            minString = "0" + "\(min)"
        }
        if sec < 10 {
            secString = "0" + "\(sec)"
        }
        
        // 显示
        lblTime.text = "支付剩余时间 " + hourString + ":" + minString + ":" + secString
    }
}
