//
//  VodInfoBottomView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class VodInfoBottomView: UIView {
    @objc var showLiveProductListBlock: emptyClosure? //点击购物篮按钮
    @objc var playVideoBlock: emptyClosure? //点击播放按钮
    @objc var pauseVideoBlock: emptyClosure? //点击暂停按钮
    @objc var setVideoTimeBlock :((Float)->())? //设置播放时间
    var currectVideoTime:Float = 0.0 //当前视频播放时间
    var totalVideoTime:Float = 0.0 //总的视频播放时间
    var isVideoPlaying = false   //判断是否在播放
    //直播商品列表入口
    fileprivate lazy var productIcon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "live_product_list_icon"), for: UIControl.State())
       // button.setImage(UIImage(named: "live_product_list_icon"), for: UIControl.State())
        button.imageView?.contentMode = .scaleToFill
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.showLiveProductListBlock {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    //抢购按钮
    var productBadgeView : JSBadgeView?
    
    //播放进度条
    fileprivate lazy var playerSlider : VideoPlayerSlider = {
        let slider = VideoPlayerSlider()
        slider.leftBarColor = RGBColor(0xFF2D5C) //左轨道颜色
        slider.rightBarColor = RGBColor(0xFFFFFF) //右轨道颜色
        slider.barHeight = WH(3) //轨道高度
        slider.setThumbImage(UIImage(named: "video_slider_icon"),for: .normal) //改变控制器图片
        //slider.thumbim = RGBColor(0xFF2D5C)  //改变控制器颜色
        slider.addTarget(self, action: #selector(sliderNumChange(_:)), for: .valueChanged)
        return slider
    }()
    
    //总的播放时间
    fileprivate lazy var totalTimeLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xFFFFFF)
        label.font = UIFont.boldSystemFont(ofSize: WH(11))
        label.text = "00:00"
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    //当前播放时间
    fileprivate lazy var currectTimeLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xFFFFFF)
        label.font = UIFont.boldSystemFont(ofSize: WH(11))
        label.text = "00:00"
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    //直播商品列表入口
    fileprivate lazy var playVideoIcon: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setImage(UIImage(named: "video_play_icon"), for: UIControl.State())
        button.imageView?.contentMode = .center
        button.imageEdgeInsets = UIEdgeInsets(top: WH(8), left: WH(8), bottom: WH(8), right: WH(8))
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.isVideoPlaying == true{
                //暂停
                if let closure = strongSelf.pauseVideoBlock {
                    closure()
                }
            }else{
                //播放
                if let closure = strongSelf.playVideoBlock {
                    closure()
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(productIcon)
        self.addSubview(playerSlider)
        self.addSubview(totalTimeLabel)
        self.addSubview(currectTimeLabel)
        self.addSubview(playVideoIcon)
        
        productBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.productIcon, alignment:JSBadgeViewAlignment.topCenter)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(0), y: WH(2))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(12))
            cbv?.badgeTextColor =  RGBColor(0xFFFFFF)
            cbv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
            cbv?.badgeStrokeWidth = WH(1)
            cbv?.badgeStrokeColor = RGBColor(0xFFFFFF)
            return cbv
        }()
        
        
        productIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(19))
            make.top.equalTo(self).offset(WH(15))
            make.height.width.equalTo(WH(40))
        }
        
        playerSlider.snp.makeConstraints { (make) in
            make.left.equalTo(currectTimeLabel.snp.right).offset(WH(9))
            make.top.equalTo(self).offset(WH(21.5))
            make.right.equalTo(totalTimeLabel.snp.left).offset(WH(-9))
            make.height.equalTo(WH(40))
        }
        
        playVideoIcon.snp.makeConstraints { (make) in
            make.left.equalTo(productIcon.snp.right).offset(WH(5.5))
            make.top.equalTo(productIcon.snp.top).offset(WH(6))
            make.height.width.equalTo(WH(40))
        }
        totalTimeLabel.snp.makeConstraints { (make) in
            //make.left.equalTo(playerSlider.snp.right).offset(WH(4))
            make.centerY.equalTo(playVideoIcon.snp.centerY)
            make.right.equalTo(self.snp.right).offset(WH(-15))
            //make.width.equalTo(WH(44))
        }
        currectTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playVideoIcon.snp.right).offset(WH(-10))
            make.centerY.equalTo(playVideoIcon.snp.centerY)
            make.width.equalTo(WH(41))
        }
        
        
        
    }
}
//MARK:
extension VodInfoBottomView {
    func changeBottomViewStyle(_ show:Bool){
        if show == true{
            productIcon.isHidden = false
            productIcon.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(WH(19))
                make.height.width.equalTo(WH(40))
            }
        }else{
            productIcon.isHidden = true
            productIcon.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(WH(11))
                make.height.width.equalTo(WH(0))
            }
        }
    }
    func productBadgeNumText(_ badgeText:String?){
        self.productBadgeView?.badgeText = badgeText
    }
    @objc func sliderNumChange(_ slider:UISlider){
        if let block = self.setVideoTimeBlock{
            block(slider.value)
        }
    }
    func setVideoTotalTime(_ totalTime:Float){
        self.totalTimeLabel.text  = self.transToHourMinSec(time: totalTime)
        self.totalVideoTime = totalTime
    }
    
    func setVideoCurrectTime(_ currectTime:Float){
        self.currectTimeLabel.text  = self.transToHourMinSec(time: currectTime)
        self.currectVideoTime = currectTime
        if self.totalVideoTime != 0{
            self.playerSlider.value = self.currectVideoTime/self.totalVideoTime
        }else{
            self.playerSlider.value = 0.0
        }
    }
    func setPlayVideoState(){
        playVideoIcon.isEnabled = true
        isVideoPlaying = true
        playVideoIcon.setImage(UIImage(named: "video_pause_icon"), for: UIControl.State())
    }
    
    func setPauseVideoState(){
        playVideoIcon.isEnabled = true
        isVideoPlaying = false
        playVideoIcon.setImage(UIImage(named: "video_play_icon"), for: UIControl.State())
    }
    // MARK: - 把秒数转换成时分秒（00:00:00）格式
    ///
    /// - Parameter time: time(Float格式)
    /// - Returns: String格式(00:00:00)
    func transToHourMinSec(time: Float) -> String
    {
        let allTime: Int = Int(time)
       // var hours = 0
        var minutes = 0
        var seconds = 0
        //var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        minutes = allTime / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
//        if allTime > 3600{
//            hours = allTime / 3600
//            hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
//            return "\(hoursText):\(minutesText):\(secondsText)"
//        }
        
        return "\(minutesText):\(secondsText)"
    }
}
