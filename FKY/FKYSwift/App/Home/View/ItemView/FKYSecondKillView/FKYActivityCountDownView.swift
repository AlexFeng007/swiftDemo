//
//  FKYActivityCountDownView.swift
//  FKY
//
//  Created by Andy on 2018/10/25.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  秒杀专区活动页倒计时

import UIKit

class FKYActivityCountDownView: UIView {
    // MARK: - Property
    
    // closure
    var moreCallback: (()->())? // 查看更多
    
    // 商品model
    var secKill: HomeSecondKillModel?
    
    // 定时器
    fileprivate var timer: ZJTimer!
    
    // 剩余时间
    public var count: Int = 0
    
    // 倒计时是否进行中~!@
    fileprivate var isCounting: Bool = false
    
    // 进入后台时的时间戳
    fileprivate var timestampBackground: Int?
    
    // 若倒计时结束后的立即刷新操作（结束的同一秒刷新数据），接口仍返回了刚刚过期的秒杀活动数据，则需要延迟后再刷新一次，仅一次。
    fileprivate var needToRefreshAgain: Bool = false
    
    //
    public lazy var lblTitleLeft: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x333333)
        lbl.text = "距结束"
        return lbl
    }()
    
    //
    fileprivate lazy var lblHour: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = "23"
        return lbl
    }()
    
    //
    fileprivate lazy var lblMinute: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = "58"
        return lbl
    }()
    
    //
    fileprivate lazy var lblSecond: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = "32"
        return lbl
    }()
    
    //
    fileprivate lazy var lblColonLeft: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0x333333)
        lbl.text = ":"
        return lbl
    }()
    
    //
    fileprivate lazy var lblColonRight: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textAlignment = .center
        lbl.textColor = RGBColor(0x333333)
        lbl.text = ":"
        return lbl
    }()
    
    //
    fileprivate lazy var viewHour: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x333333)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    
    //
    fileprivate lazy var viewMinute: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x333333)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    
    //
    fileprivate lazy var viewSecond: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x333333)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // UI
        setupView()
        // Notification...<每次从前台到后台时，若有倒计时运行中，则需要记录当前时间戳>
        NotificationCenter.default.addObserver(self, selector: #selector(saveTimestampWhenEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // Notification...<每次从后台到前台时，若有倒计时运行中，则需要记录当前时间戳>
        NotificationCenter.default.addObserver(self, selector: #selector(getTimestampWhenEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        // Notification...<首页刷新数据成功时，若之前带倒计时的楼层不再返回，则需要暂停>
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimerWhenHomeRefresh), name: NSNotification.Name(rawValue: FKYSecondKillCountOver), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("FKYActivityCountDownView deinit~!@")
        if timer != nil {
            timer.invalidate()
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        addSubview(lblTitleLeft)
        lblTitleLeft.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(5))
            make.centerY.equalTo(self)
        }
        
        addSubview(lblHour)
        lblHour.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitleLeft.snp.right).offset(WH(11))
            make.centerY.equalTo(self)
            make.height.equalTo(WH(21))
            make.width.lessThanOrEqualTo(WH(40))
        }
        
        addSubview(viewHour)
        viewHour.snp.makeConstraints { (make) in
            make.center.equalTo(lblHour)
            make.height.equalTo(WH(21))
            make.width.greaterThanOrEqualTo(WH(21))
            make.width.lessThanOrEqualTo(WH(46))
            make.width.equalTo(lblHour).offset(WH(6))
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
            make.size.equalTo(CGSize.init(width: WH(21), height: WH(21)))
        }
        
        addSubview(viewMinute)
        viewMinute.snp.makeConstraints { (make) in
            make.left.equalTo(lblColonLeft.snp.right).offset(WH(2))
            make.centerY.equalTo(lblHour)
            make.size.equalTo(CGSize.init(width: WH(21), height: WH(21)))
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
            make.size.equalTo(CGSize.init(width: WH(21), height: WH(21)))
        }
        
        addSubview(viewSecond)
        viewSecond.snp.makeConstraints { (make) in
            make.left.equalTo(lblColonRight.snp.right).offset(WH(2))
            make.centerY.equalTo(lblHour)
            make.size.equalTo(CGSize.init(width: WH(21), height: WH(21)))
        }
        
        bringSubviewToFront(lblHour)
        bringSubviewToFront(lblMinute)
        bringSubviewToFront(lblSecond)
    }
    
    
    // MARK: - Public
    
    // 展示数据
    func configData(_ timeLeft: Int64) {
        // 保存
        //        secKill = model
        //
        //        if model.hasShowFloor == false {
        //            // 刷新数据后的第一次显示cell...<先取消之前的timer>
        //            stopCount()
        //        }
        
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
            strongSelf.refreshSecKillData()
        }
    }
    
    
    // MARK: - Private
    
    // 开始倒计时
    fileprivate func beginCount() {
        // 取消timer
        stopCount()
        
        // 先显示最大时间间隔
        showCountDownContent(count)
        timer = ZJTimer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showTimeCount), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.timer.fire()
        }
        
        // 倒计时开始
        isCounting = true
    }
    
    // 停止倒计时
    fileprivate func stopCount() {
        if timer != nil {
            timer.invalidate()
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
            //refreshHomeData()
            // 必须延迟1s后再刷新；否则，当前时间立即刷新时，接口仍会返回秒杀楼层
            // eg: 过期时间10:50，刷新时间10:50
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.refreshSecKillData()
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
    
    // 刷新数据
    @objc fileprivate func refreshSecKillData() {
        print("refreshSecKillData")
        count = 0
        stopCount()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FKYSecondKillCountOver), object: self, userInfo: nil)
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
            refreshSecKillData()
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
class ZJTimer: NSObject {
    private(set) var _timer: Timer!
    fileprivate weak var _aTarget: AnyObject!
    fileprivate var _aSelector: Selector!
    var fireDate: Date {
        get{
            return _timer.fireDate
        }
        set{
            _timer.fireDate = newValue
        }
    }
    
    class func scheduledTimer(timeInterval ti: TimeInterval, target aTarget: AnyObject, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> ZJTimer {
        let timer = ZJTimer()
        
        timer._aTarget = aTarget
        timer._aSelector = aSelector
        timer._timer = Timer.scheduledTimer(timeInterval: ti, target: timer, selector: #selector(ZJTimer.zj_timerRun), userInfo: userInfo, repeats: yesOrNo)
        return timer
    }
    
    func fire() {
        _timer.fire()
    }
    
    func invalidate() {
        _timer.invalidate()
    }
    
    @objc func zj_timerRun() {
        //如果崩在这里，说明你没有在使用Timer的VC里面的deinit方法里调用invalidate()方法
        _ = _aTarget.perform(_aSelector)
    }
    
    deinit {
        print("计时器已销毁")
    }
}
