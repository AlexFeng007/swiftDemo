//
//  FKYHomePageCountView.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageCountView: UIView {

    /// 每次一次倒计时调用都通知数据源更改剩余倒计时时间
//    static let didCount:String = "FKYHomePageCountView-didCount"
    
    
    /// 到期时间，单位秒
    var DueTime:Int = 0
    
    /// 小时
    lazy var hourLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = .boldSystemFont(ofSize: WH(12))
        lb.backgroundColor = RGBColor(0xFF2D5C)
        lb.layer.cornerRadius = WH(4)
        lb.layer.masksToBounds = true
        return lb
    }()
    
    /// 分
    lazy var minuteLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = .boldSystemFont(ofSize: WH(12))
        lb.backgroundColor = RGBColor(0xFF2D5C)
        lb.layer.cornerRadius = WH(4)
        lb.layer.masksToBounds = true
        return lb
    }()
    
    /// 秒
    lazy var secondLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFFFFFF)
        lb.font = .boldSystemFont(ofSize: WH(12))
        lb.backgroundColor = RGBColor(0xFF2D5C)
        lb.layer.cornerRadius = WH(4)
        lb.layer.masksToBounds = true
        return lb
    }()
    
    /// 分割1
    lazy var margin1:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFF2D5C)
        lb.text = ": "
        lb.font = .boldSystemFont(ofSize: WH(12))
        return lb
    }()
    
    /// 分割2
    lazy var margin2:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0xFF2D5C)
        lb.text = ": "
        lb.font = .boldSystemFont(ofSize: WH(12))
        return lb
    }()
    
    /// 倒计时
    var timer:Timer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - 显示数据
extension FKYHomePageCountView{
    /*
    func showTestData(){
        startCount(DueTime: 1603354804)
    }
    */
    
    /// 开始倒计时
    /// - Parameter totleCount: 总的倒计时，单位秒
    func startCount(DueTime:Int){
        self.DueTime = DueTime
        if self.timer != nil {
            self.timer?.invalidate()
        }
        self.timer = Timer(timeInterval: 1, target: self, selector: #selector(FKYHomePageCountView.repeatCount), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        //self.timer?.fireDate = Date.distantPast
        self.timer?.fire()
    }
    
    /// 暂停倒计时
    func suspendCount(){
//        guard let time_t = timer else{
//            return
//        }
        
    }
    
    /// 停止倒计时
    func stopCount(){
        guard let time_t = timer else {
            return
        }
        time_t.invalidate()
    }
}


//MARK: - 私有方法
extension FKYHomePageCountView {
    
    /// 倒计时调用方法
    @objc func repeatCount(){
        let currentTime = Int(Date().timeIntervalSince1970)
        let leftTime = computingTime(startTime: currentTime, endTime: self.DueTime)
        self.hourLB.text = String(format: "%02d ",leftTime.0)
        self.minuteLB.text = String(format: "%02d ",leftTime.1)
        self.secondLB.text = String(format: "%02d ",leftTime.2)
    }
    
    /// 将时间差转换为时分秒
    /// - Parameters:
    ///   - startTime: 开始时间 单位秒
    ///   - endTime: 到期时间 单位秒
    /// - Returns: 返回元组 时，分，秒
    func computingTime(startTime:Int,endTime:Int) -> (Int,Int,Int){
        let temp = endTime-startTime
        if temp <= 0{// 倒计时结束或者结束时间早于开始时间
            stopCount()
            return (0,0,0)
        }
        let sec = temp % 60
        let minuts = Int(temp/60)%60
        let hours = Int(temp/60/60)
        return (hours,minuts,sec)
    }
    
}

//MARK: - UI
extension FKYHomePageCountView{
    func setupUI(){
        self.addSubview(self.hourLB)
        self.addSubview(self.minuteLB)
        self.addSubview(self.secondLB)
        self.addSubview(self.margin1)
        self.addSubview(self.margin2)
        
        self.hourLB.snp_makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        
        self.margin1.snp_makeConstraints { (make) in
            make.left.equalTo(self.hourLB.snp_right)
            make.top.bottom.equalToSuperview()
        }
        
        self.minuteLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.margin1.snp_right)
            make.top.bottom.equalToSuperview()
        }
        
        self.margin2.snp_makeConstraints { (make) in
            make.left.equalTo(self.minuteLB.snp_right)
            make.top.bottom.equalToSuperview()
        }
        
        self.secondLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.margin2.snp_right)
            make.top.bottom.right.equalToSuperview()
        }
        
        self.margin1.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.margin1.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.margin2.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.margin2.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        
    }
    
}
