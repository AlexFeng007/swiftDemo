//
//  LiveEndHeadView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveEndHeadView: UIView {
    @objc var clickExitBlock: emptyClosure? //点击退出
    @objc var replayLiveBlock: emptyClosure? //直播重放
    fileprivate lazy var headView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x363B47)
        return view
    }()
    //    fileprivate lazy var bottomView : UIView = {
    //        let view = UIView()
    //        view.backgroundColor = RGBColor(0xF4F4F4)
    //        return view
    //    }()
    //重新播放按钮
    fileprivate lazy var replayBtn : UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "replay_icon"), for: [.normal])
        backBtn.backgroundColor = .clear
        _ = backBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.replayLiveBlock {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        backBtn.isHidden = false
        return backBtn
    }()
    
    //消失按钮
    fileprivate lazy var dismissBtn : UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "btn_common_close"), for: [.normal])
        backBtn.backgroundColor = .clear
        _ = backBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickExitBlock {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        backBtn.isHidden = false
        return backBtn
    }()
    //主播名
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.text = "直播已结束"
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var leftView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x979797)
        return view
    }()
    
    fileprivate lazy var rightView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0x979797)
        return view
    }()
    fileprivate lazy var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    
    //回放提示
    fileprivate lazy var replayListLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.text = "回放列表"
        label.textAlignment = .center
        label.sizeToFit()
        return label
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
        self.addSubview(headView)
        self.addSubview(bottomView)
        self.addSubview(replayBtn)
        self.addSubview(dismissBtn)
        self.addSubview(tipLabel)
        self.addSubview(leftView)
        self.addSubview(rightView)
        bottomView.addSubview(replayListLabel)
        
        // CGFloat(SKPhotoBrowser.getScreenTopMargin()) + WH(93)
        headView.snp.makeConstraints({ (make) in
            make.top.right.left.equalTo(self)
            make.height.equalTo(WH(197) + SKPhotoBrowser.getScreenTopMargin())
        })
        
        bottomView.snp.makeConstraints({ (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(WH(35))
        })
        replayListLabel.snp.makeConstraints({ (make) in
            make.right.left.equalTo(self)
            make.bottom.equalTo(bottomView).offset(WH(-1))
        })
        
        
        dismissBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(WH(-10))
            make.top.equalTo(self).offset(CGFloat(SKPhotoBrowser.getScreenTopMargin()) + WH(43))
            make.height.width.equalTo(WH(40))
        })
        
        tipLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(headView.snp.bottom).offset(WH(-34))
            make.centerX.equalTo(self)
        })
        leftView.snp.makeConstraints({ (make) in
            make.right.equalTo(tipLabel.snp.left).offset(WH(-5))
            make.centerY.equalTo(tipLabel.snp.centerY)
            make.height.equalTo(WH(1))
            make.width.equalTo(WH(72))
        })
        rightView.snp.makeConstraints({ (make) in
            make.left.equalTo(tipLabel.snp.right).offset(WH(5))
            make.centerY.equalTo(tipLabel.snp.centerY)
            make.height.equalTo(WH(1))
            make.width.equalTo(WH(72))
        })
        replayBtn.snp.makeConstraints({ (make) in
            make.bottom.equalTo(tipLabel.snp.top).offset(WH(-34))
            make.centerX.equalTo(self)
            make.height.width.equalTo(WH(40))
        })
    }
    
}
