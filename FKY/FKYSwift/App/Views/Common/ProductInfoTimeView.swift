//
//  ProductInfoTimeView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/9.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ProductInfoTimeView: UIView {
    
    var timeout : Int64 = 0 //剩余时间轴
    var type = 0 //(1:表示活动未开始，2 ：活动开始 3 活动已经结束)
    var refreshDataWithTimeOut : ((_ typeTimer: Int)->())? //倒计时结束刷新
    fileprivate var timer: Timer!
    fileprivate var productModel: Any?
    
    //倒计时
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xFFFCF1)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(4)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textColor = RGBColor(0xE8772A)
        label.textAlignment = .center
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
    //    deinit {
    //        self.stopCount()
    //    }
    // MARK: - UI
    fileprivate func setupView() {
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(14))
            make.left.equalTo(self.snp.left).offset(WH(15))
            make.height.equalTo(WH(21))
            make.width.equalTo(WH(0))
        }
    }
    //设置商家特惠中ui布局
    func resetTimeLabelLayout() {
        self.timeLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.height.equalTo(WH(21))
            make.width.equalTo(WH(0))
        }
        timeLabel.backgroundColor = RGBColor(0xFFEDE7)
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = WH(10.5)
        timeLabel.textColor = RGBColor(0xFF2D5C)
        
    }
    //设置单品包邮中的ui布局
    func resetTimePackageLabelLayout() {
        self.timeLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.height.equalTo(WH(21))
            make.width.equalTo(WH(0))
        }
        timeLabel.backgroundColor = RGBColor(0xFFFCF1)
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = WH(10.5)
        timeLabel.textColor = RGBColor(0xE8772A)
    }
    
    //一起购列表倒计时
    func configYQGCell(_ product: Any,nowLocalTime : Int64) {
        self.type = 0
        self.timeout = 0
        if let model = product as? FKYTogeterBuyModel{
            self.productModel = model
            //倒计时相关
            if let endInterval =  model.endTime,let beginInterval = model.beginTime {
                if beginInterval > nowLocalTime {
                    //活动未开始(按钮置灰隐藏进度条及百分比显示)
                    self.type = 1
                    timeout = beginInterval - nowLocalTime
                    self.stopCount()
                    self.showShopCountDownContent(timeout)
                    // 启动timer...<1.s后启动>
                    let date = NSDate.init(timeIntervalSinceNow: 1.0)
                    timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                } else if beginInterval <= nowLocalTime, nowLocalTime < endInterval {
                    //活动已经开始
                    self.type = 2
                    timeout = endInterval - nowLocalTime
                    self.stopCount()
                    self.showShopCountDownContent(timeout)
                    // 启动timer...<1.s后启动>
                    let date = NSDate.init(timeIntervalSinceNow: 1.0)
                    timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                    
                } else if nowLocalTime > endInterval {
                    //活动结束
                    self.type = 3
                    self.resetAllData()
                }else {
                    self.resetAllData()
                }
            }else{
                self.resetAllData()
            }
        }
    }
    func configCell(_ product: Any){
        self.type = 0
        self.timeout = 0
        if let model = product as? ShopListSecondKillProductItemModel{
            self.productModel = model
            //店铺管秒杀特惠
            if let endInterval =  model.downTimeMillis,let beginInterval = model.upTimeMillis {
                if beginInterval > model.sysTimeMillis! {
                    //活动未开始(按钮置灰隐藏进度条及百分比显示)
                    self.type = 1
                    timeout = (beginInterval - model.sysTimeMillis!)/1000
                    self.stopCount()
                    self.showShopCountDownContent(timeout)
                    // 启动timer...<1.s后启动>
                    let date = NSDate.init(timeIntervalSinceNow: 1.0)
                    timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                } else if beginInterval <= model.upTimeMillis!, model.sysTimeMillis! < endInterval {
                    //活动已经开始
                    self.type = 2
                    timeout = (endInterval - model.sysTimeMillis!)/1000
                    self.stopCount()
                    self.showShopCountDownContent(timeout)
                    // 启动timer...<1.s后启动>
                    let date = NSDate.init(timeIntervalSinceNow: 1.0)
                    timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                    
                } else if model.sysTimeMillis! > endInterval {
                    //活动结束
                    self.type = 3
                    self.resetAllData()
                }else {
                    self.resetAllData()
                }
            }else{
                self.resetAllData()
            }
        }
    }
    
    func configPrefertailTimeCell(_ product: Any,nowLocalTime : Int64) {
        self.type = 0
        self.timeout = 0
        self.isHidden = true
        //商家特惠倒计时
        if let model = product as? FKYPreferetailModel{
            self.productModel = model
            //倒计时相关
            if let endInterval =  model.endTime {
                if nowLocalTime < endInterval {
                    //活动已经开始
                    self.isHidden = false
                    self.type = 2
                    timeout = (endInterval - nowLocalTime)/1000
                    self.stopCount()
                    self.showShopCountDownContent(timeout)
                    // 启动timer...<1.s后启动>
                    let date = NSDate.init(timeIntervalSinceNow: 1.0)
                    timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                    
                } else if nowLocalTime > endInterval {
                    //活动结束
                    self.type = 3
                    self.resetAllData()
                }else {
                    self.resetAllData()
                }
            }else{
                self.resetAllData()
            }
        }else if let model = product as? FKYPackageRateModel {
            //单品包邮
            self.productModel = model
            //倒计时相关
            if let endInterval =  model.endTime ,let beginInterval = model.beginTime{
                if beginInterval > nowLocalTime {
                   //活动未开始
                    self.isHidden = false
                    self.type = 1
                    timeout = (endInterval - nowLocalTime)/1000
                    self.stopCount()
                    self.showShopCountDownContent(timeout)
                    // 启动timer...<1.s后启动>
                    let date = NSDate.init(timeIntervalSinceNow: 1.0)
                    timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                } else if beginInterval <= nowLocalTime, nowLocalTime < endInterval {
                    //活动已经开始
                    self.isHidden = false
                    self.type = 2
                    timeout = (endInterval - nowLocalTime)/1000
                    self.stopCount()
                    self.showShopCountDownContent(timeout)
                    // 启动timer...<1.s后启动>
                    let date = NSDate.init(timeIntervalSinceNow: 1.0)
                    timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                } else if nowLocalTime > endInterval {
                    //活动结束
                    self.type = 3
                    self.resetAllData()
                }else {
                    self.resetAllData()
                }
            }else{
                self.resetAllData()
            }
        }
    }
    @objc func showTimeCount() {
        timeout -= 1
        if timeout <= 0 {
            if let block = self.refreshDataWithTimeOut {
                block(self.type)
            }
            if self.type == 1 {
                //对于未开始时间完成需请求接口，接口可能失败定时器不会刷新
                self.resetAllData()
            }
        } else {
            self.showShopCountDownContent(timeout)
        }
        //根据判断views所属的控制器被销毁了，销毁定时器
        guard (self.getFirstViewController()) != nil else{
            self.stopCount()
            return
        }
    }
    // 显示倒计时内容
    func showShopCountDownContent(_ timeInterval: Int64) {
        var time = timeInterval
        let day = Int(time / 3600 / 24)
        if day > 0 {
            time = time - Int64(day * 3600 * 24)
        }
        let hour = Int(time / 3600)
        let min = Int(time % 3600 / 60)
        let sec = Int(time % 3600 % 60)
        
        var dayString = "\(day)"
        var hourString = "\(hour)"
        var minString = "\(min)"
        var secString = "\(sec)"
        if day < 10 {
            dayString = "0" + "\(day)"
        }
        if hour < 10 {
            hourString = "0" + "\(hour)"
        }
        if min < 10 {
            minString = "0" + "\(min)"
        }
        if sec < 10 {
            secString = "0" + "\(sec)"
        }
        let status: String = self.type == 2 ? "结束" : "开始"
        var str = ""
        if day > 0 {
            str = "还剩 \(dayString) 天 \(hourString):\(minString):\(secString) \(status)"
        } else {
            str = "还剩 \(hourString):\(minString):\(secString) \(status)"
        }
        self.timeLabel.attributedText = self.getProductTimeAttrStr(str)
        let contentSizeW = self.timeLabel.attributedText!.boundingRect(with: CGSize(width: SCREEN_WIDTH - SORT_TAB_W - WH(60 +  8 + 22), height: WH(18)), options: .usesLineFragmentOrigin, context: nil).size.width + WH(14)
        self.timeLabel.snp.updateConstraints { (make) in
            make.width.equalTo(contentSizeW)
        }
        
        self.layoutIfNeeded()
    }
    func showCountDownContent(_ timeInterval: Int64) {
        let hour = timeInterval / 3600
        let min = timeInterval % 3600 / 60
        let sec = timeInterval % 60
        if self.type == 1 {
            self.timeLabel.attributedText = self.getProductTimeAttrStr(String.init(format: "还剩 %02d:%02d:%02d 开始", hour,min,sec))
            let contentSizeW = self.timeLabel.attributedText!.boundingRect(with: CGSize(width: SCREEN_WIDTH - SORT_TAB_W - WH(60 +  8 + 22), height: WH(18)), options: .usesLineFragmentOrigin, context: nil).size.width + WH(14)
            self.timeLabel.snp.updateConstraints { (make) in
                make.width.equalTo(contentSizeW)
            }
        }else if self.type == 2 {
            self.timeLabel.attributedText = self.getProductTimeAttrStr(String.init(format: "还剩 %02d:%02d:%02d 结束", hour,min,sec))
            let contentSizeW = self.timeLabel.attributedText!.boundingRect(with: CGSize(width: SCREEN_WIDTH - SORT_TAB_W - WH(60 +  8 + 22), height: WH(18)), options: .usesLineFragmentOrigin, context: nil).size.width + WH(14)
            self.timeLabel.snp.updateConstraints { (make) in
                make.width.equalTo(contentSizeW)
            }
            
        }
    }
    
    // 停止倒计时
    func stopCount() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        //        // 倒计时结束
        //        isCounting = false
    }
    
    func resetAllData() {
        //        self.stepper.isHidden = true
        //        self.addProductBtn.isHidden = true
        self.timeLabel.attributedText = self.getProductTimeAttrStr("还剩 00:00:00 结束")
        let contentSizeW = self.timeLabel.attributedText!.boundingRect(with: CGSize(width: SCREEN_WIDTH - SORT_TAB_W - WH(60 +  8 + 22), height: WH(18)), options: .usesLineFragmentOrigin, context: nil).size.width + WH(14)
        self.timeLabel.snp.updateConstraints { (make) in
            make.width.equalTo(contentSizeW)
        }
        stopCount()
    }
    
    //获取行高
    static func getContentHeight(_ product: Any) -> CGFloat{
        var Cell = WH(0)
        if product is FKYTogeterBuyModel{
            //一起购信息
            Cell =  Cell + WH(35)
        }
        if product is ShopListSecondKillProductItemModel{
            //秒杀特惠
            Cell =  Cell + WH(35)
        }
        
        
        return Cell
    }
    //MARK:商家特惠计算高度 or 单品包邮计算高度
    static func getPreferentialContentHeight (_ product: Any,_ nowLocalTime : Int64) -> CGFloat {
        var Cell = WH(0)
        if let model = product as? FKYPreferetailModel {
            if let endInterval =  model.endTime {
                if nowLocalTime < endInterval {
                    //活动已经开始
                    Cell =  Cell + WH(26)
                }
            }
        }else if let model = product as? FKYPackageRateModel {
            if  let endInterval =  model.endTime ,let beginInterval = model.beginTime {
                if beginInterval > nowLocalTime {
                    //活动未开始
                    Cell =  Cell + WH(26)
                }else if beginInterval <= nowLocalTime, nowLocalTime < endInterval {
                    //活动已经开始
                    Cell =  Cell + WH(26)
                }
            }
        }
        return Cell
    }
    
    //生成符文本
    func getProductTimeAttrStr(_ timeStr:String) -> (NSMutableAttributedString) {
        //定义富文本即有格式的字符串
        var textColor = RGBColor(0xE8772A)
        if let _ = self.productModel as? FKYPreferetailModel {
            textColor = RGBColor(0xFF2D5C)
        }
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let timeStr : NSAttributedString =  NSAttributedString(string: timeStr, attributes: [NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12))])
        attributedStrM.append(timeStr )
        attributedStrM.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12))], range: NSMakeRange(0, 2))
        attributedStrM.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12))], range: NSMakeRange(attributedStrM.length - 2, 2))
        return attributedStrM;
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
