//
//  HomeTimeCountView.swift
//  FKY
//
//  Created by 寒山 on 2019/3/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新首页 活动倒计时

import UIKit

class HomeTimeCountView: UIView {

    // closure
   // var moreCallback: (()->())? // 查看更多
    
    // 商品model
    var secKill: HomeSecdKillProductModel?
    
    // 定时器
    fileprivate var timer: Timer!
    
    // 剩余时间
    fileprivate var count: Int = 0
    
    // 倒计时是否进行中~!@
    fileprivate var isCounting: Bool = false
    
    // 进入后台时的时间戳
    fileprivate var timestampBackground: Int?
    
    // 若倒计时结束后的立即刷新操作（结束的同一秒刷新数据），接口仍返回了刚刚过期的秒杀活动数据，则需要延迟后再刷新一次，仅一次。
    fileprivate var needToRefreshAgain: Bool = false
    
    //时分秒
    fileprivate lazy var lblHour: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(10))
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = "23"
        return lbl
    }()
    
    //
    fileprivate lazy var lblMinute: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(10))
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = "58"
        return lbl
    }()
    
    //
    fileprivate lazy var lblSecond: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(10))
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = "32"
        return lbl
    }()
    
    //
    fileprivate lazy var lblColonLeft: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(10))
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = ":"
        return lbl
    }()
    
    //
    fileprivate lazy var lblColonRight: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(10))
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = ":"
        return lbl
    }()
    
   //时分秒背景
    fileprivate lazy var viewHour: UIView! = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(2)
        return view
    }()
    
    //
    fileprivate lazy var viewMinute: UIView! = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(2)
        return view
    }()
    
    //
    fileprivate lazy var viewSecond: UIView! = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(2)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // UI
        setupView()
        // Notification...<每次从前台到后台时，若有倒计时运行中，则需要记录当前时间戳>
        NotificationCenter.default.addObserver(self, selector: #selector(saveTimestampWhenEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // Notification...<每次从后台到前台时，若有倒计时运行中，则需要记录当前时间戳>
        NotificationCenter.default.addObserver(self, selector: #selector(getTimestampWhenEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        // Notification...<首页刷新数据成功时，若之前带倒计时的楼层不再返回，则需要暂停>
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimerWhenHomeRefresh), name: NSNotification.Name(rawValue: FKYNEWHomeSecondKillCountOver), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(lblHour)
        lblHour.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(WH(15))
            make.width.lessThanOrEqualTo(WH(40))
        }
        
        addSubview(viewHour)
        viewHour.snp.makeConstraints { (make) in
            make.center.equalTo(lblHour)
            make.height.equalTo(WH(14))
            make.width.greaterThanOrEqualTo(WH(15))
            make.width.lessThanOrEqualTo(WH(46))
            make.width.equalTo(lblHour).offset(WH(1))
        }
        
        addSubview(lblColonLeft)
        lblColonLeft.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblHour).offset(0)
            make.left.equalTo(viewHour.snp.right).offset(WH(2))
            make.width.equalTo(WH(8))
        }
        
        addSubview(lblMinute)
        lblMinute.snp.makeConstraints { (make) in
            make.left.equalTo(lblColonLeft.snp.right).offset(WH(2))
            make.centerY.equalTo(lblHour)
            make.size.equalTo(CGSize.init(width: WH(15), height: WH(14)))
        }
        
        addSubview(viewMinute)
        viewMinute.snp.makeConstraints { (make) in
            make.left.equalTo(lblColonLeft.snp.right).offset(WH(2))
            make.centerY.equalTo(lblHour)
            make.size.equalTo(CGSize.init(width: WH(15), height: WH(14)))
        }
        
        addSubview(lblColonRight)
        lblColonRight.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblMinute).offset(0)
            make.left.equalTo(lblMinute.snp.right).offset(WH(2))
            make.width.equalTo(WH(8))
        }
        
        addSubview(lblSecond)
        lblSecond.snp.makeConstraints { (make) in
            make.left.equalTo(lblColonRight.snp.right).offset(WH(2))
            make.centerY.equalTo(lblHour)
            make.size.equalTo(CGSize.init(width: WH(15), height: WH(14)))
        }
        
        addSubview(viewSecond)
        viewSecond.snp.makeConstraints { (make) in
            make.left.equalTo(lblColonRight.snp.right).offset(WH(2))
            make.centerY.equalTo(lblHour)
            make.size.equalTo(CGSize.init(width: WH(15), height: WH(14)))
        }
        
        bringSubviewToFront(lblHour)
        bringSubviewToFront(lblMinute)
        bringSubviewToFront(lblSecond)
    }
    
    func setThemeColor(_ color : UIColor) {
        viewHour.backgroundColor = color
        viewMinute.backgroundColor = color
        viewSecond.backgroundColor = color
        lblColonLeft.textColor = color
        lblColonRight.textColor = color
    }
    // MARK: - Public
    
    // 展示数据
    func configData(_ timeLeft: Int64, _ model: HomeSecdKillProductModel) {
        // 保存
        secKill = model
        
//        if model.hasShowFloor == false {
//            // 刷新数据后的第一次显示cell...<先取消之前的timer>
//            stopCount()
//        }
//
        guard timeLeft > 0 else {
            resetAllData()
            return
        }
        
        // 保证只有一个timer
        if !isCounting {
            count = Int(timeLeft)
            beginCount()
        }
        
        // 只要有倒计时，就一定置false
        needToRefreshAgain = false
    }
    
    // 重置所有数据
    func resetAllData() {
        count = 0
        isCounting = false
        timestampBackground = nil
        lblHour.text = "00"
        lblMinute.text = "00"
        lblSecond.text = "00"
        stopCount()
    }
    
    // 倒计时结束后立即刷新，若此时接口仍返回无时间间隔(当前系统时间与活动结束时间在同一秒)的活动数据，则最好延迟后再刷新一次。
    func refreshAgainWhenTimeOver() {
        guard needToRefreshAgain else {
            return
        }
        
        needToRefreshAgain = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshHomeData()
        }
    }
    
    
    // MARK: - Private
    
    // 开始倒计时
    fileprivate func beginCount() {
        // 取消timer
        stopCount()
        
        // 先显示最大时间间隔
        showCountDownContent(count)
        
        // 启动timer...<1.2s后启动>
        let date = NSDate.init(timeIntervalSinceNow: 1.2)
        timer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        // 倒计时开始
        isCounting = true
    }
    
    // 停止倒计时
    fileprivate func stopCount() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        // 倒计时结束
        isCounting = false
    }
    
    // 倒计时操作
    @objc fileprivate func showTimeCount() {
        count = count - 1
        let timeInterval: Int = count
        //print("count:\(count)")
        
        // 倒计时结束...<刷新首页数据>
        guard timeInterval > 0 else {
            resetAllData()
            needToRefreshAgain = true
            // 必须延迟1s后再刷新；否则，当前时间立即刷新时，接口仍会返回秒杀楼层
            // eg: 过期时间10:50，刷新时间10:50
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.refreshHomeData()
            }
            return
        }
        
        // 显示内容
        showCountDownContent(timeInterval)
    }
    
    // 显示倒计时内容
    func showCountDownContent(_ timeInterval: Int) {
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
        
        lblHour.text = hourString
        lblMinute.text = minString
        lblSecond.text = secString
    }
    
    // 刷新首页数据
    @objc fileprivate func refreshHomeData() {
        print("refreshHomeData")
        count = 0
        stopCount()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FKYNEWHomeSecondKillCountOver), object: self, userInfo: nil)
    }
    // MARK: - Notification
    
    @objc fileprivate func saveTimestampWhenEnterBackground() {
        print("saveTimestampWhenEnterBackground")
        guard count > 0 else {
            return
        }
        guard isCounting else {
            return
        }
        // 保存当前时间戳
        let time = NSDate().timeIntervalSince1970
        timestampBackground = Int(time)
        // 停止计数器timer
        stopCount()
    }
    
    @objc fileprivate func getTimestampWhenEnterForeground() {
        print("getTimestampWhenEnterForeground")
        guard count > 0 else {
            return
        }
        // 获取当前时间戳
        let time = NSDate().timeIntervalSince1970
        let timefg = Int(time)
        // 判断逻辑
        guard let timebg = timestampBackground, timefg > timebg, timefg - timebg < count else {
            // 时间间隔异常 or 时间间隔超过剩余时间
            count = 0
            stopCount()
            lblHour.text = "00"
            lblMinute.text = "00"
            lblSecond.text = "00"
            refreshHomeData()
            return
        }
        // 启动timer
        count = count - (timefg - timebg)
        beginCount()
    }
    
    @objc fileprivate func stopTimerWhenHomeRefresh() {
        print("stopTimerWhenHomeRefresh")
        stopCount()
    }

}
//MARK:自定义修改倒计时样式
extension HomeTimeCountView {
    //MARK:设置首页倒计时样式
    func setHomeThemeColor(){
        //修改约束
        viewHour.snp.updateConstraints { (make) in
            make.height.equalTo(WH(21))
            make.width.greaterThanOrEqualTo(WH(21))
        }
        lblMinute.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: WH(21), height: WH(21)))
        }
        viewMinute.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: WH(21), height: WH(21)))
        }
        lblSecond.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: WH(21), height: WH(21)))
        }
        viewSecond.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: WH(21), height: WH(21)))
        }
        //修改属性
        viewSecond.layer.cornerRadius = WH(4)
        viewSecond.layer.masksToBounds = false
        viewSecond.backgroundColor = RGBAColor(0x000000,alpha: 0.15)
        viewHour.layer.cornerRadius = WH(4)
        viewHour.layer.masksToBounds = false
        viewHour.backgroundColor = RGBAColor(0x000000,alpha: 0.15)
        viewMinute.layer.cornerRadius = WH(4)
        viewMinute.layer.masksToBounds = false
        viewMinute.backgroundColor = RGBAColor(0x000000,alpha: 0.15)
        lblColonLeft.font = t11.font
        lblColonRight.font = t11.font
        lblHour.font = t11.font
        lblMinute.font = t11.font
        lblSecond.font = t11.font
    }
    
    func setShopThemeColor(){
        //修改约束
        viewHour.snp.updateConstraints { (make) in
            make.height.equalTo(WH(14))
            make.width.greaterThanOrEqualTo(WH(14))
        }
        lblMinute.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: WH(14), height: WH(14)))
        }
        viewMinute.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: WH(14), height: WH(14)))
        }
        lblSecond.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: WH(14), height: WH(14)))
        }
        viewSecond.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: WH(14), height: WH(14)))
        }
        //修改属性
        viewSecond.layer.cornerRadius = WH(2)
        viewSecond.layer.masksToBounds = false
        viewSecond.backgroundColor = RGBAColor(0xffffff,alpha: 1.0)
        viewHour.layer.cornerRadius = WH(2)
        viewHour.layer.masksToBounds = false
        viewHour.backgroundColor = RGBAColor(0xffffff,alpha: 1.0)
        viewMinute.layer.cornerRadius = WH(2)
        viewMinute.layer.masksToBounds = false
        viewMinute.backgroundColor = RGBAColor(0xffffff,alpha: 1.0)
        lblColonLeft.font = UIFont.systemFont(ofSize: WH(10))
        lblColonRight.font = UIFont.systemFont(ofSize: WH(10))
        lblHour.font = UIFont.systemFont(ofSize: WH(10))
        lblMinute.font = UIFont.systemFont(ofSize: WH(10))
        lblSecond.font = UIFont.systemFont(ofSize: WH(10))
        lblColonLeft.textColor = RGBAColor(0xffffff,alpha: 1.0)
        lblColonRight.textColor = RGBAColor(0xffffff,alpha: 1.0)
        lblHour.textColor = t73.color
        lblMinute.textColor = t73.color
        lblSecond.textColor = t73.color
    }
    //设置阴影
//    fileprivate func setBgViewShadow(_ view:UIView){
//        view.layer.cornerRadius = WH(4)
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowColor = RGBAColor(0xFF2D5C,alpha: 0.17).cgColor
//        view.layer.shadowOpacity = 1;//阴影透明度，默认0
//        view.layer.shadowRadius = 4;//阴影半径
//    }
}
