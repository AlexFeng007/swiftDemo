//
//  FKYHomekPageV3TimeTagModule.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  时间组件

import UIKit

class FKYHomekPageV3TimeTagModule: UIView {

    
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFFFFFF)
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()
    /// 倒计时
    var timer:Timer?
    
    /// 到期时间，单位秒
    var DueTime:Int = 0
    
//    var containerView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
/*
//MARK: - 数据展示
extension FKYHomekPageV3TimeTagModule{
    
    func showTestData(){
        showText(time: "02天02:29:34")
    }
    
    func showText(time:String){
        titleLB.text = time
    }
}
*/


//MARK: - 显示数据
extension FKYHomekPageV3TimeTagModule{
    
    /// 开始倒计时
    /// - Parameter totleCount: 总的倒计时，单位秒
    func startCount(DueTime:Int){
        self.DueTime = DueTime
        if self.timer != nil {
            self.timer?.invalidate()
        }
        self.timer = Timer(timeInterval: 1, target: self, selector: #selector(FKYHomePageCountView.repeatCount), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        self.timer?.fire()
        
    }
    
}

//MARK: - 私有方法
extension FKYHomekPageV3TimeTagModule{
    
    /// 停止倒计时
    func stopCount(){
        guard let time_t = timer else {
            return
        }
        time_t.invalidate()
    }
    
    /// 倒计时调用方法
    @objc func repeatCount(){
        let currentTime = Int(Date().timeIntervalSince1970)
        let leftTime = computingTime(startTime: currentTime, endTime: self.DueTime)
        if leftTime.0 <= 0  {
            titleLB.text = String(format: "%02d:%02d:%02d", leftTime.1,leftTime.2,leftTime.3)
        }else{
            titleLB.text = String(format: "%02d天%02d:%02d:%02d", leftTime.0,leftTime.1,leftTime.2,leftTime.3)
        }
        configDisplayInfo()
    }

    /// 将时间差转换为时分秒
    /// - Parameters:
    ///   - startTime: 开始时间 单位秒
    ///   - endTime: 到期时间 单位秒
    /// - Returns: 返回元组 天，时，分，秒
    func computingTime(startTime:Int,endTime:Int) -> (Int,Int,Int,Int){
        let temp = endTime-startTime
        if temp <= 0{// 倒计时结束或者结束时间早于开始时间
            stopCount()
            return (0,0,0,0)
        }
        let sec = temp % 60
        let minuts = Int(temp/60)%60
        let hours = Int(temp/60/60)%24
        let day = Int(temp/60/60/24)
        return (day,hours,minuts,sec)
    }
    
}



//MARK: - UI
extension FKYHomekPageV3TimeTagModule{
    func setupUI(){
        addSubview(titleLB)
        backgroundColor = RGBAColor(0x000000, alpha: 0.3)
        
        titleLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(9))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-9))
        }
    }
    
    /// 设置圆角
    func configDisplayInfo(){
        self.layer.mask = nil
        self.layoutIfNeeded()
        self.setMutiRoundingCorners(WH(8), [.topLeft,.bottomRight])
    }
}
