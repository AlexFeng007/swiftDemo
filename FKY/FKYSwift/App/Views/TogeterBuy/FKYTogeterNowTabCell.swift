//
//  FKYTogeterNowTabCell.swift
//  FKY
//
//  Created by hui on 2018/10/23.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterNowTabCell: UITableViewCell {
    let PROGRESS_W = WH(85)
    
    //倒计时
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xFFFCF1)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(4)
        label.font = t22.font
        label.textColor = RGBColor(0xE8772A)
        return label
    }()
    
    // 商品图片
    lazy var img: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    // 状态图片
    lazy var statusImg: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    // 商品图片上标签
    fileprivate lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "近有效期"
        label.font = t29.font
        label.textColor = RGBColor(0xffffff)
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        return label
    }()
    
    // 名称
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = t21.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    // 规格
    fileprivate lazy var specLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        return label
    }()
    
    // 有效日期
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = t3.font
        label.textColor = RGBColor(0xFF2D5C)
        return label
    }()
    // 购买单位
    fileprivate lazy var buySpecLabel: UILabel = {
        let label = UILabel()
        label.font = t3.font
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.borderWidth = WH(1)
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(2)
        return label
    }()
    
    // 最多购买多少盒
    fileprivate lazy var maxBuyLabel: UILabel = {
        let label = UILabel()
        label.font = t3.font
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.borderWidth = WH(1)
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(2)
        return label
    }()
    
    // 价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 加车器
    fileprivate lazy var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.isHidden = true
        stepper.togeterBuyUIPattern()
        //
        stepper.toastBlock = { [weak self] (str) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.toastAddProductNum {
                closure(str!)
            }
        }
        //修改数量时候
        stepper.updateProductBlock = { [weak self] (count : Int,typeIndex : Int) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.updateAddProductNum {
                if count > 0 {
                    strongSelf.addProductBtn.isHidden = true
                    strongSelf.stepper.isHidden = false
                }else if count == 0 && typeIndex == 1 {
                    strongSelf.addProductBtn.isHidden = false
                    strongSelf.stepper.isHidden = true
                }
                closure(count,typeIndex)
            }
        }
        return stepper
    }()
    
    // 抢购
    fileprivate lazy var addProductBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("抢购", for: .normal)
        btn.titleLabel?.font = t7.font
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.backgroundColor = RGBColor(0xFF2D5C)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            if FKYLoginAPI.loginStatus() == .unlogin {
                //未登录
                if let block = strongSelf.loginClosure {
                    block()
                }
            }else {
                if strongSelf.isCheck == "0" {
                    //资质未认证
                }else {
                    if strongSelf.type == 1 {
                        //活动还未开始
//                        if let closure = self.toastAddProductNum {
//                            closure("活动未开始")
//                        }
                    }else {
                        btn.isHidden = true
                        strongSelf.stepper.isHidden = false
                        strongSelf.stepper.addNumWithAuto()
                    }
                }
            }            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //显示条
    fileprivate lazy var progressAllView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(9)/2.0
        view.layer.borderWidth = WH(1)
        view.layer.borderColor = RGBColor(0xFF3965).cgColor
        return view
    }()
    
    //已经购买显示条
    fileprivate lazy var progressFinishView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFD2DD)
        return view
    }()
    
    //已售数量
    fileprivate lazy var numCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xAAAAAA)
        label.font = t29.font
        label.textAlignment = .right
        return label
    }()
    var timeout : Int64 = 0 //剩余时间轴
    var type = 0 //(1:表示活动未开始，2 ：活动开始 3 活动已经结束)
    var refreshDataWithTimeOut : ((_ typeTimer: Int)->())? //倒计时结束刷新
    fileprivate var timer: Timer!
    var updateAddProductNum: addCarClosure? //加车更新
    var toastAddProductNum : SingleStringClosure? //加车提示
    var loginClosure: emptyClosure?
    fileprivate var isCheck:String?//是否资质认证了(//0：未审核 1;审核通过)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        self.stopCount()
    }
    func setupView() {
        contentView.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(13))
            make.left.equalTo(contentView.snp.left).offset(WH(24))
            make.height.equalTo(WH(21))
        }
        
        contentView.addSubview(self.img)
        self.img.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeLabel.snp.bottom).offset(WH(10))
            make.left.equalTo(contentView.snp.left).offset(WH(17))
            make.height.width.equalTo(WH(80))
        }
        
        self.img.addSubview(self.tagLabel)
        self.tagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.img.snp.left)
            make.top.equalTo(self.img.snp.top).offset(WH(5))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(51.9))
        }
        self.img.layoutIfNeeded()
        FKYTogeterNowTabCell.cornerView(byRoundingCorners: [.topRight , .bottomRight], radii: WH(15)/2.0, self.tagLabel)
        
        self.img.addSubview(self.statusImg)
        self.statusImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.img.snp.centerY)
            make.centerX.equalTo(self.img.snp.centerX)
        }
        
        contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.img.snp.top)
            make.left.equalTo(self.img.snp.right).offset(WH(12))
            make.right.equalTo(contentView.snp.right).offset(-WH(12))
            make.height.equalTo(WH(15))
        }
        
        contentView.addSubview(self.specLabel)
        self.specLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(WH(11))
            make.left.equalTo(self.titleLabel.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-WH(12))
            //make.height.equalTo(WH(14))
        }
        
        contentView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.specLabel.snp.bottom).offset(WH(11))
            make.left.equalTo(self.titleLabel.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-WH(12))
            make.height.equalTo(WH(12))
        }
        
        contentView.addSubview(self.buySpecLabel)
        self.buySpecLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.specLabel.snp.bottom).offset(WH(11+12+11))
            make.left.equalTo(self.titleLabel.snp.left)
            make.width.equalTo(0)
            make.height.equalTo(WH(18))
        }
        
        contentView.addSubview(self.maxBuyLabel)
        self.maxBuyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.buySpecLabel.snp.centerY)
            make.left.equalTo(self.buySpecLabel.snp.right).offset(WH(7))
            make.width.equalTo(0)
            make.height.equalTo(WH(18))
        }
        
        contentView.addSubview(self.progressAllView)
        self.progressAllView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(16))
            make.right.equalTo(contentView.snp.right).offset(-WH(11))
            make.width.equalTo(PROGRESS_W)
            make.height.equalTo(WH(9))
        }
        
        self.progressAllView.addSubview(self.progressFinishView)
        self.progressFinishView.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressAllView.snp.top)
            make.left.equalTo(self.progressAllView.snp.left)
            make.height.equalTo(WH(9))
            make.width.equalTo(WH(0))
        }
        
        contentView.addSubview(self.numCountLabel)
        self.numCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.progressAllView.snp.centerY)
            make.right.equalTo(self.progressAllView.snp.left).offset(-WH(4))
            make.height.equalTo(WH(12))
        }
        
        contentView.addSubview(self.addProductBtn)
        self.addProductBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.progressAllView.snp.top).offset(-WH(7))
            make.right.equalTo(self.progressAllView.snp.right)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(85))
        }
        
        contentView.addSubview(self.stepper)
        self.stepper.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.progressAllView.snp.top).offset(-WH(6))
            make.right.equalTo(contentView.snp.right).offset(-WH(13))
            make.height.equalTo(WH(32))
            make.width.equalTo(WH(136))
        }
        
        contentView.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(15))
            make.left.equalTo(self.titleLabel.snp.left)
            make.right.equalTo(self.addProductBtn.snp.left).offset(-WH(5))
            make.height.equalTo(WH(14))
        }
        
        // 底部分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = bg7
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints({ (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(0.5)
        })
    }
}

extension FKYTogeterNowTabCell {
    func configCell(_ model:FKYTogeterBuyModel,nowLocalTime : Int64,_ isCheck:String?) {
        self.isCheck = isCheck
        self.img.image = UIImage.init(named: "image_default_img")
        if  let urlStr = model.appChannelAdImg , let strProductPicUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.img.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        self.titleLabel.text = model.projectName
        self.specLabel.text = model.spec
        self.priceLabel.text = String.init(format: "¥%0.2f", model.subscribePrice ?? 0)
        
        //对价格大小调整
        if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
            let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
            priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
            self.priceLabel.attributedText = priceMutableStr
        }
        
        if model.isNearEffect == 1 {
            self.tagLabel.isHidden = false
            self.dateLabel.textColor = RGBColor(0xFF2D5C)
        } else {
            self.tagLabel.isHidden = true
            self.dateLabel.textColor = RGBColor(0x666666)
        }
        // 有效期
        if let time = model.deadLine, time.isEmpty == false {
            self.dateLabel.text = "有效期至: " + time
            self.dateLabel.isHidden = false
            self.buySpecLabel.snp.updateConstraints { (make) in
                make.top.equalTo(self.specLabel.snp.bottom).offset(WH(11+12+11))
            }
        }
        else {
            self.dateLabel.text = nil
            self.dateLabel.isHidden = true
            self.buySpecLabel.snp.updateConstraints { (make) in
                make.top.equalTo(self.specLabel.snp.bottom).offset(WH(11))
            }
        }
        //标签1
        self.buySpecLabel.text = "起订量\(model.unit ?? 1)\(model.unitName ?? "盒")"
        let strW = self.buySpecLabel.text!.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t3.font], context: nil).size.width + 4
        self.buySpecLabel.snp.updateConstraints { (make) in
            make.width.equalTo(strW)
        }
        //标签2
        self.maxBuyLabel.text = "最多认购\(model.subscribeNumPerClient ?? 0)\(model.unitName ?? "盒")"
        let strMaxW = self.maxBuyLabel.text!.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t3.font], context: nil).size.width + 4
        self.maxBuyLabel.snp.updateConstraints { (make) in
            make.width.equalTo(strMaxW)
        }
        
        self.addProductBtn.isHidden = true
        self.stepper.isHidden = true
        self.statusImg.isHidden = true
        self.addProductBtn.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.progressAllView.snp.top).offset(-WH(7))
            make.right.equalTo(self.progressAllView.snp.right)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(85))
        }
        
        if FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0" {
            //资质未认证
            self.addProductBtn.isHidden = false
            self.addProductBtn.isEnabled = false
            self.addProductBtn.setTitle("资质未认证", for: .normal)
            self.addProductBtn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
            self.addProductBtn.backgroundColor = RGBColor(0xFF2D5C)
        }else {
            //加车数量
            if  model.carOfCount > 0 && model.carId != 0 {
                self.stepper.isHidden = false
                self.addProductBtn.isEnabled = false
            }else {
                self.addProductBtn.isHidden = false
                self.addProductBtn.isEnabled = true
                self.addProductBtn.setTitle("抢购", for: .normal)
                self.addProductBtn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
                self.addProductBtn.backgroundColor = RGBColor(0xFF2D5C)
            }
        }
        //抢购完了
        if model.percentage == 100 {
            self.statusImg.isHidden = false
            self.addProductBtn.isHidden = true
            self.stepper.isHidden = true
            self.statusImg.image = UIImage.init(named: "sold_out_icon")
        }
        
        //已售
        if let percentNum = model.percentage {
            self.numCountLabel.text =  "已售\(percentNum)%"
            self.progressFinishView.snp.updateConstraints { (make) in
                make.width.equalTo(WH((CGFloat(percentNum)/100.0)*PROGRESS_W))
            }
        }else{
            self.numCountLabel.text =  "已售0%"
            self.progressFinishView.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
        }
        
        //为0代表达到最大可购买数量了,隐藏加车，功能按钮不能点击
        if  model.surplusNum != nil && model.surplusNum! == 0  {
            self.addProductBtn.isEnabled = false
            self.addProductBtn.isHidden = false
            self.stepper.isHidden = true
            self.addProductBtn.setTitle("已达限购总数", for: .normal)
        }else {
            self.configStepCount(model)
        }
        
        self.type = 0
        self.timeout = 0
        self.progressAllView.isHidden = false
        self.numCountLabel.isHidden = false
        //倒计时相关
        if let endInterval =  model.endTime,let beginInterval = model.beginTime {
            if beginInterval > nowLocalTime {
                //活动未开始(按钮置灰隐藏进度条及百分比显示)
                self.addProductBtn.setTitle("未开始", for: .normal)
                self.addProductBtn.isEnabled = false
                self.addProductBtn.setTitleColor(RGBColor(0x999999), for: .normal)
                self.addProductBtn.backgroundColor = RGBColor(0xF4F4F4)
                self.addProductBtn.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self.snp.bottom).offset(-WH(16))
                    make.right.equalTo(self.progressAllView.snp.right)
                    make.height.equalTo(WH(30))
                    make.width.equalTo(WH(85))
                }
                self.progressAllView.isHidden = true
                self.numCountLabel.isHidden = true
                self.type = 1
                timeout = beginInterval - nowLocalTime
                self.stopCount()
                self.showCountDownContent(timeout)
                // 启动timer...<1.s后启动>
                let date = NSDate.init(timeIntervalSinceNow: 1.0)
                timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            } else if beginInterval <= nowLocalTime, nowLocalTime < endInterval {
                //活动已经开始
                self.type = 2
                timeout = endInterval - nowLocalTime
                self.stopCount()
                self.showCountDownContent(timeout)
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
            self.showCountDownContent(timeout)
        }
         //根据判断views所属的控制器被销毁了，销毁定时器
        guard (self.getFirstViewController()) != nil else{
            self.stopCount()
            return
        }
    }
    
    func showCountDownContent(_ timeInterval: Int64) {
        let hour = timeInterval / 3600
        let min = timeInterval % 3600 / 60
        let sec = timeInterval % 60
        if self.type == 1 {
          self.timeLabel.text = String.init(format: "还剩 %02d:%02d:%02d 开始", hour,min,sec)
        }else if self.type == 2 {
          self.timeLabel.text = String.init(format: "还剩 %02d:%02d:%02d 结束", hour,min,sec)
        }
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
        self.stepper.isHidden = true
        self.addProductBtn.isHidden = true
        self.timeLabel.text = "还剩 00:00:00 结束"
        stopCount()
    }
    
    //初始化加车计数器
    func configStepCount(_ model: FKYTogeterBuyModel) {
        var num: NSInteger = 0
        if let count = model.currentInventory {
            num = count
        }else{
            num = 0
        }
        
        //限购的数量
        var exceedLimitBuyNum : Int = 0
        if  model.surplusNum != nil && model.surplusNum! > 0 {
            exceedLimitBuyNum = model.surplusNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //
        var baseCount = model.unit ?? 1
        var stepCount = model.unit ?? 1
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        
        //计算特价
        let istj : Bool = false
        var quantityCount = 0
        let minCount = 0
        if  model.carOfCount == 0 {
            quantityCount = stepCount
        }else {
            quantityCount = model.carOfCount
        }
        
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
    
    //切圆角
    static func cornerView(byRoundingCorners corners: UIRectCorner, radii: CGFloat, _ view : UIView) {
        view.layoutIfNeeded()
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
}
