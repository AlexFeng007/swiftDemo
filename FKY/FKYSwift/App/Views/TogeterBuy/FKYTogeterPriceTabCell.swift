//
//  FKYTogeterPriceTabCell.swift
//  FKY
//
//  Created by hui on 2018/10/24.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

let PROCESS_ALL_W = WH(60)

class FKYTogeterPriceTabCell: UITableViewCell {
    
    fileprivate lazy var bgImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    fileprivate lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFFFFFF)
        label.font = t1.font
        label.text = "认购价"
        return label
    }()
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFFFFFF)
        label.font = UIFont.systemFont(ofSize: WH(28))
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //显示条
    fileprivate lazy var progressAllView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(6)
        return view
    }()
    
    //已经购买显示条
    fileprivate lazy var progressFinishView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFEC83)
        return view
    }()
    
    
    fileprivate lazy var progressStrLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = t28.font
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var timeStrLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = t28.font
        label.textAlignment = .right
        label.text = "距离结束还剩"
        return label
    }()
    
    //时间显示背景
    fileprivate lazy var timeBgView : UIView = {
        let view = UIView()
        return view
    }()
    //
    fileprivate lazy var lblHour: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(11))
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0xFFFFFF)
        lbl.font = t26.font
        lbl.backgroundColor = RGBColor(0xFF2D5C)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 2
        lbl.text = "23"
        return lbl
    }()
    
    //
    fileprivate lazy var lblMinute: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(11))
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0xFFFFFF)
        lbl.font = t26.font
        lbl.backgroundColor = RGBColor(0xFF2D5C)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 2
        lbl.text = "58"
        return lbl
    }()
    
    //
    fileprivate lazy var lblSecond: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(11))
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0xFFFFFF)
        lbl.font = t26.font
        lbl.backgroundColor = RGBColor(0xFF2D5C)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 2
        lbl.text = "32"
        return lbl
    }()
    
    //
    fileprivate lazy var lblColonLeft: UILabel! = {
        let lbl = UILabel()
        lbl.font = t26.font
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.text = ":"
        return lbl
    }()
    
    //
    fileprivate lazy var lblColonRight: UILabel! = {
        let lbl = UILabel()
        lbl.font = t26.font
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.text = ":"
        return lbl
    }()
    
    var timeout = 555550
    var type = 0 //(1:表示活动未开始，2 ：活动开始 3 活动已经结束)
    fileprivate var timer: Timer!
    var refreshDataForTimeOver : ((Int)->())? //刷新
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView() {
        
        contentView.addSubview(self.bgImageView)
        self.bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        contentView.addSubview(self.introductionLabel)
        self.introductionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(20))
            make.top.equalTo(contentView.snp.top).offset(WH(20))
            make.height.equalTo(WH(12))
        }
        contentView.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.introductionLabel.snp.right).offset(WH(2))
            make.bottom.equalTo(self.introductionLabel.snp.bottom)
            make.height.equalTo(WH(21))
            make.width.equalTo(WH(115))
        }
        
        contentView.addSubview(self.progressAllView)
        self.progressAllView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-WH(128))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(14))
            make.height.equalTo(WH(14))
            make.width.equalTo(PROCESS_ALL_W)
        }
        self.progressAllView.addSubview(self.progressFinishView)
        self.progressFinishView.snp.makeConstraints { (make) in
            make.left.equalTo(self.progressAllView.snp.left)
            make.top.equalTo(self.progressAllView.snp.top)
            make.height.equalTo(WH(14))
            make.width.equalTo(WH(0))
        }
        self.progressAllView.addSubview(self.progressStrLabel)
        self.progressStrLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.progressAllView)
        }
        contentView.addSubview(self.timeStrLabel)
        self.timeStrLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-WH(23))
            make.top.equalTo(contentView.snp.top).offset(WH(8))
            make.height.equalTo(WH(10))
        }
        
        contentView.addSubview(self.timeBgView)
        self.timeBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeStrLabel.snp.bottom).offset(WH(4))
            make.height.equalTo(WH(15))
            make.centerX.equalTo(self.timeStrLabel.snp.centerX)
            make.width.lessThanOrEqualTo(WH(105))
        }
        //倒计时
        self.timeBgView.addSubview(self.lblSecond)
        self.lblSecond.snp.makeConstraints { (make) in
            make.right.equalTo(self.timeBgView.snp.right)
            make.top.equalTo(self.timeBgView.snp.top)
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(15))
        }
        contentView.addSubview(self.lblColonRight)
        self.lblColonRight.snp.makeConstraints { (make) in
            make.right.equalTo(self.lblSecond.snp.left)
            make.centerY.equalTo(self.lblSecond.snp.centerY)
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(5))
        }
        contentView.addSubview(self.lblMinute)
        self.lblMinute.snp.makeConstraints { (make) in
            make.right.equalTo(self.lblColonRight.snp.left)
            make.centerY.equalTo(self.lblSecond.snp.centerY)
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(15))
        }
        contentView.addSubview(self.lblColonLeft)
        self.lblColonLeft.snp.makeConstraints { (make) in
            make.right.equalTo(self.lblMinute.snp.left)
            make.centerY.equalTo(self.lblSecond.snp.centerY)
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(5))
        }
        contentView.addSubview(self.lblHour)
        self.lblHour.snp.makeConstraints { (make) in
            make.right.equalTo(self.lblColonLeft.snp.left)
            make.centerY.equalTo(self.lblSecond.snp.centerY)
            make.height.equalTo(WH(15))
            make.width.lessThanOrEqualTo(WH(45))
            make.left.equalTo(self.timeBgView.snp.left)
        }
    }
    
}
extension FKYTogeterPriceTabCell {
    func configCell(_ detailModel : FKYTogeterBuyDetailModel? ,_ spaceTime : Int) {
        if let model = detailModel {
            self.progressAllView.isHidden = true
            self.timeStrLabel.isHidden = true
            self.lblSecond.isHidden = true
            self.lblColonRight.isHidden = true
            self.lblMinute.isHidden = true
            self.lblColonLeft.isHidden = true
            self.lblHour.isHidden = true
            //
            if model.projectStatus == 2 || model.projectStatus == 4 {
                self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth: Float(SCREEN_WIDTH))
            }else {
                self.progressAllView.isHidden = false
                self.timeStrLabel.isHidden = false
                self.lblSecond.isHidden = false
                self.lblColonRight.isHidden = false
                self.lblMinute.isHidden = false
                self.lblColonLeft.isHidden = false
                self.lblHour.isHidden = false
                self.bgImageView.image = UIImage.init(named: "bgTogeterPic")
                if let percentNum = model.percentage {
                    self.progressStrLabel.text = "已认购\(percentNum)%"
                    self.progressFinishView.snp.updateConstraints { (make) in
                        make.width.equalTo(WH((CGFloat(percentNum)/100.0))*PROCESS_ALL_W)
                    }
                }else{
                    self.progressStrLabel.text = "已认购0%"
                    self.progressFinishView.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }
                
                //倒计时处理
                self.type = 0
                timeStrLabel.text = "距离结束还剩"
                self.progressAllView.isHidden = false
                if let currentTimeInterval =  model.endTime ,let startTimeInterval = model.startTime {
                    if startTimeInterval > 0 ,  CGFloat(startTimeInterval)/1000.0 - CGFloat(spaceTime) > 0 {
                        self.type = 1
                        //活动未开始隐藏进度条
                        timeStrLabel.text = "距离开始还剩"
                        self.progressAllView.isHidden = true
                        
                        timeout = Int(ceil(CGFloat(startTimeInterval)/1000.0 - CGFloat(spaceTime)))
                        self.stopCount()
                        self.showCountDownContent(timeout)
                        // 启动timer...<1.s后启动>
                        let date = NSDate.init(timeIntervalSinceNow: 1.0)
                        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                    }else if  currentTimeInterval > 0 , CGFloat(currentTimeInterval)/1000.0 - CGFloat(spaceTime) > 0 {
                        self.type = 2
                        timeStrLabel.text = "距离结束还剩"
                        timeout = Int(ceil(CGFloat(currentTimeInterval)/1000.0 - CGFloat(spaceTime)))
                        self.stopCount()
                        self.showCountDownContent(timeout)
                        // 启动timer...<1.s后启动>
                        let date = NSDate.init(timeIntervalSinceNow: 1.0)
                        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                    }else {
                        self.type = 3
                        self.resetAllData()
                    }
                }else {
                    self.resetAllData()
                }
            }

//            if model.isCheck == "0" {
//                self.priceLabel.font = t45.font
//                self.priceLabel.text = "资质认证后可见"
//                self.priceLabel.snp.updateConstraints { (make) in
//                    make.height.equalTo(WH(15))
//                }
//            }else {
                self.priceLabel.font = UIFont.systemFont(ofSize: WH(28))
                let priceStr = String.init(format: "¥ %.2f/%@",model.subscribePrice ?? 0,model.unit ?? "")
                let priceMutableStr = NSMutableAttributedString.init(string:priceStr)
                
                let yRange = (priceStr as NSString).range(of: "¥")
                let unitRange = (priceStr as NSString).range(of: "/\(model.unit ?? "")")
                let spotRange = (priceStr as NSString).range(of: ".")
            priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(14))], range: yRange)
            priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(20))], range:NSMakeRange(spotRange.location,3))
            priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(12))], range: unitRange)
                self.priceLabel.attributedText = priceMutableStr
//                self.priceLabel.snp.updateConstraints { (make) in
//                    make.height.equalTo(WH(21))
//                }
            //}
        }
    }
    
    @objc func showTimeCount() {
        timeout -= 1
        if timeout <= 0 {
            //self.resetAllData()
            if let block = self.refreshDataForTimeOver {
                block(self.type)
            }
        } else {
            self.showCountDownContent(timeout)
        }
        //根据判断views所属的控制器被销毁了，销毁定时器
        guard (self.getFirstViewController()) != nil else{
            self.stopCount()
            return
        }
    }
    func showCountDownContent(_ timeInterval: Int) {
        let hour = timeInterval / 3600
        let min = timeInterval % 3600 / 60
        let sec = timeInterval % 60
        self.lblHour.text = String.init(format: "%02d", hour)
        self.lblMinute.text = String.init(format: "%02d", min)
        self.lblSecond.text = String.init(format: "%02d", sec)
    }
    // 停止倒计时
    fileprivate func stopCount() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
//        // 倒计时结束
//        isCounting = false
    }
    func resetAllData() {
        self.lblHour.text = "00"
        self.lblMinute.text = "00"
        self.lblSecond.text = "00"
        stopCount()
    }
    
}
